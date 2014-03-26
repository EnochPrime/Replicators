/*
	Replicator NextBot Functions, Movement for GarrysMod
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
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

--################# MOVE TO TARGET #################--
--# Description: Move to target entity					#--
--#																#--
--# Arguments:													#--
--#   options: move to target options					#--
--##################################################--
function ENT:Rep_MoveToTarget(options)
	local options = options or {};

	local path = Path("Follow");
	path:SetMinLookAheadDistance(options.lookahead or 300);
	path:SetGoalTolerance(options.tolerance or 20);
	path:Compute(self, self:GetTarget():GetPos());

	if (!path:IsValid()) then return "failed" end

	self:StartActivity(ACT_RUN);

	-- keep updating path to target
	while (path:IsValid() and self:GetTarget():IsValid()) do
		if (path:GetAge() > 0.1) then
			path:Compute(self, self:GetTarget():GetPos());
		end
		path:Update(self);

		if (options.draw) then path:Draw(); end
		
		if (self.loco:IsStuck()) then
			self:HandleStuck();
			return "stuck";
		end

		coroutine.yield();
	end

	self:StartActivity(ACT_IDLE);
	return "ok";
end

--##################### WANDER #####################--
--# Description: Wanders to random location			#--
--#																#--
--# Arguments:													#--
--#     radius: maximum distance to wander			#--
--#   min_wait: minimum idle time						#--
--#   max_wait: maximum idle time						#--
--##################################################--
function ENT:Rep_Wander(radius, min_wait, max_wait)
	radius = radius or 1000;
	min_wait = min_wait or 0;
	max_wait = max_wait or 5;

	self:StartActivity(ACT_RUN);
	self.loco:SetDesiredSpeed(50);
	self:MoveToPos(self:GetPos() + Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0) * math.Rand(50, radius));
	self:StartActivity(ACT_IDLE);
	coroutine.wait(math.Rand(min_wait, max_wait));
end
