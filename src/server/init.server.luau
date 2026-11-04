--!strict
-- Server entry point. Runs once when the server starts.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Config = require(ReplicatedStorage.Shared.Config)

print(`[Server] {Config.GAME_NAME} v{Config.VERSION} started`)

Players.PlayerAdded:Connect(function(player: Player)
	print(`[Server] {player.Name} joined`)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	print(`[Server] {player.Name} left`)
end)
