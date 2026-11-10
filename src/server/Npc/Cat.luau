--!strict
-- The cat. Wanders the ground floor and basement and, every so often, knocks
-- something over. The crash is a loud noise that The Admin and Mom can hear.
-- The cat itself is harmless and walks straight through closed doors.
--
-- Priority (top wins):  knock something over > wander

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local NoiseService = require(script.Parent.Parent.NoiseService)
local BT = require(script.Parent.BehaviourTree)
local Controller = require(script.Parent.NpcController)
local HouseMap = require(script.Parent.HouseMap)
local Rigs = require(script.Parent.Rigs)

type Npc = Controller.Npc

local Cat = {}

-- Things built with the Knockable attribute (the living-room vase).
local function findKnockable(): BasePart?
	for _, part in CollectionService:GetTagged("Inspectable") do
		if part:IsA("BasePart") and part:GetAttribute("Knockable") == true and part.Anchored then
			return part
		end
	end
	return nil
end

function Cat.spawn(): Npc
	local model = Rigs.cat("Cat", Color3.fromRGB(235, 140, 50))
	local npc = Controller.new(
		"Cat",
		model,
		HouseMap.spawn.cat,
		{ AgentRadius = 1, AgentHeight = 2, AgentCanJump = false, AgentCanClimb = false },
		false
	)
	local bb = npc.bb
	bb.nextKnock = os.clock() + math.random(25, 40)

	local function knockTime(): boolean
		return os.clock() >= bb.nextKnock
	end
	local function knock(): BT.Status
		local now = os.clock()
		bb.knockStarted = bb.knockStarted or now
		local prop = findKnockable()
		local spot = if prop
			then Vector3.new(prop.Position.X, npc.root.Position.Y, prop.Position.Z)
			else npc.root.Position
		if Controller.moveTo(npc, spot, Config.CAT_WALK_SPEED, 5) or now - bb.knockStarted > 20 then
			if prop and (prop.Position - npc.root.Position).Magnitude < 12 then
				prop.Anchored = false
				prop:ApplyImpulse(Vector3.new(math.random(-3, 3), 4, math.random(-3, 3)) * prop.AssemblyMass)
			end
			Controller.say(npc, "CAT", "Meow! I'm happy to knock this over for you!", 60)
			NoiseService.emit(npc.root.Position, Config.CAT_NOISE_RADIUS, true, nil, model)
			bb.nextKnock = now + math.random(35, 60)
			bb.knockStarted = nil
		end
		return "running"
	end

	local function wander(): BT.Status
		local now = os.clock()
		if now < (bb.waitUntil or 0) then
			return "running"
		end
		bb.target = bb.target or HouseMap.catSpots[math.random(#HouseMap.catSpots)]
		bb.wanderStarted = bb.wanderStarted or now
		if Controller.moveTo(npc, bb.target, Config.CAT_WALK_SPEED) or now - bb.wanderStarted > 25 then
			bb.target, bb.wanderStarted = nil, nil
			bb.waitUntil = now + math.random(3, 8)
		end
		return "running"
	end

	Controller.run(
		npc,
		BT.selector({
			BT.sequence({ BT.condition(knockTime), BT.action(knock) }),
			BT.action(wander),
		})
	)
	return npc
end

return Cat
