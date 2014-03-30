--[[
	Replicator Queen for GarrysMod
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

-- Header
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

-- NPC Code

-- Initialize @jdm12989
function ENT:Initialize()
	-- call base class init
	self.BaseClass.Initialize(self);

	self:SetModel("models/AntLion.mdl");
	self:SetMaterial("replicators/block");
	self:SetHealth(100);

	--self.max_minions = 10;
	
	--[[ gain control of unallocated reps
	for k,v in pairs(Replicators.Reps) do
		if (v ~= self and v.leader == nil) then
			v.leader = self;
			self.minions[k] = v;
			v:SetCode("rep_test.txt");
		end
	end]]
end

-- RunBehavior @jdm12989
function ENT:RunBehaviour()
	while (true) do
		-- set default speed		
		self.loco:SetDesiredSpeed(65);

		-- replicate!
		self:Rep_Replicate();

		-- can't have loop end too quickly or game will freeze
		coroutine.wait(1);
	end
end
