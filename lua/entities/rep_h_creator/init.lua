/*
	Human-Form Replicator Creator for GarrysMod10
	Copyright (C) 2008 JDM12989

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
--################# SENT CODE ###############

--################# Init @JDM12989
function ENT:Initialize()
	self.ENTINDEX = self:EntIndex();
	self:SetModel("models/Votekick/rep_create.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	
	self.enabled = false;
	self.percent = 0;
	self.dummy = nil;
	self.mdl = "models/gman.mdl";
	
	--self:CreateWireOutputs("Active","% Complete");
	
	local phys = self.Entity:GetPhysicsObject();
	if(phys:IsValid()) then
		phys:Wake();
		phys:SetMass(10);
	end
end

--################# Spawn the SENT @JDM12989
function ENT:SpawnFunction(p,t)
	if(not t.Hit) then return end;
	local e = ents.Create("rep_h_creator");
	e:SetPos(t.HitPos+Vector(0,0,50));
	e:Spawn();
	return e;
end

function ENT:OnRemove()
	timer.Destroy("rep_create_"..self.ENTINDEX);
end

--################# Adds the annoying overlay speechbubble to this SENT @JDM12989
function ENT:ShowOutput(v,force)
	local add = "(Off)";
	if(self.enabled) then add = "(On)" end;
	self:SetOverlayText("Rep Creator "..add.."\n"..v.."%");
end

--################# Use @JDM12989
function ENT:Use(p)
	if (self.enabled) then
		self:Abort();
		return;
	end
	
	self.mdl = "models/gman.mdl";
	--self:Start();
	
	umsg.Start("Show_RepHumanCtrl");
		umsg.Entity(self);
	umsg.End();
	
	p.Rep_Create = self;
	-- select model
	-- select code / features (eventually, like no replicating and such)
	-- then start the process
end

--################# Think @JDM12989
function ENT:Think()
	self:ShowOutput(self.percent);
	self.Entity:NextThink(CurTime()+0.25);
	return true;
end

--################# StartCreation @JDM12989
function ENT:Start()
	self.enabled = true;
	self:SpawnModel(self.mdl);
	timer.Create("rep_create_"..self.ENTINDEX,0.25,100,
		function()
			self.percent = self.percent + 1;
			--self:ConsumeResource("energy",10000);
			local r,g,b,a = self.dummy:GetColor();
			self.dummy:SetColor(r,g,b,self.percent*2.55);
			if (self.percent == 100) then
				self.dummy:Remove();
				local rep = ents.Create("rep_h");
				rep:ChangeModel(self.mdl);
				rep:SetPos(self:GetPos()+self:GetForward()*50+self:GetUp()*-25);
				rep:Spawn();
				self.percent = 0;
				self.enabled = false;
			end
		end
	);
end

local function Rep_Create_Start(p,com,args)
	local dev = p.Rep_Create;
	dev.mdl = args[1];
	dev:Start();
end
concommand.Add("Rep_Create_Start",Rep_Create_Start);

--################# Abort Creation @JDM12989
function ENT:Abort()
	timer.Destroy("rep_create_"..self.ENTINDEX);
	self.dummy:Remove();
	self.percent = 0;
	self.enabled = false;
end

--################# Spawns the model of rep being created @JDM12989
function ENT:SpawnModel(mdl)
	local dummy = ents.Create("prop_physics");
	dummy:SetModel(mdl);
	dummy:SetPos(self:GetPos()+self:GetRight()*-38+self:GetUp()*8);
	local ang = self:GetAngles(); ang.p = (ang.p-90) % 360; ang.r = 0; ang.y = (ang.y+90) % 360;
	dummy:SetAngles(ang);
	dummy:Spawn();
	dummy:SetParent(self);
	local r,g,b,a = dummy:GetColor();
	dummy:SetColor(r,g,b,0);
	self.dummy = dummy;
end
