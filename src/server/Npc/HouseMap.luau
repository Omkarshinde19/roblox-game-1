--!strict
-- Named spots in the cabin for NPCs to walk to. Coordinates match the
-- blockout (tools/blockout/README.md). Y is the floor level + 3.

local B, G = 232 + 3, 246 + 3

local function g(x: number, z: number): Vector3
	return Vector3.new(x, G, z)
end
local function b(x: number, z: number): Vector3
	return Vector3.new(x, B, z)
end

local HouseMap = {
	-- The Admin
	adminChair = b(-40.5, -60), -- standing spot behind his gaming chair
	fridge = g(28.5, -88.5), -- in front of the kitchen fridge

	-- Mom
	momDinnerCall = g(3, -96), -- stair hall, by the top of the stairs
	momPatrol = { g(20, -79), g(-22, -52), g(-2, -47), g(37, -52), g(44, -80), g(3, -79) },

	-- The cat
	catSpots = {
		g(-22, -52),
		g(-34, -58),
		g(-2, -47),
		g(20, -79),
		g(42, -94),
		g(-18, -80),
		g(3, -79),
		g(37, -52),
		b(-25, -55),
		b(30, -55),
		b(20, -88),
	},

	spawn = { admin = b(-40.5, -60), mom = g(20, -79), cat = g(-22, -52) },
}

return HouseMap
