--!strict
-- Blockout step 4: greybox cabin (hillside walk-out) at the house plot.
-- Basement (B 234) / Ground (G 246) / Attic (A 258, ridge 274). Front faces +Z (downhill).
-- Main cabin x -34..34, z -90..-46. Garage annex x 34..62.

local root = workspace:WaitForChild("Blockout")
local old = root:FindFirstChild("House")
if old then
	old:Destroy()
end
local house = Instance.new("Model")
house.Name = "House"

local B, G, A, RIDGE = 234, 246, 258, 274
local X1, X2, Z1, Z2 = -34, 34, -90, -46
local GX2 = 62
local ZM, HALF, RISE = (Z1 + Z2) / 2, (Z2 - Z1) / 2, RIDGE - A
local H = 12
local M = Enum.Material
local C = {
	timber = Color3.fromRGB(120, 72, 42),
	concrete = Color3.fromRGB(130, 130, 128),
	floor = Color3.fromRGB(150, 110, 75),
	glass = Color3.fromRGB(255, 190, 120),
	roof = Color3.fromRGB(38, 40, 44),
	stone = Color3.fromRGB(105, 105, 100),
	inner = Color3.fromRGB(200, 195, 185),
}

local function folder(name: string): Folder
	local f = Instance.new("Folder")
	f.Name = name
	f.Parent = house
	return f
end

local function box(name: string, cf: CFrame, size: Vector3, mat: Enum.Material, col: Color3, parent: Instance, className: string?): BasePart
	local p = Instance.new(className or "Part") :: BasePart
	p.Name = name
	p.Anchored = true
	p.CFrame = cf
	p.Size = size
	p.Material = mat
	p.Color = col
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

type Gap = { c: number, w: number, b: number, t: number, glass: boolean? }

-- wall along "x" (fixed z) or "z" (fixed x), from s1 to s2, with door/window gaps
local function wall(name: string, axis: string, fixed: number, s1: number, s2: number, y0: number, h: number, gaps: { Gap }, mat: Enum.Material, col: Color3, parent: Instance)
	table.sort(gaps, function(a, b)
		return a.c < b.c
	end)
	local function seg(a: number, b: number, yb: number, yt: number, m: Enum.Material, c: Color3, nm: string, glass: boolean)
		if b - a < 0.05 or yt - yb < 0.05 then
			return
		end
		local mid, len, ym = (a + b) / 2, b - a, y0 + (yb + yt) / 2
		local cf = if axis == "x" then CFrame.new(mid, ym, fixed) else CFrame.new(fixed, ym, mid)
		local size = if axis == "x" then Vector3.new(len, yt - yb, 1) else Vector3.new(1, yt - yb, len)
		local p = box(nm, cf, size, m, c, parent)
		if glass then
			p.Transparency = 0.55
			p.CastShadow = false
		end
	end
	local cur = s1
	for _, g in gaps do
		local a, b = g.c - g.w / 2, g.c + g.w / 2
		seg(cur, a, 0, h, mat, col, name, false)
		seg(a, b, 0, g.b, mat, col, name, false)
		seg(a, b, g.t, h, mat, col, name, false)
		if g.glass then
			seg(a, b, g.b, g.t, M.Glass, C.glass, name .. "_Glass", true)
		end
		cur = b
	end
	seg(cur, s2, 0, h, mat, col, name, false)
end

