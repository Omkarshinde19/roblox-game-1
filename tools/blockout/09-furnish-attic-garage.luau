--!strict
-- Blockout step 9: furniture for the attic and the garage.
-- Rebuilds Workspace.Blockout.House.Furnishings.Attic and .Garage only.
-- Yaw: 0 faces -Z (back of the house), 180 faces +Z (front), 90 faces -X, -90 faces +X.

local Kit = require(script.Parent.Kit)
local Storage = require(script.Parent.furniture.Storage)
local Appliances = require(script.Parent.furniture.Appliances)
local Seating = require(script.Parent.furniture.Seating)

return function()
	local house = workspace.Blockout:WaitForChild("House")
	local furnishings = house:FindFirstChild("Furnishings") or Kit.folder("Furnishings", house)
	for _, name in { "Attic", "Garage" } do
		local old = furnishings:FindFirstChild(name)
		if old then
			old:Destroy()
		end
	end

	local G, A = 246, 260
	local C = Kit.Color
	local M = Enum.Material
	local V = Vector3.new

	---------------- ATTIC (x -52..52, z -104..-40, ridge along z = -72) ----------------
	local attic = Kit.folder("Attic", nil)
	local function up(x: number, z: number, yaw: number?, lift: number?): CFrame
		return Kit.at(x, A + (lift or 0), z, yaw)
	end

	-- the Golden DIMM shrine at the west end
	local shrine = Kit.model("GoldenDIMMShrine", attic)
	Seating.rug(shrine, up(-42, -72), 10, 10, C.red)
	Kit.part(shrine, up(-42, -72), "Pedestal", 0, 0, 0, 3, 3.2, 3, C.white, M.Marble)
	local dimm = Kit.part(shrine, up(-42, -72), "Marker_GoldenDIMM", 0, 3.6, 0, 2.6, 0.7, 0.3, C.gold, M.Neon)
	dimm:SetAttribute("GoldenDIMM", true)
	Seating.poster(shrine, up(-42, -69.8, 0, 0.4), 4, 1.6, "DO NOT SELL\nEVEN FOR $10K", C.black, C.gold)
	local lamp = Kit.part(shrine, up(-42, -72, 0, 15), "ShrineSpot", 0, 0, 0, 1, 0.6, 1, C.black, M.Metal)
	local spot = Instance.new("SpotLight")
	spot.Face = Enum.NormalId.Bottom
	spot.Color = Color3.fromRGB(255, 225, 150)
	spot.Angle = 40
	spot.Range = 24
	spot.Brightness = 6
	spot.Shadows = true
	spot.Parent = lamp
	for _, p in { { -46, -67 }, { -38, -67 }, { -46, -77 }, { -38, -77 } } do
		Kit.cylinder(shrine, up(p[1], p[2]), "RopePost", 0, 0, 0, 0.5, 3, C.gold, M.Metal)
	end

	Storage.trunk(attic, up(-22, -80, 180), "AtticTrunk", 6, 3, 3.4, C.darkWood, {
		{
			n = "Vintage DDR3",
			s = V(1.6, 0.4, 0.5),
			c = C.green,
			value = 180,
			line = "DDR3. From the before times. It belongs in a museum. Our museum has racks.",
		},
		{
			n = "Baby photos",
			s = V(1.6, 0.4, 1.2),
			c = C.cream,
			line = "Baby photos. He was moderating the other babies. Even then.",
		},
	})
	for i, p in { { 16, -62 }, { 20.5, -63 } } do
		local gpu =
			Storage.box(attic, up(p[1], p[2], i * 15), "Sealed 2023 GPU", 3.6, 2.2, 2, C.black, "GPU 2023\nSEALED")
		Kit.loot(
			gpu,
			"Sealed 2023 GPU",
			450,
			"Unopened stock from 2023. Two hundred years old. Still faster than what we ship."
		)
	end
	Storage.box(attic, up(-8, -58, 10), "Box", 4, 3, 3.4, nil, "HALLOWEEN")
	Storage.box(attic, up(-13, -60, -20), "Box", 3.4, 2.6, 3, nil, "HIS DRAWINGS")
	Storage.box(attic, up(-2, -86, 5), "Box", 4, 3, 3, nil, "DO NOT THROW OUT")
	Storage.box(attic, up(24, -84, 0), "Box", 5, 3.4, 3.4, nil, "XMAS TREE")
	Storage.box(attic, up(-30, -88, 30), "Box", 3, 3, 3)
	local crt = Kit.part(attic, up(30, -66, 200), "Dusty CRT", 0, 0, 0, 3, 2.8, 3, C.cream, M.Plastic)
	Kit.inspectable(
		crt,
		"Dusty CRT",
		"Another CRT. He keeps them 'for the input lag'. There is none. That's the point."
	)
	Seating.chair(attic, up(8, -62, 150), C.darkWood)
	Seating.bulb(attic, Kit.at(0, A + 20.5, -72), Color3.fromRGB(255, 200, 140), 44, 0.9)
	-- crates to climb to the roof window (x 34..44 on the front slope)
	local step1 = Storage.box(attic, up(39, -61, 180), "WindowCrate", 5, 2.2, 4, C.darkWood)
	local step2 = Storage.box(attic, up(39, -56.5, 180), "WindowCrate", 5, 4.6, 4.6, C.darkWood)
	step1.Material = M.WoodPlanks
	step2.Material = M.WoodPlanks
	attic.Parent = furnishings

	---------------- GARAGE (x 52..92, z -88..-40, door on the +Z side) ----------------
	local garage = Kit.folder("Garage", nil)
	local function at(x: number, z: number, yaw: number?, lift: number?): CFrame
		return Kit.at(x, G + (lift or 0), z, yaw)
	end
	Appliances.moped(garage, at(60, -52, 180))
	Seating.rug(garage, at(74, -58), 12, 18, Color3.fromRGB(45, 45, 48))
	Storage.drawers(garage, at(70, -85.8, 180), "Workbench", 10, 3.6, 2.8, 2, C.darkWood, {
		[1] = {
			{
				n = "Every Allen key",
				s = V(3, 0.5, 1.4),
				c = C.steel,
				m = M.Metal,
				line = "Every Allen key from every flat-pack desk since 2190.",
			},
		},
		[2] = {
			{
				n = "Spare RAM box",
				s = V(2.4, 0.9, 1.4),
				c = C.blue,
				value = 220,
				line = "A box labelled 'spare RAM'. Nobody has spare RAM. Except him. Until now.",
			},
		},
	})
	Seating.poster(garage, at(70, -87.2, 180, 5), 10, 4, "TOOLS\n(never used)", C.cardboard, C.black)
	Storage.cabinet(garage, at(81, -85.9, 180), "ToolCabinet", 4, 7.4, 2.4, C.red, {
		{
			{
				n = "Unopened toolkit",
				s = V(2.4, 1, 1.4),
				c = C.black,
				line = "A toolkit. Shrink-wrapped. He builds PCs with a butter knife.",
			},
		},
		{
			{
				n = "Moped manual",
				s = V(1.4, 0.3, 1),
				c = C.cream,
				line = "The moped manual. Max rider weight is circled. And ignored.",
			},
		},
		{ { n = "Helmet", s = V(1.6, 1.4, 1.6), c = C.red, line = "A helmet. Size: small. Safety third." } },
	}, "Tool cabinet", M.Metal)
	Storage.shelf(garage, at(53.9, -63, -90), "GarageShelf", 12, 8, 2, 3, C.steel, {
		{
			{ n = "Motor oil", s = V(1.2, 1.6, 1), c = C.black },
			{
				n = "Car battery",
				s = V(2, 1.4, 1.4),
				c = C.red,
				value = 60,
				line = "A battery. Power is compute. Compute is everything. Yoink.",
			},
		},
		{
			{
				n = "Keyboard graveyard",
				s = V(5, 1, 1.4),
				c = C.black,
				line = "Nine dead keyboards. Cause of death: rage.",
			},
		},
		{
			{
				n = "Camping gear",
				s = V(4, 1.6, 1.4),
				c = C.green,
				m = M.Fabric,
				line = "Camping gear. Unused. Indoors is undefeated.",
			},
		},
	}, M.Metal)
	for i, z in { -71.5, -74 } do
		Appliances.towerPC(garage, at(54.3, z, -90), 140 + i * 20)
	end
	Appliances.towerPC(garage, at(57, -86, 180), 180)
	Storage.shelf(garage, at(90.1, -56, 90), "GarageShelf", 12, 8, 2, 3, C.steel, {
		{
			{ n = "Paint cans", s = V(3, 1.2, 1.4), c = C.steel, m = M.Metal },
			{ n = "Snow chains", s = V(2.4, 0.8, 1.4), c = C.black, m = M.Metal },
		},
		{
			{
				n = "Box of monitors' boxes",
				s = V(4, 1.8, 1.6),
				c = C.cardboard,
				line = "Boxes of boxes. In case he needs to return a monitor from 2195.",
			},
		},
	}, M.Metal)
	for i = 0, 2 do
		local tire = Kit.cylinder(garage, at(88, -44), "Tire", 0, i * 1.2, 0, 3.4, 1.2, C.black, M.Rubber)
		if i == 2 then
			Kit.inspectable(tire, "Tires", "Car tires. He doesn't own a car. He owns a moped. And opinions.")
		end
	end
	garage.Parent = furnishings

	print(`[blockout] attic + garage furniture: {#attic:GetDescendants() + #garage:GetDescendants()} instances`)
end
