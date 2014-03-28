--[[
	Replicator Module, Gather for GarrysMod
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

-- Rep_FindResources @jdm12989
-- Finds closest 'prop_physics' entity and sets as target
function ENT:Rep_FindResources()
	local target = self:Find("prop_physics");
	if (target and target:IsValid()) then
		self:SetTarget(target);
		return true;
	end
	
	self:SetTarget(nil);	
	return false;
end

-- Rep_GatherResource @jdm12989
-- Collects resources from target and performs animation
function ENT:Rep_GatherResource()
	-- setup entity maximum resources
	if (self:GetTarget() and self:GetTarget():IsValid()) then
		self:Rep_SetupResources(self:GetTarget(), { 10 * self:GetTarget():GetPhysicsObject():GetMass(), 0 });
	else
		coroutine.yield();
	end

	-- collect resources
	self:Rep_Transfer("metal", 10, self:GetTarget());	

	-- play eat animation and wait until completion
	self.loco:FaceTowards(self:GetTarget():GetPos());	
	--self:PlaySequenceAndWait("eat", 1);	
	coroutine.wait(1);	-- add pause since there is no animation yet

	-- remove entity if all resources consumed
	if (self:GetTarget() and self:GetTarget():IsValid() and self:Rep_GetResource(self:GetTarget(), "metal") <= 0) then
		self:GetTarget():Remove();
	end
end

-- Rep_ResourcesAvailable @jdm12989
-- Returns true when resources are nearby
function ENT:Rep_ResourcesAvailable()
	if (self:GetTarget() and self:GetTarget():IsValid()) then
	 	return true;
	end

	return self:Rep_FindResources();
end
