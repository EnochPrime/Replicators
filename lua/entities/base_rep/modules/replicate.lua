/*
	Replicator NextBot Function, Replicate for GarrysMod
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

--################### REPLICATE ####################--
--# Description: Creates a new replicator				#--
--##################################################--
function ENT:Rep_Replicate()
	local replicator_limit = GetConVarNumber("replicator_limit");
	local replicator_repn_required_material = GetConVarNumber("replicator_repn_required_material");

	-- spawn new replicator (queen not available)
	if (table.Count(Replicators.Reps) < replicator_limit and
			self.material_metal >= replicator_repn_required_material) then

		--spawn new rep
		local pos = self:GetPos() + (self:GetForward() * 60);
		local rep = ents.Create("rep_n");
		rep:SetPos(pos);
		rep:Spawn();
		rep.leader = self;
		self.minions[rep:EntIndex()] = rep;
		self.material_metal = self.material_metal - replicator_repn_required_material;
	end	
end
