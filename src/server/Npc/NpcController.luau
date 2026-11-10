--!strict
-- Shared body for every NPC: walking with pathfinding, opening doors, seeing
-- players, hearing noise, speaking lines and running a behaviour tree.

local CollectionService = game:GetService("CollectionService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.Remotes)
local NoiseService = require(script.Parent.Parent.NoiseService)
local OpenableService = require(script.Parent.Parent.OpenableService)
local BT = require(script.Parent.BehaviourTree)

export type Npc = {
	name: string,
	model: Model,
	humanoid: Humanoid,
	root: BasePart,
	bb: { [string]: any }, -- blackboard: everything the behaviour tree remembers
	agent: { [string]: any },
	opensDoors: boolean,
	waypoints: { PathWaypoint },
	waypointIndex: number,
	pathTarget: Vector3?,
	pathTime: number,
	mood: TextLabel,
}

local Controller = {}

local function flat(a: Vector3, b: Vector3): number
	return Vector3.new(a.X - b.X, 0, a.Z - b.Z).Magnitude
end

function Controller.new(name: string, model: Model, at: Vector3, agent: { [string]: any }, opensDoors: boolean): Npc
	local humanoid = model:FindFirstChildOfClass("Humanoid") :: Humanoid
	local root = model:FindFirstChild("HumanoidRootPart") :: BasePart
	model:PivotTo(CFrame.new(at))
	model.Parent = workspace
	for _, part in model:GetDescendants() do
		if part:IsA("BasePart") and not part.Anchored then
			part:SetNetworkOwner(nil) -- the server drives NPCs
		end
	end

	local board = Instance.new("BillboardGui")
	board.Name = "Mood"
	board.Size = UDim2.fromScale(5, 1.6)
	board.StudsOffsetWorldSpace = Vector3.new(0, 4.5, 0)
	board.MaxDistance = 90
	board.Adornee = root
	local mood = Instance.new("TextLabel")
	mood.Size = UDim2.fromScale(1, 1)
	mood.BackgroundTransparency = 1
	mood.Font = Enum.Font.GothamBold
	mood.TextScaled = true
	mood.TextStrokeTransparency = 0.3
	mood.Text = ""
	mood.Parent = board
	board.Parent = root

	local npc: Npc = {
		name = name,
		model = model,
		humanoid = humanoid,
		root = root,
		bb = {},
		agent = agent,
		opensDoors = opensDoors,
		waypoints = {},
		waypointIndex = 1,
		pathTarget = nil,
		pathTime = 0,
		mood = mood,
	}

	-- hearing: remember the latest noise in range that this NPC didn't make
	NoiseService.heard:Connect(function(noise: NoiseService.Noise)
		if noise.from == model or (not noise.loud and noise.source == nil) then
			return
		end
		if (noise.position - root.Position).Magnitude <= noise.radius then
			npc.bb.newNoise = { position = noise.position, loud = noise.loud, time = os.clock() }
		end
	end)
	return npc
end

function Controller.setMood(npc: Npc, text: string, color: Color3?)
	npc.mood.Text = text
	npc.mood.TextColor3 = color or Color3.new(1, 1, 1)
end

-- Speaks a subtitle line to every player within `range` studs.
function Controller.say(npc: Npc, speaker: string, text: string, range: number?)
	for _, player in Players:GetPlayers() do
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if root and root:IsA("BasePart") and (root.Position - npc.root.Position).Magnitude <= (range or 80) then
			Remotes.get("ShowLine"):FireClient(player, speaker, text)
		end
	end
end

function Controller.stop(npc: Npc)
	npc.humanoid:MoveTo(npc.root.Position)
	npc.pathTarget = nil
end

function Controller.face(npc: Npc, toward: Vector3)
	local pos = npc.root.Position
	local look = Vector3.new(toward.X, pos.Y, toward.Z)
	if (look - pos).Magnitude > 0.5 then
		npc.root.CFrame = CFrame.lookAt(pos, look)
	end
end

local doors: { Model }? = nil
local function openDoorsNear(npc: Npc)
	if not doors then
		local found = {}
		for _, m in CollectionService:GetTagged("Openable") do
			if m:IsA("Model") and m.Name:sub(1, 5) == "Door_" then
				table.insert(found, m)
			end
		end
		doors = found
	end
	for _, door in doors :: { Model } do
		if not OpenableService.isOpen(door) and (door:GetPivot().Position - npc.root.Position).Magnitude < 9 then
			OpenableService.setOpen(door, true, false, nil, npc.model)
		end
	end
end

-- Walks toward `target`. Returns true once the NPC has arrived.
function Controller.moveTo(npc: Npc, target: Vector3, speed: number, arrive: number?): boolean
	npc.humanoid.WalkSpeed = speed
	local pos = npc.root.Position
	if flat(pos, target) <= (arrive or 3.5) and math.abs(target.Y - pos.Y) < 9 then
		Controller.stop(npc)
		return true
	end
	local now = os.clock()
	if not npc.pathTarget or (npc.pathTarget - target).Magnitude > 4 or now - npc.pathTime > 3 then
		npc.pathTarget = target
		npc.pathTime = now
		local path = PathfindingService:CreatePath(npc.agent)
		local ok = pcall(function()
			path:ComputeAsync(pos, target)
		end)
		if ok and path.Status == Enum.PathStatus.Success then
			npc.waypoints = path:GetWaypoints()
			npc.waypointIndex = 2
		else
			npc.waypoints = {}
		end
	end
	local waypoint = npc.waypoints[npc.waypointIndex]
	while waypoint and flat(waypoint.Position, pos) < 2.5 do
		npc.waypointIndex += 1
		waypoint = npc.waypoints[npc.waypointIndex]
	end
	npc.humanoid:MoveTo(if waypoint then waypoint.Position else target)
	if npc.opensDoors then
		openDoorsNear(npc)
	end
	return false
end

-- Can this NPC see that player right now? Hidden and banned players are invisible.
function Controller.canSee(npc: Npc, player: Player, range: number, fovDegrees: number): boolean
	if player:GetAttribute("Hidden") == true or player:GetAttribute("InTimeout") == true then
		return false
	end
	local character = player.Character
	local target = character and character:FindFirstChild("HumanoidRootPart")
	if not character or not target or not target:IsA("BasePart") then
		return false
	end
	local eye = npc.root.Position + Vector3.new(0, 1.5, 0)
	local offset = target.Position - eye
	if offset.Magnitude > range then
		return false
	end
	local look = npc.root.CFrame.LookVector
	if offset.Magnitude > 4 and math.deg(math.acos(math.clamp(look:Dot(offset.Unit), -1, 1))) > fovDegrees / 2 then
		return false
	end
	local params = RaycastParams.new()
	local ignore: { Instance } = { npc.model }
	params.FilterType = Enum.RaycastFilterType.Exclude
	for _ = 1, 5 do
		params.FilterDescendantsInstances = ignore
		local hit = workspace:Raycast(eye, offset, params)
		if not hit or hit.Instance:IsDescendantOf(character) then
			return true
		end
		if hit.Instance.Transparency < 0.4 then
			return false -- a solid thing is in the way
		end
		table.insert(ignore, hit.Instance) -- glass: look through it
	end
	return false
end

function Controller.nearestVisible(npc: Npc, range: number, fovDegrees: number): (Player?, number)
	local best: Player? = nil
	local bestDistance = math.huge
	for _, player in Players:GetPlayers() do
		if Controller.canSee(npc, player, range, fovDegrees) then
			local root = (player.Character :: Model):FindFirstChild("HumanoidRootPart") :: BasePart
			local distance = (root.Position - npc.root.Position).Magnitude
			if distance < bestDistance then
				best, bestDistance = player, distance
			end
		end
	end
	return best, bestDistance
end

-- Ticks the behaviour tree about seven times a second until the NPC is removed.
function Controller.run(npc: Npc, tree: BT.Node)
	task.spawn(function()
		local last = os.clock()
		while npc.model.Parent do
			local now = os.clock()
			local ok, err = pcall(tree, npc, now - last)
			last = now
			if not ok then
				warn(`[NPC {npc.name}] {err}`)
			end
			task.wait(0.15)
		end
	end)
end

return Controller
