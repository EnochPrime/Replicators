/*
	Replicator AI Function, Wander for GarrysMod
	Copyright (C) 2014

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
--	schd:EngTask("TASK_WANDER", radius);
	schd:EngTask("TASK_WAIT_FOR_MOVEMENT",0);
	schd:EngTask("TASK_WAIT",math.random(min_wait,max_wait));
	
	--MsgN("Replicator " .. self.ENTINDEX .. " is wandering."); 
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
