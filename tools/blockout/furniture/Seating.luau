--!strict
-- Furniture catalogue: things that don't open. Sofas, chairs, tables, beds,
-- rugs, lamps and small decoration.
-- Every piece is built at `cf`: a point on the floor, front facing cf's -Z.

local Kit = require(script.Parent.Parent.Kit)

local C = Kit.Color
local M = Enum.Material

local Seating = {}

function Seating.sofa(parent: Instance, cf: CFrame, w: number, col: Color3): Model
	local m = Kit.model("Sofa", parent)
	Kit.part(m, cf, "Base", 0, 0.4, 0, w, 1.4, 4, col, M.Fabric)
	Kit.part(m, cf, "Back", 0, 1.8, 1.5, w, 2.4, 1, col, M.Fabric)
	Kit.part(m, cf, "Arm", -w / 2 + 0.5, 1.8, -0.2, 1, 1.2, 3.4, col, M.Fabric)
	Kit.part(m, cf, "Arm", w / 2 - 0.5, 1.8, -0.2, 1, 1.2, 3.4, col, M.Fabric)
	local n = math.max(1, math.floor((w - 2) / 3.2))
	local cw = (w - 2) / n
	for i = 1, n do
		Kit.part(
			m,
			cf,
			"Cushion",
			-w / 2 + 1 + (i - 0.5) * cw,
			1.8,
			-0.4,
			cw - 0.2,
			0.5,
			2.8,
			col:Lerp(C.white, 0.15),
			M.Fabric
		)
	end
	return m
end

function Seating.chair(parent: Instance, cf: CFrame, col: Color3): Model
	local m = Kit.model("Chair", parent)
	Kit.part(m, cf, "Seat", 0, 1.8, 0, 2.4, 0.4, 2.4, col, M.Wood)
	Kit.part(m, cf, "Back", 0, 2.2, 1, 2.4, 2.8, 0.4, col, M.Wood)
	for _, p in { { -1, -1 }, { 1, -1 }, { -1, 1 }, { 1, 1 } } do
		Kit.part(m, cf, "Leg", p[1], 0, p[2], 0.3, 1.8, 0.3, col, M.Wood)
	end
	return m
end

function Seating.table(
	parent: Instance,
	cf: CFrame,
	name: string,
	w: number,
	d: number,
	h: number,
	col: Color3,
	mat: Enum.Material?
): Model
	local m = Kit.model(name, parent)
	Kit.part(m, cf, "Top", 0, h - 0.4, 0, w, 0.4, d, col, mat or M.Wood)
	for _, p in { { -1, -1 }, { 1, -1 }, { -1, 1 }, { 1, 1 } } do
		Kit.part(m, cf, "Leg", p[1] * (w / 2 - 0.4), 0, p[2] * (d / 2 - 0.4), 0.4, h - 0.4, 0.4, col, mat or M.Wood)
	end
	return m
end

-- Dining table laid for dinner, with chairs along both long sides and the ends.
function Seating.diningSet(parent: Instance, cf: CFrame, col: Color3): Model
	local m = Kit.model("DiningSet", parent)
	Seating.table(m, cf, "DiningTable", 14, 6, 3.2, col)
	for _, x in { -4, 0, 4 } do
		Seating.chair(m, cf * CFrame.new(x, 0, -4.2) * CFrame.Angles(0, math.pi, 0), col)
		Seating.chair(m, cf * CFrame.new(x, 0, 4.2), col)
		for _, z in { -1.7, 1.7 } do
			Kit.cylinder(m, cf, "Plate", x, 3.2, z, 1.5, 0.1, C.white, M.SmoothPlastic)
		end
	end
	local pot = Kit.cylinder(m, cf, "Dinner pot", 0, 3.2, 0, 2, 1.2, C.steel, M.Metal)
	Kit.inspectable(pot, "Dinner pot", "Dinner for one. She set six places. Hope is a powerful drug.")
	return m
end

-- Bed with the headboard at the back (+Z). `dusty` greys the bedding.
function Seating.bed(parent: Instance, cf: CFrame, w: number, col: Color3, dusty: boolean?): Model
	local m = Kit.model("Bed", parent)
	local sheet = if dusty then Color3.fromRGB(150, 150, 145) else C.white
	Kit.part(m, cf, "Frame", 0, 0, 0, w, 1.2, 10, C.darkWood, M.Wood)
	Kit.part(m, cf, "Mattress", 0, 1.2, 0, w - 0.4, 1, 9.6, sheet, M.Fabric)
	Kit.part(m, cf, "Blanket", 0, 2.2, -1.4, w - 0.2, 0.3, 6.6, col, M.Fabric)
	Kit.part(m, cf, "Headboard", 0, 0, 4.8, w, 4.6, 0.5, C.darkWood, M.Wood)
	local pillows = if w > 6 then { -w / 4, w / 4 } else { 0 }
	for _, x in pillows do
		Kit.part(m, cf, "Pillow", x, 2.2, 3.4, 2.6, 0.6, 1.6, sheet, M.Fabric)
	end
	return m
