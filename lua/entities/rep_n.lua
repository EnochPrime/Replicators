--[[
	Replicator Spider for GarrysMod
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
AddCSLuaFile("rep_n.lua");
ENT.Base			= "base_rep";
ENT.PrintName	= "Replicator";
ENT.Author		= "JDM12989";

if (CLIENT) then
language.Add("rep_n","Replicator");
end

if (SERVER) then

-- Initialize @jdm12989
function ENT:Initialize()
	-- call base class init
	self.BaseClass.Initialize(self);

	self:SetModel("models/replicators/rep_n/rep_n.mdl");
	self:SetMaterial("replicators/block");
	self:SetCollisionBounds(Vector(-4, -4, 0), Vector(4, 4, 64));
	self:SetHealth(25);

	self.leader = self:Find("rep_q");	-- default leader to nearest queen
end

-- RunBehavior @jdm12989
function ENT:RunBehaviour()
	while (true) do
--		MsgN("run behavior");	
		
		-- set default speed		
		self.loco:SetDesiredSpeed(65);

		-- if no queen exists
		if (table.Count(ents.FindByClass("rep_q")) <= 0) then		
			self:Rep_MakeQueen();
		end

		--[[
		if resourceAvail and (not maxcap or noqueen) then gather
		elseif maxcap and queen then bring to queen
		else wander

		need to have target separate from resources or else queen will get eatten
		]]

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

end
