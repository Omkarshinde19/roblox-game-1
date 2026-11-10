--!strict
-- Placeholder NPC bodies until the Blender models exist.
--   Rigs.dummy: a standard animated Roblox R15 character, tinted and scaled.
--   Rigs.cat:   a small part-built animal with a Humanoid.

local Players = game:GetService("Players")

local Rigs = {}

export type DummySpec = {
	name: string,
	skin: Color3,
	shirt: Color3,
	pants: Color3,
	width: number,
	height: number,
	depth: number,
	head: number,
}

local WALK_ANIM = "rbxassetid://507777826"
local IDLE_ANIM = "rbxassetid://507766388"

local function weldTo(part: BasePart, to: BasePart)
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = to
	weld.Part1 = part
	weld.Parent = part
end

-- Adds a small unanchored part welded to a limb (headset, hammer...).
function Rigs.attach(
	to: BasePart,
	name: string,
	offset: CFrame,
	size: Vector3,
	color: Color3,
	material: Enum.Material
): Part
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Color = color
	p.Material = material
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.Massless = true
	p.CFrame = to.CFrame * offset
	p.Parent = to.Parent
	weldTo(p, to)
	return p
end

local function animate(humanoid: Humanoid)
	local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator")
	animator.Parent = humanoid
	local function load(id: string): AnimationTrack
		local animation = Instance.new("Animation")
		animation.AnimationId = id
		return animator:LoadAnimation(animation)
	end
	local walk, idle = load(WALK_ANIM), load(IDLE_ANIM)
	idle.Looped = true
	walk.Looped = true
	idle:Play()
	humanoid.Running:Connect(function(speed: number)
		if speed > 0.5 then
			if not walk.IsPlaying then
				walk:Play(0.2)
			end
			walk:AdjustSpeed(math.clamp(speed / 10, 0.6, 1.8))
		elseif walk.IsPlaying then
			walk:Stop(0.2)
		end
	end)
end

function Rigs.dummy(spec: DummySpec): Model
	local description = Instance.new("HumanoidDescription")
	description.HeadColor = spec.skin
	description.LeftArmColor = spec.skin
	description.RightArmColor = spec.skin
	description.TorsoColor = spec.shirt
	description.LeftLegColor = spec.pants
	description.RightLegColor = spec.pants
	local model = Players:CreateHumanoidModelFromDescription(description, Enum.HumanoidRigType.R15)
	model.Name = spec.name
	local humanoid = model:FindFirstChildOfClass("Humanoid") :: Humanoid
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	humanoid.BreakJointsOnDeath = false
	-- NPCs can be bigger than the avatar limits allow players to be
	for scaleName, value in
		{
			BodyWidthScale = spec.width,
			BodyHeightScale = spec.height,
			BodyDepthScale = spec.depth,
			HeadScale = spec.head,
		}
	do
		local scale = humanoid:FindFirstChild(scaleName)
		if scale and scale:IsA("NumberValue") then
			scale.Value = value
		end
	end
	local animateScript = model:FindFirstChild("Animate")
	if animateScript then
		animateScript:Destroy() -- a LocalScript; it never runs for NPCs
	end
	animate(humanoid)
	return model
end

function Rigs.cat(name: string, color: Color3): Model
	local model = Instance.new("Model")
	model.Name = name
	local root = Instance.new("Part")
	root.Name = "HumanoidRootPart"
	root.Size = Vector3.new(1.2, 1.1, 2.8)
	root.Color = color
	root.Material = Enum.Material.Fabric
	root.TopSurface = Enum.SurfaceType.Smooth
	root.BottomSurface = Enum.SurfaceType.Smooth
	root.Parent = model
	model.PrimaryPart = root
	local head =
		Rigs.attach(root, "Head", CFrame.new(0, 0.5, -1.7), Vector3.new(1.1, 1, 1), color, Enum.Material.Fabric)
	Rigs.attach(head, "Ear", CFrame.new(-0.35, 0.65, 0), Vector3.new(0.3, 0.4, 0.3), color, Enum.Material.Fabric)
	Rigs.attach(head, "Ear", CFrame.new(0.35, 0.65, 0), Vector3.new(0.3, 0.4, 0.3), color, Enum.Material.Fabric)
	Rigs.attach(
		root,
		"Tail",
		CFrame.new(0, 0.7, 1.7) * CFrame.Angles(math.rad(50), 0, 0),
		Vector3.new(0.3, 0.3, 1.8),
		color,
		Enum.Material.Fabric
	)
	for _, p in { { -0.4, -0.9 }, { 0.4, -0.9 }, { -0.4, 0.9 }, { 0.4, 0.9 } } do
		Rigs.attach(root, "Leg", CFrame.new(p[1], -0.9, p[2]), Vector3.new(0.3, 0.8, 0.3), color, Enum.Material.Fabric)
	end
	local humanoid = Instance.new("Humanoid")
	humanoid.HipHeight = 1.2
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	humanoid.Parent = model
	return model
end

return Rigs
