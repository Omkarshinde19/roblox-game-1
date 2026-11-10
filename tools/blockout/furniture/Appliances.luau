--!strict
-- Furniture catalogue: appliances, electronics, bathroom and garage pieces.
-- Every piece is built at `cf`: a point on the floor, front facing cf's -Z.

local Kit = require(script.Parent.Parent.Kit)
local Storage = require(script.Parent.Storage)

local C = Kit.Color
local M = Enum.Material
local V = Vector3.new
type Item = Kit.Item

local Appliances = {}

local DOOM = Color3.fromRGB(60, 200, 70)

local function can(): Item
	return {
		n = "Mountain Doom",
		s = V(0.6, 1, 0.6),
		c = DOOM,
		m = M.Metal,
		line = "Mountain Doom. 400% of your daily sugar. He has a subscription.",
	}
end

function Appliances.fridge(parent: Instance, cf: CFrame): Model
	local m = Storage.cabinet(parent, cf, "Fridge", 6, 9, 4, C.white, {
		{
			can(),
			can(),
			can(),
			{
				n = "Cold pizza",
				s = V(2, 0.3, 2),
				c = C.cardboard,
				line = "Cold pizza, labelled MOD ONLY. Of course it is.",
			},
		},
		{
			{
				n = "Expired milk",
				s = V(0.8, 1.6, 0.8),
				c = C.white,
				line = "Milk. Best before March 2219. It's 2221. It moved.",
			},
			{
				n = "Sad lettuce",
				s = V(1.1, 0.8, 1.1),
				c = C.green,
				line = "One lettuce. Untouched. Mom keeps trying.",
			},
			{
				n = "Butter dish",
				s = V(1.2, 0.5, 0.8),
				c = C.gold,
				value = 120,
				line = "A RAM stick in the butter dish! Cold storage. Smart. Mine now.",
			},
			{
				n = "Pickle jar",
				s = V(0.7, 1.1, 0.7),
				c = Color3.fromRGB(120, 150, 60),
				m = M.Glass,
				line = "Pickles. The jar is winning.",
			},
		},
		{
			{
				n = "Humming tub",
				s = V(1.4, 0.8, 1.2),
				c = C.blue,
				line = "A tub labelled DO NOT OPEN. It's humming. I respect its boundaries.",
			},
			{
				n = "Mom's casserole",
				s = V(1.8, 0.6, 1.4),
				c = C.cream,
				line = "Casserole, labelled 'for my special boy'. There are six of these.",
			},
		},
	}, "Fridge", M.Metal)
	Kit.light(m, "FridgeLight", (cf * CFrame.new(0, 8, 0)).Position, C.white, 8, 0.6)
	return m
end

function Appliances.miniFridge(parent: Instance, cf: CFrame): Model
	return Storage.cabinet(parent, cf, "MiniFridge", 3.4, 3.8, 3, C.black, {
		{ can(), can(), can() },
		{
			can(),
			can(),
			{
				n = "Emergency cheese",
				s = V(0.8, 0.5, 0.8),
				c = C.gold,
				line = "Emergency cheese. For moderation emergencies.",
			},
		},
	}, "Mini fridge", M.Metal)
end

function Appliances.stove(parent: Instance, cf: CFrame): Model
	local m, moving = Kit.hinged(parent, "Oven", cf * CFrame.new(0, 0.3, -2), -90, "Oven", "X")
	Storage.carcass(m, cf, 5, 3.4, 4, C.steel, M.Metal)
	for _, p in { { -1.2, -0.9 }, { 1.2, -0.9 }, { -1.2, 0.9 }, { 1.2, 0.9 } } do
		Kit.cylinder(m, cf, "Burner", p[1], 3.4, p[2], 1.4, 0.1, C.black, M.Metal)
	end
	Kit.part(m, cf, "Backsplash", 0, 3.4, 1.8, 5, 1, 0.3, C.steel, M.Metal)
	Kit.part(moving, cf, "Panel", 0, 0.3, -2.15, 4.6, 2.8, 0.3, C.black, M.Metal)
	Kit.part(moving, cf, "Handle", 0, 2.7, -2.45, 3.4, 0.25, 0.3, C.steel, M.Metal)
	Kit.stock(m, cf, 0.3, 0, -1, 0.3, {
		{
			n = "Forgotten casserole",
			s = V(2, 0.7, 1.6),
			c = Color3.fromRGB(60, 45, 35),
			line = "A casserole from 2219. The oven is its home now.",
		},
	})
	return m
end

