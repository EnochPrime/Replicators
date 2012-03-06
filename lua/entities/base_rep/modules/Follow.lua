-- follows specific ent and performs specific action when less than 50 units away, when b = true
-- return true	following
-- return false	no ent to follow
function ENT:Rep_AI_Follow(e,b)
	e = self:ExtractEnt(e);
	if (e == nil or not ValidEntity(e)) then
		self.tasks = false;
	else
		local pos = self:GetPos();
		local epos = e:GetPos();
		self:SetTarget(e);
		local s = ai_schedule.New();
		s:EngTask("TASK_GET_PATH_TO_TARGET",0);
		s:EngTask("TASK_FACE_PATH",0);
		local d = (pos-epos):Length();
		if (d > 50) then
			s:EngTask("TASK_RUN_PATH",0);
		elseif (b) then
			self:Activity(e);
		end
		self:StartSchedule(s);
		self.tasks = true;
	end
end

local Data = {
	"Choose what to follow.",
	"ents",
};

Replicators.RegisterVGUI("Follow",Data);