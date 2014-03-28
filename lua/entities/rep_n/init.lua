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
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

-- NPC Code

-- Initialize @jdm12989
function ENT:Initialize()
	self.BaseClass.Initialize(self);
	self.leader = self:Find("rep_q");	-- default leader to nearest queen
	self:SetCollisionBounds(Vector(-4, -4, 0), Vector(4, 4, 64));
	self:SetHealth(25);
end