function Appliances.sinkCounter(parent: Instance, cf: CFrame, col: Color3, rows: { { Item } }?): Model
	local m = Storage.counter(parent, cf, "SinkCabinet", 4, col, rows)
	Kit.part(m, cf, "Basin", 0, 3.35, -0.2, 2.6, 0.2, 2, C.steel, M.Metal)
	Kit.part(m, cf, "Faucet", 0, 3.5, 1, 0.3, 1.2, 0.3, C.steel, M.Metal)
	Kit.part(m, cf, "Faucet", 0, 4.5, 0.6, 0.3, 0.3, 1, C.steel, M.Metal)
	return m
end

function Appliances.microwave(parent: Instance, cf: CFrame): Model
	return Storage.cabinet(parent, cf, "Microwave", 2.8, 1.7, 2, C.black, {
		{
			{
				n = "Frozen burrito",
				s = V(1.4, 0.5, 0.6),
				c = C.cream,
				line = "A burrito. Hot outside, frozen inside. Like our terms of service.",
			},
		},
	}, "Microwave", M.Metal)
end

-- Washer or dryer: a white metal cabinet with a porthole on the door.
function Appliances.laundryMachine(parent: Instance, cf: CFrame, name: string, items: { Item }): Model
	local m = Storage.cabinet(parent, cf, name, 4, 4.4, 4, C.white, { items }, name, M.Metal)
	local moving = m:FindFirstChild("Moving") :: Model
	Kit.part(moving, cf, "Porthole", 0, 1.2, -2.35, 2, 2, 0.15, C.black, M.Glass)
	Kit.part(m, cf, "Controls", 0, 4.4, 1.5, 4, 0.8, 0.6, C.steel, M.Metal)
	return m
end

function Appliances.trashCan(parent: Instance, cf: CFrame, line: string): Model
	return Storage.trunk(parent, cf, "TrashCan", 2.2, 3.2, 2.2, C.steel, {
		{ n = "Trash", s = V(1.2, 1.4, 1.2), c = C.black, m = M.Fabric, line = line },
	}, "Trash can")
end

-- TV on a low cabinet. The screen is tagged for the Distraction role later.
function Appliances.tv(parent: Instance, cf: CFrame, rows: { { Item } }?): Model
	local m = Kit.model("TV", parent)
	Storage.cabinet(m, cf * CFrame.new(-3, 0, 0), "TVStandLeft", 6, 2.4, 2.4, C.darkWood, rows, "TV cabinet")
	Storage.cabinet(m, cf * CFrame.new(3, 0, 0), "TVStandRight", 6, 2.4, 2.4, C.darkWood, {
		{
			{
				n = "Tangled cables",
				s = V(2, 0.6, 1.4),
				c = C.black,
				m = M.Fabric,
				line = "Cables. All of them. One of these is load-bearing.",
			},
		},
	}, "TV cabinet")
	Kit.part(m, cf, "Neck", 0, 2.4, 0.3, 1, 0.8, 0.4, C.black, M.Metal)
	local screen = Kit.part(m, cf, "Screen", 0, 3.2, 0.3, 11, 6.2, 0.4, C.black, M.Glass)
	screen:SetAttribute("TV", true)
	return m
end

-- The Admin's battlestation: desk, three monitors, the rig, the lockdown button.
function Appliances.battlestation(parent: Instance, cf: CFrame): Model
	local m = Kit.model("Battlestation", parent)
	Kit.part(m, cf, "DeskTop", 0, 3, 0, 14, 0.4, 4, C.black, M.Wood)
	Kit.part(m, cf, "DeskLeg", -6.6, 0, 0, 0.4, 3, 3.6, C.black, M.Metal)
	Kit.part(m, cf, "DeskLeg", 6.6, 0, 0, 0.4, 3, 3.6, C.black, M.Metal)
	for i, x in { -4.4, 0, 4.4 } do
		local yaw = (2 - i) * -18
		local mcf = cf * CFrame.new(x, 3.4, 1.1 - math.abs(x) * 0.12) * CFrame.Angles(0, math.rad(yaw), 0)
		Kit.part(m, mcf, "MonitorStand", 0, 0, 0, 0.4, 0.8, 0.4, C.black, M.Metal)
		local screen = Kit.part(m, mcf, "Monitor", 0, 0.8, 0, 4.2, 2.6, 0.2, Color3.fromRGB(90, 60, 200), M.Neon)
		screen:SetAttribute("AdminPC", true)
	end
	Kit.part(m, cf, "Keyboard", 0, 3.4, -0.9, 3, 0.15, 1, C.black, M.Plastic)
	Kit.part(m, cf, "ChipsBowl", 4.6, 3.4, -1, 1.2, 0.5, 1.2, C.red, M.Plastic)
	local button = Kit.cylinder(m, cf, "Marker_LockdownButton", -5.4, 3.4, -1, 1.2, 0.5, C.red, M.Neon)
	button:SetAttribute("LockdownButton", true)
	-- the rig: glass tower with two GPUs (2-person carry), RAM and CPU
	local rcf = cf * CFrame.new(9.5, 0, 0.2)
	Kit.part(m, rcf, "RigStand", 0, 0, 0, 3.4, 1.2, 4.4, C.black, M.Metal)
	local case = Kit.part(m, rcf, "RigCase", 0, 1.2, 0, 2.6, 5.4, 4, C.black, M.Glass)
	case.Transparency = 0.6
	for i, y in { 2.4, 3.8 } do
		local gpu = Kit.part(m, rcf, "Marker_GPU" .. i, 0, y, 0, 1.8, 0.9, 3.2, C.purple, M.Neon)
		gpu:SetAttribute("HeavyLoot", true)
		gpu:SetAttribute("Carriers", 2)
	end
	local ram = Kit.part(m, rcf, "Marker_RAM", 0, 5.2, 0.6, 1.4, 0.8, 0.4, C.gold, M.Neon)
	ram:SetAttribute("RigLoot", true)
	Kit.light(m, "RigGlow", (rcf * CFrame.new(0, 4, 0)).Position, Color3.fromRGB(80, 160, 255), 14, 2)
	return m
