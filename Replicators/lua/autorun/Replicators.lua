--############### Includes all files for server or client
Replicators = Replicators or {};

function Replicators.Load()
	MsgN("=======================================================");
	local fn = "";
	if (SERVER) then
		-- include all server files
		for _,fn in pairs(file.FindInLua("replicators/server/*.lua")) do
			include("replicators/server/"..fn);
			MsgN("Including: "..fn);
		end
		-- add client files to download list
		for _,fn in pairs(file.FindInLua("replicators/vgui/*.lua")) do
			AddCSLuaFile("replicators/vgui/"..fn);
			MsgN("AddCSLua: "..fn);
		end
		-- make sure to add myself
		AddCSLuaFile("autorun/Replicators.lua");
	elseif (CLIENT) then
		-- inlcude all client files
		for _,fn in pairs(file.FindInLua("replicators/vgui/*.lua")) do
			include("replicators/vgui/"..fn);
			MsgN("Including: "..fn);
		end
	end
	
	-- include shared for both server and client
	for _,fn in pairs(file.FindInLua("replicators/shared/*.lua")) do
		include("replicators/shared/"..fn);
		if (SERVER) then
			AddCSLuaFile("replicators/shared/"..fn);
		end
		MsgN("Including: "..fn);
	end
	MsgN("Replicators Initialized");
	MsgN("=======================================================");
end
Replicators.Load();
