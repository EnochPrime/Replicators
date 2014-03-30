--[[
	Replicator Spawn List for GarrysMod
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

-- AddNPCS @jdm12989
function Replicators.AddNPCS()
	local cat = "Stargate";
	local NPC;
	
	-- replicator spider
	NPC = { Name = "Replicator", Class = "rep_n", Category = cat };
	list.Set("NPC", NPC.Class, NPC);

	-- replicator queen
	NPC = { Name = "Replicator Queen", Class = "rep_q", Category = cat };
	list.Set("NPC", NPC.Class, NPC);

	-- human form replicator
	--NPC = {Name = "Human-Form Replicator",Class = "rep_h",Category = cat};
	--list.Set("NPC",NPC.Class,NPC);
end
Replicators.AddNPCS();
