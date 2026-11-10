--!strict
-- A tiny behaviour-tree runtime. A node is a function (npc, dt) -> Status.
-- Trees are re-run from the root every tick, so higher branches always win
-- (a priority tree). Long-running actions keep their progress on npc.bb.

export type Status = "success" | "failure" | "running"
export type Node = (npc: any, dt: number) -> Status

local BT = {}

-- Runs children in order and stops at the first one that doesn't fail.
function BT.selector(children: { Node }): Node
	return function(npc, dt)
		for _, child in children do
			local status = child(npc, dt)
			if status ~= "failure" then
				return status
			end
		end
		return "failure"
	end
end

-- Runs children in order and stops at the first one that doesn't succeed.
function BT.sequence(children: { Node }): Node
	return function(npc, dt)
		for _, child in children do
			local status = child(npc, dt)
			if status ~= "success" then
				return status
			end
		end
		return "success"
	end
end

function BT.condition(test: (npc: any, dt: number) -> boolean): Node
	return function(npc, dt)
		return if test(npc, dt) then "success" else "failure"
	end
end

-- An action returns a Status, or nothing (which counts as "running").
function BT.action(run: (npc: any, dt: number) -> Status?): Node
	return function(npc, dt)
		return run(npc, dt) or "running"
	end
end

-- Runs a step for its side effects and always falls through to the next branch.
function BT.always(run: (npc: any, dt: number) -> ()): Node
	return function(npc, dt)
		run(npc, dt)
		return "failure"
	end
end

return BT
