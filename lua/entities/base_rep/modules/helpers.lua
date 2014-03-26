local Help = {};

-- does appropriate activity based on the entitiy
function ENT:Activity(e)
	local c = e:GetClass();
	if (c == "rep_q") then
		e.material_metal = e.material_metal + self.material_metal;
		e.material_other = e.material_other + self.material_other;
		self.material_metal = 0;
		self.material_other = 0;
		return;
	end
	
	if (e:IsPlayer() or e:IsNPC()) then
		e:TakeDamage(5,self);
	elseif (c == "prop_physics") then
		if (gcombat) then
			if (gcombat.devhit(e,10,4) == 2) then
				e:Remove();
			end
		elseif (cds_damagepos) then
			cds_damagepos(e,10,50,nil,self);
		else
			if (not e.__count) then
				local ent_phys = e:GetPhysicsObject();
				e.__count = 1;
				e.__maxcount = ent_phys:GetMass();
			else
				e.__count = e.__count + 1;
				if (e.__count >= e.__maxcount) then
					e:Remove();
				end
			end
		end
		self.material_metal = self.material_metal + 10;
	end
end

-- extracts entity from table of strings
-- return ent
function ENT:ExtractEnt(t)
	if (type(t) == "table") then
		local ent_table = {};
		local ent_trgt = ent_trgt or nil;
		local p_trgt = nil;
		local d = 10000; -- maximum distance
		local pos = self:GetPos();
		
		-- setup of ent_table
		for _,v in pairs(ents.GetAll()) do
			if (v:IsPlayer() and table.HasValue(t,v:GetName())) then
				table.insert(ent_table,v);
			elseif (v:IsNPC() and table.HasValue(t,v:GetClass())) then
				table.insert(ent_table,v);
			end
		end

		-- find 1st valid and set as target
		for _,v in pairs(ent_table) do
			if (IsValid(v)) then
				local dist = (v:GetPos() - pos):Length();
				if (dist <= d) then
					p_trgt = v;
					t = p_trgt;
					d = dist;
				end
			end
		end
	end
	
	-- last resort in case the table is not chaged to a player or npc
	if (type(t) == "table") then
		t = nil;
	end
	return t;
end

-- finds the nearest object by it's class
-- return closest ent by class
function ENT:Find(class_name)
	local e = nil;
	local d = 10000; -- maximum find distance
	local dist = 0;
	local pos = self:GetPos();
	
	-- step through all entities within sphere and find closest
	for _,v in pairs(ents.FindInSphere(pos,d)) do	
		local color = v:GetColor();
		-- if entity is of correct class, not invisible, and is not in ignore list
		if (v:GetClass() == class_name and color.a == 255 and not table.HasValue(Replicators.IgnoreMe,v:GetModel())) then
			-- if entity can be targeted					
			if (self:Visible(v) and Help.Can_Target(self,v)) then				
				dist = (pos - v:GetPos()):Length();
				if (dist < d) then
					d = dist;
					e = v;
				end
			end
		end
	end
	if (IsValid(e) and not table.HasValue(e.__rep_count,self)) then table.insert(e.__rep_count,self) end;
	return e;
end

-- get/set target
function ENT:SetTarget(target)
	self.Target = target;
end
function ENT:GetTarget()
	return self.Target;
end

-- return whether or not ent can be targeted
function Help.Can_Target(s,e)
	if (not e.__rep_count) then e.__rep_count = {} end;
	if (e:IsPlayer() or e:IsNPC()) then return true end;
	
	Help.Clean_Table(e.__rep_count);
	if (table.HasValue(e.__rep_count,s) or table.HasValue(e.__rep_count,nil) or #e.__rep_count < GetConVarNumber("replicator_limit_bunch")) then
		return true;
	end
	
	return false;
end

-- cleans out nil values from table
function Help.Clean_Table(t)
	if (#t == 0) then return end;
	
	for k,v in pairs(t) do
		if (not IsValid(v) or k > GetConVarNumber("replicator_limit_bunch")) then
			table.remove(t,k);
		end
	end
end
