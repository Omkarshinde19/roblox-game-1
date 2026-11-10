--!strict
-- Furniture catalogue: things that open. Cabinets, drawers, shelves, trunks.
-- Every piece is built at `cf`: a point on the floor, front facing cf's -Z.

local Kit = require(script.Parent.Parent.Kit)

local C = Kit.Color
local M = Enum.Material
type Item = Kit.Item

local Storage = {}

local T = 0.3 -- panel thickness

-- An open-fronted box: back, sides, top, bottom.
function Storage.carcass(m: Instance, cf: CFrame, w: number, h: number, d: number, col: Color3, mat: Enum.Material?)
	Kit.part(m, cf, "Back", 0, 0, d / 2 - T / 2, w, h, T, col, mat)
	Kit.part(m, cf, "Side", -w / 2 + T / 2, 0, 0, T, h, d, col, mat)
	Kit.part(m, cf, "Side", w / 2 - T / 2, 0, 0, T, h, d, col, mat)
	Kit.part(m, cf, "Top", 0, h - T, 0, w, T, d, col, mat)
	Kit.part(m, cf, "Bottom", 0, 0, 0, w, T, d, col, mat)
end

-- A cabinet with one hinged door. `rows` sit on the bottom and on shelves.
function Storage.cabinet(
	parent: Instance,
	cf: CFrame,
	name: string,
	w: number,
	h: number,
	d: number,
	col: Color3,
	rows: { { Item } }?,
	display: string?,
	mat: Enum.Material?
): Model
	local m, moving = Kit.hinged(parent, name, cf * CFrame.new(-w / 2, 0, -d / 2), 100, display or name)
	Storage.carcass(m, cf, w, h, d, col, mat or M.Wood)
	Kit.part(moving, cf, "Panel", 0, 0.1, -d / 2 - 0.15, w - 0.1, h - 0.2, 0.3, col, mat or M.Wood)
	Kit.part(moving, cf, "Handle", w / 2 - 0.5, h / 2 - 0.45, -d / 2 - 0.45, 0.25, 0.9, 0.3, C.steel, M.Metal)
	if rows then
		local spacing = (h - T) / #rows
		for i, items in rows do
			local y = T + (i - 1) * spacing
			if i > 1 then
				Kit.part(m, cf, "Shelf", 0, y - 0.2, 0, w - 2 * T, 0.2, d - T, col, mat or M.Wood)
			end
			Kit.stock(m, cf, y, 0, -w / 2 + 0.6, 0.25, items)
		end
	end
	return m
end

-- A kitchen-style base cabinet with a stone worktop.
function Storage.counter(parent: Instance, cf: CFrame, name: string, w: number, col: Color3, rows: { { Item } }?): Model
	local m = Storage.cabinet(parent, cf, name, w, 3.2, 3, col, rows, "Cabinet")
	Kit.part(m, cf, "Worktop", 0, 3.2, -0.1, w + 0.05, 0.3, 3.4, C.stone, M.Marble)
	return m
end

-- A closet you can hide in.
function Storage.wardrobe(parent: Instance, cf: CFrame, name: string, col: Color3): Model
	local m = Storage.cabinet(parent, cf, name, 6, 10, 4, col, nil, "Wardrobe")
	Kit.part(m, cf, "Rail", 0, 8.6, 0, 5.2, 0.2, 0.2, C.steel, M.Metal)
	for i, c in { C.red, C.blue, C.cream, C.green } do
		local cloth = Kit.part(m, cf, "Clothes", -2.9 + i * 1.1, 4.4, 0.6, 0.5, 4.2, 2, c, M.Fabric)
		cloth.CanCollide = false
	end
	Kit.hidingSpot(m, cf * CFrame.new(0, 1.2, 0.2))
	return m
end

