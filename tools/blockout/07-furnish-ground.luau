--!strict
-- Blockout step 7: furniture for the ground floor and the deck.
-- Rebuilds Workspace.Blockout.House.Furnishings.Ground only.
-- Yaw: 0 faces -Z (back of the house), 180 faces +Z (front), 90 faces -X, -90 faces +X.

local Kit = require(script.Parent.Kit)
local Storage = require(script.Parent.furniture.Storage)
local Appliances = require(script.Parent.furniture.Appliances)
local Seating = require(script.Parent.furniture.Seating)

return function()
	local house = workspace.Blockout:WaitForChild("House")
	local furnishings = house:FindFirstChild("Furnishings") or Kit.folder("Furnishings", house)
	local old = furnishings:FindFirstChild("Ground")
	if old then
		old:Destroy()
	end
	local root = Kit.folder("Ground", nil)

	local G = 246
	local C = Kit.Color
	local M = Enum.Material
	local V = Vector3.new
	local DOOM = Color3.fromRGB(60, 200, 70)

	local function at(x: number, z: number, yaw: number?, up: number?): CFrame
		return Kit.at(x, G + (up or 0), z, yaw)
	end
	local function books(n: number, special: Kit.Item?): { Kit.Item }
		local cols = { C.red, C.blue, C.green, C.cream, C.darkWood }
		local t: { Kit.Item } = {}
		for i = 1, n do
			table.insert(t, { n = "Book", s = V(0.5, 1.5, 1.1), c = cols[(i % #cols) + 1] })
		end
		if special then
			table.insert(t, math.ceil(n / 2), special)
		end
		return t
	end

	---------------- LIVING ROOM (x -52..-4, z -72..-40) ----------------
	local living = Kit.folder("LivingRoom", root)
	Appliances.tv(living, at(-44, -70.2, 180), {
		{
			{
				n = "Game discs",
				s = V(2.4, 0.5, 1.4),
				c = C.blue,
				line = "Physical game discs. In 2221. This man is a museum.",
			},
		},
	})
	local console = Kit.part(living, at(-41, -70.2, 180), "GameBox 9000", 0, 2.4, 0, 2.2, 0.5, 1.5, C.black, M.Plastic)
	Kit.loot(console, "GameBox 9000", 250, "A GameBox 9000. It has chips. Chips are chips. Bagging it.")
	Seating.rug(living, at(-44, -62), 18, 13, Color3.fromRGB(110, 50, 50))
	Seating.sofa(living, at(-44, -56), 12, C.fabric)
	Seating.sofa(living, at(-32.5, -63, 90), 5, C.fabric)
	Seating.table(living, at(-44, -63.5), "CoffeeTable", 7, 3.4, 1.6, C.darkWood)
	local remote = Kit.part(living, at(-45, -63.5), "TV remote", 0, 1.6, 0, 0.4, 0.15, 1, C.black, M.Plastic)
	Kit.inspectable(remote, "TV remote", "The remote. A Distraction's best friend.")
	Seating.table(living, at(-36, -54.5), "SideTable", 2.4, 2.4, 2.4, C.darkWood)
	Seating.vase(living, at(-36, -54.5, 0, 2.4))
	Storage.shelf(living, at(-26, -70.6, 180), "Bookshelf", 8, 9, 1.6, 4, C.darkWood, {
		books(7),
		books(
			6,
			{
				n = "Self-help book",
				s = V(0.5, 1.5, 1.1),
				c = C.gold,
				line = "'How to Win Friends and Ban People'. Signed by the author. He is the author.",
			}
		),
		books(7),
		{
			{
				n = "Family photo",
				s = V(1.6, 1.2, 0.2),
				c = C.cream,
				line = "A family photo. Mom is smiling. He's on his phone. The cat is mid-crime.",
			},
		},
	})
	Seating.floorLamp(living, at(-49.5, -44))
	Seating.plant(living, at(-8, -43.5), 7)
	Seating.plant(living, at(-49.5, -67), 6)

	---------------- DINING (x -4..28, z -72..-40) ----------------
	local dining = Kit.folder("Dining", root)
	Seating.rug(dining, at(12, -56), 19, 12, Color3.fromRGB(70, 80, 100))
	Seating.diningSet(dining, at(12, -56), C.wood)
	Storage.drawers(dining, at(10.25, -70.2, 180), "Sideboard", 5, 3.6, 2.4, 3, C.darkWood, {
		[1] = {
			{
				n = "Tablecloth",
				s = V(2.4, 0.4, 1.4),
				c = C.white,
				m = M.Fabric,
				line = "The good tablecloth. For guests. There have been no guests.",
			},
		},
		[2] = {
			{
				n = "Good silverware",
				s = V(2.2, 0.4, 1),
				c = C.steel,
				m = M.Metal,
				value = 90,
				line = "Real silver. Silver conducts. That's basically hardware.",
			},
		},
		[3] = {
			{
				n = "Takeout menus",
				s = V(1.6, 0.3, 1.2),
				c = C.red,
				line = "Forty takeout menus. All from the same pizza place.",
			},
		},
	})
	Storage.cabinet(dining, at(26.2, -48, 90), "ChinaCabinet", 4, 8, 2.4, C.darkWood, {
		{
			{
				n = "Wedding china",
				s = V(2.4, 0.8, 1.4),
				c = C.white,
				line = "Wedding china. Never used. Much like his gym membership.",
			},
		},
		{ { n = "Teapot", s = V(1.2, 1, 1), c = C.blue, line = "A teapot shaped like a cat. The cat hates it." } },
		{
			{
				n = "Coin jar",
				s = V(0.9, 1.1, 0.9),
				c = C.gold,
				m = M.Glass,
				value = 40,
				line = "A jar of coins. Physical money. Adorable. Mine.",
			},
		},
	}, "China cabinet")

	---------------- MOM'S ROOM (x 28..52, z -72..-40) ----------------
	local mom = Kit.folder("MomRoom", root)
	Seating.rug(mom, at(39, -56), 12, 14, Color3.fromRGB(150, 110, 130))
	Seating.bed(mom, at(46, -56, 90), 7, Color3.fromRGB(190, 120, 150))
	Storage.drawers(mom, at(50, -61.2, 90), "Nightstand", 2.6, 2.6, 2.4, 2, C.wood, {
		[2] = {
			{
				n = "RAM pendant",
				s = V(0.9, 0.3, 0.6),
				c = C.gold,
				m = M.Metal,
				value = 300,
				line = "A pendant shaped like a RAM stick. Wait. It IS a RAM stick. On a chain. Yoink.",
			},
		},
	})
	Storage.drawers(mom, at(50, -50.8, 90), "Nightstand", 2.6, 2.6, 2.4, 2, C.wood, {
		[1] = {
			{
				n = "Romance novel",
				s = V(1, 0.4, 0.7),
				c = C.red,
				line = "'Passion in the Server Room'. Volume nine. Well-read.",
			},
		},
	})
	Storage.wardrobe(mom, at(34, -69.4, 180), "Wardrobe_Mom", C.cream)
	Storage.drawers(mom, at(40, -42.1, 0), "Dresser", 6, 3.6, 2.4, 3, C.wood, {
		[1] = {
			{
				n = "Knitted GPU cosy",
				s = V(2, 0.6, 1.2),
				c = C.purple,
				m = M.Fabric,
				line = "She knitted a cosy for his graphics card. It says 'my little gamer'.",
			},
		},
		[3] = {
			{
				n = "Cash in a sock",
				s = V(1.2, 0.5, 0.7),
				c = C.cream,
				m = M.Fabric,
				value = 60,
				line = "Cash in a sock. Classic Mom encryption.",
			},
		},
	})
	local basket = Kit.cylinder(mom, at(31.5, -44), "Laundry basket", 0, 0, 0, 2.6, 2.2, C.cream, M.Fabric)
	Kit.inspectable(basket, "Laundry basket", "Clean laundry. Folded with love. Nobody asked.")

	---------------- THE ADMIN'S OLD BEDROOM (x -52..-26, z -104..-72) ----------------
	local bedroom = Kit.folder("OldBedroom", root)
	Seating.bed(bedroom, at(-46, -98, -90), 6, C.blue, true)
	Seating.desk(bedroom, at(-49.4, -86, -90), 8, C.darkWood)
	local laptop = Kit.part(bedroom, at(-49.4, -86, -90), "Gaming laptop", 0, 3.2, 0, 2.4, 0.3, 1.8, C.black, M.Metal)
	Kit.loot(laptop, "Gaming laptop", 400, "His old gaming laptop. Sixteen whole gigabytes. In this economy!")
	Seating.chair(bedroom, at(-45.4, -86, 90), C.darkWood)
	Storage.wardrobe(bedroom, at(-28.6, -93, 90), "Wardrobe_OldBedroom", C.darkWood)
	Storage.shelf(bedroom, at(-27.3, -80, 90), "TrophyShelf", 6, 7, 1.4, 3, C.wood, {
		{
			{
				n = "Box of cables",
				s = V(2, 1.2, 1),
				c = C.cardboard,
				line = "A box labelled 'cables (important)'. They are not important.",
			},
		},
		{
			{
				n = "Trophy",
				s = V(0.9, 1.6, 0.9),
				c = C.gold,
				m = M.Metal,
				line = "'Moderator of the Month'. Awarded by himself. Twelve times.",
			},
		},
		{
			{
				n = "Action figure",
				s = V(0.7, 1.4, 0.5),
				c = C.red,
				line = "A mint-condition action figure. He's never opened it. He's never opened anything.",
			},
		},
	})
	Seating.poster(bedroom, at(-44, -72.6, 0, 4.5), 5, 6, "DIZCORD\nMOD OF THE YEAR\n2209", C.purple)
	Seating.poster(bedroom, at(-51.2, -97, -90, 5), 4, 5, "NO GIRLS\nNO NOOBS\nNO MOM", C.black, C.red)
	Seating.beanbag(bedroom, at(-37, -80), C.red)
	Storage.box(bedroom, at(-33, -100.5, 180), "Box", 3.4, 3, 3, nil, "OLD STUFF")
	Storage.box(bedroom, at(-37.5, -100.5, 180), "Box", 3, 2.4, 3, nil, "OLDER STUFF")

	---------------- BATHROOM (x -26..-10, z -104..-72) ----------------
	local bath = Kit.folder("Bathroom", root)
	Appliances.bathtub(bath, at(-20.5, -101.2, 180), -4.5)
	Appliances.toilet(bath, at(-23.6, -88, -90))
	Appliances.vanity(bath, at(-12.1, -85, 90))
	Storage.trunk(bath, at(-12.4, -76, 90), "Hamper", 2.4, 3, 2.4, C.cream, {
		{
			n = "Lonely sock",
			s = V(0.9, 0.3, 0.5),
			c = C.red,
			m = M.Fabric,
			line = "One sock. Its partner has been missing since 2217.",
		},
	}, "Laundry hamper")
	Seating.rug(bath, at(-18, -96), 5, 3, C.blue)

	---------------- STAIR HALL (x -10..8, z -104..-72) ----------------
	local hall = Kit.folder("StairHall", root)
	Storage.cabinet(hall, at(6.6, -96.5, 90), "ShoeCabinet", 4, 3.2, 1.6, C.wood, {
		{
			{
				n = "One left shoe",
				s = V(1.4, 0.6, 0.8),
				c = C.black,
				line = "One left shoe. Just the one. Outdoor use: zero hours.",
			},
		},
		{
			{
				n = "Emergency Mountain Doom",
				s = V(0.6, 1, 0.6),
				c = DOOM,
				m = M.Metal,
				line = "Emergency Mountain Doom. In the shoe cabinet. For hallway emergencies.",
			},
		},
	}, "Shoe cabinet")
	Seating.poster(hall, at(7.45, -92, 90, 5), 3.4, 2.6, "LIVE\nLAUGH\nBAN", C.cream, C.black)

	---------------- KITCHEN (x 8..36, z -104..-72) ----------------
	local kitchen = Kit.folder("Kitchen", root)
	Appliances.sinkCounter(kitchen, at(25, -101.7, 180), C.cream, {
		{ { n = "Dish soap", s = V(0.6, 1.2, 0.6), c = C.green, line = "Dish soap. Full. Suspiciously full." } },
	})
	Storage.counter(kitchen, at(29, -101.7, 180), "Counter", 4, C.cream, {
		{
			{
				n = "RAM-Os cereal",
				s = V(1.2, 1.8, 0.6),
				c = C.red,
				value = 150,
				line = "RAM-Os. There's real RAM in the box. Part of a complete breakfast.",
			},
		},
	})
	Storage.counter(kitchen, at(33, -101.7, 180), "Counter", 4, C.cream, {
		{
			{
				n = "Taped-shut pot",
				s = V(1.6, 1.2, 1.6),
				c = C.steel,
				m = M.Metal,
				line = "A pot with the lid taped shut. The label says 'science'.",
			},
		},
	})
	Appliances.fridge(kitchen, at(33.4, -88.5, 90))
	Appliances.stove(kitchen, at(10.6, -94, -90))
	Storage.counter(kitchen, at(10.2, -88.4, -90), "Counter", 5, C.cream, {
		{
			{
				n = "Pan collection",
				s = V(2.4, 0.8, 1.6),
				c = C.black,
				m = M.Metal,
				line = "Pans. One has been used. Once.",
			},
		},
	})
	Appliances.microwave(kitchen, at(9.8, -88.4, -90, 3.5))
	Storage.cabinet(kitchen, at(9.4, -93.5, -90, 7), "UpperCabinet", 4, 3.2, 1.6, C.cream, {
		{
			{
				n = "Novelty mug",
				s = V(0.9, 1, 0.9),
				c = C.white,
				line = "'World's Okayest Mod'. A gift. From himself.",
			},
		},
	}, "Cabinet")
	Storage.counter(kitchen, at(20, -86, 180), "Island", 4, C.cream, {
		{
			{
				n = "Snack drawer overflow",
				s = V(2.4, 1.2, 1.6),
				c = C.gold,
				line = "Snacks, sorted by crunch volume. That's a threat to stealth.",
			},
		},
	})
	Storage.counter(kitchen, at(24, -86, 180), "Island", 4, C.cream, {
		{
			{ n = "Blender", s = V(1, 1.8, 1), c = C.steel, m = M.Glass, line = "A blender. Not the 3D kind. Useless." },
		},
	})
	local fruit = Kit.cylinder(kitchen, at(22, -86, 0, 3.5), "Fruit bowl", 0, 0, 0, 2, 0.6, C.gold, M.SmoothPlastic)
	Kit.inspectable(fruit, "Fruit bowl", "Decorative fruit. Decorative since 2218.")
	Appliances.trashCan(kitchen, at(9.8, -101.6, 180), "Pizza boxes. All the way down. It's a geological record.")
	local bowl = Kit.cylinder(kitchen, at(22.5, -101.8), "Cat bowl", 0, 0, 0, 1.4, 0.4, C.red, M.SmoothPlastic)
	Kit.inspectable(bowl, "Cat bowl", "The cat's bowl. Full. The cat prefers crimes.")

	---------------- PANTRY (x 36..52, z -104..-88) ----------------
	local pantry = Kit.folder("Pantry", root)
	local function tin(col: Color3): Kit.Item
		return { n = "Tin", s = V(0.8, 1, 0.8), c = col, m = M.Metal }
	end
	Storage.shelf(pantry, at(45, -102.2, 180), "PantryShelf", 12, 9, 2, 4, C.wood, {
		{
			{
				n = "Mountain Doom crate",
				s = V(3, 1.8, 1.6),
				c = DOOM,
				line = "A crate of Mountain Doom. There are nine more. This is his water.",
			},
			{ n = "Mountain Doom crate", s = V(3, 1.8, 1.6), c = DOOM },
			{ n = "Mountain Doom crate", s = V(3, 1.8, 1.6), c = DOOM },
		},
		{ tin(C.red), tin(C.red), tin(C.blue), tin(C.green), tin(C.red), tin(C.cream), tin(C.blue) },
		{
			{
				n = "Family-size chips",
				s = V(2, 1.8, 1),
				c = C.gold,
				line = "Family-size chips. The family is one man.",
			},
			{
				n = "Instant noodles",
				s = V(2.4, 1.4, 1.2),
				c = C.red,
				line = "Instant noodles. He eats them dry. I've seen the logs.",
			},
			{
				n = "Protein powder",
				s = V(1.2, 1.6, 1.2),
				c = C.black,
				line = "Protein powder. Sealed. An aspirational purchase.",
			},
		},
		{
			{
				n = "Flour tin",
				s = V(1.4, 1.4, 1.4),
				c = C.cream,
				m = M.Metal,
				value = 200,
				line = "The flour tin rattles. Flour doesn't rattle. Two sticks of DDR5. Thanks, Mom.",
			},
			tin(C.green),
			tin(C.blue),
		},
	})
	Storage.shelf(pantry, at(50.4, -94, 90), "PantryShelf", 7, 9, 1.6, 4, C.wood, {
		{ { n = "Rice sack", s = V(2.6, 1.4, 1.2), c = C.cream, m = M.Fabric } },
		{ tin(C.red), tin(C.green), tin(C.red), tin(C.blue) },
		{ { n = "Spice rack", s = V(2.6, 1, 0.8), c = C.darkWood, line = "Spices. Salt, and a second salt." } },
	})
	Storage.box(pantry, at(39.5, -90.4, 180), "Mountain Doom crate", 3, 2, 2.4, DOOM, "MOUNTAIN DOOM x24")

	---------------- MUD ROOM (x 36..52, z -88..-72) ----------------
	local mud = Kit.folder("MudRoom", root)
	Seating.bench(mud, at(44.5, -73.6), 8, C.wood)
	Kit.part(mud, at(44.5, -72.7, 0, 7), "CoatHooks", 0, 0, 0, 8, 0.4, 0.3, C.darkWood, M.Wood)
	for i, col in { C.red, C.blue, C.black } do
		local coat = Kit.part(mud, at(41.5 + i * 1.6, -73, 0, 3.2), "Coat", 0, 0, 0, 1.4, 3.8, 0.6, col, M.Fabric)
		coat.CanCollide = false
	end
	Storage.shelf(mud, at(44.5, -86.7, 180), "ShoeRack", 7, 3, 1.6, 2, C.wood, {
		{
			{
				n = "Hiking boots",
				s = V(1.6, 1, 1),
				c = C.darkWood,
				line = "Hiking boots. Tags still on. He lives in the mountains.",
			},
		},
		{ { n = "Mom's gardening clogs", s = V(1.4, 0.6, 1), c = C.green } },
	})

	---------------- DECK (x -56..56, z -40..-20) ----------------
	local deck = Kit.folder("Deck", root)
	Appliances.grill(deck, at(44, -23.5))
	Seating.table(deck, at(-30, -28), "DeckTable", 4, 4, 2.6, C.darkWood)
	Seating.chair(deck, at(-34.5, -28, -90), C.darkWood)
	Seating.chair(deck, at(-25.5, -28, 90), C.darkWood)
	local wood = Kit.part(deck, at(-52.5, -36), "Firewood", 0, 0, 0, 5, 3, 2.4, C.darkWood, M.Wood)
	Kit.inspectable(wood, "Firewood", "Firewood, stacked by Mom. The fireplace is a hologram.")

	root.Parent = furnishings
	print(`[blockout] ground-floor furniture: {#root:GetDescendants()} instances`)
end
