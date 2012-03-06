-- goes after and gathers materials until reached max_num
-- return true	prop to gather from
-- return false	no prop to gather from
function ENT:Rep_AI_Gather(max_num)
	max_num = max_num or self.material_max;
	
	local e = nil;
	if (self.material_metal + self.material_other < max_num) then
		e = self:Find("prop_physics");
	else
		e = self:Find("rep_q");
	end
	self:Rep_AI_Follow(e,true);
end

local Data = {
	"Set amount to gather.",
	"numbers",
};

Replicators.RegisterVGUI("Gather",Data);