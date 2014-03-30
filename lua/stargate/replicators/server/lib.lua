--############### Core Library ###############--

Replicators.HasCD = #file.Find("autorun/server/sv_cds_core.lua","LUA") == 1;
Replicators.HasGC = #file.Find("weapons/gmod_tool/stools/gcombat.lua","LUA") == 1;
Replicators.HasSG = #file.Find("autorun/stargate.lua","LUA") == 1;

-- maximum number of replicators that can be present
CreateConVar("replicator_limit", "25", FCVAR_ARCHIVE);
-- number of replicators which can target entity
CreateConVar("replicator_limit_bunch", "5", FCVAR_ARCHIVE);
-- number of resources a replicator can carry
CreateConVar("replicator_max_material_carry", "1000", FCVAR_ARCHIVE);
-- number of resources to create replicators
CreateConVar("replicator_repn_required_material", "1000", FCVAR_ARCHIVE);
CreateConVar("replicator_repq_required_material", "1000", FCVAR_ARCHIVE);

Replicators.Enemies = {};
Replicators.Human_Number = 1;	-- humanform number

-- required blocks for types
Replicators.RequiredNumber = {};
Replicators.RequiredNumber["rep_n"] = 20;
Replicators.RequiredNumber["rep_q"] = 50;

-- ARG variables
Replicators.Immunities = {};
Replicators.FreqLog = {};
--CreateConVar("replicator_arg_immunity_disable", "0", FCVAR_ARCHIVE);
--CreateConVar("replicator_arg_immunity_after", "5", FCVAR_ARCHIVE);

-- model ignore lists
Replicators.IgnoreMe = {
	"models/zup/ramps/brick_01.mdl",
	"models/zup/ramps/brick_01_small.mdl",
	"models/zup/ramps/sgc_ramp.mdl",
	"models/zup/ramps/sgc_ramp_small.mdl",
	"models/zup/sg_rings/ring.mdl",
};

-- Remove @jdm12989
-- Decrements counters for replicator types
function Replicators.Remove(e)
	-- check if all replicators are dead
	if (table.Count(ents.FindByClass("rep_n")) == 0 and table.Count(ents.FindByClass("rep_q")) == 0) then
		Replicators.Enemies = {};
		Replicators.Immunities = {};
		Replicators.FreqLog = {};
	end
end

--################# Add Attacker @JDM12989
function Replicators.AddEnemy(p)
	if (#Replicators.Enemies <= 0) then
		table.ForceInsert(Replicators.Enemies, p);
		MsgN(p:GetClass() .. ":" .. p:EntIndex() .. " is now a Replicator enemy.");
	else
		if (!table.HasValue(Replicators.Enemies, p)) then
			table.insert(Replicators.Enemies, p);
			MsgN(p:GetClass() .. ":" .. p:EntIndex() .. " is now a Replicator enemy.");
		end
	end
end

--################# Remove Attacker @JDM12989
function Replicators.RemoveEnemy(p)
	for k,v in pairs(Replicators.Enemies) do
		if (v == p) then
			table.remove(Replicators.Enemies, k);
			MsgN(p:GetClass() .. ":" .. p:EntIndex() .. " is no longer a Replicator enemy.");
			break;
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
