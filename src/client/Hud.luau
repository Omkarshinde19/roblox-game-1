--!strict
-- Heads-up display: subtitles for Scam lines, the crew loot counter, a noise
-- cue and the "hidden" badge. Built in code so there is nothing to sync by hand.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

local player = Players.LocalPlayer

local Hud = {}

local function label(parent: Instance, name: string, size: UDim2, position: UDim2, anchor: Vector2): TextLabel
	local l = Instance.new("TextLabel")
	l.Name = name
	l.Size = size
	l.Position = position
	l.AnchorPoint = anchor
	l.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
	l.BackgroundTransparency = 0.35
	l.TextColor3 = Color3.fromRGB(240, 240, 240)
	l.Font = Enum.Font.GothamMedium
	l.TextScaled = true
	l.TextWrapped = true
	l.Visible = false
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = l
	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0, 12)
	pad.PaddingRight = UDim.new(0, 12)
	pad.PaddingTop = UDim.new(0, 6)
	pad.PaddingBottom = UDim.new(0, 6)
	pad.Parent = l
	local limit = Instance.new("UITextSizeConstraint")
	limit.MaxTextSize = 24
	limit.Parent = l
	l.Parent = parent
	return l
end

function Hud.start()
	local gui = Instance.new("ScreenGui")
	gui.Name = "Hud"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local subtitle = label(gui, "Subtitle", UDim2.new(0.6, 0, 0, 64), UDim2.new(0.5, 0, 1, -150), Vector2.new(0.5, 1))
	local loot = label(gui, "Loot", UDim2.fromOffset(220, 40), UDim2.new(1, -16, 0, 16), Vector2.new(1, 0))
	local toast = label(gui, "LootToast", UDim2.fromOffset(320, 34), UDim2.new(1, -16, 0, 62), Vector2.new(1, 0))
	local noise = label(gui, "Noise", UDim2.fromOffset(260, 44), UDim2.new(0.5, 0, 0, 80), Vector2.new(0.5, 0))
	local hidden = label(gui, "Hidden", UDim2.fromOffset(300, 40), UDim2.new(0.5, 0, 1, -230), Vector2.new(0.5, 1))
	local tip = label(gui, "Tip", UDim2.fromOffset(330, 34), UDim2.new(0, 16, 1, -16), Vector2.new(0, 1))

	tip.Text = "Hold E: open quietly   ·   Tap E: yank it open (loud)"
	tip.TextColor3 = Color3.fromRGB(190, 195, 205)
	tip.Visible = true
	noise.BackgroundColor3 = Color3.fromRGB(150, 25, 25)
	noise.Font = Enum.Font.GothamBold
	hidden.Text = "HIDDEN  ·  jump to get out"
	hidden.TextColor3 = Color3.fromRGB(150, 255, 170)
	toast.TextColor3 = Color3.fromRGB(255, 215, 90)

	-- subtitles
	local lineId = 0
	Remotes.get("ShowLine").OnClientEvent:Connect(function(speaker: string, text: string)
		lineId += 1
		local id = lineId
		subtitle.Text = `{speaker}: {text}`
		subtitle.Visible = true
		task.delay(Config.LINE_SECONDS, function()
			if lineId == id then
				subtitle.Visible = false
			end
		end)
	end)

	-- crew loot
	local function showLoot()
		local total = workspace:GetAttribute("CrewLoot")
		loot.Text = `CREW LOOT   ${if typeof(total) == "number" then total else 0}`
		loot.Visible = true
	end
	workspace:GetAttributeChangedSignal("CrewLoot"):Connect(showLoot)
	showLoot()
	local toastId = 0
	Remotes.get("LootChanged").OnClientEvent:Connect(function(_total: number, itemName: string, takenBy: string)
		toastId += 1
		local id = toastId
		toast.Text = `{takenBy} took: {itemName}`
		toast.Visible = true
		task.delay(3, function()
			if toastId == id then
				toast.Visible = false
			end
		end)
	end)

	-- noise: a ring in the world for everyone, a warning if you're in earshot of a loud one
	local noiseId = 0
	Remotes.get("NoiseMade").OnClientEvent:Connect(function(position: Vector3, radius: number, loud: boolean)
		local ring = Instance.new("Part")
		ring.Shape = Enum.PartType.Ball
		ring.Anchored = true
		ring.CanCollide = false
		ring.CanQuery = false
		ring.CanTouch = false
		ring.CastShadow = false
		ring.Material = Enum.Material.ForceField
		ring.Color = if loud then Color3.fromRGB(255, 70, 70) else Color3.fromRGB(120, 200, 255)
		ring.Size = Vector3.one
		ring.Position = position
		ring.Parent = workspace
		local grow = TweenService:Create(
			ring,
			TweenInfo.new(if loud then 0.7 else 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				Size = Vector3.one * radius * (if loud then 0.6 else 2),
				Transparency = 1,
			}
		)
		grow.Completed:Connect(function()
			ring:Destroy()
		end)
		grow:Play()

		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if loud and root and root:IsA("BasePart") and (root.Position - position).Magnitude <= radius then
			noiseId += 1
			local id = noiseId
			noise.Text = "LOUD NOISE!"
			noise.Visible = true
			task.delay(1.4, function()
				if noiseId == id then
					noise.Visible = false
				end
			end)
		end
	end)

	-- hidden badge
	local function showHidden()
		hidden.Visible = player:GetAttribute("Hidden") == true
	end
	player:GetAttributeChangedSignal("Hidden"):Connect(showHidden)
	showHidden()
end

return Hud
