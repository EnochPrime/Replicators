/*
	Replicator AI Function, Replicate for GarrysMod
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

function ENT:Rep_AI_Replicate()
	local replicator_limit = GetConVarNumber("replicator_limit");
	local replicator_max_material = GetConVarNumber("replicator_max_material");

	-- spawn new replicator (queen not available)
	if (table.Count(Replicators.Reps) >= GetConVarNumber("replicator_limit") and 
			self.material_metal >= 1000) then
		--spawn new rep
		local pos = self:GetPos() + (self:GetForward() * 60);
		local rep = ents.Create("rep_n");
		rep:SetPos(pos);
		rep:Spawn();
		--rep:SetMaterial("materials/JDM12989/replicators/Block_Gray.vmt");
		rep.leader = self;
		self.minions[rep.ENTINDEX] = rep;
		self.material_metal = self.material_metal - 1000;
	end	

	-- determine which schedule to run
	-- if there is nothing to gather, wander around
	if (not self:Rep_AI_Gather(1000)) then
		self:Rep_AI_Wander();
	end
end

local Data = {};

--Replicators.RegisterVGUI("Replicate",Data);
