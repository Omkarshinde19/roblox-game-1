--!strict
-- Blockout step 6: ClosedAI factory (data center) in a forest clearing past the highway end.
-- Hall 536 x 64 x 143 studs (~150 x 18 x 40 m): dark timber base + translucent skin.

local root = workspace:WaitForChild("Blockout")
local old = root:FindFirstChild("Factory")
if old then
	old:Destroy()
end
local nodes = root.RoadPath:GetChildren()
table.sort(nodes, function(a, b)
	return a.Name < b.Name
end)
local endP = (nodes[#nodes] :: BasePart).Position
local Y = 18
local M = Enum.Material
local T = workspace.Terrain

local f = Instance.new("Model")
f.Name = "Factory"
local function box(name: string, cf: CFrame, size: Vector3, mat: Enum.Material, col: Color3, parent: Instance, transparency: number?): BasePart
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.CFrame = cf
	p.Size = size
	p.Material = mat
	p.Color = col
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Transparency = transparency or 0
	p.Parent = parent
	return p
end

-- clearing + forecourt
local PC = Vector3.new(endP.X + 450, Y, endP.Z - 560)
T:FillBlock(CFrame.new(PC + Vector3.new(0, 80, 0)), Vector3.new(1000, 160, 800), M.Air)
T:FillBlock(CFrame.new(PC + Vector3.new(0, -31, 0)), Vector3.new(1000, 60, 800), M.LeafyGrass)
T:FillBlock(CFrame.new(PC + Vector3.new(0, -2.5, 150)), Vector3.new(640, 4, 150), M.Pavement)

-- access road from the highway end
local road = Instance.new("Folder")
road.Name = "AccessRoad"
road.Parent = f
local pts = { endP, endP + Vector3.new(160, 0, -60), PC + Vector3.new(-120, 0, 330), PC + Vector3.new(0, 0, 225) }
for i = 1, #pts - 1 do
	local a, b = pts[i], pts[i + 1]
	local len = (b - a).Magnitude
	local cf = CFrame.lookAt((a + b) / 2, b)
	T:FillBlock(cf * CFrame.new(0, 60.5, 0), Vector3.new(70, 120, len + 20), M.Air)
	T:FillBlock(cf * CFrame.new(0, -8, 0), Vector3.new(40, 12, len + 20), M.Pavement)
	T:FillBlock(cf * CFrame.new(0, -21, 0), Vector3.new(90, 26, len + 20), M.Ground)
	box("AccessRoad", cf, Vector3.new(26, 1, len + 2), M.Asphalt, Color3.fromRGB(42, 43, 45), road)
end

-- hall
local HL, HH, HD, BASE = 536, 64, 143, 12
local UP = HH - BASE
local hc = PC + Vector3.new(0, 0, -20)
local hall = Instance.new("Model")
hall.Name = "Hall"
hall.Parent = f
local dark = Color3.fromRGB(70, 48, 36)
local skin = Color3.fromRGB(225, 232, 235)
box("Slab", CFrame.new(hc + Vector3.new(0, 0.5, 0)), Vector3.new(HL, 1, HD), M.Concrete, Color3.fromRGB(120, 120, 118), hall)
box("Base_Back", CFrame.new(hc + Vector3.new(0, BASE / 2 + 1, -HD / 2)), Vector3.new(HL, BASE, 1.5), M.WoodPlanks, dark, hall)
box("Base_West", CFrame.new(hc + Vector3.new(-HL / 2, BASE / 2 + 1, 0)), Vector3.new(1.5, BASE, HD), M.WoodPlanks, dark, hall)
box("Base_East", CFrame.new(hc + Vector3.new(HL / 2, BASE / 2 + 1, 0)), Vector3.new(1.5, BASE, HD), M.WoodPlanks, dark, hall)
box("Base_Front_W", CFrame.new(hc + Vector3.new(-HL / 4 - 10, BASE / 2 + 1, HD / 2)), Vector3.new(HL / 2 - 20, BASE, 1.5), M.WoodPlanks, dark, hall)
box("Base_Front_E", CFrame.new(hc + Vector3.new(HL / 4 + 10, BASE / 2 + 1, HD / 2)), Vector3.new(HL / 2 - 20, BASE, 1.5), M.WoodPlanks, dark, hall)
local ent = box("Entrance", CFrame.new(hc + Vector3.new(0, 5, HD / 2)), Vector3.new(40, 9, 0.5), M.Glass, Color3.fromRGB(255, 200, 140), hall, 0.5)
ent.CanCollide = false
ent:SetAttribute("Entrance", true)
box("Skin_Front", CFrame.new(hc + Vector3.new(0, BASE + 1 + UP / 2, HD / 2)), Vector3.new(HL, UP, 1), M.Glass, skin, hall, 0.35)
box("Skin_Back", CFrame.new(hc + Vector3.new(0, BASE + 1 + UP / 2, -HD / 2)), Vector3.new(HL, UP, 1), M.Glass, skin, hall, 0.35)
box("Skin_West", CFrame.new(hc + Vector3.new(-HL / 2, BASE + 1 + UP / 2, 0)), Vector3.new(1, UP, HD), M.Glass, skin, hall, 0.35)
box("Skin_East", CFrame.new(hc + Vector3.new(HL / 2, BASE + 1 + UP / 2, 0)), Vector3.new(1, UP, HD), M.Glass, skin, hall, 0.35)
box("Roof", CFrame.new(hc + Vector3.new(0, HH + 1.5, 0)), Vector3.new(HL + 2, 1, HD + 2), M.Metal, Color3.fromRGB(60, 62, 66), hall)
for x = -HL / 2 + 12, HL / 2 - 12, 24 do
	box("RoofFin", CFrame.new(hc + Vector3.new(x, HH + 3, HD / 2 + 4)), Vector3.new(1, 3, 14), M.Metal, Color3.fromRGB(40, 40, 42), hall)
end
for x = -HL / 2 + 20, HL / 2 - 20, 30 do
	box("VineMarker", CFrame.new(hc + Vector3.new(x, HH * 0.45, HD / 2 + 1.5)), Vector3.new(3, HH * 0.8, 1), M.Grass, Color3.fromRGB(70, 110, 50), hall)
end
box("SideBlock", CFrame.new(hc + Vector3.new(-HL / 2 - 30, 26, 10)), Vector3.new(60, 52, 70), M.Metal, Color3.fromRGB(120, 72, 50), hall)

-- interior markers for scene 11
local col = Instance.new("Part")
col.Name = "ContainmentColumn"
col.Shape = Enum.PartType.Cylinder
col.Anchored = true
col.Size = Vector3.new(HH - 2, 30, 30)
col.CFrame = CFrame.new(hc + Vector3.new(0, HH / 2 + 1, -10)) * CFrame.Angles(0, 0, math.rad(90))
col.Material = M.ForceField
col.Color = Color3.fromRGB(120, 200, 255)
col.Parent = hall
for r = 0, 3 do
	box("ServerRack_Row" .. r, CFrame.new(hc + Vector3.new(-160 + r * 40, 5, -30)), Vector3.new(6, 9, 80), M.Metal, Color3.fromRGB(30, 30, 34), hall)
	box("ServerRack_Row" .. (r + 4), CFrame.new(hc + Vector3.new(40 + r * 40, 5, -30)), Vector3.new(6, 9, 80), M.Metal, Color3.fromRGB(30, 30, 34), hall)
end
local stop = box("Marker_RobotaxiStop", CFrame.new(PC + Vector3.new(0, 0.6, 200)), Vector3.new(30, 0.2, 18), M.Neon, Color3.fromRGB(80, 200, 255), f, 0.5)
stop.CanCollide = false

f.Parent = root
print(`[blockout] factory hall at {hc}`)
