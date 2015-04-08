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
AddCSLuaFile("rep_hive.lua");
ENT.Base		= "base_anim";
ENT.PrintName	= "Replicator Hive Mind";
ENT.Author		= "JDM12989";

if (SERVER) then

-- Initialize @jdm12989
function ENT:Initialize()
	self.BaseClass.Initialize(self);
end

-- Think @jdm12989
function ENT:Think()	
	-- create key value pairing
	-- key = entid
	-- value = weighting
	
	-- step through all entities and assign a weight
	-- should have each rep report entities that have been discovered
	for _,v in pairs ents.FindByClass("prop_physics") do
		--if IsValid(v) and v:IsVisibleByAnyRep then
			local dist = v:GetPosition() - self:GetPosition();
			w = math.Max(500 - dist, 0);
		--else
			--w = 0;
		--end
	end
	
	-- step through all enemies and assign a weight
	for _,v in pairs Replicators.Enemies do
		local killThreshold = 5;		-- make these ConVars
		local distThreshold = 500;
		--if not IsValued(v) then
			-- remove v from array
		--end
		--if IsValid(v) and v:IsVisibleByAnyRep then
			-- weight = killcount / killThreshold;
			-- if nearby replicators are < X then multiple by -1 to represent fleeing
		--else
			w = 0;
		--end
	end
	
	-- sort array by weight
	-- prioritize closest reps to target (up to max bunch limit)
	-- continue until replicator count exhausted
	
end

end
