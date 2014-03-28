include("shared.lua");

--################# nice fade away @JDM12989
function ENT:Draw()
	self.Alpha = self.Alpha or 255;
	if(self:GetNWBool("fade_out")) then
		self.Alpha = math.Clamp(self.Alpha-FrameTime()*80,0,255);
		self:SetColor(255,255,255,self.Alpha);
	end
	self:DrawModel();
end