---------------- BASEMENT: den (west) | storage + laundry (east) ----------------
local bF = folder("Basement")
box("Floor", CFrame.new(0, B - 0.5, ZM), Vector3.new(X2 - X1, 1, Z2 - Z1), M.Concrete, C.concrete, bF)
wall("BackWall", "x", Z1, X1, X2, B, H, {}, M.Concrete, C.concrete, bF)
wall("WestWall", "z", X1, Z1, Z2, B, H, {}, M.Concrete, C.concrete, bF)
wall("EastWall", "z", X2, Z1, Z2, B, H, {}, M.Concrete, C.concrete, bF)
wall("FrontWall", "x", Z2, X1, X2, B, H, {
	{ c = -18, w = 8, b = 4, t = 8, glass = true },
	{ c = 14, w = 6, b = 0, t = 8 }, -- walk-out door
	{ c = 26, w = 6, b = 4, t = 8, glass = true },
}, M.Concrete, C.concrete, bF)
wall("DenStorageDivider", "z", 10, Z1, Z2, B, H, { { c = -60, w = 6, b = 0, t = 8 } }, M.Concrete, C.inner, bF)
box("Marker_DenRig", CFrame.new(-22, B + 2, -84), Vector3.new(10, 4, 4), M.Neon, Color3.fromRGB(170, 60, 255), bF)
box("Marker_AdminChair", CFrame.new(-22, B + 2, -76), Vector3.new(4, 4, 4), M.Fabric, Color3.fromRGB(40, 40, 40), bF)
box("Marker_BreakerBox", CFrame.new(X2 - 1.5, B + 5, -84), Vector3.new(1, 3, 2), M.Metal, Color3.fromRGB(90, 90, 90), bF)

---------------- GROUND FLOOR: kitchen | living | Mom's room | stair hall | garage ----------------
local gF = folder("GroundFloor")
-- floor with a stairwell opening at x -4..4, z -88..-68
box("Floor_W", CFrame.new((X1 - 4) / 2, G - 0.5, ZM), Vector3.new(-4 - X1, 1, Z2 - Z1), M.WoodPlanks, C.floor, gF)
box("Floor_E", CFrame.new((4 + X2) / 2, G - 0.5, ZM), Vector3.new(X2 - 4, 1, Z2 - Z1), M.WoodPlanks, C.floor, gF)
box("Floor_N", CFrame.new(0, G - 0.5, (-68 + Z2) / 2), Vector3.new(8, 1, Z2 + 68), M.WoodPlanks, C.floor, gF)
box("Floor_S", CFrame.new(0, G - 0.5, (Z1 - 88) / 2), Vector3.new(8, 1, 2), M.WoodPlanks, C.floor, gF)
box("GarageFloor", CFrame.new((X2 + GX2) / 2, G - 0.5, ZM), Vector3.new(GX2 - X2, 1, Z2 - Z1), M.Concrete, C.concrete, gF)
wall("FrontWall", "x", Z2, X1, X2, G, H, {
	{ c = -16, w = 24, b = 0.5, t = 11, glass = true },
	{ c = 4, w = 8, b = 0, t = 10 }, -- front slider
	{ c = 20, w = 20, b = 0.5, t = 11, glass = true },
}, M.WoodPlanks, C.timber, gF)
wall("BackWall", "x", Z1, X1, X2, G, H, {
	{ c = -24, w = 8, b = 4, t = 9, glass = true }, -- kitchen window
	{ c = -12, w = 6, b = 0, t = 8 }, -- back door
	{ c = -6, w = 2, b = 0, t = 2 }, -- doggy door
}, M.WoodPlanks, C.timber, gF)
wall("WestWall", "z", X1, Z1, Z2, G, H, { { c = -68, w = 6, b = 4, t = 9, glass = true } }, M.WoodPlanks, C.timber, gF)
wall("CabinGarageWall", "z", X2, Z1, Z2, G, H, { { c = -80, w = 5, b = 0, t = 8 } }, M.WoodPlanks, C.inner, gF)
wall("GarageFront", "x", Z2, X2, GX2, G, 11, { { c = 48, w = 18, b = 0, t = 9 } }, M.WoodPlanks, C.timber, gF)
wall("GarageBack", "x", Z1, X2, GX2, G, 11, {}, M.WoodPlanks, C.timber, gF)
wall("GarageEast", "z", GX2, Z1, Z2, G, 11, { { c = -75, w = 5, b = 0, t = 8 } }, M.WoodPlanks, C.timber, gF)
box("GarageRoof", CFrame.new((X2 + GX2) / 2, G + 11.5, ZM), Vector3.new(GX2 - X2 + 2, 1, Z2 - Z1 + 2), M.Metal, C.roof, gF)
box("GarageDoorPanel", CFrame.new(48, G + 4.5, Z2), Vector3.new(18, 9, 0.6), M.Metal, Color3.fromRGB(60, 60, 62), gF)
wall("KitchenLivingDivider", "x", -66, X1, -6, G, H, { { c = -20, w = 8, b = 0, t = 9 } }, M.SmoothPlastic, C.inner, gF)
wall("MomRoomWall", "x", -66, 10, X2, G, H, { { c = 22, w = 5, b = 0, t = 8 } }, M.SmoothPlastic, C.inner, gF)
wall("StairHallWest", "z", -6, Z1, -66, G, H, { { c = -78, w = 5, b = 0, t = 8 } }, M.SmoothPlastic, C.inner, gF)
wall("StairHallEast", "z", 10, Z1, -66, G, H, { { c = -78, w = 5, b = 0, t = 8 } }, M.SmoothPlastic, C.inner, gF)
box("Marker_Fridge", CFrame.new(-31, G + 3.5, -86), Vector3.new(4, 7, 4), M.Metal, Color3.fromRGB(220, 220, 220), gF)

