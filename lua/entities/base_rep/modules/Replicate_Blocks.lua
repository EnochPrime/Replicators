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

local Data = {};

--Replicators.RegisterVGUI("Replicate_Blocks",Data);