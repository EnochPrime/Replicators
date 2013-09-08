include("shared.lua");
language.Add("rep_n","Replicator");

-- SOUND NOT WORKING!!!
--################# Think (From StaffWeapon flyby code) @aVoN
function ENT:Think()
	if ((self.Last or 0)+0.6 <= CurTime()) then
		local v = self:GetVelocity();
		local v_len = v:Length();
		local d = (LocalPlayer():GetPos()-self:GetPos());
		local d_len = d:Length();
		if (d_len <= 700) then
			self.Last = CurTime();
			-- Vector math: Get the distance from the player orthogonally to the projectil's velocity vector
			local intensity = math.sqrt(1-(d:DotProduct(v)/(d_len*v_len))^2)*d_len;
			self.Entity:EmitSound(Sound("Replicators/walk.mp3"),100*(1-intensity/2500),math.random(80,120));
		end
	end
end
