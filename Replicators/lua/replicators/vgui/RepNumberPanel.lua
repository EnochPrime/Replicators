/*
	RepNumberPanel for GarrysMod10
	Copyright (C) 2008-2009  JDM12989

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

function PANEL:Init()
	self.VGUI = {
		TE_Number = vgui.Create("DTextEntry",self);
		BT_Submit = vgui.Create("DButton",self);
	};
	
	self:SetSize(150,100);
	self:SetMinimumSize(150,100);
	self:SetPos(250,100);
	
	self.VGUI.TE_Number:SetPos(10,35);
	--limit characters to just numbers @aVoN
	self.VGUI.TE_Number.OnTextChanged =
		function(TextEntry)
			local text = TextEntry:GetValue();
			local pos = TextEntry:GetCaretPos();
			local len = text:len();
			local letters = text:upper():gsub("[^0-9]",""):TrimExplode(""); -- Upper, remove invalid chars and split!
			local text = ""; -- Wipe
			for _,v in pairs(letters) do
				text = text..v;
			end
			TextEntry:SetText(text);
			TextEntry:SetCaretPos(math.Clamp(pos - (len-#letters),0,text:len())); -- Reset the caretpos!
		end
		
	self.VGUI.BT_Submit:SetText("Submit");
	self.VGUI.BT_Submit:SetPos(20,175);
	self.VGUI.BT_Submit.DoClick =
		function()
			self:SetVisible(false);
			local text = self.VGUI.TE_Number:GetValue();
			self.MC:SetText(text);
		end
end

--############### Keeps buttons in the correct position when resizing @JDM12989
function PANEL:PerformLayout()
	local w,h = self:GetSize();
	self.VGUI.TE_Number:SetSize(w-20,self.VGUI.TE_Number:GetTall());
	self.VGUI.BT_Submit:SetPos((w/2)-30,h-35);
end

--############### Draws the panel @JDM12989
function PANEL:Paint()
	draw.RoundedBox(10,0,0,self:GetWide(),self:GetTall(),Color(16,16,16,255));
	draw.DrawText("Number Input","ScoreboardText",30,8,Color(255,255,255,255),0);
	return true;
end

--############### Thinking... @JDM12989
function PANEL:Think()
	if (not Window or not Window:IsVisible()) then return end;
end

vgui.Register("RepNumberPanel",PANEL,"Frame");