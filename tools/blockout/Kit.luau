--!strict
-- Shared building helpers for the blockout scripts: boxes, walls with door and
-- window gaps, openable doors/drawers, and the tags the game code looks for.
--
-- Tags and attributes written here (read by src/server/*):
--   "Openable"    Model. Kind = "Hinge" | "Slide", OpenAngle, Axis, SlideOffset,
--                 DisplayName. Child Model "Moving" (PrimaryPart "Hinge") moves.
--   "Inspectable" BasePart. DisplayName, Line (what a Scam says about it).
--   "Loot"        BasePart. DisplayName, Value, Line.
--   "HidingSpot"  an Openable with a Seat named "HideSeat" inside.
--   "Shutter"     hidden BasePart at a door's closed-shutter position (scene 07).

local CollectionService = game:GetService("CollectionService")

local Kit = {}

export type Gap = { c: number, w: number, b: number, t: number, glass: boolean? }
export type Item = { n: string, s: Vector3, c: Color3, line: string?, value: number?, m: Enum.Material? }
export type DoorSpec = {
	name: string,
	axis: string, -- "x": wall runs along X at fixed Z. "z": wall runs along Z at fixed X
	fixed: number,
	c: number, -- centre of the doorway along the wall
	y: number, -- floor level
	w: number,
	h: number,
	hinge: number, -- -1 or 1: which end of the doorway the hinge is on
	swing: number, -- -1 or 1: which side of the wall the door opens toward
	col: Color3,
	mat: Enum.Material?,
	glass: boolean?,
	display: string?,
}

local SMOOTH = Enum.SurfaceType.Smooth
local M = Enum.Material

Kit.Color = {
	timber = Color3.fromRGB(120, 72, 42),
	darkTimber = Color3.fromRGB(70, 48, 36),
	concrete = Color3.fromRGB(130, 130, 128),
	floor = Color3.fromRGB(150, 110, 75),
	glassWarm = Color3.fromRGB(255, 190, 120),
	roof = Color3.fromRGB(38, 40, 44),
	stone = Color3.fromRGB(105, 105, 100),
	inner = Color3.fromRGB(205, 200, 190),
	white = Color3.fromRGB(235, 235, 232),
	black = Color3.fromRGB(28, 28, 30),
	steel = Color3.fromRGB(160, 165, 170),
	wood = Color3.fromRGB(150, 105, 65),
	darkWood = Color3.fromRGB(85, 58, 40),
	cardboard = Color3.fromRGB(170, 135, 90),
	red = Color3.fromRGB(190, 45, 40),
	green = Color3.fromRGB(70, 130, 60),
	blue = Color3.fromRGB(50, 90, 170),
	gold = Color3.fromRGB(255, 200, 60),
	purple = Color3.fromRGB(170, 60, 255),
	fabric = Color3.fromRGB(95, 100, 110),
	cream = Color3.fromRGB(225, 215, 195),
}

function Kit.folder(name: string, parent: Instance?): Folder
	local f = Instance.new("Folder")
	f.Name = name
	f.Parent = parent
	return f
end

function Kit.model(name: string, parent: Instance?): Model
	local m = Instance.new("Model")
	m.Name = name
	m.Parent = parent
	return m
end

function Kit.box(
	parent: Instance?,
	name: string,
	cf: CFrame,
	size: Vector3,
	col: Color3,
	mat: Enum.Material?,
	className: string?
): BasePart
	local p = Instance.new(className or "Part") :: BasePart
	p.Name = name
	p.Anchored = true
	p.CFrame = cf
	p.Size = size
	p.Material = mat or M.SmoothPlastic
	p.Color = col
	p.TopSurface = SMOOTH
	p.BottomSurface = SMOOTH
	p.Parent = parent
	return p
end

-- A part in furniture space: x/z are the centre, y is the BOTTOM, all relative
-- to `origin` (a point on the floor; the piece's front faces origin's -Z).
function Kit.part(
	parent: Instance?,
	origin: CFrame,
	name: string,
	x: number,
	y: number,
	z: number,
	sx: number,
	sy: number,
	sz: number,
	col: Color3,
	mat: Enum.Material?
): BasePart
	return Kit.box(parent, name, origin * CFrame.new(x, y + sy / 2, z), Vector3.new(sx, sy, sz), col, mat)
end

-- An upright cylinder in furniture space (y is the bottom).
function Kit.cylinder(
	parent: Instance?,
	origin: CFrame,
	name: string,
	x: number,
	y: number,
	z: number,
	diameter: number,
	height: number,
	col: Color3,
	mat: Enum.Material?
): BasePart
	local cf = origin * CFrame.new(x, y + height / 2, z) * CFrame.Angles(0, 0, math.rad(90))
	local p = Kit.box(nil, name, cf, Vector3.new(height, diameter, diameter), col, mat) :: Part
	p.Shape = Enum.PartType.Cylinder
	p.Parent = parent
	return p
end

-- A wall along "x" (fixed z) or "z" (fixed x) from s1 to s2, with gaps for
-- doors (b = 0) and windows (glass = true fills the gap with a pane).
function Kit.wall(
	parent: Instance,
	name: string,
	axis: string,
	fixed: number,
	s1: number,
	s2: number,
	y0: number,
	h: number,
	gaps: { Gap },
	col: Color3,
	mat: Enum.Material?,
	thick: number?
)
	local t = thick or 1
	table.sort(gaps, function(a, b)
		return a.c < b.c
	end)
	local function seg(a: number, b: number, yb: number, yt: number, glass: boolean)
		if b - a < 0.05 or yt - yb < 0.05 then
			return
		end
		local mid, len, ym = (a + b) / 2, b - a, y0 + (yb + yt) / 2
		local cf = if axis == "x" then CFrame.new(mid, ym, fixed) else CFrame.new(fixed, ym, mid)
		local size = if axis == "x" then Vector3.new(len, yt - yb, t) else Vector3.new(t, yt - yb, len)
		if glass then
			local paneSize = if axis == "x" then Vector3.new(len, yt - yb, 0.3) else Vector3.new(0.3, yt - yb, len)
			local pane = Kit.box(parent, name .. "_Glass", cf, paneSize, Kit.Color.glassWarm, M.Glass)
			pane.Transparency = 0.6
			pane.CastShadow = false
		else
			Kit.box(parent, name, cf, size, col, mat)
		end
	end
	local cur = s1
	for _, g in gaps do
		local a, b = g.c - g.w / 2, g.c + g.w / 2
		seg(cur, a, 0, h, false)
		seg(a, b, 0, g.b, false)
		seg(a, b, g.t, h, false)
		if g.glass then
			seg(a, b, g.b, g.t, true)
		end
		cur = b
	end
	seg(cur, s2, 0, h, false)
end

local function openable(parent: Instance?, name: string, pivot: CFrame, display: string): (Model, Model)
	local m = Kit.model(name, parent)
	m:SetAttribute("DisplayName", display)
	CollectionService:AddTag(m, "Openable")
	local moving = Kit.model("Moving", m)
	local hinge = Kit.box(moving, "Hinge", pivot, Vector3.new(0.2, 0.2, 0.2), Kit.Color.black)
	hinge.Transparency = 1
	hinge.CanCollide = false
	hinge.CanQuery = false
	hinge.CanTouch = false
	moving.PrimaryPart = hinge
	return m, moving
end

-- Something that swings open around `hingeCF`. axis "Y" (doors) or "X" (lids,
-- oven doors). Put the swinging parts in the returned `moving` model and
-- everything else (the body, the contents) in the returned openable model.
function Kit.hinged(
	parent: Instance?,
	name: string,
	hingeCF: CFrame,
	openAngle: number,
	display: string,
	axis: string?
): (Model, Model)
	local m, moving = openable(parent, name, hingeCF, display)
	m:SetAttribute("Kind", "Hinge")
	m:SetAttribute("OpenAngle", openAngle)
	m:SetAttribute("Axis", axis or "Y")
	return m, moving
end

-- Something that slides open by `offset` (in originCF's space): drawers, sliding doors.
function Kit.sliding(
	parent: Instance?,
	name: string,
	originCF: CFrame,
	offset: Vector3,
	display: string
): (Model, Model)
	local m, moving = openable(parent, name, originCF, display)
	m:SetAttribute("Kind", "Slide")
	m:SetAttribute("SlideOffset", offset)
	return m, moving
end

function Kit.inspectable(part: BasePart, display: string, line: string)
	part:SetAttribute("DisplayName", display)
	part:SetAttribute("Line", line)
	CollectionService:AddTag(part, "Inspectable")
end

function Kit.loot(part: BasePart, display: string, value: number, line: string?)
	part:SetAttribute("DisplayName", display)
	part:SetAttribute("Value", value)
	if line then
		part:SetAttribute("Line", line)
	end
	CollectionService:AddTag(part, "Loot")
end

-- Turns an openable (closet, shower) into a place to hide: adds the seat.
function Kit.hidingSpot(openableModel: Model, seatCF: CFrame)
	local seat = Instance.new("Seat")
	seat.Name = "HideSeat"
	seat.Anchored = true
	seat.Size = Vector3.new(2, 0.4, 2)
	seat.CFrame = seatCF
	seat.Transparency = 1
	seat.CanCollide = false
	seat.CanTouch = false -- only the "Hide" prompt can seat a player
	seat.Parent = openableModel
	CollectionService:AddTag(openableModel, "HidingSpot")
end

-- Places a row of small items (left to right from x0) and tags them.
function Kit.stock(parent: Instance, origin: CFrame, y: number, z: number, x0: number, gap: number, items: { Item })
	local x = x0
	for _, item in items do
		local p = Kit.part(parent, origin, item.n, x + item.s.X / 2, y, z, item.s.X, item.s.Y, item.s.Z, item.c, item.m)
		if item.value then
			Kit.loot(p, item.n, item.value, item.line)
		elseif item.line then
			Kit.inspectable(p, item.n, item.line)
		end
		x += item.s.X + gap
	end
end

-- A hinged door that fills a doorway left by Kit.wall.
function Kit.door(parent: Instance, spec: DoorSpec): Model
	local half = spec.w / 2
	local hingePos = spec.c + spec.hinge * half
	local hingeCF: CFrame, panelCF: CFrame, size: Vector3, handleCF: CFrame, angle: number
	local handleAt = spec.c - spec.hinge * (half - 0.6)
	if spec.axis == "x" then
		hingeCF = CFrame.new(hingePos, spec.y, spec.fixed)
		panelCF = CFrame.new(spec.c, spec.y + spec.h / 2, spec.fixed)
		size = Vector3.new(spec.w - 0.2, spec.h - 0.2, 0.4)
		handleCF = CFrame.new(handleAt, spec.y + 4, spec.fixed)
		angle = 92 * spec.swing * spec.hinge
	else
		hingeCF = CFrame.new(spec.fixed, spec.y, hingePos)
		panelCF = CFrame.new(spec.fixed, spec.y + spec.h / 2, spec.c)
		size = Vector3.new(0.4, spec.h - 0.2, spec.w - 0.2)
		handleCF = CFrame.new(spec.fixed, spec.y + 4, handleAt)
		angle = -92 * spec.swing * spec.hinge
	end
	local m, moving = Kit.hinged(parent, spec.name, hingeCF, angle, spec.display or "Door")
	local panel =
		Kit.box(moving, "Panel", panelCF, size, spec.col, if spec.glass then M.Glass else (spec.mat or M.Wood))
	if spec.glass then
		panel.Transparency = 0.5
	end
	Kit.box(moving, "Handle", handleCF, Vector3.new(0.9, 0.5, 0.9), Kit.Color.steel, M.Metal)
	return m
end

-- Where a steel shutter slams shut over a door in scene 07. Hidden until then.
function Kit.shutter(parent: Instance, name: string, cf: CFrame, size: Vector3)
	local p = Kit.box(parent, name, cf, size, Kit.Color.steel, M.DiamondPlate)
	p.Transparency = 1
	p.CanCollide = false
	p.CanQuery = false
	CollectionService:AddTag(p, "Shutter")
end

function Kit.sign(part: BasePart, face: Enum.NormalId, text: string, fg: Color3?, bg: Color3?)
	local gui = Instance.new("SurfaceGui")
	gui.Face = face
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 40
	gui.LightInfluence = 1
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundColor3 = bg or Kit.Color.black
	label.BackgroundTransparency = if bg then 0 else 1
	label.TextColor3 = fg or Kit.Color.white
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.Text = text
	label.Parent = gui
	gui.Parent = part
end

function Kit.light(
	parent: Instance,
	name: string,
	pos: Vector3,
	col: Color3,
	range: number,
	brightness: number,
	shadows: boolean?
): BasePart
	local p = Kit.box(parent, name, CFrame.new(pos), Vector3.one, col)
	p.Transparency = 1
	p.CanCollide = false
	p.CanQuery = false
	local l = Instance.new("PointLight")
	l.Color = col
	l.Range = range
	l.Brightness = brightness
	l.Shadows = shadows == true
	l.Parent = p
	return p
end

-- Floor-space CFrame helper: position + yaw in degrees. Yaw 0 faces -Z,
-- 90 faces -X, 180 faces +Z, -90 faces +X.
function Kit.at(x: number, y: number, z: number, yaw: number?): CFrame
	return CFrame.new(x, y, z) * CFrame.Angles(0, math.rad(yaw or 0), 0)
end

return Kit
