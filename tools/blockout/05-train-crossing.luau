--!strict
-- Blockout step 5: level crossing on the highway at ~8,200 studs (RoadPath Node206).
-- Track runs perpendicular to the road through cuttings so the train shows up late.

return function()
	local root = workspace:WaitForChild("Blockout")
	local old = root:FindFirstChild("TrainCrossing")
	if old then
		old:Destroy()
	end
	local nodes = root.RoadPath:GetChildren()
	table.sort(nodes, function(a, b)
		return a.Name < b.Name
	end)
	local n0, n1 = nodes[206] :: BasePart, nodes[207] :: BasePart
	local c = n0.Position
	local fwd = Vector3.new(n1.Position.X - c.X, 0, n1.Position.Z - c.Z).Unit
	local right = Vector3.new(-fwd.Z, 0, fwd.X)
	local trackCF = CFrame.lookAt(c, c + right)
	local T = workspace.Terrain
	local M = Enum.Material

	local model = Instance.new("Model")
	model.Name = "TrainCrossing"
	model:SetAttribute("PathDistance", n0:GetAttribute("Distance"))

	local function box(
		name: string,
		cf: CFrame,
		size: Vector3,
		mat: Enum.Material,
		col: Color3,
		parent: Instance
	): BasePart
		local p = Instance.new("Part")
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

	-- mounds either side of the road, straddling the track
	for _, rs in { -1, 1 } do
		for _, d in { 200, 380, 600 } do
			for _, f in { -90, 90 } do
				local p = c + right * rs * d + fwd * f
				T:FillBall(Vector3.new(p.X, c.Y - 160, p.Z), 230, M.Grass)
			end
		end
	end
	-- track bed cut through the mounds
	local LEN = 2400
	for s = -LEN / 2, LEN / 2, 100 do
		local p = trackCF * CFrame.new(0, 0, -s)
		T:FillBlock(p * CFrame.new(0, 40, 0), Vector3.new(36, 80, 104), M.Air)
		T:FillBlock(p * CFrame.new(0, -5, 0), Vector3.new(36, 8, 104), M.Ground)
		T:FillBlock(p * CFrame.new(0, -4, 0), Vector3.new(14, 7, 104), M.Slate)
	end
	-- keep the highway clear around the crossing
	for i = 196, 216 do
		local a, b = (nodes[i] :: BasePart).Position, (nodes[i + 1] :: BasePart).Position
		local cf = CFrame.lookAt((a + b) / 2, b)
		local len = (b - a).Magnitude
		T:FillBlock(cf * CFrame.new(0, 60.5, 0), Vector3.new(160, 120, len + 12), M.Air)
		T:FillBlock(cf * CFrame.new(0, -6, 0), Vector3.new(160, 8, len + 12), M.Ground)
		T:FillBlock(cf * CFrame.new(0, -8, 0), Vector3.new(124, 12, len + 12), M.Pavement)
	end

	-- rails + crossing panel
	for _, g in { -2.5, 2.5 } do
		box(
			"Rail",
			trackCF * CFrame.new(g, 0.75, 0),
			Vector3.new(0.5, 0.5, LEN),
			M.Metal,
			Color3.fromRGB(110, 105, 100),
			model
		)
	end
	box(
		"CrossingPanel",
		trackCF * CFrame.new(0, 0.55, 0),
		Vector3.new(10, 0.2, 130),
		M.Concrete,
		Color3.fromRGB(120, 120, 118),
		model
	)

	-- boom gates + signals: each carriageway, both sides of the track
	for _, side in { -1, 1 } do
		for _, lane in { -32, 32 } do
			local base = c + fwd * side * 12 + right * (lane + (if lane > 0 then 28 else -28))
			box(
				"SignalPost",
				CFrame.new(base + Vector3.new(0, 6, 0)),
				Vector3.new(1, 12, 1),
				M.Metal,
				Color3.fromRGB(230, 230, 230),
				model
			)
			box(
				"SignalLight",
				CFrame.new(base + Vector3.new(0, 10, 0)),
				Vector3.new(1.6, 1.6, 1.6),
				M.Neon,
				Color3.fromRGB(255, 30, 30),
				model
			)
			local armDir = -right * math.sign(lane)
			local pivot = base + Vector3.new(0, 4, 0)
			local arm = box(
				"BoomArm",
				CFrame.lookAt(pivot + armDir * 13, pivot + armDir * 26),
				Vector3.new(0.8, 0.8, 26),
				M.SmoothPlastic,
				Color3.fromRGB(240, 240, 240),
				model
			)
			arm:SetAttribute("Boom", true)
		end
	end

	-- placeholder train parked 1,000 studs up the track
	local train = Instance.new("Model")
	train.Name = "Train"
	train.Parent = model
	train:SetAttribute("StartOffset", -1000)
	for i = 0, 8 do
		local isLoco = i == 0
		box(
			if isLoco then "Locomotive" else "FreightCar" .. i,
			trackCF * CFrame.new(0, 8.5, -1000 - i * 64),
			Vector3.new(11, 15, if isLoco then 70 else 60),
			M.Metal,
			if isLoco then Color3.fromRGB(200, 150, 30) else Color3.fromRGB(90, 60, 45),
			train
		)
	end
	train.PrimaryPart = train:FindFirstChild("Locomotive") :: BasePart
	model.Parent = root
	print(`[blockout] crossing at {c}`)
end