end

function Appliances.gamingChair(parent: Instance, cf: CFrame): Model
	local m = Kit.model("Marker_AdminChair", parent)
	Kit.cylinder(m, cf, "Base", 0, 0, 0, 3, 0.4, C.black, M.Metal)
	Kit.cylinder(m, cf, "Post", 0, 0.4, 0, 0.6, 1.4, C.black, M.Metal)
	Kit.part(m, cf, "Seat", 0, 1.8, 0, 4.4, 0.8, 4.2, C.red, M.Fabric)
	Kit.part(m, cf, "Back", 0, 2.6, 1.8, 4.2, 5.6, 0.8, C.red, M.Fabric)
	Kit.part(m, cf, "Arm", -2.3, 2.6, 0, 0.5, 1.2, 3, C.black, M.Plastic)
	Kit.part(m, cf, "Arm", 2.3, 2.6, 0, 0.5, 1.2, 3, C.black, M.Plastic)
	return m
end

function Appliances.toilet(parent: Instance, cf: CFrame): Model
	local m = Kit.model("Toilet", parent)
	Kit.part(m, cf, "Bowl", 0, 0, -0.4, 2, 1.8, 2.6, C.white, M.SmoothPlastic)
	Kit.part(m, cf, "Seat", 0, 1.8, -0.4, 2.2, 0.2, 2.8, C.white, M.SmoothPlastic)
	Kit.part(m, cf, "Tank", 0, 1.6, 1.3, 2.4, 2.4, 0.9, C.white, M.SmoothPlastic)
	return m
end

-- Bathtub with a shower curtain that slides along it. You can hide behind it.
function Appliances.bathtub(parent: Instance, cf: CFrame, slide: number): Model
	local m, moving =
		Kit.sliding(parent, "Shower", cf * CFrame.new(0, 0, -2), Vector3.new(slide, 0, 0), "Shower curtain")
	Kit.part(m, cf, "TubBottom", 0, 0, 0, 9, 0.6, 4, C.white, M.SmoothPlastic)
	Kit.part(m, cf, "TubSide", 0, 0.6, -1.8, 9, 1.8, 0.4, C.white, M.SmoothPlastic)
	Kit.part(m, cf, "TubSide", 0, 0.6, 1.8, 9, 1.8, 0.4, C.white, M.SmoothPlastic)
	Kit.part(m, cf, "TubEnd", -4.3, 0.6, 0, 0.4, 1.8, 3.2, C.white, M.SmoothPlastic)
	Kit.part(m, cf, "TubEnd", 4.3, 0.6, 0, 0.4, 1.8, 3.2, C.white, M.SmoothPlastic)
	Kit.part(m, cf, "CurtainRail", 0, 9.6, -2, 9, 0.2, 0.2, C.steel, M.Metal)
	local curtain = Kit.part(moving, cf, "Handle", 0, 2.4, -2, 9, 7.2, 0.15, C.blue, M.Fabric)
	curtain.CanCollide = false
	Kit.hidingSpot(m, cf * CFrame.new(0, 1, 0.2))
	return m
end

-- Bathroom sink with a mirrored medicine cabinet above it.
function Appliances.vanity(parent: Instance, cf: CFrame): Model
	local m = Kit.model("Vanity", parent)
	Appliances.sinkCounter(m, cf, C.white, {
		{
			{
				n = "Bulk toilet paper",
				s = V(2.2, 1.6, 1.6),
				c = C.white,
				line = "Forty-eight rolls. He's prepared for a long ban wave.",
			},
		},
	})
	Storage.cabinet(m, cf * CFrame.new(0, 5.6, 0.9), "MedicineCabinet", 3.4, 3.2, 1.2, C.steel, {
		{
			{
				n = "Expired vitamins",
				s = V(0.6, 0.9, 0.6),
				c = Color3.fromRGB(230, 140, 40),
				line = "Vitamins. Expired 2214. Unopened. Consistent.",
			},
			{
				n = "Mod-strength deodorant",
				s = V(0.6, 1.2, 0.6),
				c = C.blue,
				line = "Deodorant. Still sealed. That explains the basement.",
			},
		},
		{
			{
				n = "Tiny soap",
				s = V(0.8, 0.3, 0.5),
				c = C.cream,
				line = "Hotel soap from a convention he attended. Online.",
			},
		},
	}, "Medicine cabinet", M.Metal)
	return m
