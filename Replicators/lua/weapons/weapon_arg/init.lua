/*
	Anti-Replicator Gun for GarrysMod10
	Copyright (C) 2009

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

--############### HEADER ###############
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");
include("shared.lua");

--############### SWEP CODE ###############
SWEP.Sounds = {
	Shot={Sound("weapons/hd_shot1.mp3"),Sound("weapons/hd_shot2.mp3")},
	SwitchMode=Sound("buttons/button5.wav"),
};
SWEP.AttackMode = 1;
SWEP.MaxAmmo = 100;
SWEP.Delay = 5;
SWEP.TimeOut = 0.25; -- Time in seconds, a target will be tracked when hit with the beam

--################### Init the SWEP @ jdm12989
function SWEP:Initialize()
	self:SetWeaponHoldType("ar2");
end

--################### Initialize the shot @ jdm12989
function SWEP:PrimaryAttack(fast)
	local ammo = self.Weapon:Clip1();
	local delay = 0;
	if(ammo >= 20 and not fast) then
		self.Owner:EmitSound(self.Sounds.Shot[1],90,math.random(96,102));
		self:PushEffect();
		delay = 0.3;
		self.Weapon:SetNextPrimaryFire(CurTime()+0.8);
	else
		self.Weapon:SetNextPrimaryFire(CurTime()+0.5);
	end
	local e = self.Weapon;
	timer.Simple(delay,
		function()
			if(ValidEntity(e) and ValidEntity(e.Owner)) then
				e:DoShoot();
			end
		end
	);
	return true;
end

--################### Secondary Attack @ aVoN
function SWEP:SecondaryAttack()
	--Change our Mode
	local modes = 4; -- When you want to add more modes, jdm...
	self.AttackMode = math.Clamp((self.AttackMode+1) % (modes + 1),1,modes);
	self:EmitSound(self.Sounds.SwitchMode); -- Make some mode-change sounds
	self.Owner:SetAmmo(self.Secondary.Ammo,self.AttackMode);
	self.Weapon:SetNWBool("Mode",self.AttackMode); -- Tell client, what mode we are in
	self.Owner.__ARGMode = self.AttackMode; -- So modes are saved accross "session" (if he died it's the last mode he used it before)
end

--################### Reset Mode @ aVoN
function SWEP:OwnerChanged() 
	self.AttackMode = self.Owner.__ARGMode or 1;
	self.Weapon:SetNWBool("Mode",self.AttackMode);
end

--################### Do the shot @ jdm12989
function SWEP:DoShoot()
	local p = self.Owner;
	if(not ValidEntity(p)) then return end;
	local pos = p:GetShootPos();
	local normal = p:GetAimVector();
	local ammo = self.Weapon:Clip1();
	local disassemble = true;
	-- push attack
	if(ammo >= 20) then
		self:TakePrimaryAmmo(20);
		Replicators.AddEnemy(p);
		if (Replicators.ARG(self.AttackMode)) then
			for _,v in pairs(ents.FindInSphere(pos + (100*normal),75)) do
				if(v ~= self.Owner) then
					local c = v:GetClass();
					if (c == "rep_n" or c == "rep_q" or c == "rep_h") then
						v:Rep_AI_Disassemble(0.5);
					end
				end
			end
		end
	end
end

--################### Think @ jdm12989
function SWEP:Think()
	if(self.AttackMode == 2 and self.Owner:GetNWBool("shooting_hand",false) and not self.Owner:KeyDown(IN_ATTACK)) then
		self.Owner:SetNWBool("shooting_hand",false);
	end
	local time = CurTime();
	if((self.LastThink or 0) + 0.1 < time) then
		self.LastThink = time;
		--primary reserve
		local ammo = self.Owner:GetAmmoCount(self.Primary.Ammo);
		if(ammo > self.Delay) then
			self.Owner:RemoveAmmo(ammo-self.Delay,self.Primary.Ammo);
		end
		--primary ammo
		local ammo = self.Weapon:Clip1();
		local set = math.Clamp(ammo+1,0,self.MaxAmmo);
		self.Weapon:SetClip1(set);
	end
end

--################### Do a push @ jdm12989
function SWEP:PushEffect()
	local e = self.Owner;
	-- Timer fixes bug, where you cant see your own effect
	timer.Simple(0.1,
		function()
			if(e and e:IsValid()) then
				local fx = EffectData();
				fx:SetEntity(e);
				fx:SetOrigin(e:GetPos());
				util.Effect("hd_push",fx,true,true);
			end
		end
	);
end
