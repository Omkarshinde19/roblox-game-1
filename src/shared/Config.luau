--!strict
-- Shared game configuration. Readable by both server and client.

local Config = {
	GAME_NAME = "Chip Heist",
	VERSION = "0.2.0",
	DEBUG = true,

	-- Opening things (doors, drawers, the fridge)
	QUIET_HOLD_SECONDS = 0.9, -- hold the prompt this long to open quietly
	TAP_MAX_SECONDS = 0.35, -- releasing sooner than this counts as a loud tap
	OPEN_SECONDS = 0.35, -- how long the swing/slide animation takes
	INTERACT_DISTANCE = 9, -- studs
	QUIET_NOISE_RADIUS = 8, -- studs an NPC can hear a careful open from
	LOUD_NOISE_RADIUS = 70, -- studs an NPC can hear a yanked-open door from

	-- NPCs
	DIFFICULTY = "Medium", -- "Easy" (cat only) | "Medium" | "Hard"
	ADMIN_WALK_SPEED = 9,
	ADMIN_HUNT_SPEED = 15, -- players run at 16
	ADMIN_SLEEP_SECONDS = 45,
	ADMIN_GAME_SECONDS = 25,
	ADMIN_LOUD_SUSPICION = 0.34, -- three loud noises take him from calm to hunting
	ADMIN_GIVE_UP_SECONDS = 10, -- hunting stops this long after he last saw anyone
	ADMIN_CATCH_DISTANCE = 6,
	MOM_WALK_SPEED = 8,
	MOM_DINNER_SECONDS = 90,
	CAT_WALK_SPEED = 11,
	CAT_NOISE_RADIUS = 45,
	APPEAL_SECONDS = 3, -- hold time for a teammate to free a banned Scam

	-- Subtitles
	LINE_SECONDS = 4.5,
}

return Config
