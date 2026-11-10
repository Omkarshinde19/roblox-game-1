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

	-- Subtitles
	LINE_SECONDS = 4.5,
}

return Config
