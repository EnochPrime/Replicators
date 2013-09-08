/*
	Replicator Control PC for GarrysMod10
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
--################### Head
SWEP.Category = "Stargate"
SWEP.PrintName = "Replicator Control PC";
SWEP.Author = "JDM12989";
SWEP.Contact = "";
SWEP.Purpose = "";
SWEP.Instructions = "";
SWEP.Base = "weapon_base";
SWEP.Slot = 3;
SWEP.SlotPos = 3;
SWEP.DrawAmmo	= false;
SWEP.DrawCrosshair = true;
SWEP.ViewModel = "models/weapons/v_superphyscannon.mdl";
SWEP.WorldModel = "models/weapons/w_physics.mdl";

-- primary.
SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = -1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo	= "none";

-- secondary
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none";

-- spawnables.
SWEP.Spawnable = true;
SWEP.AdminSpawnable = true;

--################### Dummys for the client @ aVoN
function SWEP:PrimaryAttack() return false end;
function SWEP:SecondaryAttack() return false end;

-- to cancel out default reload function
function SWEP:Reload() return end;