--[[
	Replicator Library, Resources for GarrysMod
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

-- Replicators Resources Table
Replicators.Resources = {};

-- valid classes for replicator resources
Replicators.Resources.ValidClasses = { "rep_n", "rep_q", "prop_physics" };

-- Resources.Initialize @jdm12989
-- Initializes replicator resources on entities (when spacebuild is not installed)
function Replicators.Resources.Initialize(ent)
	-- check for spacebuild
	-- return if found or initialze for prop_physics?

	-- initialze default system
	if (ent and ent:IsValid() and ent.rep_resource) then return true; end
	if (ent and ent:IsValid() and table.HasValue(Replicators.Resources.ValidClasses, ent:GetClass())) then
		ent.rep_resource = {};
		if (ent:GetClass() == "prop_physics" and ent:GetPhysicsObject() and ent:GetPhysicsObject():IsValid()) then
			ent.rep_resource.metal = ent:GetPhysicsObject():GetMass() * 10;
			ent.rep_resource.energy = 0;
		else
			ent.rep_resource.metal = ent.rep_defaultMetal or 0;
			ent.rep_resource.energy = ent.rep_defaultMetal or 100000;
		end
		return true;
	end

	return false;
end

-- Resources.Consume @jdm12989
function Replicators.Resources.Consume(ent, resType, value)
	-- if resource distribution is installed
	-- use that system

	-- default to replicator system
	if (ent and ent:IsValid() and Replicators.Resources.Initialize(ent)) then
		if (resType == "metal" and ent.rep_resource.metal >= value) then
			ent.rep_resource.metal = ent.rep_resource.metal - value;
		elseif (resType == "energy" and ent.rep_resource.energy >= value) then
			ent.rep_resource.energy = ent.rep_resource.energy - value;
		else
			-- not a valid resource type or insufficient resources
			return false;
		end
	end

	return false;
end

-- Resources.Get @jdm12989
function Replicators.Resources.Get(ent, resType)
	-- if resource distribution is installed
	-- use that system

	-- default to replicator system
	if (ent and ent:IsValid() and Replicators.Resources.Initialize(ent)) then
		if (resType == "metal") then
			return ent.rep_resource.metal;
		elseif (resType == "energy") then
			return ent.rep_resource.energy;
		else
			-- not a valid resource type
			return 0;
		end
	end

	return 0;
end

-- Resources.GetMax @jdm12989
function Replicators.Resources.GetMax(ent, resType)
	-- if resource distribution is installed
	-- use that system

	-- default to replicator system
	local repn_max_material = GetConVarNumber("replicator_max_material_carry");

	if (IsValid(ent) and Replicators.Resources.Initialize(ent)) then
		if (resType == "metal") then
			return ent.rep_resource.metal_max or repn_max_material;
		elseif (resType == "energy") then
			return ent.rep_resource.energy_max or 0;
		else
			-- not a valid resource type
			return 0;
		end
	end

	return 0;
end

-- Resources.Transfer @jdm12989
function Replicators.Resources.Transfer(source, target, resType, value)
	-- if resource distribution is installed
	-- use that system

	-- default to replicator system
	if (source and source:IsValid() and Replicators.Resources.Initialize(source)) then
		if (target and target:IsValid() and Replicators.Resources.Initialize(target)) then
			if (resType == "metal" and source.rep_resource.metal >= value) then
				source.rep_resource.metal = source.rep_resource.metal - value;
				target.rep_resource.metal = target.rep_resource.metal + value;
				return true;
			elseif (resType == "energy" and source.rep_resource.energy >= value) then
				source.rep_resource.energy = source.rep_resource.energy - value;
				target.rep_resource.energy = target.rep_resource.energy + value;
				return true;
			else
				-- not a valid resource type or insufficient resources
				return false;
			end
		end
	end

	return false;
end
