--!strict
-- Server entry point. Runs once when the server starts and boots the services.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Config = require(ReplicatedStorage.Shared.Config)
require(ReplicatedStorage.Shared.Remotes) -- creates the RemoteEvents before anything fires

local OpenableService = require(script.OpenableService)
local InspectService = require(script.InspectService)
local LootService = require(script.LootService)
local HidingService = require(script.HidingService)

OpenableService.start()
InspectService.start()
LootService.start()
HidingService.start()

print(`[Server] {Config.GAME_NAME} v{Config.VERSION} started`)

Players.PlayerAdded:Connect(function(player: Player)
	print(`[Server] {player.Name} joined`)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	print(`[Server] {player.Name} left`)
end)
