--################# HEADER #################
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

--################# SENT CODE #################

--################# Init @JDM12989
function ENT:Initialize()
	self.Male = file.Find("../models/Humans/Group01/Male_*.mdl");
	self.Female = file.Find("../models/Humans/Group01/Female_*.mdl");
	self.BaseClass.Initialize(self);
	if (self.Model == "temp.mdl") then
		self:SetModel(self:GetHumanModel());
	end
end

function ENT:ChangeModel(mdl)
	self:SetModel(mdl);
	self.Model = mdl;
end

function ENT:GetHumanModel()
	local model = "models/gman.mdl";
	if (Replicators.Human_Number == 1) then
		model = "models/gman.mdl";
	else
		if (Replicators.Human_Number % 2 == 0) then
			-- make girl
			model = "models/Humans/Group01/"..self.Female[math.random(1,#self.Female)];
		else
			-- make guy
			model = "models/Humans/Group01/"..self.Male[math.random(1,#self.Male)];
		end
	end
	Replicators.Human_Number = Replicators.Human_Number + 1;
	return model;
end
