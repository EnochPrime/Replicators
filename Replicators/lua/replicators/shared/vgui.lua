-- vgui commands registered
Replicators.VGUI = {};

--################# Adds to VGUI Registry @JDM12989
function Replicators.RegisterVGUI(command,data)
	Replicators.VGUI[command] = data;
end
