--!strict
-- Every sound an NPC could hear goes through here. NPCs (The Admin, Mom)
-- will connect to NoiseService.heard; clients get a HUD cue.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.Remotes)

export type Noise = { position: Vector3, radius: number, loud: boolean, source: Player?, from: Instance? }

local event = Instance.new("BindableEvent")

local NoiseService = {}

-- Fires with one Noise table per sound.
NoiseService.heard = event.Event

-- `source` is the player who caused it; `from` is the NPC model that made it (if any).
function NoiseService.emit(position: Vector3, radius: number, loud: boolean, source: Player?, from: Instance?)
	local noise: Noise = { position = position, radius = radius, loud = loud, source = source, from = from }
	event:Fire(noise)
	Remotes.get("NoiseMade"):FireAllClients(position, radius, loud)
end

return NoiseService
