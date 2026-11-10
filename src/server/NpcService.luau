--!strict
-- Spawns the NPCs for the chosen difficulty and prepares the house for them:
-- door panels are passable for pathfinding (NPCs open them as they walk),
-- and the cat doesn't collide with doors at all.

local CollectionService = game:GetService("CollectionService")
local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local Admin = require(script.Parent.Npc.Admin)
local Cat = require(script.Parent.Npc.Cat)
local Mom = require(script.Parent.Npc.Mom)

local NpcService = {}

local function prepareDoors()
	PhysicsService:RegisterCollisionGroup("DoorPanel")
	PhysicsService:RegisterCollisionGroup("Cat")
	PhysicsService:CollisionGroupSetCollidable("Cat", "DoorPanel", false)
	for _, model in CollectionService:GetTagged("Openable") do
		if model.Name:sub(1, 5) == "Door_" then
			for _, part in model:GetDescendants() do
				if part:IsA("BasePart") then
					part.CollisionGroup = "DoorPanel"
					local modifier = Instance.new("PathfindingModifier")
					modifier.PassThrough = true
					modifier.Parent = part
				end
			end
		end
	end
end

function NpcService.start()
	if not workspace:FindFirstChild("Blockout") or not workspace.Blockout:FindFirstChild("House") then
		warn("[NpcService] no house in this place; NPCs not spawned")
		return
	end
	prepareDoors()
	task.spawn(function()
		local admin = Admin.spawn()
		local cat = Cat.spawn()
		for _, part in cat.model:GetDescendants() do
			if part:IsA("BasePart") then
				part.CollisionGroup = "Cat"
			end
		end
		if Config.DIFFICULTY ~= "Easy" then
			Mom.spawn(admin)
		end
		print(`[Server] NPCs spawned ({Config.DIFFICULTY})`)
	end)
end

return NpcService
