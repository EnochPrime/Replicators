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
	local repn_required_material = GetConVarNumber("replicator_repn_required_material");

	-- spawn new replicator
	if (table.Count(ents.FindByClass("rep_n")) < replicator_limit and
			Replicators.Resources.Get(self, "metal") >= repn_required_material) then

		-- play replicator create animation
		--self:PlaySequenceAndWait("create", 1);
		coroutine.wait(1);		-- wait because no animation exists

		--spawn new rep
		local pos = self:GetPos() + (self:GetForward() * 60) + (self:GetUp() * 10);
		local rep = ents.Create("rep_n");
		rep:SetPos(pos);
		rep:Spawn();
		rep.leader = self;
		self.minions[rep:EntIndex()] = rep;
		Replicators.Resources.Consume(self, "metal", repn_required_material);
	end	
end

-- Rep_MakeQueen @jdm12989
-- Upgrades from spider to queen
function ENT:Rep_MakeQueen()
	local repn_required_material = GetConVarNumber("replicator_repn_required_material");
	local repq_required_material = GetConVarNumber("replicator_repq_required_material");

	-- if not a minion then upgrade
	if (not IsValid(self.leader)) then
		-- form queen or gather more material & energy
		if (Replicators.Resources.Get(self, "metal") >= repq_required_material + repn_required_material) then
			-- consume resources
			Replicators.Resources.Consume(self, "metal", repq_required_material);			

			-- play upgrade animation
			--self:PlaySequenceAndWait("upgrade", 1);
			coroutine.wait(1);		-- wait because no animation exists

			-- create the queen
			local e = ents.Create("rep_q");
			e:SetPos(self:GetPos());
			e:SetAngles(self:GetAngles());
			e:Spawn();

			-- transfer resources to self
			Replicators.Resources.Transfer(self, e, "metal", Replicators.Resources.Get(self, "metal"));
			Replicators.Resources.Transfer(self, e, "energy", Replicators.Resources.Get(self, "energy"));

			-- remove old self
			self:Remove();
		end
	end
end
