include("shared.lua");
-- Inventory Icon 
--if(file.Exists("../materials/weapons/hand_inventory.vmt")) then
--	SWEP.WepSelectIcon = surface.GetTextureID("weapons/hand_inventory");
--end
-- Kill Icon
--if(file.Exists("../materials/weapons/hand_killicon.vmt")) then
--	killicon.Add("weapon_hand_device","weapons/hand_killicon",Color(255,255,255));
--end
language.Add("Battery_ammo","Naquadah");
language.Add("weapon_arg","Anti-Replicator Gun");

--################### Tell a player how to use this @aVoN
function SWEP:DrawHUD()
	local mode = "Frequency: #1";
	local int = self.Weapon:GetNWInt("Mode",1);
	if(int == 1) then
		mode = "Frequency: #1";
	elseif(int == 2) then
		mode = "Frequency: #2";
	elseif(int == 3) then
		mode = "Frequency: #3";
	elseif(int == 4) then
		mode = "Frequency: #4";
	end
	draw.WordBox(8,ScrW()-188,ScrH()-120,"Primary: "..mode,"Default",Color(0,0,0,80),Color(255,220,0,220));
end
