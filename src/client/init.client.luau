--!strict
-- Client entry point. Runs on each player's machine.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Config = require(ReplicatedStorage.Shared.Config)
local Hud = require(script.Hud)

local player = Players.LocalPlayer
Hud.start()
print(`[Client] Hello {player.Name}, welcome to {Config.GAME_NAME}`)
