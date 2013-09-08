/*
	RepMessage for GarrysMod10
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

function PANEL:Init()
	self.VGUI = {
		I_Icon = vgui.Create("DImage",self);
		BT_Custom1 = vgui.Create("DButton",self);
		BT_Custom2 = vgui.Create("DButton",self);
	};
	
	self:SetSize(300,100);
	self:SetPos(250,100);
	self.MC = nil;
	self.text = "";
	self.type = ""
	self.twobtn = false;
		
	self.VGUI.BT_Custom1:SetText("___");
	self.VGUI.BT_Custom1.DoClick =
		function()
			local parent = self:GetParent();
			if(self.VGUI.BT_Custom1.Type == "Save") then
				parent:Save(self.VGUI.BT_Custom1.Fn);
			end
			self:SetVisible(false);
		end
		
	self.VGUI.BT_Custom2:SetText("___");
	self.VGUI.BT_Custom2.DoClick =
		function()
			self:SetVisible(false);
		end
end

--############### Keeps buttons in the correct position when resizing @JDM12989
function PANEL:PerformLayout()
	local w,h = self:GetSize();
	if(self.twobtn) then
		self.VGUI.BT_Custom1:SetPos(w/4,h-35);
		self.VGUI.BT_Custom2:SetPos((3*w/4)-60,h-35);
	else
		self.VGUI.BT_Custom1:SetPos(w,h);
		self.VGUI.BT_Custom2:SetPos((w/2)-30,h-35);
	end
end

--############### Draws the panel @JDM12989
function PANEL:Paint()
	draw.RoundedBox(10,0,0,self:GetWide(),self:GetTall(),Color(16,16,16,255));
	draw.DrawText(self.type,"ScoreboardText",30,8,Color(255,255,255,255),0);	
	draw.DrawText(self.text,"ConsoleText",30,35,Color(255,255,255,255),0);
	return true;
end

--############### Sets windows text @JDM12989
function PANEL:Display(str,icon,bt1,bt2,data)
	self.text = str;
	
	-- set icon
	if(icon == "!") then
		-- set to a !
		self.type = "Warning";
	elseif(icon == "X") then
		-- set to a X
		self.type = "Error";
	end
	
	-- use 2 buttons?
	self.twobtn = (bt2 ~= nil);
	if(self.twobtn) then
		self.VGUI.BT_Custom1:SetText(bt1);
		self.VGUI.BT_Custom1.Type = bt1;
		if(self.VGUI.BT_Custom1.Type == "Save") then
			self.VGUI.BT_Custom1.Fn = data;
		end
		self.VGUI.BT_Custom2:SetText(bt2);
	else
		self.VGUI.BT_Custom2:SetText(bt1);
	end
	
	-- show message
	self:SetVisible(true);
end

vgui.Register("RepMessage",PANEL,"Frame");