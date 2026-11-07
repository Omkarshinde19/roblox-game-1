--!strict
-- Blockout step 3: hillside house plot. Run after step 2 (which clears terrain).
-- Ground floor level G = 246 (plateau behind), basement walk-out level B = 234 (yard in front, +Z).

local T = workspace.Terrain
local M = Enum.Material
local G, B = 246, 234
local rng = Random.new(7)

-- mountainside ridge behind the cabin, rising further back
for i = 0, 8 do
	local x = -520 + i * 130 + rng:NextNumber(-40, 40)
	for j, zb in { -380, -600, -850 } do
		local r = 420 + j * 60
		local peak = G + 15 + j * 40 + rng:NextNumber(-10, 10)
		local mat = (j == 3 and rng:NextNumber() < 0.5) and M.Rock or M.Grass
		T:FillBall(Vector3.new(x, peak - r, zb + rng:NextNumber(-60, 60)), r, mat)
	end
	task.wait()
end

-- clear above the plot levels
T:FillBlock(CFrame.new(0, G + 60, -180), Vector3.new(560, 120, 300), M.Air)
T:FillBlock(CFrame.new(0, B + 70, 40), Vector3.new(420, 140, 160), M.Air)
-- plateau + house pad at ground-floor level
T:FillBlock(CFrame.new(0, G - 30, -200), Vector3.new(560, 60, 260), M.Grass)
T:FillBlock(CFrame.new(0, G - 30, -70), Vector3.new(160, 60, 60), M.Ground)
-- walk-out yard at basement level
T:FillBlock(CFrame.new(0, B - 30, 40), Vector3.new(420, 60, 160), M.Grass)
-- side slopes plateau -> yard
T:FillWedge(CFrame.new(-150, (G + B) / 2 - 15, -55) * CFrame.Angles(0, math.pi, 0), Vector3.new(140, G - B + 30, 30), M.Grass)
T:FillWedge(CFrame.new(160, (G + B) / 2 - 15, -55) * CFrame.Angles(0, math.pi, 0), Vector3.new(120, G - B + 30, 30), M.Grass)
-- slope from yard down to the road start (road y ~230 at z 120)
T:FillWedge(CFrame.new(0, (B + 228) / 2 - 15, 135) * CFrame.Angles(0, math.pi, 0), Vector3.new(420, B - 228 + 30, 30), M.Grass)

-- gravel drive up the east side to the garage pad
local drive = {
	Vector3.new(0, 230, 118),
	Vector3.new(60, 232, 95),
	Vector3.new(110, 236, 50),
	Vector3.new(120, 241, 0),
	Vector3.new(105, 246, -50),
}
for i = 1, #drive - 1 do
	local a, b = drive[i], drive[i + 1]
	local cf = CFrame.lookAt((a + b) / 2, b)
	local len = (b - a).Magnitude + 10
	T:FillBlock(cf * CFrame.new(0, 30, 0), Vector3.new(26, 60, len), M.Air)
	T:FillBlock(cf * CFrame.new(0, -12, 0), Vector3.new(60, 24, len), M.Ground)
	T:FillBlock(cf * CFrame.new(0, -10.5, 0), Vector3.new(20, 22, len), M.Pavement)
end
print("[blockout] house plot done")
