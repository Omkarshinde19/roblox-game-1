--!strict
-- The Admin's Mom. Patrols the ground floor, calls him up for DINNER on a
-- timer, and if she spots a Scam she says so, loudly (which The Admin hears).
-- She never attacks. Not present on Easy.
--
-- Priority (top wins):  spots a player > dinner call > checks a noise > patrol

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local NoiseService = require(script.Parent.Parent.NoiseService)
local BT = require(script.Parent.BehaviourTree)
local Controller = require(script.Parent.NpcController)
local HouseMap = require(script.Parent.HouseMap)
local Rigs = require(script.Parent.Rigs)

type Npc = Controller.Npc

local HUMS = {
	"What a wonderful evening for doing laundry nobody asked me to do!",
	"I should knit him another GPU cosy.",
	"He was such a polite baby. He only banned me twice.",
}

local Mom = {}

function Mom.spawn(admin: Npc): Npc
	local model = Rigs.dummy({
		name = "Mom",
		skin = Color3.fromRGB(235, 200, 175),
		shirt = Color3.fromRGB(215, 120, 160),
		pants = Color3.fromRGB(120, 90, 130),
		width = 1,
		height = 1,
		depth = 1,
		head = 1,
	})
	local npc = Controller.new(
		"Mom",
		model,
		HouseMap.spawn.mom,
		{ AgentRadius = 2, AgentHeight = 5, AgentCanJump = false, AgentCanClimb = false },
		true
	)
	local hard = Config.DIFFICULTY == "Hard"
	local bb = npc.bb
	bb.patrolIndex = 1
	bb.nextDinner = os.clock() + Config.MOM_DINNER_SECONDS

	local function seesPlayer(): boolean
		local target = Controller.nearestVisible(npc, if hard then 55 else 40, 120)
		bb.seen = target
		return target ~= nil
	end
	local function raiseAlarm(): BT.Status
		local root = ((bb.seen :: Player).Character :: Model):FindFirstChild("HumanoidRootPart") :: BasePart
		Controller.stop(npc)
		Controller.face(npc, root.Position)
		Controller.setMood(npc, "!", Color3.fromRGB(255, 210, 60))
		local now = os.clock()
		if now >= (bb.alarmReady or 0) then
			bb.alarmReady = now + (if hard then 5 else 10)
			Controller.say(npc, "MOM", "Oh! Are you one of his internet friends? He doesn't have any of those.")
			NoiseService.emit(npc.root.Position, Config.LOUD_NOISE_RADIUS, true, nil, model)
		end
		return "running"
	end

	local function dinnerTime(): boolean
		return os.clock() >= bb.nextDinner
	end
	local function callDinner(): BT.Status
		Controller.setMood(npc, "")
		if Controller.moveTo(npc, HouseMap.momDinnerCall, Config.MOM_WALK_SPEED) then
			bb.nextDinner = os.clock() + Config.MOM_DINNER_SECONDS
			Controller.say(npc, "MOM", "Sweetie! DINNER!", 150)
			admin.bb.dinner = true
		end
		return "running"
	end

	local function hasNoise(): boolean
		if bb.newNoise then
			bb.noise, bb.newNoise = bb.newNoise, nil
		end
		return bb.noise ~= nil and os.clock() - bb.noise.time < 12
	end
	local function checkNoise(): BT.Status
		Controller.setMood(npc, "?", Color3.fromRGB(255, 210, 60))
		if Controller.moveTo(npc, bb.noise.position, Config.MOM_WALK_SPEED, 6) then
			bb.noise = nil
			Controller.say(npc, "MOM", "Kitty? Was that you? You little criminal.")
		end
		return "running"
	end

	local function patrol(): BT.Status
		local now = os.clock()
		bb.noise = nil
		Controller.setMood(npc, "")
		if now < (bb.waitUntil or 0) then
			return "running"
		end
		if Controller.moveTo(npc, HouseMap.momPatrol[bb.patrolIndex], Config.MOM_WALK_SPEED) then
			bb.patrolIndex = bb.patrolIndex % #HouseMap.momPatrol + 1
			bb.waitUntil = now + 5
			if math.random() < 0.35 then
				Controller.say(npc, "MOM", HUMS[math.random(#HUMS)], 45)
			end
		end
		return "running"
	end

	Controller.run(
		npc,
		BT.selector({
			BT.sequence({ BT.condition(seesPlayer), BT.action(raiseAlarm) }),
			BT.sequence({ BT.condition(dinnerTime), BT.action(callDinner) }),
			BT.sequence({ BT.condition(hasNoise), BT.action(checkNoise) }),
			BT.action(patrol),
		})
	)
	return npc
end

return Mom
