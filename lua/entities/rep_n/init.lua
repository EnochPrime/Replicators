--################# HEADER #################
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

--################# SENT CODE #################

--################# Init @JDM12989
function ENT:Initialize()
	self.BaseClass.Initialize(self);
	self.leader = self:Find("rep_q");	-- default leader to nearest queen
	self:SetMaterial("JDM12989/block_tex");	-- work around for bad textures
	self:SetMaterial("phoenix_storms/metalfloor_2-3");
	self:SetCollisionBounds(Vector(-4, -4, 0), Vector(4, 4, 64));
	self:SetHealth(25);
end