local sF = folder("Stairs")
for i = 0, 11 do
	box("Step" .. i, CFrame.new(0, B + 0.5 + i, -69.5 - i * 1.5), Vector3.new(7, 1, 1.6), M.WoodPlanks, C.floor, sF)
end

---------------- ATTIC: floor with hatch, Golden DIMM shrine, gables ----------------
local aF = folder("Attic")
local hx1, hx2, hz1, hz2 = 0, 6, -62, -56
box("Floor_W", CFrame.new((X1 + hx1) / 2, A - 0.5, ZM), Vector3.new(hx1 - X1, 1, Z2 - Z1), M.WoodPlanks, C.floor, aF)
box("Floor_E", CFrame.new((hx2 + X2) / 2, A - 0.5, ZM), Vector3.new(X2 - hx2, 1, Z2 - Z1), M.WoodPlanks, C.floor, aF)
box("Floor_N", CFrame.new((hx1 + hx2) / 2, A - 0.5, (hz2 + Z2) / 2), Vector3.new(hx2 - hx1, 1, Z2 - hz2), M.WoodPlanks, C.floor, aF)
box("Floor_S", CFrame.new((hx1 + hx2) / 2, A - 0.5, (Z1 + hz1) / 2), Vector3.new(hx2 - hx1, 1, hz1 - Z1), M.WoodPlanks, C.floor, aF)
local ladder = box("PullDownLadder", CFrame.new(3, (G + A) / 2, -59) * CFrame.Angles(math.rad(-20), 0, 0), Vector3.new(3, 13, 0.6), M.Wood, Color3.fromRGB(160, 120, 80), aF)
ladder:SetAttribute("Climbable", true)
local truss = box("LadderClimb", CFrame.new(3, (G + A) / 2, -57.5), Vector3.new(2, 12, 2), M.Plastic, C.inner, aF, "TrussPart")
truss.Transparency = 1
box("Marker_GoldenDIMMShrine", CFrame.new(X1 + 4, A + 2.5, ZM), Vector3.new(3, 5, 8), M.Neon, Color3.fromRGB(255, 200, 60), aF)
for _, x in { X1, X2 } do
	box("Gable_Front", CFrame.new(x, A + RISE / 2, ZM + HALF / 2) * CFrame.Angles(0, math.pi, 0), Vector3.new(1, RISE, HALF), M.WoodPlanks, C.timber, aF, "WedgePart")
	box("Gable_Back", CFrame.new(x, A + RISE / 2, ZM - HALF / 2), Vector3.new(1, RISE, HALF), M.WoodPlanks, C.timber, aF, "WedgePart")
end

