--############### Includes all files for server or client
Replicators = Replicators or {};

function Replicators.Load()
	MsgN("=======================================================");
	MsgN("=====                 REPLICATORS                 =====");
	MsgN("=======================================================");
	MsgN("PREPARING FILES:");
	local fn = "";
	if (SERVER) then
		-- make sure to add myself
		AddCSLuaFile("autorun/rep_autorun.lua");
		MsgN("./autorun/rep_autorun.lua");
		-- include all server files
		for _,fn in pairs(file.Find("stargate/replicators/server/*.lua","LUA")) do
			include("stargate/replicators/server/"..fn);
			MsgN("./server/"..fn);
		end
	elseif (CLIENT) then
		-- inlcude all client files
	end

	-- include shared for both server and client
	for _,fn in pairs(file.Find("stargate/replicators/shared/*.lua","LUA")) do
		include("stargate/replicators/shared/"..fn);
		if (SERVER) then
			AddCSLuaFile("stargate/replicators/shared/"..fn);
		end
		MsgN("./shared/"..fn);
	end
	MsgN("=======================================================");
end
Replicators.Load();
