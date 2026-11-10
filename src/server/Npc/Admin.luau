--!strict
-- The Admin. Sleeps in his chair, makes snack runs to the kitchen fridge,
-- investigates noise, and hunts with the Ban Hammer once he's sure.
--
-- Priority (top wins):  hunt > notice a player > investigate noise > routine
-- Suspicion runs 0..1. Seeing a player fills it; each loud noise adds a chunk.

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local OpenableService = require(script.Parent.Parent.OpenableService)
local TimeoutService = require(script.Parent.Parent.TimeoutService)
local BT = require(script.Parent.BehaviourTree)
local Controller = require(script.Parent.NpcController)
local HouseMap = require(script.Parent.HouseMap)
local Rigs = require(script.Parent.Rigs)

type Npc = Controller.Npc

local PEPPY, GLITCHED = "ADMIN", "ADMIN (GLITCHED)"
local CALM, WARY, ANGRY = Color3.fromRGB(170, 60, 255), Color3.fromRGB(255, 210, 60), Color3.fromRGB(255, 40, 40)
local MONITORS = Vector3.new(-52, 235, -60) -- he faces these in his chair

local Admin = {}

local function findFridge(): Model?
	for _, m in CollectionService:GetTagged("Openable") do
		if m.Name == "Fridge" and m:IsA("Model") then
			return m
		end
	end
	return nil
end

