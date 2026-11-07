--!strict
-- Blockout step 1: road centreline (Workspace.Blockout.RoadPath) + road surface parts.
-- Run in the Studio command bar. Rebuilds Workspace.Blockout from scratch.
-- Path: 10,360 studs from the house (0,230,120) to the factory exit.
-- Two-lane (32 studs) up to 6,430 studs, then divided highway (2 x 50 + median).

local old = workspace:FindFirstChild("Blockout")
if old then
	old:Destroy()
end
local baseplate = workspace:FindFirstChild("Baseplate")
if baseplate then
	baseplate:Destroy()
end

local root = Instance.new("Folder")
root.Name = "Blockout"
local pathF = Instance.new("Folder")
pathF.Name = "RoadPath"
pathF.Parent = root

local CP = {
	Vector3.new(-200, 232, 40), -- phantom start
	Vector3.new(0, 230, 120),
	Vector3.new(400, 224, 360),
	Vector3.new(900, 214, 200),
	Vector3.new(1300, 200, -150),
	Vector3.new(1800, 184, -350),
	Vector3.new(2400, 166, -150),
	Vector3.new(2900, 146, 200),
	Vector3.new(3500, 122, 330),
	Vector3.new(4100, 98, 120),
	Vector3.new(4600, 76, -150),
	Vector3.new(5200, 56, -200),
	Vector3.new(5800, 40, 0),
	Vector3.new(6300, 30, 100),
	Vector3.new(7000, 24, 120),
	Vector3.new(7800, 20, 60),
	Vector3.new(8600, 18, -40),
	Vector3.new(9400, 18, -80),
	Vector3.new(10200, 18, -40),
	Vector3.new(11000, 18, 40),
	Vector3.new(11800, 18, 120), -- phantom end
}

local function catmullRom(p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, t: number): Vector3
	local t2, t3 = t * t, t * t * t
	return 0.5 * ((2 * p1) + (-p0 + p2) * t + (2 * p0 - 5 * p1 + 4 * p2 - p3) * t2 + (-p0 + 3 * p1 - 3 * p2 + p3) * t3)
end

local dense: { Vector3 } = {}
for i = 2, #CP - 2 do
	for s = 0, 49 do
		table.insert(dense, catmullRom(CP[i - 1], CP[i], CP[i + 1], CP[i + 2], s / 50))
	end
end
table.insert(dense, CP[#CP - 1])

local STEP, MAXD = 40, 10360
local nodes: { Vector3 } = { dense[1] }
local acc, total = 0, 0
for i = 2, #dense do
	local a, b = dense[i - 1], dense[i]
	local seg = (b - a).Magnitude
	local pos = 0
	while acc + (seg - pos) >= STEP do
		pos += STEP - acc
		acc = 0
		total += STEP
		table.insert(nodes, a:Lerp(b, pos / seg))
		if total >= MAXD then
			break
		end
	end
	if total >= MAXD then
		break
	end
	acc += seg - pos
end

for i, p in nodes do
	local n = Instance.new("Part")
	n.Name = string.format("Node%03d", i)
	n.Anchored = true
	n.CanCollide = false
	n.CanQuery = false
	n.CanTouch = false
	n.Transparency = 1
	n.Size = Vector3.one
	n.Position = p
	n:SetAttribute("Distance", (i - 1) * STEP)
	n.Parent = pathF
end
pathF:SetAttribute("Step", STEP)
pathF:SetAttribute("Length", (#nodes - 1) * STEP)

-- road surface
local MERGE = 6430
local roadF = Instance.new("Folder")
roadF.Name = "Road"
roadF.Parent = root

local function part(name: string, size: Vector3, cf: CFrame, mat: Enum.Material, col: Color3, parent: Instance)
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.Size = size
	p.CFrame = cf
	p.Material = mat
	p.Color = col
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
end

local ASPHALT = Color3.fromRGB(43, 44, 46)
local CONCRETE = Color3.fromRGB(150, 150, 145)
local STEEL = Color3.fromRGB(170, 175, 178)

local chunk = Instance.new("Folder")
local ci = 1
for i = 1, #nodes - 1 do
	local a, b = nodes[i], nodes[i + 1]
	local len = (b - a).Magnitude
	local cf = CFrame.lookAt((a + b) / 2, b)
	if (i - 1) * STEP >= MERGE then
		for _, s in { -32, 32 } do
			part("Carriageway", Vector3.new(50, 1, len + 1), cf * CFrame.new(s, 0, 0), Enum.Material.Asphalt, ASPHALT, chunk)
		end
		part("Median", Vector3.new(2, 3, len + 0.5), cf * CFrame.new(0, 2, 0), Enum.Material.Concrete, CONCRETE, chunk)
		for _, s in { -58, 58 } do
			part("Guardrail", Vector3.new(0.6, 2.5, len + 0.5), cf * CFrame.new(s, 1.75, 0), Enum.Material.Metal, STEEL, chunk)
		end
	else
		part("TwoLane", Vector3.new(32, 1, len + 1), cf, Enum.Material.Asphalt, ASPHALT, chunk)
		for _, s in { -17.5, 17.5 } do
			if i % 2 == 0 then
				part("ConcreteBarrier", Vector3.new(2, 3, len + 0.5), cf * CFrame.new(s, 2, 0), Enum.Material.Concrete, CONCRETE, chunk)
			else
				part("Guardrail", Vector3.new(0.6, 2.5, len + 0.5), cf * CFrame.new(s, 1.75, 0), Enum.Material.Metal, STEEL, chunk)
			end
		end
	end
	if i % 20 == 0 then
		chunk.Name = "Chunk" .. ci
		chunk.Parent = roadF
		ci += 1
		chunk = Instance.new("Folder")
		task.wait()
	end
end
chunk.Name = "Chunk" .. ci
chunk.Parent = roadF

root.Parent = workspace
print(`[blockout] road: {#nodes} nodes, {(#nodes - 1) * STEP} studs`)
