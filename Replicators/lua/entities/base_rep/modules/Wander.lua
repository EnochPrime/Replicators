-- make rep wander about a 1000 unit radius with random 0-5 second wait or defined by params
-- returns true
function ENT:Rep_AI_Wander(radius,min_wait,max_wait)
	radius = radius or 1000;
	min_wait = min_wait or 0;
	max_wait = max_wait or 5;
	
	if (not self.wanderTime or CurTime() >= self.wanderTime + 2) then
		local pos = self:GetPos();
		pos.x = math.random(radius*-1,radius);
		pos.y = math.random(radius*-1,radius);
		self:SetLastPosition(pos);
		self.wanderPos = pos;
		self.wanderDelay = math.random(min_wait,max_wait);
	end
	self.wanderTime = CurTime();
	local s = ai_schedule.New();
	s:EngTask("TASK_GET_PATH_TO_LASTPOSITION",0);
	s:EngTask("TASK_FACE_PATH",0);
	s:EngTask("TASK_RUN_PATH",0);
	if ((self.wanderPos - self:GetPos()):Length() >= 50) then
		self:StartSchedule(s);
		self.wanderStart = CurTime();
	end
	if (self.wanderStart and CurTime() >= self.wanderStart + self.wanderDelay) then
		self.wanderTime = -1;
	end
	self.tasks = true;
end

local Data = {
	"Set wander radius.",
	"numbers",
	"Set minimum wait time.",
	"numbers",
	"Set maximum wait time.",
	"numbers",
};

Replicators.RegisterVGUI("Wander",Data);