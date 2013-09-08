function ENT:Rep_AI_Replicate()
	if (table.Count(Replicators.Reps) >= GetConVarNumber("replicator_limit")) then return end;
	
	if (self.material_metal >= 1000) then
		--spawn new rep
		local pos = self:GetPos() + (self:GetForward() * 60);
		local rep = ents.Create("rep_n");
		rep:SetPos(pos);
		rep:Spawn();
		--rep:SetMaterial("materials/JDM12989/Replicators/Block_Gray.vmt");
		rep.leader = self;
		self.minions[rep.ENTINDEX] = rep;
		self.material_metal = self.material_metal - 1000;
	else
		self:Rep_AI_Gather(1000);
		if (not self.tasks) then
			self:Rep_AI_Wander();
		end
	end	
end

local Data = {};

--Replicators.RegisterVGUI("Replicate",Data);