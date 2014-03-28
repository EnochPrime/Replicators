--############## Add NPC's to tab @JDM12989
function Replicators.AddNPCS()
	local cat = "Stargate"
	local NPC = {Name = "Replicator",Class = "rep_n",Category = cat};
	list.Set("NPC",NPC.Class,NPC);
	--NPC = {Name = "Replicator Queen",Class = "rep_q",Category = cat};
	--list.Set("NPC",NPC.Class,NPC);
	--NPC = {Name = "Human-Form Replicator",Class = "rep_h",Category = cat};
	--list.Set("NPC",NPC.Class,NPC);
end
Replicators.AddNPCS();