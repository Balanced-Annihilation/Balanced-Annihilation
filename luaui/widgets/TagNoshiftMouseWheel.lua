function widget:GetInfo()
	return {
		name = "TAG No shift Mouse Wheel",
		desc = "No shift Mouse Wheel",
		license = "gplv2",
		layer = 3000, 
		enabled = false
	}
end

function widget:MouseWheel(up,value)
	local alt,ctrl,meta,shift=Spring.GetModKeyState()
	if shift then
		return true
	else
		return false
	end
end
