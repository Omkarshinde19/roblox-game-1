--!strict
-- Client entry point. Runs on each player's machine.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Config = require(ReplicatedStorage.Shared.Config)

local player = Players.LocalPlayer
print(`[Client] Hello {player.Name}, welcome to {Config.GAME_NAME}`)
