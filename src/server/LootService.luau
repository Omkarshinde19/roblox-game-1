--!strict
-- "Loot" things: take one and it's added to your haul and the crew total.
-- Totals live in attributes so clients can read them:
--   Workspace "CrewLoot" (number), Player "LootValue" (number).

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.Remotes)
local InspectService = require(script.Parent.InspectService)

local TAG = "Loot"

local LootService = {}

local function take(player: Player, part: BasePart)
	if part:GetAttribute("Taken") or not InspectService.canReach(player, part) then
		return
	end
	part:SetAttribute("Taken", true)
	local value = part:GetAttribute("Value")
	local amount = if typeof(value) == "number" then value else 0
	local name = (part:GetAttribute("DisplayName") :: string?) or part.Name
	local line = part:GetAttribute("Line")

	player:SetAttribute("LootValue", ((player:GetAttribute("LootValue") :: number?) or 0) + amount)
	local total = ((workspace:GetAttribute("CrewLoot") :: number?) or 0) + amount
	workspace:SetAttribute("CrewLoot", total)
	Remotes.get("LootChanged"):FireAllClients(total, name, player.Name)
	if typeof(line) == "string" then
		Remotes.get("ShowLine"):FireClient(player, "SCAM", line)
	end
	part:Destroy()
end

local function setup(instance: Instance)
	if not instance:IsA("BasePart") or instance:FindFirstChildOfClass("ProximityPrompt") then
		return
	end
	local prompt = InspectService.addPrompt(instance, "Take", 0.4)
	prompt.Triggered:Connect(function(player: Player)
		take(player, instance)
	end)
end

function LootService.start()
	workspace:SetAttribute("CrewLoot", 0)
	Players.PlayerAdded:Connect(function(player: Player)
		player:SetAttribute("LootValue", 0)
	end)
	for _, player in Players:GetPlayers() do
		player:SetAttribute("LootValue", 0)
	end
	for _, instance in CollectionService:GetTagged(TAG) do
		setup(instance)
	end
	CollectionService:GetInstanceAddedSignal(TAG):Connect(setup)
end

return LootService
