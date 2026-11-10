--!strict
-- Blockout step 8: furniture for the basement (den, spare room, storage, laundry).
-- Rebuilds Workspace.Blockout.House.Furnishings.Basement only.
-- Yaw: 0 faces -Z (back of the house), 180 faces +Z (front), 90 faces -X, -90 faces +X.

local Kit = require(script.Parent.Kit)
local Storage = require(script.Parent.furniture.Storage)
local Appliances = require(script.Parent.furniture.Appliances)
local Seating = require(script.Parent.furniture.Seating)

return function()
	local house = workspace.Blockout:WaitForChild("House")
	local furnishings = house:FindFirstChild("Furnishings") or Kit.folder("Furnishings", house)
	local old = furnishings:FindFirstChild("Basement")
	if old then
		old:Destroy()
	end
	local root = Kit.folder("Basement", nil)

	local B = 232
	local C = Kit.Color
	local M = Enum.Material
	local V = Vector3.new
	local DOOM = Color3.fromRGB(60, 200, 70)

	local function at(x: number, z: number, yaw: number?, up: number?): CFrame
		return Kit.at(x, B + (up or 0), z, yaw)
	end
	local function carton(label: string): Kit.Item
		return { n = label, s = V(2.4, 1.8, 1.4), c = C.cardboard, m = M.Cardboard }
	end

	---------------- THE DEN / "SERVER ROOM" (x -52..12, z -76..-40) ----------------
	local den = Kit.folder("Den", root)
	Seating.rug(den, at(-42, -60), 14, 16, Color3.fromRGB(40, 30, 60))
	Appliances.battlestation(den, at(-48.8, -60, -90))
	Appliances.gamingChair(den, at(-43.5, -60, 90))
	Appliances.miniFridge(den, at(-49.3, -71, -90))
	Seating.sofa(den, at(-42, -73.2, 180), 10, Color3.fromRGB(60, 50, 80))
	Seating.poster(den, at(-42, -75.4, 180, 6), 7, 4, "RULE 1:\nI AM THE RULES", C.black, C.purple)
	Seating.poster(den, at(-50.9, -44, -90, 5), 5, 6, "BAN LIST\n(everyone)", C.white, C.red)
	Storage.shelf(den, at(-18, -74.4, 180), "ScalpedGPUShelf", 10, 8, 2, 3, C.black, {
		{
			{
				n = "Boxed GPU",
				s = V(2.6, 1.8, 1.4),
				c = C.green,
				value = 500,
				line = "A boxed GPU. Still sealed. He scalped it and never even played. Liberated.",
			},
			{
				n = "Boxed GPU",
				s = V(2.6, 1.8, 1.4),
				c = C.green,
				value = 500,
				line = "Another one. This shelf is a crime scene. I'm the detective. And the thief.",
			},
		},
		{
			{
				n = "Boxed GPU",
				s = V(2.6, 1.8, 1.4),
				c = C.red,
				value = 500,
				line = "Sealed since launch day. It deserves a data center. It deserves me.",
			},
			{
				n = "Receipt binder",
				s = V(1.6, 1.6, 1),
				c = C.blue,
				line = "Receipts. He bought forty GPUs and returned none. Respect. Also, mine.",
			},
		},
		{
			{
				n = "Funko wall",
				s = V(6, 1.6, 1.2),
				c = C.cream,
				line = "Collectible figures of streamers. All of them have banned him.",
			},
		},
	}, M.Metal)
	Seating.beanbag(den, at(-22, -52), C.purple)
	local pizza = Storage.box(den, at(-34, -45, 180), "Pizza box tower", 2.6, 4, 2.6)
	Kit.inspectable(pizza, "Pizza box tower", "A tower of pizza boxes. Load-bearing. Do not remove the bottom one.")
	for i, p in { { -30, -44 }, { -27.5, -45.5 }, { -29, -47 } } do
		local bag = Kit.part(den, at(p[1], p[2]), "Trash bag", 0, 0, 0, 2.4, 2.4, 2.4, C.black, M.Fabric) :: Part
		bag.Shape = Enum.PartType.Ball
		if i == 1 then
			Kit.inspectable(bag, "Trash bag", "Trash bags. He takes them out annually. It's a tradition.")
		end
	end
	local cans = Kit.part(den, at(-46, -50), "Can pyramid", 0, 0, 0, 3, 2.6, 3, DOOM, M.Metal)
	Kit.inspectable(cans, "Can pyramid", "A pyramid of empty Mountain Doom cans. Ancient. Sacred. Sticky.")
	for _, strip in { { -50.9, -58, -90, 34 }, { -20, -75.4, 180, 62 } } do
		local s = Kit.part(
			den,
			at(strip[1], strip[2], strip[3], 12.4),
			"RGBStrip",
			0,
			0,
			0,
			strip[4],
			0.3,
			0.2,
			C.purple,
			M.Neon
		)
		s.CanCollide = false
	end

	---------------- SPARE ROOM (x -52..-10, z -104..-76) ----------------
	local spare = Kit.folder("SpareRoom", root)
	Seating.bulb(spare, Kit.at(-30, B + 13, -90), Color3.fromRGB(255, 170, 120), 26, 0.9)
	Seating.chair(spare, at(-30, -90, 180), C.steel)
	local mattress =
		Kit.part(spare, at(-46, -98, 20), "Old mattress", 0, 0, 0, 6, 1, 9, Color3.fromRGB(160, 155, 140), M.Fabric)
	Kit.inspectable(
		mattress,
		"Old mattress",
		"A mattress on the floor and one chair. I'm getting 'timeout' energy from this room."
	)
	Storage.box(spare, at(-14, -100, 180), "Box", 4, 3, 3, nil, "BANNED USERS' STUFF")
	Storage.box(spare, at(-18.5, -100.5, 180), "Box", 3, 2.4, 3)
	Seating.poster(spare, at(-30, -76.6, 0, 6), 6, 2, "KEEP OUT", C.black, C.red)

	---------------- STORAGE (x 12..52, z -76..-40) ----------------
	local storage = Kit.folder("Storage", root)
	Appliances.breakerBox(storage, at(50.5, -58, 90, 4))
	Storage.shelf(storage, at(21, -74.4, 180), "StorageShelf", 10, 9, 2, 3, C.steel, {
		{ carton("Tax records 2190-2220"), carton("Cables (more)") },
		{
			carton("Mom's yarn"),
			{
				n = "Old router",
				s = V(1.6, 0.6, 1.2),
				c = C.black,
				value = 70,
				line = "A router from the 2100s. There's a chip in there somewhere. Everything counts.",
			},
		},
		{ carton("Baby clothes") },
	}, M.Metal)
	Storage.shelf(storage, at(44, -74.4, 180), "StorageShelf", 12, 9, 2, 3, C.steel, {
		{ carton("XMAS 2198"), carton("XMAS 2199"), carton("XMAS (broken)") },
		{
			{
				n = "Paint cans",
				s = V(3, 1.2, 1.4),
				c = C.steel,
				m = M.Metal,
				line = "Paint. The colour is called 'Moderator Grey'.",
			},
		},
		{ carton("Dad's things") },
	}, M.Metal)
	local crate =
		Storage.box(storage, at(38, -48, 180), "Marker_MiningRigCrate", 6, 4.4, 5, C.darkWood, "MINING RIG\n(retired)")
	crate.Material = M.WoodPlanks
	crate:SetAttribute("HeavyLoot", true)
	crate:SetAttribute("Carriers", 3)
	Appliances.waterHeater(storage, at(48, -44))
	local crt = Kit.part(storage, at(18, -44, 160), "Old CRT monitor", 0, 0, 0, 3, 2.8, 3, C.cream, M.Plastic)
	Kit.inspectable(crt, "Old CRT monitor", "A CRT. It weighs more than our entire safety team.")
	Storage.trunk(storage, at(26, -44, 0), "ToolChest", 5, 2.6, 3, C.red, {
		{
			n = "Thermal paste hoard",
			s = V(1.8, 0.6, 1.2),
			c = C.steel,
			value = 110,
			line = "Forty tubes of thermal paste. For a rainy day. It's raining.",
		},
	}, "Tool chest")

	---------------- LAUNDRY (x -1..52, z -104..-76) ----------------
	local laundry = Kit.folder("Laundry", root)
	Appliances.laundryMachine(laundry, at(20, -101, 180), "Washer", {
		{
			n = "Wet hoodie",
			s = V(2, 0.8, 1.6),
			c = C.black,
			m = M.Fabric,
			line = "A hoodie that says MOD. Washed weekly. By Mom.",
		},
	})
	Appliances.laundryMachine(laundry, at(24.5, -101, 180), "Dryer", {
		{
			n = "Jeans with a USB stick",
			s = V(2, 0.8, 1.6),
			c = C.blue,
			m = M.Fabric,
			value = 80,
			line = "Jeans. There's a USB stick in the pocket. Tumble-dried storage. Still counts.",
		},
	})
	Appliances.sinkCounter(laundry, at(30, -101.4, 180), C.white, {
		{
			{
				n = "Detergent",
				s = V(1.2, 1.8, 1),
				c = C.blue,
				line = "Detergent. 'Mountain Fresh'. Not that mountain.",
			},
		},
	})
	Storage.shelf(laundry, at(39, -102.2, 180), "LaundryShelf", 8, 7, 2, 3, C.white, {
		{ { n = "Folded towels", s = V(3, 1.4, 1.4), c = C.cream, m = M.Fabric } },
		{
			{
				n = "Lost-sock jar",
				s = V(1.2, 1.4, 1.2),
				c = C.red,
				m = M.Glass,
				line = "A jar of single socks. Each one a tragedy.",
			},
		},
	})
	for i, p in { { 10, -92 }, { 13.5, -95 } } do
		local basket = Kit.cylinder(laundry, at(p[1], p[2]), "Laundry basket", 0, 0, 0, 2.8, 2.2, C.cream, M.Fabric)
		if i == 1 then
			Kit.inspectable(basket, "Laundry basket", "Laundry nobody asked her to do. She did it anyway. Twice.")
		end
	end
	Seating.table(laundry, at(40, -86, 0), "IroningBoard", 7, 2, 3.2, C.steel, M.Metal)
	Seating.bulb(laundry, Kit.at(25, B + 13, -90), Color3.fromRGB(200, 220, 255), 30, 0.8)

	root.Parent = furnishings
	print(`[blockout] basement furniture: {#root:GetDescendants()} instances`)
end
