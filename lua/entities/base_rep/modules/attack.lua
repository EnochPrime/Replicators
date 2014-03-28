function ENT:AttackWho()
	local d = 10000; -- maximum distance to find
	local e = nil;
	local pos = self:GetPos();
	for _,v in pairs(Replicators.Enemies) do
		if (IsValid(v)) then
			local dist = (v:GetPos() - pos):Length();
			if (dist <= d) then
				e = v;
				d = dist;
			end
		end
	end
	return e;
end

-- make rep attack specific enemy
-- return true	ent to attack
-- return false	no ent to attack
function ENT:Rep_AI_Attack(e)
	e = e or self:AttackWho();
	if (e == nil or not IsValid(e)) then
		MsgN("Replicator:" .. self:EntIndex() .. " has no enemies.");
		return false;
	end

	self.attack = e;
	return self:Rep_AI_Follow(self.attack, true);
end

local Data = {
	"Choose what to attack.",
	"ents",
};

Replicators.RegisterVGUI("Attack",Data);
