/*
	RepAttackableList for GarrysMod10
	Copyright (C) 2008  JDM12989

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

PANEL = {};
PANEL.MC = nil;

--############### Initialize @JDM12989
function PANEL:Init()
	self.VGUI = {
		BT_Submit = vgui.Create("DButton",self);
		PL_Attackable = vgui.Create("DPanelList",self);
		PL_Players = vgui.Create("DPanelList",self);
		PL_NPCs = vgui.Create("DPanelList",self);
	};
	
	self:SetSize(110,200);
	self:SetMinimumSize(110,200);
	self:SetPos(400,100);
	
	self.VGUI.BT_Submit:SetText("Submit");
	self.VGUI.BT_Submit:SetPos(20,175);
	self.VGUI.BT_Submit.DoClick =
		function()
			self:SetVisible(false);			
			players = self.VGUI.PL_Players:GetItems();
			npcs = self.VGUI.PL_NPCs:GetItems();
			text = "{";
			for k,v in pairs(players) do
				if (v:GetChecked()) then
					text = text..string.char(34)..v.text..string.char(34)..",";
				end
			end
			for k,v in pairs(npcs) do
				if (v:GetChecked()) then
					text = text..string.char(34)..v.text..string.char(34)..",";
				end
			end
			text = text.."}";
			self.MC:SetText(text);
		end
		
	self.VGUI.PL_Attackable:SetPos(10,35);
	self.VGUI.PL_Attackable:SetSize(self:GetWide()-20,self:GetTall()-75);
	self.VGUI.PL_Attackable:SetSpacing(5);
	self.VGUI.PL_Attackable:EnableHorizontal(false);
	self.VGUI.PL_Attackable:EnableVerticalScrollbar(true);
	
	self.VGUI.PL_Players:SetAutoSize(true);
	self.VGUI.PL_NPCs:SetAutoSize(true);
end

--############### Keeps buttons in the correct position when resizing @JDM12989
function PANEL:PerformLayout()
	local w,h = self:GetSize();
	self.VGUI.PL_Attackable:SetSize(w-20,h-75);
	self.VGUI.BT_Submit:SetPos((w/2)-30,h-35);
end

--############### Draws the panel @JDM12989
function PANEL:Paint()
	draw.RoundedBox(10,0,0,self:GetWide(),self:GetTall(),Color(16,16,16,255));
	draw.DrawText("Attackable","ScoreboardText",30,8,Color(255,255,255,255),0);
	return true;
end

--############### Thinking @JDM12989
function PANEL:Think()
	if (not Window or not Window:IsVisible()) then return end;
end

--############### Setting up list @JDM12989
function PANEL:SetUpList()
	self.VGUI.PL_Attackable:Clear();
	self.VGUI.PL_Players:Clear();
	self.VGUI.PL_NPCs:Clear();
	local ents = ents.GetAll();
	-- cc with players
	local DCC_Players = vgui.Create("DCollapsibleCategory",self);
	DCC_Players:SetExpanded(0);
	DCC_Players:SetLabel("Players");
	DCC_Players:SetContents(self.VGUI.PL_Players);
	-- cc with npc classes
	local DCC_NPC = vgui.Create("DCollapsibleCategory",self);
	DCC_NPC:SetExpanded(0);
	DCC_NPC:SetLabel("NPCs");
	DCC_NPC:SetContents(self.VGUI.PL_NPCs);
	DCC_NPC.Classes = {};
	-- organize
	for _,v in pairs(ents) do
		if (ValidEntity(v)) then
			if (v:IsPlayer()) then
				DCB = vgui.Create("DCheckBoxLabel",self);
				DCB:SetText(v:GetName());
				DCB.text = v:GetName();
				self.VGUI.PL_Players:AddItem(DCB);
			elseif (v:IsNPC()) then
				local class = v:GetClass();
				if (not table.HasValue(DCC_NPC.Classes,class)) then
					table.insert(DCC_NPC.Classes,class);
					DCB = vgui.Create("DCheckBoxLabel",self);
					DCB:SetText(class);
					DCB.text = class;
					self.VGUI.PL_NPCs:AddItem(DCB);
				end
			end
		end
	end
	self.VGUI.PL_Attackable:AddItem(DCC_Players);
	self.VGUI.PL_Attackable:AddItem(DCC_NPC);
end

vgui.Register("RepAttackableList",PANEL,"Frame");