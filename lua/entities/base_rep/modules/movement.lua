--[[
	Replicator Module, Movement for GarrysMod
	Copyright (C) 2014

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http:--www.gnu.org/licenses/>.
]]

-- Rep_MoveToTarget @jdm12989
--	Move to target entity.
--	Options:
--		lookahead:
--		tolerance:
function ENT:Rep_MoveToTarget(options)
	local options = options or {};

	local path = Path("Follow");
	path:SetMinLookAheadDistance(options.lookahead or 300);
	path:SetGoalTolerance(options.tolerance or 40);
	path:Compute(self, self:GetTarget():GetPos());

	if (!path:IsValid()) then return "failed" end

	-- start run animation
	self:StartActivity(ACT_RUN);

	-- keep updating path to target
	while (path:IsValid() and self:GetTarget():IsValid()) do
		if (path:GetAge() > 0.1) then
			path:Compute(self, self:GetTarget():GetPos());
		end
		path:Update(self);

		-- draw the path
		if (options.draw) then path:Draw(); end
		
		-- handle stuck
		if (self.loco:IsStuck()) then
			self:HandleStuck();
			return "stuck";
		end

		coroutine.yield();
	end

	-- start idle animation
	self:StartActivity(ACT_IDLE);
	return "ok";
end

-- Rep_Wander @jdm12989
--	Wanders to random location and idles for a random amount of time.
--	Options:
--		maxDistance: farthest distance from current location
--		minWait: shortest amount of time to idle in seconds
--		maxWait: longest amount of time to wait in seconds
function ENT:Rep_Wander(options)
	local options = options or {};

	self:StartActivity(ACT_RUN);
	self.loco:SetDesiredSpeed(50);
	self:MoveToPos(self:GetPos() + Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0) * math.Rand(50, options.maxDistance or 1000));
	self:StartActivity(ACT_IDLE);
	coroutine.wait(math.Rand(options.minWait or 0, options.maxWait or 5));
end
