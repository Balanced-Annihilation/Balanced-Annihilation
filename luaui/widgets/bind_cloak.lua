function widget:GetInfo()
	return {
		name      = "Bind cloak to k",
		desc      = "Bind cloak to k",
		author    = "",
		date      = "",
		license   = "CC0",
		layer     = 5,
		enabled   = true,
	}
end


function widget:Initialize()
	 Spring.SendCommands("bind k wantcloak")
	widgetHandler:RemoveWidget(widget)
end