function Admin.spawn(): Npc
	local model = Rigs.dummy({
		name = "TheAdmin",
		skin = Color3.fromRGB(235, 200, 175),
		shirt = Color3.fromRGB(45, 45, 55),
		pants = Color3.fromRGB(30, 30, 40),
		width = 1.9,
		height = 1.25,
		depth = 1.8,
		head = 1.25,
	})
	local npc = Controller.new(
		"TheAdmin",
		model,
		HouseMap.spawn.admin,
		{ AgentRadius = 3, AgentHeight = 7, AgentCanJump = false, AgentCanClimb = false },
		true
	)
	local head = model:FindFirstChild("Head") :: BasePart
	local hand = model:FindFirstChild("RightHand") :: BasePart
	local headset =
		Rigs.attach(head, "Headset", CFrame.new(0, 0.5, 0), Vector3.new(2.3, 0.5, 1.6), CALM, Enum.Material.Neon)
	Rigs.attach(
		hand,
		"BanHammerHandle",
		CFrame.new(0, -0.3, -1.6),
		Vector3.new(0.4, 0.4, 3.6),
		Color3.fromRGB(90, 60, 40),
		Enum.Material.Wood
	)
	Rigs.attach(
		hand,
		"BanHammerHead",
		CFrame.new(0, -0.3, -3.6),
		Vector3.new(1.6, 1.6, 2.4),
		Color3.fromRGB(190, 45, 40),
		Enum.Material.Metal
	)

	local bb = npc.bb
	bb.phase = "sleep"
	bb.phaseUntil = os.clock() + Config.ADMIN_SLEEP_SECONDS
	bb.suspicion = 0
	bb.alerted = false
	local fridge = findFridge()

	local function asleep(): boolean
		return bb.phase == "sleep" and not bb.alerted
	end
	local function setPhase(phase: string, seconds: number?)
		bb.phase = phase
		bb.step = 1
		bb.phaseUntil = os.clock() + (seconds or 0)
	end
	local function alert(seenAt: Vector3?)
		if bb.alerted then
			return
		end
		bb.alerted = true
		bb.suspicion = 1
		bb.lastSeen = seenAt or (bb.noise and bb.noise.position) or npc.root.Position
		bb.lastSeenTime = os.clock()
		Controller.say(npc, PEPPY, "Hello! Welcome! You are... you are... you are...")
		task.delay(1.6, function()
			Controller.say(npc, GLITCHED, "...BANNED.")
		end)
	end

	-- runs every tick before the tree: hearing, suspicion decay, mood
	local function perceive(_: Npc, dt: number)
		local now = os.clock()
		local heard = bb.newNoise
		bb.newNoise = nil
		if heard and not bb.alerted then
			if heard.loud then
				bb.suspicion += Config.ADMIN_LOUD_SUSPICION
			end
			if asleep() then
				if heard.loud and bb.suspicion >= 0.6 then
					setPhase("game", Config.ADMIN_GAME_SECONDS)
					bb.noise = heard
					Controller.say(npc, PEPPY, "Huh? Who pinged me? That's a rule violation! A friendly one!")
				elseif heard.loud then
					Controller.say(npc, PEPPY, "Mmm... you are now muted...")
				end
			else
				bb.noise = heard
			end
			if bb.suspicion >= 1 then
				alert(heard.position)
			end
		elseif heard and bb.alerted and heard.loud then
			bb.lastSeen = heard.position -- a loud noise gives the crew away mid-hunt
			bb.lastSeenTime = now
		end
		if bb.dinner then
			bb.dinner = false
			if not bb.alerted and bb.phase ~= "snack" then
				setPhase("snack")
				Controller.say(npc, PEPPY, "Coming, Mom! Great question! Five more minutes!", 120)
			end
		end
		if not bb.alerted and not bb.watching then
			bb.suspicion = math.max(0, bb.suspicion - 0.03 * dt)
		end
		bb.watching = false

		if bb.alerted then
			Controller.setMood(npc, "!", ANGRY)
			headset.Color = ANGRY
		elseif asleep() then
			Controller.setMood(npc, "Zzz", Color3.fromRGB(180, 200, 255))
			headset.Color = CALM
		elseif bb.suspicion > 0.3 then
			Controller.setMood(npc, "?", WARY)
			headset.Color = WARY
		else
			Controller.setMood(npc, "")
			headset.Color = CALM
		end
	end

	local function hunt(_: Npc): BT.Status
		local now = os.clock()
		local target, distance = Controller.nearestVisible(npc, 90, 220)
		if target then
			local root = (target.Character :: Model):FindFirstChild("HumanoidRootPart") :: BasePart
			bb.lastSeen = root.Position
			bb.lastSeenTime = now
			if distance <= Config.ADMIN_CATCH_DISTANCE and now >= (bb.swingReady or 0) then
				bb.swingReady = now + 1.5
				TimeoutService.ban(target)
				Controller.say(npc, GLITCHED, "Muted. Kicked. BANNED.")
			end
		end
		if now < (bb.swingReady or 0) - 0.7 then
			Controller.stop(npc) -- a beat to swing the hammer
		elseif bb.lastSeen then
			Controller.moveTo(npc, bb.lastSeen, Config.ADMIN_HUNT_SPEED, 3)
		end
		if now - (bb.lastSeenTime or now) > Config.ADMIN_GIVE_UP_SECONDS then
			bb.alerted = false
			bb.suspicion = 0.2
			bb.noise = nil
			setPhase("game", Config.ADMIN_GAME_SECONDS)
			Controller.say(npc, PEPPY, "Hmm. Must have been a bot. Back to moderating!")
		end
		return "running"
	end

	local function noticesPlayer(): boolean
		if asleep() then
			return false
		end
		local target, distance = Controller.nearestVisible(npc, 45, 110)
		bb.seen, bb.seenDistance = target, distance
		return target ~= nil
	end
	local function buildSuspicion(_: Npc, dt: number): BT.Status
		local root = ((bb.seen :: Player).Character :: Model):FindFirstChild("HumanoidRootPart") :: BasePart
		bb.watching = true
		Controller.stop(npc)
		Controller.face(npc, root.Position)
		local closeness = 1 - math.clamp(bb.seenDistance / 45, 0, 1)
		bb.suspicion += (0.35 + 1.4 * closeness) * dt
		local now = os.clock()
		if now >= (bb.helloReady or 0) then
			bb.helloReady = now + 8
			Controller.say(npc, PEPPY, "Hello? Is someone in my server room? That's a rule violation! A friendly one!")
		end
		if bb.suspicion >= 1 then
			alert(root.Position)
		end
		return "running"
	end

	local function hasNoise(): boolean
		return not asleep() and bb.noise ~= nil and os.clock() - bb.noise.time < 14
	end
	local function investigate(): BT.Status
		local now = os.clock()
		if Controller.moveTo(npc, bb.noise.position, Config.ADMIN_WALK_SPEED, 5) then
			bb.lookUntil = bb.lookUntil or now + 3
			if now >= bb.lookUntil then
				bb.noise, bb.lookUntil = nil, nil
				Controller.say(npc, PEPPY, "Nobody here. Probably lag.")
			end
		end
		return "running"
	end

	local function routine(): BT.Status
		local now = os.clock()
		bb.noise, bb.lookUntil = nil, nil
		if bb.phase == "snack" then
			if bb.step == 1 then
				if Controller.moveTo(npc, HouseMap.fridge, Config.ADMIN_WALK_SPEED, 4) then
					if fridge then
						Controller.face(npc, fridge:GetPivot().Position)
						OpenableService.setOpen(fridge, true, false, nil, model)
					end
					Controller.say(npc, PEPPY, "Snack o'clock! I love snacks. Snacks love me.")
					bb.step, bb.phaseUntil = 2, now + 4
				end
			elseif bb.step == 2 then
				if now >= bb.phaseUntil then
					if fridge then
						OpenableService.setOpen(fridge, false, false, nil, model)
					end
					bb.step = 3
				end
			elseif Controller.moveTo(npc, HouseMap.adminChair, Config.ADMIN_WALK_SPEED) then
				setPhase("game", Config.ADMIN_GAME_SECONDS)
			end
			return "running"
		end
		-- sleep or game: both happen at his chair, facing the monitors
		if Controller.moveTo(npc, HouseMap.adminChair, Config.ADMIN_WALK_SPEED) then
			Controller.face(npc, MONITORS)
			if now >= bb.phaseUntil then
				if bb.phase == "sleep" then
					setPhase("snack")
				else
					setPhase("sleep", Config.ADMIN_SLEEP_SECONDS)
					Controller.say(npc, PEPPY, "Mmm... thank you for being part of the community...", 40)
				end
			end
		end
		return "running"
	end

	Controller.run(
		npc,
		BT.selector({
			BT.always(perceive),
			BT.sequence({
				BT.condition(function()
					return bb.alerted
				end),
				BT.action(hunt),
			}),
			BT.sequence({ BT.condition(noticesPlayer), BT.action(buildSuspicion) }),
			BT.sequence({ BT.condition(hasNoise), BT.action(investigate) }),
			BT.action(routine),
		})
	)
	return npc
end

return Admin
