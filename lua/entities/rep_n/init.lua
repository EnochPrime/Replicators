--################# HEADER #################
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

--################# SENT CODE #################

--################# Init @JDM12989
function ENT:Initialize()
	self.BaseClass.Initialize(self);
	self.leader = self:Find("rep_q");	-- default leader to nearest queen
	self:SetMaterial("JDM12989/replicators/block_tex");	-- work around for bad textures
end