end

function Seating.rug(parent: Instance, cf: CFrame, w: number, d: number, col: Color3): BasePart
	local p = Kit.part(parent, cf, "Rug", 0, 0, 0, w, 0.1, d, col, M.Fabric)
	p.CanCollide = false
	return p
end

function Seating.floorLamp(parent: Instance, cf: CFrame): Model
	local m = Kit.model("FloorLamp", parent)
	Kit.cylinder(m, cf, "Base", 0, 0, 0, 1.6, 0.2, C.black, M.Metal)
	Kit.cylinder(m, cf, "Pole", 0, 0.2, 0, 0.25, 6.4, C.black, M.Metal)
	local shade = Kit.cylinder(m, cf, "Shade", 0, 6.2, 0, 2.2, 1.6, C.cream, M.Fabric)
	local l = Instance.new("PointLight")
	l.Color = Color3.fromRGB(255, 200, 140)
	l.Range = 16
	l.Brightness = 1.2
	l.Parent = shade
	return m
end

function Seating.plant(parent: Instance, cf: CFrame, h: number): Model
	local m = Kit.model("Plant", parent)
	Kit.cylinder(m, cf, "Pot", 0, 0, 0, 1.8, 1.6, Color3.fromRGB(150, 90, 60), M.Slate)
	Kit.cylinder(m, cf, "Stem", 0, 1.6, 0, 0.3, h - 3, C.darkWood, M.Wood)
	local leaves = Kit.part(m, cf, "Leaves", 0, h - 3, 0, 3, 3, 3, C.green, M.Grass) :: Part
	leaves.Shape = Enum.PartType.Ball
	leaves.CanCollide = false
	return m
end

-- A vase the cat can knock over later.
function Seating.vase(parent: Instance, cf: CFrame): BasePart
	local p = Kit.cylinder(parent, cf, "Vase", 0, 0, 0, 0.9, 1.6, C.blue, M.Glass)
	p:SetAttribute("Knockable", true)
	Kit.inspectable(p, "Vase", "A vase. Fragile, expensive, and right on the edge. The cat has plans.")
	return p
end

function Seating.beanbag(parent: Instance, cf: CFrame, col: Color3): Model
	local m = Kit.model("Beanbag", parent)
	Kit.cylinder(m, cf, "Bag", 0, 0, 0, 4.4, 1.4, col, M.Fabric)
	Kit.cylinder(m, cf, "Top", 0, 1.4, 0.6, 3, 1, col, M.Fabric)
	return m
end

function Seating.desk(parent: Instance, cf: CFrame, w: number, col: Color3): Model
	local m = Kit.model("Desk", parent)
	Kit.part(m, cf, "Top", 0, 2.8, 0, w, 0.4, 3.4, col, M.Wood)
	Kit.part(m, cf, "Leg", -w / 2 + 0.2, 0, 0, 0.4, 2.8, 3.2, col, M.Wood)
	Kit.part(m, cf, "Leg", w / 2 - 0.2, 0, 0, 0.4, 2.8, 3.2, col, M.Wood)
	Kit.part(m, cf, "Modesty", 0, 1, 1.4, w - 0.8, 1.8, 0.2, col, M.Wood)
	return m
end

function Seating.bench(parent: Instance, cf: CFrame, w: number, col: Color3): Model
	local m = Kit.model("Bench", parent)
	Kit.part(m, cf, "Seat", 0, 1.6, 0, w, 0.4, 2, col, M.Wood)
	Kit.part(m, cf, "Leg", -w / 2 + 0.3, 0, 0, 0.4, 1.6, 1.8, col, M.Wood)
	Kit.part(m, cf, "Leg", w / 2 - 0.3, 0, 0, 0.4, 1.6, 1.8, col, M.Wood)
	return m
end

-- A flat poster on a wall. cf's -Z points out of the wall.
function Seating.poster(
	parent: Instance,
	cf: CFrame,
	w: number,
	h: number,
	text: string,
	bg: Color3,
	fg: Color3?
): BasePart
	local p = Kit.part(parent, cf, "Poster", 0, 0, 0, w, h, 0.1, bg, M.SmoothPlastic)
	p.CanCollide = false
	Kit.sign(p, Enum.NormalId.Front, text, fg or C.white)
	return p
end

-- A ceiling bulb on a wire. cf is the point on the ceiling.
function Seating.bulb(parent: Instance, cf: CFrame, col: Color3, range: number, brightness: number): BasePart
	Kit.part(parent, cf, "Wire", 0, -2, 0, 0.1, 2, 0.1, C.black, M.Metal)
	local p = Kit.part(parent, cf, "Bulb", 0, -2.7, 0, 0.7, 0.7, 0.7, col, M.Neon) :: Part
	p.Shape = Enum.PartType.Ball
	local l = Instance.new("PointLight")
	l.Color = col
	l.Range = range
	l.Brightness = brightness
	l.Parent = p
	return p
end

return Seating
