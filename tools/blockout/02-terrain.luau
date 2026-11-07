--!strict
-- Blockout step 2: valley terrain along the road. Needs step 1 (RoadPath).
-- Clears ALL terrain, then: gentle hills -> wide base band -> road corridor cut.
-- Slow (big FillBall/FillBlock calls): run in the command bar, not via a short RPC.

local nodes = workspace.Blockout.RoadPath:GetChildren()
table.sort(nodes, function(a, b)
	return a.Name < b.Name
end)
local pts: { Vector3 } = {}
for i, n in nodes do
	pts[i] = (n :: BasePart).Position
end
local function distance(i: number): number
	return nodes[i]:GetAttribute("Distance") :: number
end

local T = workspace.Terrain
local M = Enum.Material
local MERGE = 6430
T:Clear()
task.wait()

-- 1) hills: low spherical caps beside the road, never closer than 80 studs to it
local rng = Random.new(2221)
local function minFlatDist(p: Vector3): number
	local m = math.huge
	for _, q in pts do
		local d = Vector2.new(p.X - q.X, p.Z - q.Z).Magnitude
		if d < m then
			m = d
		end
	end
	return m
end
for i = 1, #pts - 1, 3 do
	local a, b = pts[i], pts[i + 1]
	local dir = Vector3.new(b.X - a.X, 0, b.Z - a.Z).Unit
	local side = Vector3.new(-dir.Z, 0, dir.X)
	for _, s in { -1, 1 } do
		for k = 1, 3 do
			local r = rng:NextNumber(350, 700)
			local rise = r * rng:NextNumber(0.10, 0.30) + (k - 1) * 30
			local foot = math.sqrt(r * r - (r - rise) ^ 2)
			local c = a + side * s * (foot + rng:NextNumber(90, 350) + (k - 1) * 450)
			if minFlatDist(c) - foot > 80 then
				local mat = (k == 3 and rng:NextNumber() < 0.35) and M.Rock or M.Grass
				T:FillBall(Vector3.new(c.X, a.Y + rise - r - 2, c.Z), r, mat)
			end
		end
	end
	if i % 12 == 1 then
		task.wait()
	end
end

-- 2) base band so there is no void between hills (top 1 stud under road level)
for i = 1, #pts - 1 do
	local a, b = pts[i], pts[i + 1]
	local _, yaw, _ = CFrame.lookAt((a + b) / 2, b):ToOrientation()
	local flat = CFrame.new((a + b) / 2) * CFrame.Angles(0, yaw, 0)
	local width = i <= 65 and 1100 or 1300
	T:FillBlock(flat * CFrame.new(0, -36, 0), Vector3.new(width, 70, (b - a).Magnitude + 30), M.Grass)
	if i % 20 == 0 then
		task.wait()
	end
end

-- 3) road corridor: cut air above, ground shoulders, pavement bed 2 studs under the road parts
for i = 1, #pts - 1 do
	local a, b = pts[i], pts[i + 1]
	local len = (b - a).Magnitude
	local cf = CFrame.lookAt((a + b) / 2, b)
	local hw = distance(i) >= MERGE
	local cw = hw and 160 or 70
	local rw = hw and 124 or 40
	T:FillBlock(cf * CFrame.new(0, 60.5, 0), Vector3.new(cw, 120, len + 12), M.Air)
	T:FillBlock(cf * CFrame.new(0, -6, 0), Vector3.new(cw, 10, len + 12), M.Ground)
	T:FillBlock(cf * CFrame.new(0, 2, 0), Vector3.new(rw, 8, len + 12), M.Air)
	T:FillBlock(cf * CFrame.new(0, -8, 0), Vector3.new(rw, 12, len + 12), M.Pavement)
	if i % 20 == 0 then
		task.wait()
	end
end
print("[blockout] terrain done")
