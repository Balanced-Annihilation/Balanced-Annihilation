function widget:GetInfo()
	return {
		name = "TAG No Alt Mouse Wheel",
		desc = "No Alt Mouse Wheel",
		license = "gplv2",
		layer = 3000, -- so that any widget with a lower number has a chance to catch mousewheel first
		enabled = false
	}
end

function widget:MouseWheel(up,value)
	local alt,ctrl,meta,shift=Spring.GetModKeyState()
	if alt then
		return true
	else
		return false
	end
end