---------------- ROOF: dark metal gable, escape window on the front slope ----------------
local rF = folder("Roof")
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
local wx1, wx2, ws1, ws2 = 16, 24, 11, 17
box("BackSlope", slabCF(false, 0, 0, slopeLen), Vector3.new(xb - xa, 1, slopeLen), M.CorrodedMetal, C.roof, rF)
box("FrontSlope_W", slabCF(true, (xa + wx1) / 2, 0, slopeLen), Vector3.new(wx1 - xa, 1, slopeLen), M.CorrodedMetal, C.roof, rF)
box("FrontSlope_E", slabCF(true, (wx2 + xb) / 2, 0, slopeLen), Vector3.new(xb - wx2, 1, slopeLen), M.CorrodedMetal, C.roof, rF)
box("FrontSlope_Low", slabCF(true, (wx1 + wx2) / 2, 0, ws1), Vector3.new(wx2 - wx1, 1, ws1), M.CorrodedMetal, C.roof, rF)
box("FrontSlope_High", slabCF(true, (wx1 + wx2) / 2, ws2, slopeLen), Vector3.new(wx2 - wx1, 1, slopeLen - ws2), M.CorrodedMetal, C.roof, rF)
local win = box("RoofWindow_Escape", slabCF(true, (wx1 + wx2) / 2, ws1, ws2), Vector3.new(wx2 - wx1, 0.4, ws2 - ws1), M.Glass, Color3.fromRGB(180, 210, 230), rF)
win.Transparency = 0.6
win.CanCollide = false
win:SetAttribute("EscapeExit", true)

---------------- DECK on a stone retaining wall (gap for the basement walk-out) ----------------
local dF = folder("Deck")
local DZ = Z2 + 16
local wallY = (B + G - 1) / 2 - 1
box("DeckBoards", CFrame.new((X1 - 4 + X2) / 2, G - 0.5, (Z2 + DZ) / 2), Vector3.new(X2 - X1 + 4, 1, DZ - Z2), M.WoodPlanks, Color3.fromRGB(170, 110, 60), dF)
box("StoneWall_W", CFrame.new((X1 - 4 + 8) / 2, wallY, DZ - 1.5), Vector3.new(8 - (X1 - 4), G - B + 1, 3), M.Slate, C.stone, dF)
box("StoneWall_E", CFrame.new((20 + X2) / 2, wallY, DZ - 1.5), Vector3.new(X2 - 20, G - B + 1, 3), M.Slate, C.stone, dF)
box("StoneWall_Lintel", CFrame.new(14, G - 2.5, DZ - 1.5), Vector3.new(12, 3, 3), M.Slate, C.stone, dF)
box("StoneWall_W_Side", CFrame.new(X1 - 5.5, wallY, (Z2 + DZ) / 2), Vector3.new(3, G - B + 1, DZ - Z2), M.Slate, C.stone, dF)

---------------- blockout lights ----------------
local function light(name: string, pos: Vector3, col: Color3, range: number, brightness: number, shadows: boolean)
	local p = box(name, CFrame.new(pos), Vector3.one, M.Plastic, col, house)
	p.CanCollide = false
	p.CanQuery = false
	p.Transparency = 1
	local l = Instance.new("PointLight")
	l.Color = col
	l.Range = range
	l.Brightness = brightness
	l.Shadows = shadows
	l.Parent = p
end
light("Light_Living", Vector3.new(-10, 255, -56), Color3.fromRGB(255, 190, 130), 30, 2, true)
light("Light_Living2", Vector3.new(18, 255, -56), Color3.fromRGB(255, 190, 130), 30, 2, true)
light("Light_Kitchen", Vector3.new(-22, 255, -80), Color3.fromRGB(255, 200, 150), 22, 1.5, false)
light("Light_DenRGB", Vector3.new(-14, 242, -76), Color3.fromRGB(170, 60, 255), 28, 3, true)

house.Parent = root
local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
if spawn then
	spawn.CFrame = CFrame.new(14, B + 0.6, 0)
	spawn.Size = Vector3.new(6, 1, 6)
end
print(`[blockout] house: {#house:GetDescendants()} instances`)
