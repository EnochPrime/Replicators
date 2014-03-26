/*
	Replicator AI Function, Gather for GarrysMod
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

--##################### GATHER #####################--
--# Description: Goes after and gathers materials  #--
--#																#--
--# Arguments:													#--
--#   max_num: maximum number of resources to		#--
--#     gather before returning to queen				#--
--#																#--
--# Returns:													#--
--#   true: moving toward target							#--
--#   false: when no taget exists						#--
--##################################################--
function ENT:Rep_AI_Gather(max_num)
	local replicator_max_material = GetConVarNumber("replicator_max_material_carry");	
	max_num = max_num or replicator_max_material;
	
	local target = nil;
	-- are we carring the maximum resources?	
	if (self.material_metal + self.material_other >= max_num) then
		-- bring materials back to queen
		--MsgN("Replicator:" .. self:EntIndex() .. " looking for queen.");
		target = self:Find("rep_q");
	else
		-- find more resources
		--MsgN("Replicator:" .. self:EntIndex() .. " looking for resources.");
		target = self:Find("prop_physics");
	end

	return self:Rep_AI_GoToTarget(target, true);
end

function ENT:FindResources()
	local target = self:Find("prop_physics");
	if (target != nil and IsValid(target)) then
		self:SetTarget(target);
		return true;
	end
	
	self:SetTarget(nil);	
	return false;
end

function ENT:Rep_GatherResource()
	-- collect resources
	if (!self:GetTarget()._repResourceRemaining) then
		self:GetTarget()._repResourceRemaining = self:GetTarget():GetPhysicsObject():GetMass();
	else
		if (self:GetTarget()._repResourceRemaining > 0) then		
			self:GetTarget()._repResourceRemaining = self:GetTarget()._repResourceRemaining - 1;
			self.material_metal = self.material_metal + 10;
		end
	end

	-- play eat animation and wait until completion
	--self:PlaySequenceAndWait("eat", 1);	
	coroutine.wait(2);	-- add pause since there is no animation yet

	if (self:GetTarget().repResourceRemaining <= 0) then
		self:GetTarget():Remove();
	end
end

local Data = {
	"Set amount to gather.",
	"numbers",
};

Replicators.RegisterVGUI("Gather",Data);
