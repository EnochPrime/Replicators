ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Replicator Base Code"
ENT.Author = "JDM12989"

ENT.AutomaticFrameAdvance = true
ENT.ZatIgnore = true

MsgN("=======================================================");
MsgN("Replicator Base Code Initializing...");
for _,file in pairs(file.FindInLua("entities/base_rep/modules/*.lua")) do
	MsgN("Initializing: "..file);
	include("modules/"..file);
end
MsgN("Replicator Base Code Initialized Successfully");
MsgN("=======================================================");