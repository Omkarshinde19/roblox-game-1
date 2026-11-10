--!strict
-- "HidingSpot" models (wardrobes, the shower): open one, hide inside, and the
-- door shuts behind you. Jump to get out. While you're inside with the door
-- shut, your Player has the attribute Hidden = true (NPCs will check it).

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local OpenableService = require(script.Parent.OpenableService)

local TAG = "HidingSpot"

local HidingService = {}

local function setup(instance: Instance)
	if not instance:IsA("Model") then
		return
	end
	local seat = instance:FindFirstChild("HideSeat")
	if not seat or not seat:IsA("Seat") or seat:FindFirstChildOfClass("ProximityPrompt") then
		return
	end

	local prompt = Instance.new("ProximityPrompt")
	prompt.ObjectText = (instance:GetAttribute("DisplayName") :: string?) or "Hiding spot"
	prompt.ActionText = "Hide"
	prompt.HoldDuration = 0.3
	prompt.MaxActivationDistance = Config.INTERACT_DISTANCE
	prompt.RequiresLineOfSight = false
	prompt.KeyboardKeyCode = Enum.KeyCode.F
	prompt.UIOffset = Vector2.new(0, -40)
	prompt.Parent = seat

	local hider: Player? = nil
	local function refresh()
		local open = instance:GetAttribute("Open") == true
		prompt.Enabled = open and seat.Occupant == nil
		if hider then
			hider:SetAttribute("Hidden", not open)
		end
	end
	instance:GetAttributeChangedSignal("Open"):Connect(refresh)

	prompt.Triggered:Connect(function(player: Player)
		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health > 0 and seat.Occupant == nil and instance:GetAttribute("Open") == true then
			seat:Sit(humanoid)
		end
	end)

	seat:GetPropertyChangedSignal("Occupant"):Connect(function()
		local occupant = seat.Occupant
		if occupant then
			hider = Players:GetPlayerFromCharacter(occupant.Parent)
			OpenableService.setOpen(instance, false, false, hider)
		else
			local left = hider
			hider = nil
			if left then
				left:SetAttribute("Hidden", false)
				OpenableService.setOpen(instance, true, false, left)
				-- step out in front of the hiding spot
				local character = left.Character
				if character then
					task.defer(function()
						character:PivotTo(seat.CFrame * CFrame.new(0, 3, -5.5))
					end)
				end
			end
		end
		refresh()
	end)
	refresh()
end

function HidingService.start()
	Players.PlayerAdded:Connect(function(player: Player)
		player:SetAttribute("Hidden", false)
	end)
	for _, instance in CollectionService:GetTagged(TAG) do
		setup(instance)
	end
	CollectionService:GetInstanceAddedSignal(TAG):Connect(setup)
end

return HidingService
