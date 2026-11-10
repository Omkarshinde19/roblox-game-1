--!strict
-- Blockout step 3: hillside house plot for the 104 x 64 stud cabin.
-- Run after step 2 (which clears terrain). Safe to re-run on its own.
--   G = 246  ground floor: plateau behind the cabin + forecourt by the garage (east)
--   B = 232  basement walk-out level: the yard in front (+Z) of the cabin
-- Pass { skipRidge = true } to leave the mountainside behind the cabin as it is
-- (the ridge is slow to fill).

return function(opts: { skipRidge: boolean? }?)
	local T = workspace.Terrain
	local M = Enum.Material
	local G, B = 246, 232
	local PI = math.pi

	if not (opts and opts.skipRidge) then
		local rng = Random.new(7)
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
	end

	-- clear everything above the plot levels
	T:FillBlock(CFrame.new(0, G + 60, -180), Vector3.new(560, 120, 300), M.Air)
	T:FillBlock(CFrame.new(0, B + 70, 40), Vector3.new(420, 140, 160), M.Air)
	task.wait()
	-- plateau behind + pad under the cabin, at ground-floor level
	T:FillBlock(CFrame.new(0, G - 30, -200), Vector3.new(560, 60, 260), M.Grass)
	T:FillBlock(CFrame.new(0, G - 30, -76), Vector3.new(220, 60, 72), M.Ground)
	-- walk-out yard in front of the cabin, at basement level
	T:FillBlock(CFrame.new(0, B - 30, 40), Vector3.new(420, 60, 160), M.Grass)
	-- slope west of the cabin, plateau -> yard
	T:FillWedge(
		CFrame.new(-160, (G + B) / 2 - 15, -55) * CFrame.Angles(0, PI, 0),
		Vector3.new(100, G - B + 30, 30),
		M.Grass
	)
	task.wait()
	-- forecourt east of the cabin (garage door, Robotaxi pickup), at ground-floor level
	T:FillBlock(CFrame.new(117, G - 30, -58.5), Vector3.new(126, 60, 107), M.Ground)
	T:FillWedge(
		CFrame.new(117, (G + B) / 2 - 15, 10) * CFrame.Angles(0, PI, 0),
		Vector3.new(126, G - B + 30, 30),
		M.Grass
	)
	-- slope from the yard down to the road start (road y ~230 at z 120)
	T:FillWedge(
		CFrame.new(0, (B + 228) / 2 - 15, 135) * CFrame.Angles(0, PI, 0),
		Vector3.new(420, B - 228 + 30, 30),
		M.Grass
	)
	task.wait()

	-- gravel drive: road start -> up the east side -> forecourt
	local drive = {
		Vector3.new(0, 230, 118),
		Vector3.new(60, 231, 95),
		Vector3.new(120, 234, 60),
		Vector3.new(135, 240, 20),
		Vector3.new(125, 246, -15),
		Vector3.new(110, 246, -35),
	}
	for i = 1, #drive - 1 do
		local a, b = drive[i], drive[i + 1]
		local cf = CFrame.lookAt((a + b) / 2, b)
		local len = (b - a).Magnitude + 10
		T:FillBlock(cf * CFrame.new(0, 30, 0), Vector3.new(26, 60, len), M.Air)
		T:FillBlock(cf * CFrame.new(0, -12, 0), Vector3.new(60, 24, len), M.Ground)
		T:FillBlock(cf * CFrame.new(0, -10.5, 0), Vector3.new(20, 22, len), M.Pavement)
	end

	local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
	if spawn then
		spawn.CFrame = CFrame.new(20, B + 0.6, 10)
		spawn.Size = Vector3.new(6, 1, 6)
	end
	print("[blockout] house plot done")
end
