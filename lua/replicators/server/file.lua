--############### Creates the player's dir on server @JDM12989
function Replicators.InitDirectory(p)
	if (SinglePlayer()) then return end;
	if (p and p:IsValid() and p:IsPlayer()) then
		if (#file.FindDir("replicators/"..p:GetName()) == 0) then
			file.CreateDir("replicators/"..p:GetName());
		end
	end
end
concommand.Add("RepInitUserDir",Replicators.InitDirectory);

--############### Saves file to server @JDM12989
function Replicators.SaveFile(p,com,args)
	if (not args[3] or args[3] == "") then return end;		-- arg1: Dir  |  arg2: Fn  |  arg3: Text
	file.Write(args[1]..p:GetName().."/"..args[2],args[3]);
	print_r(p.rep);
	print_r(args[2]);
	p.rep:SetCode(args[2]);
end
concommand.Add("RepSaveFile",Replicators.SaveFile);
