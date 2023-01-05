function widget:GetInfo()
	return {
		name	= "Grabinput",
		desc	= "Enables GrabInput in Windowed mode (Prevents/Enables the mouse from leaving the game window)",
		author	= "abma",
		date	= "2012-08-11",
		license	= "GPL v2 or later",
		layer	= 5,
		enabled	= false,
	}
end

local sec = 0

function widget:Initialize()
	Spring.SendCommands("grabinput 1")
end

function widget:Update(dt)
	sec = sec + dt
	if sec > 1 then
		sec = 0
		Spring.SendCommands("grabinput 1")
	end
end

function widget:Shutdown()
	Spring.SendCommands("grabinput 0")
end
