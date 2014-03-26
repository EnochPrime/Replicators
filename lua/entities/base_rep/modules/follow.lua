-- follows specific ent and performs specific action when less than 50 units away, when b = true
-- return true	following
-- return false	no ent to follow
function ENT:Rep_AI_Follow(e,b)
	e = self:ExtractEnt(e);
	if (e == nil or not IsValid(e)) then
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
			s:EngTask("TASK_WAIT_FOR_MOVEMENT",0);
		elseif (b) then
			self:Activity(e);
		end
		self:StartSchedule(s);
		self.tasks = true;
	end
end

function ENT:Rep_AI_GoToTarget(target, performAction)
	-- check for null target
	if (target == nil and not IsValid(target)) then
		MsgN("Replicator " .. self:EntIndex() .. " has no valid target.");
		return false;
	end

	-- get positions		
	local self_posn = self:GetPos();
	local target_posn = target:GetPos();

	-- perform action
	if ((target_posn - self_posn):Length() <= 50 and performAction) then
		self:Activity(target);
	end

	-- target no longer valid
	if (target == nil or not IsValid(target)) then
		return false;
	end

	-- set target
	MsgN("Replicator:" .. self:EntIndex() .. " set target to " .. target:GetClass() .. ":" .. target:EntIndex());	
	self:SetTarget(target);
	
	-- create schedule
	local schd = ai_schedule.New();
	schd:EngTask("TASK_SET_FAIL_SCHEDULE", SCHED_NONE);
	schd:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 1);			-- need this to stop search for path to invalid target
	schd:EngTask("TASK_GET_PATH_TO_TARGET", 0);
	schd:EngTask("TASK_FACE_PATH", 0);
	schd:EngTask("TASK_MOVE_TO_TARGET_RANGE", 10);
	schd:EngTask("TASK_WAIT_FOR_MOVEMENT_STEP", 0);
	
	if (performAction) then
		--schd:EngTask("TASK_MELEE_ATTACK1", 0);
	end
	
	-- start schedule
	MsgN("Replicator:" .. self:EntIndex() .. " is going to " .. target:GetClass() .. ":" .. target:EntIndex()); 
	self:StartSchedule(schd);
	return true;
end

local Data = {
	"Choose what to follow.",
	"ents",
};

Replicators.RegisterVGUI("Follow",Data);
