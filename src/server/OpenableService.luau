--!strict
-- Makes every "Openable" model in the world work: doors, drawers, cabinets,
-- the fridge. Hold the prompt to open quietly, tap it to yank it open (loud).
--
-- A model's state is its "Open" attribute. Anything tagged Inspectable or Loot
-- inside an Openable gets a "Reachable" attribute that follows that state.

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Config = require(ReplicatedStorage.Shared.Config)
local NoiseService = require(script.Parent.NoiseService)

type State = {
	model: Model,
	moving: Model,
	closed: CFrame,
	open: CFrame,
	isOpen: boolean,
	animation: number, -- bumped on every toggle so an older animation stops
	prompt: ProximityPrompt,
	contents: { BasePart },
	holdStart: { [Player]: number },
}

local TAG = "Openable"
local states: { [Model]: State } = {}

local OpenableService = {}

local function openPose(model: Model, closed: CFrame): CFrame
	if model:GetAttribute("Kind") == "Slide" then
		local offset = model:GetAttribute("SlideOffset")
		return closed * CFrame.new(if typeof(offset) == "Vector3" then offset else Vector3.zero)
	end
	local angle = math.rad((model:GetAttribute("OpenAngle") :: number?) or 90)
	if model:GetAttribute("Axis") == "X" then
		return closed * CFrame.Angles(angle, 0, 0)
	end
	return closed * CFrame.Angles(0, angle, 0)
end

local function animate(state: State, target: CFrame)
	state.animation += 1
	local id = state.animation
	local from = state.moving:GetPivot()
	local started = os.clock()
	while state.animation == id do
		local alpha = math.min((os.clock() - started) / Config.OPEN_SECONDS, 1)
		local eased = TweenService:GetValue(alpha, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		state.moving:PivotTo(from:Lerp(target, eased))
		if alpha >= 1 then
			break
		end
		RunService.Heartbeat:Wait()
	end
end

local function apply(state: State)
	state.model:SetAttribute("Open", state.isOpen)
	state.prompt.ActionText = if state.isOpen then "Close" else "Open"
	for _, part in state.contents do
		if part.Parent then
			part:SetAttribute("Reachable", state.isOpen)
		end
	end
end

-- Opens or closes a model. `loud` decides how far the noise carries.
function OpenableService.setOpen(model: Model, open: boolean, loud: boolean, source: Player?)
	local state = states[model]
	if not state or state.isOpen == open then
		return
	end
	state.isOpen = open
	apply(state)
	local radius = if loud then Config.LOUD_NOISE_RADIUS else Config.QUIET_NOISE_RADIUS
	NoiseService.emit(state.moving:GetPivot().Position, radius, loud, source)
	task.spawn(animate, state, if open then state.open else state.closed)
end

function OpenableService.isOpen(model: Model): boolean
	local state = states[model]
	return state ~= nil and state.isOpen
end

local function closeEnough(player: Player, part: BasePart): boolean
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root or not root:IsA("BasePart") then
		return false
	end
	return (root.Position - part.Position).Magnitude <= Config.INTERACT_DISTANCE + 6
end

local function setup(instance: Instance)
	if not instance:IsA("Model") or states[instance] then
		return
	end
	local moving = instance:FindFirstChild("Moving")
	if not moving or not moving:IsA("Model") or not moving.PrimaryPart then
		warn(`[Openable] {instance:GetFullName()} has no Moving model with a PrimaryPart`)
		return
	end
	local handle = moving:FindFirstChild("Handle") or moving:FindFirstChild("Panel") or moving.PrimaryPart
	if not handle or not handle:IsA("BasePart") then
		return
	end

	local prompt = Instance.new("ProximityPrompt")
	prompt.ObjectText = (instance:GetAttribute("DisplayName") :: string?) or instance.Name
	prompt.HoldDuration = Config.QUIET_HOLD_SECONDS
	prompt.MaxActivationDistance = Config.INTERACT_DISTANCE
	prompt.RequiresLineOfSight = false
	prompt.Parent = handle

	local contents: { BasePart } = {}
	for _, d in instance:GetDescendants() do
		if
			d:IsA("BasePart") and (CollectionService:HasTag(d, "Inspectable") or CollectionService:HasTag(d, "Loot"))
		then
			table.insert(contents, d)
		end
	end

	local closed = moving:GetPivot()
	local state: State = {
		model = instance,
		moving = moving,
		closed = closed,
		open = openPose(instance, closed),
		isOpen = false,
		animation = 0,
		prompt = prompt,
		contents = contents,
		holdStart = {},
	}
	states[instance] = state
	apply(state)

	prompt.PromptButtonHoldBegan:Connect(function(player: Player)
		state.holdStart[player] = os.clock()
	end)
	-- held all the way: quiet
	prompt.Triggered:Connect(function(player: Player)
		state.holdStart[player] = nil
		if closeEnough(player, handle) then
			OpenableService.setOpen(instance, not state.isOpen, false, player)
		end
	end)
	-- let go early: a quick tap yanks it open (loud); a half-hold does nothing
	prompt.PromptButtonHoldEnded:Connect(function(player: Player)
		local started = state.holdStart[player]
		state.holdStart[player] = nil
		if started and os.clock() - started <= Config.TAP_MAX_SECONDS and closeEnough(player, handle) then
			OpenableService.setOpen(instance, not state.isOpen, true, player)
		end
	end)
end

function OpenableService.start()
	for _, instance in CollectionService:GetTagged(TAG) do
		setup(instance)
	end
	CollectionService:GetInstanceAddedSignal(TAG):Connect(setup)
	CollectionService:GetInstanceRemovedSignal(TAG):Connect(function(instance: Instance)
		states[instance :: Model] = nil
	end)
end

return OpenableService
