--############### Core Library ###############--

Replicators.HasCD = #file.FindInLua("autorun/server/sv_cds_core.lua") == 1;
Replicators.HasGC = #file.FindInLua("weapons/gmod_tool/stools/gcombat.lua") == 1;
Replicators.HasSG = #file.FindInLua("autorun/stargate.lua") == 1;

Replicators.Reps = {};
CreateConVar("replicator_limit","25",FCVAR_ARCHIVE);	-- rep limit
CreateConVar("replicator_limit_bunch",5,FCVAR_ARCHIVE);	-- bunching limit

Replicators.Enemies = {};
Replicators.Human_Number = 1;	-- humanform number

-- required blocks for types
Replicators.RequiredNumber = {};
Replicators.RequiredNumber["rep_n"] = 20;
Replicators.RequiredNumber["rep_q"] = 50;

-- ARG variables
Replicators.Immunities = {};
Replicators.FreqLog = {};
CreateConVar("replicator_arg_immunity_disable","0",FCVAR_ARCHIVE);
CreateConVar("replicator_arg_immunity_after","5",FCVAR_ARCHIVE);

-- model ignore lists
Replicators.IgnoreMe = {
	"models/zup/ramps/brick_01.mdl",
	"models/zup/ramps/brick_01_small.mdl",
	"models/zup/ramps/sgc_ramp.mdl",
	"models/zup/ramps/sgc_ramp_small.mdl",
	"models/zup/sg_rings/ring.mdl",
};

--################# Register Rep @JDM12989
function Replicators.Add(e)
	table.insert(Replicators.Reps,e);
end

--################# Remove Rep @JDM12989
function Replicators.Remove(e)
	for k,v in pairs(Replicators.Reps) do
		if (v == e) then
			table.remove(Replicators.Reps,k);
		end
	end
	if (table.Count(Replicators.Reps) == 0) then
		Replicators.Enemies = {};
		Replicators.Immunities = {};
		Replicators.FreqLog = {};
	end
end

--################# Add Attacker @JDM12989
function Replicators.AddEnemy(p)
	if (#Replicators.Enemies > 0 and not table.HasValue(Replicators.Enemies,p)) then
		table.insert(Replicators.Enemies,p);
	else
		table.ForceInsert(Replicators.Enemies,p);
	end
end

--################# Remove Attacker @JDM12989
function Replicators.RemoveEnemy(p)
	for k,v in pairs(Replicators.Enemies) do
		if (v == p) then
			table.remove(Replicators.Enemies,k);
		end
	end
end
hook.Add("PlayerDeath","RemoveFromEnemies",Replicators.RemoveEnemy);

--################# ARG Immunity handling @JDM12989
function Replicators.ARG(freq)
	-- returns true for disassembling
	if (GetConVarNumber("replicator_arg_immunity_disable") == 0) then
		local freq_count = (Replicators.FreqLog[freq] or 0) + 1;
		Replicators.FreqLog[freq] = freq_count;
		if (freq_count >= GetConVarNumber("replicator_arg_immunity_after")) then
			Replicators.Immunities[freq] = freq;
		else
			-- removes in case it has already become immune but "replicator_arg_immunity_after" has been increased
			if (table.HasValue(Replicators.Immunities,freq)) then
				talbe.Remove(Replicators.Immunuities,freq);
			end
		end
		-- no immunities?
		if (#Replicators.Immunities == 0) then return true end;
		-- is immune to freq?
		if (table.HasValue(Replicators.Immunities,freq)) then return false end;
	end
	return true;
end
