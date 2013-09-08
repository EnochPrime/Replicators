--################# HEADER #################
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

--################# SENT CODE #################

--################# Init @JDM12989
function ENT:Initialize()
	self.BaseClass.Initialize(self);
	self.max_minions = 10;
	
	-- gain control of unallocated reps
	for k,v in pairs(Replicators.Reps) do
		if (v ~= self and v.leader == nil) then
			v.leader = self;
			self.minions[k] = v;
			v:SetCode("rep_test.txt");
		end
	end
end
