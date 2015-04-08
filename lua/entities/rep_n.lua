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
	self:SetCollisionBounds(Vector(-8, -16, 0), Vector(16, 16, 8));		-- width, length, height
	self:SetSolid(SOLID_BBOX);
	self:SetHealth(25);

	self.leader = self:Find("rep_q");	-- default leader to nearest queen
end

-- RunBehavior @jdm12989
function ENT:RunBehaviour()
	while (IsValid(self)) do
--		MsgN("run behavior");	
		
		-- set default speed		
		self.loco:SetDesiredSpeed(65);

		-- determine target
		local maxWeight = 0;
		local tmpTarget;
		for _,v in pairs ents.FindByClass("prop_physics") do
			--if IsValid(v) and v:IsVisibleByRep then
				local dist = v:GetPosition() - self:GetPosition();
				w = math.Max(500 - dist, 0);
			--else
				--w = 0;
			--end
			
			-- adjust to highest priority
			if (w > maxWeight) then
				maxWeight = w;
				tmpTarget = v;
			end
		end
		-- step through enemies
			-- weight enemies based on aggressiveness and distance
			for _,v in pairs Replicators.Enemies do
				local cutoffDist = 500;
				local dist = v:GetPosition() - self:GetPosition();
				w = math.max(500-dist, 0);		-- weighting based only on distance
			end
		-- step all objects	
			-- weight resources by quantity and distance
			 
	
		
		-- if no queen exists
		if (table.Count(ents.FindByClass("rep_q")) <= 0) then		
			self:Rep_MakeQueen();
		end

		-- if resources available and not overloaded or missing queen, gather resources
		if (self:Rep_ResourcesAvailable() and (Replicators.Resources.Get(self, "metal") < Replicators.Resources.GetMax(self, "metal") or table.Count(ents.FindByClass("rep_q")) <= 0)) then
			-- if in range, eat resources, otherwise move closer
			if (self:GetRangeTo(self:GetTarget()) <= 45) then
				self:Rep_GatherResource();
			else
				local options = {
					tolerance = 45
				};				
				self:Rep_MoveToTarget(options);
			end

		-- if overloaded and queen available, return resources
		elseif (Replicators.Resources.Get(self, "metal") >= Replicators.Resources.GetMax(self, "metal") and table.Count(ents.FindByClass("rep_q")) > 0) then
			-- target nearest queen
			self:SetTarget(self:Find("rep_q"));

			-- if in range, transfer resources, otherwise move closer
			if (IsValid(self:GetTarget())) then
				if (self:GetRangeTo(self:GetTarget()) <= 60) then
					Replicators.Resources.Transfer(self, self:GetTarget(), "metal", Replicators.Resources.Get(self, "metal"));
					coroutine.wait(1);
				else
					local options = {
						tolerance = 60
					};
					self:Rep_MoveToTarget(options);
				end
			else
				self:Rep_Wander();
			end

		-- if no tasks, wander
		else
			self:Rep_Wander();
		end
	end
end

end
