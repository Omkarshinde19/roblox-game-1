--!strict
-- "Inspectable" things (expired milk, trophies): look at one and your Scam
-- says a line about it.

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

local TAG = "Inspectable"

local InspectService = {}

-- Adds a prompt that is only usable while the part is reachable (its
-- container is open). Shared with LootService.
function InspectService.addPrompt(part: BasePart, action: string, hold: number): ProximityPrompt
	local prompt = Instance.new("ProximityPrompt")
	prompt.ObjectText = (part:GetAttribute("DisplayName") :: string?) or part.Name
	prompt.ActionText = action
	prompt.HoldDuration = hold
	prompt.MaxActivationDistance = Config.INTERACT_DISTANCE
	prompt.RequiresLineOfSight = false
	prompt.KeyboardKeyCode = Enum.KeyCode.F
	prompt.UIOffset = Vector2.new(0, -40)
	local function refresh()
		prompt.Enabled = part:GetAttribute("Reachable") ~= false
	end
	part:GetAttributeChangedSignal("Reachable"):Connect(refresh)
	refresh()
	prompt.Parent = part
	return prompt
end

function InspectService.canReach(player: Player, part: BasePart): boolean
	if part:GetAttribute("Reachable") == false then
		return false
	end
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	return root ~= nil
		and root:IsA("BasePart")
		and (root.Position - part.Position).Magnitude <= Config.INTERACT_DISTANCE + 6
end

local function setup(instance: Instance)
	if not instance:IsA("BasePart") or instance:FindFirstChildOfClass("ProximityPrompt") then
		return
	end
	local prompt = InspectService.addPrompt(instance, "Look", 0)
	prompt.Triggered:Connect(function(player: Player)
		local line = instance:GetAttribute("Line")
		if typeof(line) == "string" and InspectService.canReach(player, instance) then
			Remotes.get("ShowLine"):FireClient(player, "SCAM", line)
		end
	end)
end

function InspectService.start()
	for _, instance in CollectionService:GetTagged(TAG) do
		setup(instance)
	end
	CollectionService:GetInstanceAddedSignal(TAG):Connect(setup)
end

return InspectService
