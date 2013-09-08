include("shared.lua");

PANEL = {};
PANEL.Ent = nil;

function PANEL:Init()
	self.VGUI = {
		BT_Submit = vgui.Create("DButton",self);
		MC_Gender = vgui.Create("DMultiChoice",self);
		MC_Person = vgui.Create("DMultiChoice",self);
		MC_Outfit = vgui.Create("DMultiChoice",self);
		
		P_Mdl = vgui.Create("DModelPanel",self);
	};
	self.Gender = "Male";
	self.Person = "01";
	self.Outfit = "group01";
	self.Mdl = "models/gman.mdl";
	
	self:SetSize(260,350);
	self:SetMinimumSize(260,350);
	self:Center();
	
	self.VGUI.BT_Submit:SetText("Start Creation Process");
	self.VGUI.BT_Submit:SetPos(10,320);
	self.VGUI.BT_Submit:SetSize(230,20);
	self.VGUI.BT_Submit.DoClick =
		function()
			self:SetVisible(false);
			RunConsoleCommand("Rep_Create_Start",self.Mdl);
		end

	self.VGUI.MC_Gender:SetPos(10,280);
	self.VGUI.MC_Gender:SetSize(100,20);
	self.VGUI.MC_Gender:SetEditable(false);
	self.VGUI.MC_Gender:AddChoice("Male");
	self.VGUI.MC_Gender:AddChoice("Female");
	self.VGUI.MC_Gender:ChooseOptionID(1);
	self.VGUI.MC_Gender.OnSelect = 
		function(MultiChoice)
			local text = MultiChoice.TextEntry:GetValue();
			self.Gender = text;
			self:GetNewModel();
		end

	self.VGUI.MC_Person:SetPos(10,300);
	self.VGUI.MC_Person:SetSize(100,20);
	self.VGUI.MC_Person:SetEditable(false);
	self.VGUI.MC_Person:AddChoice("Person 01");
	self.VGUI.MC_Person:AddChoice("Person 02");
	self.VGUI.MC_Person:AddChoice("Person 03");
	self.VGUI.MC_Person:AddChoice("Person 04");
	self.VGUI.MC_Person:AddChoice("Person 05");
	self.VGUI.MC_Person:AddChoice("Person 06");
	self.VGUI.MC_Person:AddChoice("Person 07");
	self.VGUI.MC_Person:AddChoice("Person 08");
	self.VGUI.MC_Person:AddChoice("Person 09");
	self.VGUI.MC_Person:ChooseOptionID(1);
	self.VGUI.MC_Person.OnSelect = 
		function(MultiChoice)
			local text = MultiChoice.TextEntry:GetValue();
			self.Person = string.Right(text,2);
			self:GetNewModel();
		end

	self.VGUI.MC_Outfit:SetPos(130,300);
	self.VGUI.MC_Outfit:SetSize(100,20);
	self.VGUI.MC_Outfit:SetEditable(false);
	self.VGUI.MC_Outfit:AddChoice("Citizen 1");
	self.VGUI.MC_Outfit:AddChoice("Citizen 2");
	self.VGUI.MC_Outfit:AddChoice("Rebel");
	self.VGUI.MC_Outfit:AddChoice("Medic")
	self.VGUI.MC_Outfit:ChooseOptionID(1);
	self.VGUI.MC_Outfit.OnSelect = 
		function(MultiChoice)
			local text = MultiChoice.TextEntry:GetValue();
			if(text == "Citizen 1") then
				self.Outfit = "group01"
			elseif(text == "Citizen 2") then
				self.Outfit = "group02"
			elseif(text == "Rebel") then
				self.Outfit = "group03";
			elseif(text == "Medic") then
				self.Outfit = "group03m";
			end
			self:GetNewModel();
		end
		
	self.VGUI.P_Mdl:SetSize(240,240);
	self.VGUI.P_Mdl:SetPos(10,30);
	self.VGUI.P_Mdl:SetLookAt(Vector(0,0,35));
	self.VGUI.P_Mdl:SetCamPos(Vector(75,0,35));
	self.VGUI.P_Mdl:SetModel("models/gman.mdl");
end

--############### Keeps buttons in the correct position when resizing @JDM12989
function PANEL:PerformLayout()
	local w,h = self:GetSize();
	self.VGUI.P_Mdl:SetSize(w-20,h-110);
	self.VGUI.BT_Submit:SetPos((w/2)-115,h-30);
	self.VGUI.MC_Gender:SetPos(10,h-70);
	self.VGUI.MC_Person:SetPos(10,h-50);
	self.VGUI.MC_Outfit:SetPos(130,h-50);
end

--############### Draws the panel @JDM12989
function PANEL:Paint()
	draw.RoundedBox(10,0,0,self:GetWide(),self:GetTall(),Color(16,16,16,255));
	draw.DrawText("Custom Replicator","ScoreboardText",30,8,Color(255,255,255,255),0);
	return true;
end

function PANEL:SetEnt(e)
	self.Ent = e;
end

--################# Compile model name from drop downs @JDM12989
function PANEL:GetNewModel()
	mdl = "models/Humans/";
	mdl = mdl..self.Outfit.."/"..self.Gender.."_"..self.Person..".mdl";
	self.Mdl = mdl;
	self.VGUI.P_Mdl:SetModel(mdl);
end

vgui.Register("RepCustomHuman",PANEL,"Frame");

--############### Brings up the panel @JDM12989
usermessage.Hook("Show_RepHumanCtrl",
	function(data)
		if (not RepHumanCtrl) then
			RepHumanCtrl = vgui.Create("RepCustomHuman");
		end
		local e = data:ReadEntity();
		RepHumanCtrl:SetEnt(e);
		RepHumanCtrl:SetVisible(true);
	end
);
