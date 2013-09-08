/*
	Replicator Block for GarrysMod
	Copyright (C) 2013

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
*/

--################# HEADER #################
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

--################# SENT CODE #################
ENT.CDSIgnore = true;
function ENT:gcbt_breakactions() end; ENT.hasdamagecase = true;

--################# Init @JDM12989
function ENT:Initialize()
	self.ENTINDEX = self:EntIndex();
	self:SetModel("models/JDM12989/Replicators/Block.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetCollisionGroup(COLLISION_GROUP_WORLD);
	self:DrawShadow(false);
	
	self.dead = true;
	self.timer_running = true;
	
	-- timer before fading away
	timer.Create("block_delay_"..self.ENTINDEX,10,1,
		function()
			if (self and IsValid(self)) then
				self.dead = true;
				self:OnRemove();
			end
		end
	);
	
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:Wake();
		phys:SetMass(1);
	end
end

--################# When removing @JDM12989
function ENT:OnRemove()
	self:SetNWBool("fade_out",true);
	-- actually remove after a while
	timer.Simple(5,
		function()
			if (self and IsValid(self)) then
				self:Remove();
			end
		end
	);
end

--################# Think @JDM12989
function ENT:Think()
	if (self.dead) then
		if (not self.timer_running) then
			timer.Start("block_delay_"..self.ENTINDEX);
			self.timer_running = true;
		end
	else
		timer.Stop("block_delay_"..self.ENTINDEX);
		self.timer_running = false;
	end
end
