/*
	RepFile for GarrysMod10
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
PANEL.Type = "Custom";
PANEL.Dir = "replicators/";
PANEL.Protected = {
	"rep_n.txt",
	"rep_q.txt",
	"rep_h.txt",
};

--############### Initializes the panel @JDM12989
function PANEL:Init()
	self.VGUI = {
		IBT_Delete = vgui.Create("DImageButton",self);
		BT_Custom = vgui.Create("DButton",self);
		BT_Cancel = vgui.Create("DButton",self);
		LV_Files = vgui.Create("DListView",self);
		TE_File = vgui.Create("DTextEntry",self);
	};

	self:SetSize(295,225);
	self:SetMinimumSize(295,225);
	self:SetPos(100,100);
	
	-- delete selected file
	self.VGUI.IBT_Delete:SetSize(16,16);
	self.VGUI.IBT_Delete:SetPos(250,8);
	self.VGUI.IBT_Delete:SetImage("gui/silkicons/delete");
	self.VGUI.IBT_Delete:SetToolTip("Delete selected file!");
	self.VGUI.IBT_Delete.DoClick =
		function()
			local text = self.VGUI.TE_File:GetValue();
			if (table.HasValue(self.Protected,text)) then
				MsgN(text.." is protected.");
			else
				file.Delete(self.Dir..self.VGUI.TE_File:GetValue());
				self:SetUpFileList();
			end
		end
	
	-- load/save file
	self.VGUI.BT_Custom:SetText("Custom");
	self.VGUI.BT_Custom:SetPos(150,190);
	self.VGUI.BT_Custom.DoClick = 
		function()
			self:SetVisible(false);
			local parent = self:GetParent();
			local fn = self.VGUI.TE_File:GetValue();
			if (self.Type == "Open") then
				parent:LoadFile(fn);
			elseif (self.Type == "Save") then
				if (table.HasValue(self.Protected,fn)) then
					parent.VGUI.P_Message:Display("Unable to make file with that name!","X","Okay");
				else
					parent:SaveFile(fn);
				end
			end
		end
		
	-- cancel
	self.VGUI.BT_Cancel:SetText("Cancel");
	self.VGUI.BT_Cancel:SetPos(220,190);
	self.VGUI.BT_Cancel.DoClick =
		function()
			self:SetVisible(false);
		end
		
	-- list of all files in current dir
	self.VGUI.LV_Files:SetPos(10,35);
	self.VGUI.LV_Files:SetSize(self:GetWide()-20,self:GetTall()-70);
	self.VGUI.LV_Files:SetMultiSelect(false);
	self.VGUI.LV_Files:AddColumn("Name");
	self.VGUI.LV_Files:AddColumn("Date Modified");
	self.VGUI.LV_Files.OnRowSelected =
		function(ListView,Row)
			local selected = ListView:GetSelectedLine()
			local text = ListView:GetLine(selected):GetColumnText(1);
			self.VGUI.TE_File:SetText(text);
		end
	self.VGUI.LV_Files.DoDoubleClick =
		function(ListView,Row)
			local selected = ListView:GetSelectedLine()
			local fn = ListView:GetLine(selected):GetColumnText(1);
			self:SetVisible(false);
			local parent = self:GetParent();
			if (self.Type == "Open") then
				parent:LoadFile(fn);
			elseif (self.Type == "Save") then
				if (table.HasValue(self.Protected,fn)) then
					parent.VGUI.P_Message:Display("Unable to make file with that name!","X","Okay");
				else
					parent:SaveFile(fn);
				end
			end
		end
	
	RunConsoleCommand("RepInitUserDir");
	self:SetUpFileList();
	
	self.VGUI.TE_File:SetPos(10,190);
	self.VGUI.TE_File:SetSize(135,self.VGUI.TE_File:GetTall());
end

--############### Keeps buttons in the correct position when resizing @JDM12989
function PANEL:PerformLayout()
	local w,h = self:GetSize();
	self.VGUI.IBT_Delete:SetPos(w-45,8);
	self.VGUI.LV_Files:SetSize(w-20,h-70);
	self.VGUI.BT_Custom:SetPos(w-145,h-30);
	self.VGUI.BT_Cancel:SetPos(w-75,h-30);
	self.VGUI.TE_File:SetPos(10,h-28);
	self.VGUI.TE_File:SetSize(w-165,self.VGUI.TE_File:GetTall());
end

--############### Draws the panel @JDM12989
function PANEL:Paint()
	draw.RoundedBox(10,0,0,self:GetWide(),self:GetTall(),Color(16,16,16,255));
	local text = self.Type.." File";
	draw.DrawText(text,"ScoreboardText",30,8,Color(255,255,255,255),0);
	return true;
end

--############### Changes type to string @JDM12989
function PANEL:SetType(s)
	self.Type = s;
	self.VGUI.BT_Custom:SetText(self.Type);
end

--############### Initialize list setup / adds ai files (client) to list view @JDM12989
function PANEL:SetUpFileList()
	self.VGUI.LV_Files:Clear();
	local s = "";
	local files = {};
	files = file.Find(self.Dir.."*");
	
	if (not files) then return end;
	for k,v in pairs(files) do
		self.VGUI.LV_Files:AddLine(v,os.date("%c",file.Time(self.Dir..v)));
	end
	self.VGUI.LV_Files:SortByColumn(1);
end

vgui.Register("RepFile",PANEL,"Frame");