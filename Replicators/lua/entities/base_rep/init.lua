/*
	Replicator Basecode for GarrysMod10
	Copyright (C) 2009  JDM12989

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
*/

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
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_STEP);
	self:SetSolid(SOLID_BBOX);
	self:SetHullType(self.Hull);
	self:SetHullSizeNormal();
	self:CapabilitiesAdd(CAP_MOVE_GROUND);
	self:SetMaxYawSpeed(5000);
	self:SetNWInt("Health",self.Max_Health);
	Replicators.Add(self);
	
	-- INTELLIGENCE
	self.ai = "replicators/"..self:GetClass()..".txt";
	self.code = {};
	self:SetCode(self.ai);
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

--############### On Take Damage @JDM12989
function ENT:OnTakeDamage(dmg)
	local att = dmg:GetAttacker();
	local dam = dmg:GetDamage();
	Replicators.AddEnemy(att);
	local health = self:GetNWInt("Health");
	self:SetNWInt("Health",math.Clamp(health-dam,0,self.Max_Health));
	if (self:GetNWInt("Health") == 0) then
		-- remove from lists
		Replicators.Remove(self);
		if (self.leader and ValidEntity(self.leader)) then
			table.remove(self.leader.minions,self.ENTINDEX);
		end
		self:Remove();
		--fall apart
		-- MAKE THEM WORK THE CORRECT WAY!!!
		local str = "models/JDM12989/Replicators/"..self:GetClass().."/Gibs/";
		for _,v in pairs(file.Find("../"..str.."*.mdl")) do
			local gib = ents.Create("block");
			gib:SetPos(self:GetPos());
			gib:SetAngles(self:GetAngles());
			gib:Spawn();
			gib:SetModel(str..v);
			gib:PhysicsInit(SOLID_VPHYSICS);
			gib:GetPhysicsObject():Wake();
		end
	end
end

--############### Allows the code to be changed @JDM12989
function ENT:SetCode(code)
	local t = {};
	local s = "";
	if (file.Exists(code)) then
		s = file.Read(code);
	elseif (file.Exists("../../../data/"..code)) then
		s = file.Read("../../../data/"..code);
	else
		return;
	end
	s = string.Replace(s,"self","ents.GetByIndex("..self.ENTINDEX..")");
	t = string.Explode(";",s);
	self.ai = code;
	self.code = t;
	
	self:SetSchedule(SCHED_NONE);
end

--################# Select Schedule @JDM12989
function ENT:SelectSchedule()
	self.tasks = false;
	local i = 1;
	while (not self.tasks and i < #self.code) do
		if (self.freeze) then return end;
		local s = self.code[i];
		RunString(s);
		i = i + 1;
	end
end