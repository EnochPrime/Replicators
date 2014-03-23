-- make rep wander about a 1000 unit radius with random 0-5 second wait or defined by params
-- always returns true
function ENT:Rep_AI_Wander(radius,min_wait,max_wait)
	radius = radius or 1000;
	min_wait = min_wait or 0;
	max_wait = max_wait or 5;
	
	local schd = ai_schedule.New();
	schd:EngTask("TASK_GET_PATH_TO_RANDOM_NODE",radius);
	schd:EngTask("TASK_FACE_PATH",0);
	schd:EngTask("TASK_RUN_PATH",0);
	schd:EngTask("TASK_WAIT_FOR_MOVEMENT",0);
	schd:EngTask("TASK_WAIT",math.random(min_wait,max_wait));
	
	MsgN("Replicator " .. self.ENTINDEX .. " is wandering."); 
	self:StartSchedule(schd);
	return true;
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
