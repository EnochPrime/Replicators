-- make rep fall apart
function ENT:Rep_AI_Disassemble(delay)
	delay = delay or 0;
	if (not timer.Exists("Rep_Disassemble_"..self.ENTINDEX)) then
		timer.Create("Rep_Disassemble_"..self.ENTINDEX,delay,1,
			function()
				--fall apart
				Replicators.Remove(self);
				self:Remove();
				-- MAKE THEM WORK THE CORRECT WAY!!!
				local str = "models/JDM12989/Replicators/Rep_N/Gibs/";
				for i=1,19 do
					local gib = ents.Create("block");
					gib:SetPos(self:GetPos());
					gib:SetAngles(self:GetAngles());
					gib:Spawn();
					gib:SetModel(str..i..".mdl");
					gib:PhysicsInit(SOLID_VPHYSICS);
					gib:GetPhysicsObject():Wake();
					gib.dead = true;
					gib:OnRemove();
				end
				self.tasks = true;
				timer.Destroy("Rep_Disassemble_"..self.ENTINDEX);
			end
		);
	end
	self.task = false;
end

local Data = {
	"Set the delay before disassembling.",
	"numbers",
};
	
Replicators.RegisterVGUI("Disassemble",Data);
