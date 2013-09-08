-- vgui commands registered
Replicators.GUI = Replicators.GUI or {};
Replicators.GUI.Commands = Replicators.GUI.Commands or {};

--################# Adds to VGUI Registry @JDM12989
function Replicators.RegisterVGUI(cmd,data)
	Replicators.GUI.Commands[cmd] = data;
end
