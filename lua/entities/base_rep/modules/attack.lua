--[[
	Replicator Module, Attack for GarrysMod
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

-- Rep_EnemiesNearby @jdm12989
-- Returns true when enemies are nearby
function ENT:Rep_EnemiesNearby()
	if (self:GetTarget() and self:GetTarget():IsValid()) then
	 	return true;
	end

	return self:Rep_FindEnemy();
end

-- Rep_FindEnemy @jdm12989
-- Finds closest enemy and sets as target
-- Options:
--		radius: radial distance to find enemy
--		angle: controls width of cone
function ENT:Rep_FindEnemy(options)
	local options = options or {};

	-- find ents in forward looking cone
	-- distance = radius / tan(angle [deg] / 2)		for angle = 90 deg, distance = radius
	local tblEnts = ents.FindInCone(self:GetPos(), self:GetForward(), options.radius or 1000, options.angle or 90);
	
	-- find ents in sphere
	--local tblEnts = ents.FindInSphere(self:GetPos(), options.radius or 1000);

	-- search for enemy
	for k,v in pairs(tblEnts) do
		-- if entity is a player and visible			
		if (v:IsPlayer() and v:IsVisible()) then
			-- if player is on the hit list
			if (table.HasValue(Replicators.Enemies, v)) then
				-- set player as target
				self:SetTarget(v);
				return true;
			end
		end
	end
	
	self:SetTarget(nil);	
	return false;
end

-- Rep_Attack @jdm12989
-- Inflicts damage on enemy
-- Options:
--		damage: amount of damage to inflict
function ENT:Rep_Attack(options)
	local options = options or {};

	-- face enemy
	self.loco:FaceTowards(self:GetTarget():GetPos());	

	-- start melee animation
	self:StartActivity(ACT_MELEE_ATTACK1);
	coroutine.wait(1);	-- add pause since there is no animation yet
	self:GetTarget():TakeDamage(options.damage or 5, self);

	-- start idle animation
	self:StartActivity(ACT_IDLE);
end


