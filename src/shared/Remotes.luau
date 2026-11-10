--!strict
-- Every RemoteEvent in the game, by name. The server creates them once;
-- clients wait for them. Add new names to NAMES, nowhere else.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local NAMES = {
	"ShowLine", -- server -> client: (speaker: string, text: string) subtitle line
	"NoiseMade", -- server -> clients: (position: Vector3, radius: number, loud: boolean)
	"LootChanged", -- server -> clients: (crewTotal: number, itemName: string, takenBy: string)
}

local FOLDER_NAME = "Remotes"

local folder: Instance
if RunService:IsServer() then
	local existing = ReplicatedStorage:FindFirstChild(FOLDER_NAME)
	if existing then
		folder = existing
	else
		local created = Instance.new("Folder")
		created.Name = FOLDER_NAME
		for _, name in NAMES do
			local event = Instance.new("RemoteEvent")
			event.Name = name
			event.Parent = created
		end
		created.Parent = ReplicatedStorage
		folder = created
	end
else
	folder = ReplicatedStorage:WaitForChild(FOLDER_NAME)
end

local Remotes = {}

function Remotes.get(name: string): RemoteEvent
	local event = folder:WaitForChild(name, 10)
	assert(event and event:IsA("RemoteEvent"), `Remotes: no RemoteEvent named "{name}"`)
	return event
end

return Remotes
