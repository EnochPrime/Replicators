--[[
	Replicator Module, Resources for GarrysMod
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
	along with this program.  If not, see <http:--www.gnu.org/licenses/>.
]]

-- Rep_SetupResources @jdm12989
-- initializes replicator resources (when spacebuild is not installed)
function ENT:Rep_SetupResources(target, default)
	-- check for spacebuild
	-- return if found or initialze for prop_physics?

	-- initialze default system	
	if (target and target:IsValid()) then
		-- if resource table is nil, create
		if (!target.rep_resources) then
			target.rep_resources = {};
			target.rep_resources.metal = default[1];
			target.rep_resources.energy = default[2];
		end
	end
end

function ENT:Rep_GetResource(target, resType)
	-- check for spacebuild
	-- return spacebuild resource

	-- return default system resource
	if (resType == "metal") then return target.rep_resources.metal;
	elseif (resType == "energy") then return target.rep_resources.energy;
	else return -1;
	end
end

function ENT:Rep_SetResource(target, resType, value)
	-- check for spacebuild
	-- set spacebuild resource

	-- set default system resource
	if (resType == "metal") then target.rep_resources.metal = value;
	elseif (resType == "energy") then target.rep_resources.energy = value;
	else return;
	end
end

-- Rep_Transfer @jdm12989
-- transfers resources from target to replicator
function ENT:Rep_Transfer(resType, value, target)
	-- check for spacebuild
	-- transfer resources

	-- transfer with default system	
	if (target and target:IsValid() and self:Rep_GetResource(target, resType) >= value) then
		self:Rep_SetResource(target, resType, self:Rep_GetResource(target, resType) - value);
		self:Rep_SetResource(self, resType, value);
	end
end