end

function Appliances.waterHeater(parent: Instance, cf: CFrame): Model
	local m = Kit.model("WaterHeater", parent)
	Kit.cylinder(m, cf, "Tank", 0, 0.6, 0, 4, 8, C.white, M.Metal)
	Kit.cylinder(m, cf, "Feet", 0, 0, 0, 3, 0.6, C.black, M.Metal)
	Kit.cylinder(m, cf, "Pipe", 0.8, 8.6, 0, 0.5, 4, C.steel, M.Metal)
	return m
end

-- Wall-mounted breaker box. The switch inside is the Lookout's brownout.
function Appliances.breakerBox(parent: Instance, cf: CFrame): Model
	local m = Storage.cabinet(parent, cf, "BreakerBox", 2.6, 3.6, 0.9, C.steel, nil, "Breaker box", M.Metal)
	local switch = Kit.part(m, cf, "Marker_BreakerSwitch", 0, 1.4, 0, 0.6, 1, 0.3, C.red, M.Neon)
	switch:SetAttribute("Breaker", true)
	return m
end

function Appliances.grill(parent: Instance, cf: CFrame): Model
	local m, moving = Kit.hinged(parent, "Grill", cf * CFrame.new(0, 3.6, 1.2), 100, "Grill", "X")
	for _, x in { -2, 2 } do
		Kit.part(m, cf, "Leg", x, 0, 0, 0.3, 2.4, 2, C.black, M.Metal)
	end
	Kit.part(m, cf, "Body", 0, 2.4, 0, 5, 1.2, 2.6, C.black, M.Metal)
	Kit.part(moving, cf, "Lid", 0, 3.6, 0, 5, 1, 2.6, C.black, M.Metal)
	Kit.part(moving, cf, "Handle", 0, 4, -1.45, 2.4, 0.25, 0.3, C.steel, M.Metal)
	local burger = Kit.part(m, cf, "Burnt burger", 0, 3.6, 0, 0.9, 0.4, 0.9, C.black, M.Slate)
	Kit.inspectable(burger, "Burnt burger", "A burger from last summer. It's basically a GPU heat spreader now.")
	return m
end

-- The Admin's moped. Far too small for him.
function Appliances.moped(parent: Instance, cf: CFrame): Model
	local m = Kit.model("Moped", parent)
	m:SetAttribute("Moped", true)
	for _, z in { -2.6, 2.6 } do
		local wheel =
			Kit.box(m, "Wheel", cf * CFrame.new(0, 1.1, z), Vector3.new(0.6, 2.2, 2.2), C.black, M.Rubber) :: Part
		wheel.Shape = Enum.PartType.Cylinder
	end
	Kit.part(m, cf, "Deck", 0, 1, 0, 1.4, 0.5, 4, C.red, M.Metal)
	Kit.part(m, cf, "Seat", 0, 2.6, 1.2, 1.6, 0.6, 2.6, C.black, M.Fabric)
	Kit.part(m, cf, "SeatPost", 0, 1.5, 1.4, 1.2, 1.1, 2, C.red, M.Metal)
	Kit.part(m, cf, "Fork", 0, 1.1, -2.4, 0.5, 3.6, 0.5, C.steel, M.Metal)
	Kit.part(m, cf, "Handlebar", 0, 4.6, -2.4, 3.2, 0.3, 0.3, C.black, M.Metal)
	Kit.part(m, cf, "Headlight", 0, 3.8, -2.8, 0.9, 0.9, 0.4, Color3.fromRGB(255, 240, 200), M.Neon)
	Kit.part(m, cf, "Basket", 0, 3, -3.4, 1.8, 1, 1.2, C.steel, M.DiamondPlate)
	return m
end

-- An old beige tower PC. Whole thing is loot (the CPU is inside).
function Appliances.towerPC(parent: Instance, cf: CFrame, value: number): BasePart
	local p = Kit.part(parent, cf, "Old tower PC", 0, 0, 0, 1.6, 3.4, 3.4, C.cream, M.Plastic)
	Kit.loot(
		p,
		"Old tower PC",
		value,
		"A beige tower. There's a CPU in here older than our mission statement. Taking it."
	)
	return p
end

return Appliances
