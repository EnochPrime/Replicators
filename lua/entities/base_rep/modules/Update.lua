-- passes on it's code to near by replicators
-- returns false
function ENT:Rep_AI_Update(radius)
	radius = radius or 1000;
	local ents = ents.FindInSphere(self:GetPos(),radius);
	for _,v in pairs(ents) do
		if (v:GetClass() == "rep_n" and v.ai ~= self.ai) then
			v:SetCode(self.ai);
		end
	end
	return false;
end

local Data = {
	"Set the radius of upload.",
	"numbers",
};

Replicators.RegisterVGUI("Update",Data);
