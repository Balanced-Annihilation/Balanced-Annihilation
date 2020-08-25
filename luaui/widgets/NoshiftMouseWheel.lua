function widget:GetInfo()
	return {
		name = "No shift Mouse Wheel",
		desc = "Eats all your mousewheeling when alt is down",
		author = "zwzsg",
		date = "16 may 2010",
		license = "Free",
		version = 1,
		layer = 2000, -- so that any widget with a lower number has a chance to catch mousewheel first
		enabled = true
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
