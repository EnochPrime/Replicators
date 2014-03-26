ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Replicator Base Code"
ENT.Author = "JDM12989"

ENT.AutomaticFrameAdvance = true
ENT.ZatIgnore = true

MsgN("LOADING MODULES:");
for _,fn in pairs(file.Find("entities/base_rep/modules/*.lua","LUA")) do
	if (SERVER) then
		AddCSLuaFile("modules/"..fn);
	end
	include("modules/"..fn);
	MsgN("./modules/"..fn);
end
MsgN("INITIALIZATION COMPLETE");
MsgN("=======================================================");
