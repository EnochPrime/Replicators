-- seems like a pointless function, but will stay for now
-- make rep move to pos and wait for give time (both = rand)
function ENT:Rep_AI_Move_To_Position(pos,t_min,t_max)
	local wait = t_min or 0;
	if (t_max ~= nil) then
		wait = math.random(t_min,t_max);
	end
	
	self:SetLastPosition(pos);
	local s = ai_schedule.New();
	s:EngTask("TASK_GET_PATH_TO_LASTPOSITION",0);
	s:EngTask("TASK_FACE_PATH",0);
	s:EngTask("TASK_RUN_PATH",0);
	s:EngTask("TASK_WAIT_FOR_MOVEMENT",0);
	s:EngTask("TASK_WAIT",wait);
	self:StartSchedule(s);
end

local Data = {
	"Choose a position.", -- HOW????
	"numbers",
	"Choose minimum wait time.",
	"numbers",
	"Choose maximum wait time.",
	"numbers",
};

--Replicators.RegisterVGUI("Move_To_Position",Data);
