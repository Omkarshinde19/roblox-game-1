--!strict
-- Blockout step 4: the cabin shell (104 x 64 studs, hillside walk-out).
-- Front faces +Z (downhill). Rebuilds Workspace.Blockout.House but keeps its
-- "Furnishings" child, so furniture survives a shell rebuild.
--
--   Basement  y 232  den | spare room | stairs | storage | laundry
--   Ground    y 246  living + dining (open) | Mom's room | old bedroom |
--                    bathroom | stair hall | kitchen | pantry | mud room
--   Attic     y 260  one open space under the roof (ridge y 282)
--   Garage    x 52..92, on the east side, at ground level
--
-- Room bounds are documented in tools/blockout/README.md.

local Kit = require(script.Parent.Kit)

return function()
	local root = workspace:WaitForChild("Blockout")
	local old = root:FindFirstChild("House")
	local furnishings = old and old:FindFirstChild("Furnishings")
	if furnishings then
		furnishings.Parent = nil
	end
	if old then
		old:Destroy()
	end

	local house = Kit.model("House", nil)
	house.ModelStreamingMode = Enum.ModelStreamingMode.Atomic

	local B, G, A, RIDGE = 232, 246, 260, 282
	local H = 14
	local X1, X2, Z1, Z2 = -52, 52, -104, -40
	local GX1, GX2, GZ1, GZ2 = 52, 92, -88, -40
	local ZM, HALF, RISE = (Z1 + Z2) / 2, (Z2 - Z1) / 2, RIDGE - A
	local DZ = Z2 + 20 -- front edge of the deck
	local M = Enum.Material
	local C = Kit.Color
	local T = workspace.Terrain

	---------------- carve the hill ----------------
	T:FillBlock(CFrame.new(0, (B - 1 + G) / 2, ZM), Vector3.new(X2 - X1, G - B + 1, Z2 - Z1), M.Air) -- basement
	T:FillBlock(CFrame.new(-1, (B + G) / 2 + 1, (Z2 + DZ) / 2), Vector3.new(110, G - B + 2, DZ - Z2), M.Air) -- under the deck
	T:FillBlock(CFrame.new((GX1 + GX2) / 2, G + 6, (GZ1 + GZ2) / 2), Vector3.new(GX2 - GX1, 14, GZ2 - GZ1), M.Air) -- garage

	---------------- BASEMENT ----------------
	local bF = Kit.folder("Basement", house)
	Kit.box(bF, "Floor", CFrame.new(0, B - 0.5, ZM), Vector3.new(X2 - X1 + 2, 1, Z2 - Z1 + 2), C.concrete, M.Concrete)
	Kit.wall(bF, "BackWall", "x", Z1, X1 - 1, X2 + 1, B, H, {}, C.concrete, M.Concrete, 2)
	Kit.wall(bF, "WestWall", "z", X1, Z1, Z2, B, H, {}, C.concrete, M.Concrete, 2)
	Kit.wall(bF, "EastWall", "z", X2, Z1, Z2, B, H, {}, C.concrete, M.Concrete, 2)
	Kit.wall(bF, "FrontWall", "x", Z2, X1 - 1, X2 + 1, B, H, {
		{ c = -30, w = 10, b = 5, t = 9, glass = true },
		{ c = 6, w = 6, b = 0, t = 9 }, -- walk-out door
		{ c = 34, w = 8, b = 6, t = 9.5, glass = true },
	}, C.concrete, M.Concrete, 2)
	Kit.wall(bF, "DenBackWall", "x", -76, X1, X2, B, H, {
		{ c = -30, w = 5.5, b = 0, t = 9 }, -- spare room
		{ c = -5.5, w = 7, b = 0, t = 12.5 }, -- stairs arrive here
		{ c = 32, w = 5.5, b = 0, t = 9 }, -- storage <-> laundry
	}, C.inner, M.Concrete)
	Kit.wall(bF, "DenStorageWall", "z", 12, -76, Z2, B, H, { { c = -58, w = 5.5, b = 0, t = 9 } }, C.inner, M.Concrete)
	Kit.wall(bF, "StairWallWest", "z", -9.5, Z1, -76, B, H, {}, C.inner, M.Concrete)
	Kit.wall(bF, "StairWallEast", "z", -1.5, Z1, -76, B, H, {}, C.inner, M.Concrete)

	local function door(
		parent: Instance,
		name: string,
		axis: string,
		fixed: number,
		c: number,
		y: number,
		hinge: number,
		swing: number,
		display: string?,
		glass: boolean?,
		w: number?
	)
		return Kit.door(parent, {
			name = name,
			axis = axis,
			fixed = fixed,
			c = c,
			y = y,
			w = w or 5.5,
			h = 9,
			hinge = hinge,
			swing = swing,
			col = if glass then C.glassWarm else C.darkWood,
			glass = glass,
			display = display,
		})
	end
	door(bF, "Door_WalkOut", "x", Z2, 6, B, 1, -1, "Walk-out door", true, 6)
	door(bF, "Door_SpareRoom", "x", -76, -30, B, -1, -1)
	door(bF, "Door_Laundry", "x", -76, 32, B, 1, -1, "Laundry door")
	door(bF, "Door_Storage", "z", 12, -58, B, -1, 1, "Storage door")
	Kit.shutter(bF, "Shutter_WalkOut", CFrame.new(6, B + 4.5, Z2 + 1.3), Vector3.new(6.4, 9, 0.4))

	---------------- GROUND FLOOR ----------------
	local gF = Kit.folder("GroundFloor", house)
	-- slab with the stairwell hole at x -9..-2, z -99..-75
	Kit.box(gF, "Floor", CFrame.new((X1 - 9) / 2, G - 0.5, ZM), Vector3.new(-9 - X1, 1, Z2 - Z1), C.floor, M.WoodPlanks)
	Kit.box(gF, "Floor", CFrame.new((-2 + X2) / 2, G - 0.5, ZM), Vector3.new(X2 + 2, 1, Z2 - Z1), C.floor, M.WoodPlanks)
	Kit.box(gF, "Floor", CFrame.new(-5.5, G - 0.5, (Z1 - 99) / 2), Vector3.new(7, 1, 5), C.floor, M.WoodPlanks)
	Kit.box(gF, "Floor", CFrame.new(-5.5, G - 0.5, (-75 + Z2) / 2), Vector3.new(7, 1, 35), C.floor, M.WoodPlanks)

	Kit.wall(gF, "FrontWall", "x", Z2, X1, X2, G, H, {
		{ c = -28, w = 40, b = 0.5, t = 12, glass = true }, -- living room glass
		{ c = 0, w = 8, b = 0, t = 10 }, -- front slider
		{ c = 16, w = 20, b = 0.5, t = 12, glass = true }, -- dining glass
		{ c = 40, w = 12, b = 3.5, t = 10, glass = true }, -- Mom's window
	}, C.timber, M.WoodPlanks, 1.5)
	Kit.wall(gF, "BackWall", "x", Z1, X1, X2, G, H, {
		{ c = -39, w = 10, b = 4, t = 10, glass = true }, -- old bedroom
		{ c = -18, w = 5, b = 6.5, t = 10, glass = true }, -- bathroom
		{ c = 14, w = 5.5, b = 0, t = 9 }, -- back door
		{ c = 20, w = 2.4, b = 0, t = 2.4 }, -- doggy door
		{ c = 28, w = 10, b = 4.5, t = 10, glass = true }, -- kitchen
	}, C.timber, M.WoodPlanks, 1.5)
	Kit.wall(gF, "WestWall", "z", X1, Z1, Z2, G, H, {
		{ c = -88, w = 8, b = 4, t = 10, glass = true },
		{ c = -56, w = 14, b = 2, t = 11, glass = true },
	}, C.timber, M.WoodPlanks, 1.5)
	Kit.wall(gF, "EastWall", "z", X2, Z1, Z2, G, H, { { c = -80, w = 5.5, b = 0, t = 9 } }, C.timber, M.WoodPlanks, 1.5)

	Kit.wall(gF, "MidWall", "x", -72, X1, X2, G, H, {
		{ c = -34, w = 5.5, b = 0, t = 9 }, -- old bedroom
		{ c = -18, w = 5, b = 0, t = 9 }, -- bathroom
		{ c = 3, w = 9, b = 0, t = 11 }, -- stair hall arch
		{ c = 20, w = 14, b = 0, t = 11 }, -- kitchen arch
	}, C.inner)
	Kit.wall(gF, "BedroomBathWall", "z", -26, Z1, -72, G, H, {}, C.inner)
	Kit.wall(gF, "BathHallWall", "z", -10, Z1, -72, G, H, {}, C.inner)
	Kit.wall(gF, "HallKitchenWall", "z", 8, Z1, -72, G, H, { { c = -80, w = 6, b = 0, t = 10 } }, C.inner)
	Kit.wall(gF, "KitchenPantryWall", "z", 36, Z1, -72, G, H, {
		{ c = -96, w = 5, b = 0, t = 9 }, -- pantry
		{ c = -80, w = 5.5, b = 0, t = 9 }, -- mud room
	}, C.inner)
	Kit.wall(gF, "PantryMudWall", "x", -88, 36, X2, G, H, {}, C.inner)
	Kit.wall(gF, "MomRoomWall", "z", 28, -72, Z2, G, H, { { c = -62, w = 5.5, b = 0, t = 9 } }, C.inner)

	door(gF, "Door_Back", "x", Z1, 14, G, -1, 1, "Back door")
	door(gF, "Door_GarageInner", "z", X2, -80, G, -1, -1, "Garage door")
	door(gF, "Door_OldBedroom", "x", -72, -34, G, -1, -1)
	door(gF, "Door_Bathroom", "x", -72, -18, G, 1, -1, "Bathroom door", false, 5)
	door(gF, "Door_Pantry", "z", 36, -96, G, -1, 1, "Pantry door", false, 5)
	door(gF, "Door_MudRoom", "z", 36, -80, G, 1, 1)
	door(gF, "Door_MomRoom", "z", 28, -62, G, 1, 1, "Mom's door")

	-- front slider (slides east, behind the dining glass)
	local slider, sliderMoving =
		Kit.sliding(gF, "Door_FrontSlider", CFrame.new(0, G, Z2 - 0.5), Vector3.new(7.8, 0, 0), "Front slider")
	local pane =
		Kit.box(sliderMoving, "Panel", CFrame.new(0, G + 5, Z2 - 0.5), Vector3.new(7.8, 9.8, 0.3), C.glassWarm, M.Glass)
	pane.Transparency = 0.5
	Kit.box(sliderMoving, "Handle", CFrame.new(-3.2, G + 4, Z2 - 0.5), Vector3.new(0.5, 1.6, 0.7), C.steel, M.Metal)
	slider:SetAttribute("Entry", true)

	-- doggy door flap (hinged at the top)
	local _, flapMoving = Kit.hinged(gF, "Door_Doggy", CFrame.new(20, G + 2.4, Z1), 80, "Doggy door", "X")
	Kit.box(flapMoving, "Handle", CFrame.new(20, G + 1.2, Z1), Vector3.new(2.2, 2.2, 0.2), C.black, M.Fabric)

	Kit.shutter(gF, "Shutter_FrontSlider", CFrame.new(0, G + 5, Z2 + 1.1), Vector3.new(8.4, 10, 0.4))
	Kit.shutter(gF, "Shutter_Back", CFrame.new(14, G + 4.5, Z1 - 1.1), Vector3.new(6, 9, 0.4))
	Kit.shutter(gF, "Shutter_Doggy", CFrame.new(20, G + 1.2, Z1 - 1.1), Vector3.new(2.8, 2.4, 0.4))
	local cam = Kit.box(
		gF,
		"Marker_DoorbellCam",
		CFrame.new(5.2, G + 8, Z2 + 0.9),
		Vector3.new(0.8, 1.2, 0.4),
		C.black,
		M.Metal
	)
	cam:SetAttribute("DoorbellCam", true)

	---------------- STAIRS: ground <-> basement ----------------
	local sF = Kit.folder("Stairs", house)
	for k = 1, 13 do
		Kit.box(
			sF,
			"Step",
			CFrame.new(-5.5, G - k - 0.5, -99 + (k - 0.5) * 1.75),
			Vector3.new(7, 1, 1.8),
			C.floor,
			M.WoodPlanks
		)
	end
	Kit.box(sF, "Railing", CFrame.new(-2, G + 1.75, -87), Vector3.new(0.4, 3.5, 24), C.darkWood, M.Wood)
	Kit.box(sF, "Railing", CFrame.new(-5.5, G + 1.75, -75), Vector3.new(7, 3.5, 0.4), C.darkWood, M.Wood)
	-- invisible ramp over the steps so players and NPCs walk the stairs smoothly
	local rampTop, rampBottom = Vector3.new(-5.5, G, -99), Vector3.new(-5.5, B, -74.5)
	local ramp = Kit.box(
		sF,
		"StairRamp",
		CFrame.lookAt((rampTop + rampBottom) / 2, rampBottom) * CFrame.new(0, -0.2, 0),
		Vector3.new(7, 0.4, (rampTop - rampBottom).Magnitude),
		C.floor
	)
	ramp.Transparency = 1
	local sign = Kit.box(sF, "Sign_ModOnly", CFrame.new(-5.5, G + 10.5, -103), Vector3.new(7, 2, 0.2), C.black)
	Kit.sign(sign, Enum.NormalId.Back, "DO NOT ENTER. MOD ONLY", C.red)

	---------------- ATTIC ----------------
	local aF = Kit.folder("Attic", house)
	-- slab with the ladder hatch at x 3..8, z -90..-84
	Kit.box(aF, "Floor", CFrame.new((X1 + 3) / 2, A - 0.5, ZM), Vector3.new(3 - X1, 1, Z2 - Z1), C.floor, M.WoodPlanks)
	Kit.box(aF, "Floor", CFrame.new((8 + X2) / 2, A - 0.5, ZM), Vector3.new(X2 - 8, 1, Z2 - Z1), C.floor, M.WoodPlanks)
	Kit.box(aF, "Floor", CFrame.new(5.5, A - 0.5, (Z1 - 90) / 2), Vector3.new(5, 1, 14), C.floor, M.WoodPlanks)
	Kit.box(aF, "Floor", CFrame.new(5.5, A - 0.5, (-84 + Z2) / 2), Vector3.new(5, 1, 44), C.floor, M.WoodPlanks)
	local ladder = Kit.box(
		aF,
		"AtticLadder",
		CFrame.new(6.5, (G + A) / 2, -87),
		Vector3.new(2, A - G, 2),
		C.wood,
		M.Wood,
		"TrussPart"
	)
	ladder:SetAttribute("Climbable", true)
	for _, x in { X1, X2 } do
		Kit.box(
			aF,
			"Gable",
			CFrame.new(x, A + RISE / 2, ZM + HALF / 2) * CFrame.Angles(0, math.pi, 0),
			Vector3.new(1.5, RISE, HALF),
			C.timber,
			M.WoodPlanks,
			"WedgePart"
		)
		Kit.box(
			aF,
			"Gable",
			CFrame.new(x, A + RISE / 2, ZM - HALF / 2),
			Vector3.new(1.5, RISE, HALF),
			C.timber,
			M.WoodPlanks,
			"WedgePart"
		)
	end

	---------------- ROOF: dark metal gable, escape window on the front slope ----------------
	local rF = Kit.folder("Roof", house)
	local slopeLen = math.sqrt(HALF ^ 2 + RISE ^ 2) + 2
	local ang = math.atan2(RISE, HALF)
	local function slabCF(front: boolean, xc: number, s0: number, s1: number): CFrame
		local sm = (s0 + s1) / 2 - 2
		local dz, dy = math.cos(ang) * sm, math.sin(ang) * sm
		if front then
			return CFrame.new(xc, A + dy + 0.6, Z2 - dz) * CFrame.Angles(ang, 0, 0)
		end
		return CFrame.new(xc, A + dy + 0.6, Z1 + dz) * CFrame.Angles(-ang, 0, 0)
	end
	local xa, xb = X1 - 2, X2 + 2
	local wx1, wx2, ws1, ws2 = 34, 44, 10, 18
	local function slab(name: string, front: boolean, x1: number, x2: number, s0: number, s1: number)
		Kit.box(
			rF,
			name,
			slabCF(front, (x1 + x2) / 2, s0, s1),
			Vector3.new(x2 - x1, 1, s1 - s0),
			C.roof,
			M.CorrodedMetal
		)
	end
	slab("BackSlope", false, xa, xb, 0, slopeLen)
	slab("FrontSlope", true, xa, wx1, 0, slopeLen)
	slab("FrontSlope", true, wx2, xb, 0, slopeLen)
	slab("FrontSlope", true, wx1, wx2, 0, ws1)
	slab("FrontSlope", true, wx1, wx2, ws2, slopeLen)
	local win = Kit.box(
		rF,
		"RoofWindow_Escape",
		slabCF(true, (wx1 + wx2) / 2, ws1, ws2),
		Vector3.new(wx2 - wx1, 0.4, ws2 - ws1),
		Color3.fromRGB(180, 210, 230),
		M.Glass
	)
	win.Transparency = 0.6
	win.CanCollide = false
	win:SetAttribute("EscapeExit", true)

	---------------- GARAGE ----------------
	local gaF = Kit.folder("Garage", house)
	local gxm, gzm = (GX1 + GX2) / 2, (GZ1 + GZ2) / 2
	Kit.box(gaF, "Floor", CFrame.new(gxm, G - 0.5, gzm), Vector3.new(GX2 - GX1, 1, GZ2 - GZ1), C.concrete, M.Concrete)
	Kit.wall(
		gaF,
		"FrontWall",
		"x",
		GZ2,
		GX1,
		GX2,
		G,
		H,
		{ { c = 72, w = 24, b = 0, t = 10 } },
		C.timber,
		M.WoodPlanks,
		1.5
	)
	Kit.wall(gaF, "BackWall", "x", GZ1, GX1, GX2, G, H, {}, C.timber, M.WoodPlanks, 1.5)
	Kit.wall(
		gaF,
		"EastWall",
		"z",
		GX2,
		GZ1,
		GZ2,
		G,
		H,
		{ { c = -78, w = 5.5, b = 0, t = 9 } },
		C.timber,
		M.WoodPlanks,
		1.5
	)
	Kit.box(
		gaF,
		"Roof",
		CFrame.new(gxm, G + H + 0.5, gzm),
		Vector3.new(GX2 - GX1 + 2, 1, GZ2 - GZ1 + 2),
		C.roof,
		M.Metal
	)
	local garageDoor = Kit.box(
		gaF,
		"GarageDoor",
		CFrame.new(72, G + 5, GZ2),
		Vector3.new(24, 10, 0.6),
		Color3.fromRGB(60, 60, 62),
		M.Metal
	)
	garageDoor:SetAttribute("GarageDoor", true)
	door(gaF, "Door_GarageSide", "z", GX2, -78, G, 1, -1, "Garage side door")
	local keypad =
		Kit.box(gaF, "Marker_Keypad", CFrame.new(GX2 + 0.9, G + 4.5, -73.5), Vector3.new(0.3, 1.4, 1), C.black, M.Metal)
	keypad:SetAttribute("Keypad", true)
	Kit.shutter(gaF, "Shutter_GarageSide", CFrame.new(GX2 + 1.1, G + 4.5, -78), Vector3.new(0.4, 9, 6))
	Kit.shutter(gaF, "Shutter_Garage", CFrame.new(72, G + 5, GZ2 + 1.1), Vector3.new(24.4, 10, 0.4))

	---------------- DECK on a stone retaining wall (gap at x 2..10 for the walk-out) ----------------
	local dF = Kit.folder("Deck", house)
	local wallH = G - 1 - B
	local wallY = B + wallH / 2
	Kit.box(
		dF,
		"DeckBoards",
		CFrame.new(0, G - 0.5, (Z2 + DZ) / 2),
		Vector3.new(112, 1, DZ - Z2),
		Color3.fromRGB(170, 110, 60),
		M.WoodPlanks
	)
	Kit.box(dF, "StoneWall", CFrame.new(-27, wallY, DZ - 1.5), Vector3.new(58, wallH, 3), C.stone, M.Slate)
	Kit.box(dF, "StoneWall", CFrame.new(33, wallY, DZ - 1.5), Vector3.new(46, wallH, 3), C.stone, M.Slate)
	Kit.box(dF, "StoneWall", CFrame.new(6, G - 2.5, DZ - 1.5), Vector3.new(8, 3, 3), C.stone, M.Slate)
	Kit.box(dF, "StoneWall", CFrame.new(-57.5, wallY, (Z2 + DZ) / 2), Vector3.new(3, wallH, DZ - Z2), C.stone, M.Slate)

	---------------- room lights (only four cast shadows) ----------------
	local lF = Kit.folder("Lights", house)
	local warm, cold = Color3.fromRGB(255, 190, 130), Color3.fromRGB(190, 210, 255)
	Kit.light(lF, "Living", Vector3.new(-28, G + 12, -56), warm, 44, 2, true)
	Kit.light(lF, "Dining", Vector3.new(12, G + 12, -56), warm, 36, 2, true)
	Kit.light(lF, "Kitchen", Vector3.new(22, G + 12, -88), warm, 34, 1.6, true)
	Kit.light(lF, "StairHall", Vector3.new(3, G + 12, -88), warm, 24, 1)
	Kit.light(lF, "OldBedroom", Vector3.new(-39, G + 12, -88), cold, 28, 0.6)
	Kit.light(lF, "Bathroom", Vector3.new(-18, G + 12, -88), cold, 22, 1)
	Kit.light(lF, "MomRoom", Vector3.new(40, G + 12, -56), warm, 30, 1.2)
	Kit.light(lF, "MudRoom", Vector3.new(44, G + 12, -80), warm, 18, 0.8)
	Kit.light(lF, "Pantry", Vector3.new(44, G + 12, -96), warm, 18, 0.8)
	Kit.light(lF, "DenRGB", Vector3.new(-30, B + 10, -58), C.purple, 46, 3, true)
	Kit.light(lF, "Storage", Vector3.new(32, B + 12, -58), cold, 30, 0.7)
	Kit.light(lF, "Laundry", Vector3.new(25, B + 12, -90), cold, 34, 0.9)
	Kit.light(lF, "SpareRoom", Vector3.new(-30, B + 12, -90), cold, 28, 0.4)
	Kit.light(lF, "Attic", Vector3.new(0, A + 14, ZM), warm, 50, 0.5)
	Kit.light(lF, "Garage", Vector3.new(72, G + 12, -64), cold, 40, 0.9)

	if furnishings then
		furnishings.Parent = house
	end
	house.Parent = root
	print(`[blockout] house shell: {#house:GetDescendants()} instances`)
end
