--[[
	Replicator Module, Replicate for GarrysMod
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

-- Rep_Replicate @jdm12989
--	Creates a new replicator
function ENT:Rep_Replicate()
	local replicator_limit = GetConVarNumber("replicator_limit");
	local replicator_repn_required_material = GetConVarNumber("replicator_repn_required_material");

	-- spawn new replicator (queen not available)
	if (table.Count(Replicators.Reps) < replicator_limit and
			self:Rep_GetResource(self, "metal") >= replicator_repn_required_material) then

		--spawn new rep
		local pos = self:GetPos() + (self:GetForward() * 60);
		local rep = ents.Create("rep_n");
		rep:SetPos(pos);
		rep:Spawn();
		rep.leader = self;
		self.minions[rep:EntIndex()] = rep;
		self:Rep_SetResource(self, "metal", self:Rep_GetResource("metal") - replicator_repn_required_material);
	end	
end

function ENT:Rep_AI_Make_Queen()
	if (not self.leader or not ValidEntity(self.leader)) then
		-- form queen or gather more material & energy
		if (self.material_metal >= 3000) then
			self.material_metal = self.material_metal - 1000;
			Replicators.Remove(self);
			self:Remove();
			local e = ents.Create("rep_q");
			e:SetPos(self:GetPos());
			e:SetAngles(self:GetAngles());
			e:Spawn();
			e.material_metal = self.material_metal;
		else
			self:Rep_AI_Gather(3000);
			if (not self.tasks) then
				self:Rep_AI_Wander();
			end
		end	
		self.tasks = true;
	else
		self.tasks = false;
	end
end

function ENT:Rep_AI_Replicate_Blocks()
	if (table.Count(Replicators.Reps) >= GetConVarNumber("replicator_limit")) then return end;
	
	-- create blocks
	local pos = self:GetPos() + (self:GetForward() * 60);
	if (self.materials >= 20) then
		--spawns blocks
		local block = ents.Create("block");
		block:SetPos(pos);
		block:Spawn();
		block.dead = false;
		self.materials = self.materials - 20;
	end

	-- form rep from blocks
	local blocks_near = {};
	local ents = ents.FindInSphere(pos,60);
	for _,v in pairs(ents) do
		if (v:GetClass() == "block") then
			table.insert(blocks_near,v);
		end
	end
	if (#blocks_near >= Replicators.RequiredNumber["rep_n"]) then
		-- remove blocks
		for _,v in pairs(blocks_near) do
			v:Remove();
		end
		-- spawn rep
		local rep = ents.Create("rep_n");
		rep:SetPos(pos);
		rep:Spawn();
	end
end
