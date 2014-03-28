--[[
	Replicator Basecode for GarrysMod
	Copyright (C) 2014

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

--############## HEADER ###############
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

--############### SENT CODE ###############
ENT.CDSIgnore = true;
function ENT:gcbt_breakactions() end; ENT.hasdamagecase = true;

--############### Init @JDM12989
function ENT:Initialize()
	self.ENTINDEX = self:EntIndex();
	self:SetModel(self.Model);
--	self:PhysicsInit(SOLID_VPHYSICS);
--	self:SetMoveType(MOVETYPE_STEP);
--	self:SetSolid(SOLID_BBOX);
--	self:SetNWInt("Health",self.Max_Health);
	Replicators.Add(self);
	
	-- INTELLIGENCE
	self.ai = self:GetClass()..".lua";
	self.code = {};
	--self:SetCode(self.ai);
	self.freeze = false;
	
	-- GROUPING
	self.leader = nil;
	self.minions = {};
	self.max_minions = 0;
	self.tasks = false;
	
	-- RESOURCES
	self.rep_energy = 100000;
	self.material_metal = 0;
	self.material_other = 0;
	self.material_max = 1000;
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake();
	end
end

-- OnInjured @jdm12989
function ENT:OnInjured(info)
	Replicators.AddEnemy(info:GetAttacker());
end

-- OnKilled @jdm12989
function ENT:OnKilled(info)
	Replicators.Remove(self);
	if (self.leader and self.leader:IsValid()) then
		table.remove(self.leader.minions, self:EntIndex());
	end
	self:Remove();
end

--############### Allows the code to be changed @JDM12989
function ENT:SetCode(code)
	local t = {};
	local s = "";
	if (file.Exists("stargate/replicators/code/"..code,"LUA")) then
		s = file.Read("stargate/replicators/code/"..code,"LUA");
	else
		return;
	end
	s = string.Replace(s,"self","ents.GetByIndex("..self.ENTINDEX..")");
	t = string.Explode(";",s);
	self.ai = code;
	self.code = t;
	
	self:SetSchedule(SCHED_NONE);
end

-- BehaveUpdate @JDM12989
function ENT:BehaveUpdate()
	if (!self.BehaveThread) then return end

	--	MsgN("update behavior?");
	--[[ update logic gains based on scenario?
		multiple or aggressive enemies weights toward attack or flee depending on number of replicators
		less replicators weights toward more resource gathering
		smarter logic on certain number thresholds
		I.e. low amount is gather and replicate
		then start fleeing from attackers and defending hive
		then actively seek out aggressive attackers
		build structures / weapons? 
	]]

	local ok, message = coroutine.resume(self.BehaveThread);
	if (ok == false) then
		self.BehaveThread = nil
		Msg(self, "error: ", message, "\n");
	end
end

--################# AI Main Loop @JDM12989
function ENT:RunBehaviour()
	while (true) do
--		MsgN("run behavior");	
		
		-- set default speed		
		self.loco:SetDesiredSpeed(65);

		-- replicate!
		self:Rep_Replicate();

		-- always get resources
		if (self:Rep_ResourcesAvailable()) then
			if (self:GetRangeTo(self:GetTarget()) <= 40) then
	 	 	 	self:Rep_GatherResource();
			else
				self:Rep_MoveToTarget();
			end
		-- if no tasks then wander
		else
			self:Rep_Wander();
		end
	end
end

-- HandleStuck @jdm12989
function ENT:HandleStuck()
	--MsgN("stuck!");
	self.loco:ClearStuck();
end
