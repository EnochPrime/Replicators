/*
	Replicator Controller for GarrysMod10
	Copyright (C) 2008-2009

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

AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");
include("shared.lua");

SWEP.Sounds = {
	Valid = Sound("buttons/button3.wav"),
	Invalid = Sound("buttons/button2.wav"),
};
SWEP.Code = "";
SWEP.Delay = 1;
SWEP.Time = 0;

--################### Init the SWEP @JDM12989
function SWEP:Initialize()
	self:SetWeaponHoldType("melee");
end

--################### Initialize the shot @JDM12989
function SWEP:PrimaryAttack(fast)
	if (fast) then return end;
	if (CurTime() > self.Time) then
		local rep = self:GetRep();
		if (rep and rep:IsValid()) then
			self.Owner.rep = rep;
			print_r(rep);
			self:EmitSound(self.Sounds.Valid);
			umsg.Start("Rep_PreUpload");
			umsg.End();
			--rep:SetCode(self.Code);
		else
			self:EmitSound(self.Sounds.Invalid);
		end
		self.Time = CurTime() + self.Delay;
	end
	return true;
end

--################### Secondary Attack @ aVoN
function SWEP:SecondaryAttack()
	if (CurTime() > self.Time) then
		local rep = self:GetRep();
		if (rep and rep:IsValid()) then
			self:EmitSound(self.Sounds.Valid);
			self.Code = rep.ai;
		else
			self:EmitSound(self.Sounds.Invalid);
		end
		self.Time = CurTime() + self.Delay;
	end
end

--################### Opens up the main gui @JDM12989
function SWEP:Reload()
	local p = self.Owner;
	timer.Create("Rep_Window",0.3,1,
		function()
			umsg.Start("Show_RepCtrl",p);
			umsg.Entity(self);
			umsg.String(self.Code);
			umsg.End();
		end
	);	
	p.RepCtrl = self;
end

--################### Think @JDM12989
function SWEP:Think()
	if(self.AttackMode == 2 and self.Owner:GetNWBool("shooting_hand",false) and not self.Owner:KeyDown(IN_ATTACK)) then
		self.Owner:SetNWBool("shooting_hand",false);
	end
end

--################### Get Replicator @JDM12989
function SWEP:GetRep()
	local rep = nil;
	local p = self.Owner;
	if(not ValidEntity(p)) then return end;
	local pos = p:GetShootPos();
	local normal = p:GetAimVector();
	local t = util.QuickTrace(pos,normal*1000,{p});
	for _,v in pairs(ents.FindInSphere(t.HitPos,10)) do
		if (v ~= p) then
			local c = v:GetClass();
			if (c == "rep_n" or c == "rep_q" or c == "rep_h") then
				rep = v;
			end
		end
	end
	return rep;
end

--################### Update code to transmit @JDM12989
function RepUpdateCtrlCode(p,com,args)
	p.RepCtrl.Code = args[1];
end
concommand.Add("RepUpdateCtrlCode",RepUpdateCtrlCode)