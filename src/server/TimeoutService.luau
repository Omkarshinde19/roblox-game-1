--!strict
-- The Ban Hammer. A caught Scam is frozen where they fell with a BANNED sign
-- (Player attribute InTimeout = true) until a teammate holds "Appeal" on
-- them. If every Scam is banned at once, the run fails and everyone respawns.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

local TimeoutService = {}

local failing = false

local function release(player: Player)
	player:SetAttribute("InTimeout", false)
	local character = player.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 16
		humanoid.JumpHeight = 7.2
	end
	local root = character:FindFirstChild("HumanoidRootPart")
	if root then
		for _, name in { "BannedSign", "AppealPrompt" } do
			local old = root:FindFirstChild(name)
			if old then
				old:Destroy()
			end
		end
	end
end

local function everyoneBanned(): boolean
	local players = Players:GetPlayers()
	for _, player in players do
		if player:GetAttribute("InTimeout") ~= true then
			return false
		end
	end
	return #players > 0
end

local function fail()
	if failing then
		return
	end
	failing = true
	Remotes.get("ShowLine")
		:FireAllClients("DIZCORD", "You have been BANNED. The whole crew is in #timeout. Run failed.")
	task.delay(5, function()
		for _, player in Players:GetPlayers() do
			release(player)
			player:LoadCharacter()
		end
		failing = false
	end)
end

function TimeoutService.isBanned(player: Player): boolean
	return player:GetAttribute("InTimeout") == true
end

function TimeoutService.ban(player: Player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if TimeoutService.isBanned(player) or not humanoid or not root or not root:IsA("BasePart") then
		return
	end
	player:SetAttribute("InTimeout", true)
	player:SetAttribute("Hidden", false)
	humanoid.Sit = false
	humanoid.WalkSpeed = 0
	humanoid.JumpHeight = 0

	local sign = Instance.new("BillboardGui")
	sign.Name = "BannedSign"
	sign.Size = UDim2.fromScale(6, 1.6)
	sign.StudsOffsetWorldSpace = Vector3.new(0, 4.5, 0)
	sign.MaxDistance = 120
	local text = Instance.new("TextLabel")
	text.Size = UDim2.fromScale(1, 1)
	text.BackgroundColor3 = Color3.fromRGB(150, 25, 25)
	text.TextColor3 = Color3.new(1, 1, 1)
	text.Font = Enum.Font.GothamBold
	text.TextScaled = true
	text.Text = "BANNED"
	text.Parent = sign
	sign.Parent = root

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "AppealPrompt"
	prompt.ObjectText = player.DisplayName
	prompt.ActionText = "Appeal"
	prompt.HoldDuration = Config.APPEAL_SECONDS
	prompt.MaxActivationDistance = Config.INTERACT_DISTANCE
	prompt.RequiresLineOfSight = false
	prompt.Parent = root
	prompt.Triggered:Connect(function(helper: Player)
		if helper ~= player and not TimeoutService.isBanned(helper) then
			release(player)
			Remotes.get("ShowLine"):FireClient(player, "SCAM", "Appeal accepted! I'm back. I've learned nothing.")
		end
	end)

	Remotes.get("ShowLine"):FireClient(player, "SCAM", "I've been banned! I'd love to appeal!")
	if everyoneBanned() then
		fail()
	end
end

function TimeoutService.start()
	Players.PlayerAdded:Connect(function(player: Player)
		player:SetAttribute("InTimeout", false)
		player.CharacterAdded:Connect(function()
			player:SetAttribute("InTimeout", false)
		end)
	end)
	Players.PlayerRemoving:Connect(function()
		task.defer(function()
			if everyoneBanned() then
				fail()
			end
		end)
	end)
end

return TimeoutService
