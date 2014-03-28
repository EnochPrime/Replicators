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

ENT.Base = "base_nextbot"
ENT.PrintName = "Replicator Base Code"
ENT.Author = "JDM12989"

ENT.AutomaticFrameAdvance = true
ENT.ZatIgnore = true

MsgN("LOADING MODULES:");
for _,fn in pairs(file.Find("entities/base_rep/modules/*.lua","LUA")) do
	if (SERVER) then
		AddCSLuaFile("modules/"..fn);
	end
	include("modules/"..fn);
	MsgN("./modules/"..fn);
end
MsgN("INITIALIZATION COMPLETE");
MsgN("=======================================================");