-- A chest of drawers. contents[i] stocks drawer i (1 = bottom).
function Storage.drawers(
	parent: Instance,
	cf: CFrame,
	name: string,
	w: number,
	h: number,
	d: number,
	n: number,
	col: Color3,
	contents: { [number]: { Item } }?,
	mat: Enum.Material?
): Model
	local m = Kit.model(name, parent)
	Kit.part(m, cf, "Back", 0, 0, d / 2 - T / 2, w, h, T, col, mat or M.Wood)
	Kit.part(m, cf, "Side", -w / 2 + T / 2, 0, 0, T, h, d, col, mat or M.Wood)
	Kit.part(m, cf, "Side", w / 2 - T / 2, 0, 0, T, h, d, col, mat or M.Wood)
	Kit.part(m, cf, "Top", 0, h - T, 0, w + 0.2, T, d + 0.2, col, mat or M.Wood)
	local dh = (h - T) / n
	for i = 1, n do
		local origin = cf * CFrame.new(0, (i - 1) * dh, 0)
		local _, moving = Kit.sliding(m, "Drawer" .. i, origin, Vector3.new(0, 0, -(d - 0.9)), "Drawer")
		Kit.part(moving, origin, "Panel", 0, 0.1, -d / 2 - 0.15, w - 0.15, dh - 0.2, 0.3, col, mat or M.Wood)
		Kit.part(moving, origin, "Handle", 0, dh / 2 - 0.15, -d / 2 - 0.45, 1, 0.3, 0.3, C.steel, M.Metal)
		Kit.part(moving, origin, "Tray", 0, 0.1, 0, w - 0.8, 0.2, d - 0.6, C.darkWood, M.Wood)
		local items = contents and contents[i]
		if items then
			Kit.stock(moving, origin, 0.3, 0, -w / 2 + 0.8, 0.3, items)
		end
	end
	return m
end

-- Open shelving. rows[i] sits on board i (1 = bottom). Items are always reachable.
function Storage.shelf(
	parent: Instance,
	cf: CFrame,
	name: string,
	w: number,
	h: number,
	d: number,
	levels: number,
	col: Color3,
	rows: { { Item } }?,
	mat: Enum.Material?
): Model
	local m = Kit.model(name, parent)
	Kit.part(m, cf, "Side", -w / 2 + 0.15, 0, 0, 0.3, h, d, col, mat or M.Wood)
	Kit.part(m, cf, "Side", w / 2 - 0.15, 0, 0, 0.3, h, d, col, mat or M.Wood)
	local spacing = h / levels
	for i = 1, levels do
		local y = (i - 1) * spacing + 0.2
		Kit.part(m, cf, "Board", 0, y, 0, w - 0.6, 0.2, d, col, mat or M.Wood)
		local items = rows and rows[i]
		if items then
			Kit.stock(m, cf, y + 0.2, 0, -w / 2 + 0.6, 0.3, items)
		end
	end
	return m
end

-- A chest with a lid hinged at the back.
function Storage.trunk(
	parent: Instance,
	cf: CFrame,
	name: string,
	w: number,
	h: number,
	d: number,
	col: Color3,
	items: { Item }?,
	display: string?
): Model
	local m, moving = Kit.hinged(parent, name, cf * CFrame.new(0, h - 0.4, d / 2), 100, display or "Trunk", "X")
	Kit.part(m, cf, "Bottom", 0, 0, 0, w, T, d, col, M.Wood)
	Kit.part(m, cf, "Back", 0, 0, d / 2 - T / 2, w, h - 0.4, T, col, M.Wood)
	Kit.part(m, cf, "Front", 0, 0, -d / 2 + T / 2, w, h - 0.4, T, col, M.Wood)
	Kit.part(m, cf, "Side", -w / 2 + T / 2, 0, 0, T, h - 0.4, d, col, M.Wood)
	Kit.part(m, cf, "Side", w / 2 - T / 2, 0, 0, T, h - 0.4, d, col, M.Wood)
	Kit.part(moving, cf, "Lid", 0, h - 0.4, 0, w + 0.1, 0.4, d + 0.1, col, M.Wood)
	Kit.part(moving, cf, "Handle", 0, h - 0.9, -d / 2 - 0.15, 0.8, 0.5, 0.3, C.steel, M.Metal)
	if items then
		Kit.stock(m, cf, T, 0, -w / 2 + 0.6, 0.3, items)
	end
	return m
end

-- A plain box (cardboard by default). Returns the part so it can be tagged.
function Storage.box(
	parent: Instance,
	cf: CFrame,
	name: string,
	w: number,
	h: number,
	d: number,
	col: Color3?,
	label: string?
): BasePart
	local p = Kit.part(parent, cf, name, 0, 0, 0, w, h, d, col or C.cardboard, M.Cardboard)
	if label then
		Kit.sign(p, Enum.NormalId.Front, label, C.black)
	end
	return p
end

return Storage
