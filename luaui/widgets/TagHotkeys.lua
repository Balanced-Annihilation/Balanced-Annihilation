
function widget:GetInfo()
	return {
		name      = "TAG Hotkeys",
		desc      = "Press cntrl X to select every onscreen with the same type as your selection",
		author    = "aegis",
		date      = "Jan 2, 2011",
		license   = "Public Domain",
		layer     = 2,
		enabled = true,
        handler = true,
	}
end


function widget:Initialize() 
		widgetHandler:DisableWidget("BA Hotkeys")
		--rad
		Spring.SendCommands("bind v buildunit_armrad")
        Spring.SendCommands("bind shift+v buildunit_armrad")
        Spring.SendCommands("bind v buildunit_corrad")
        Spring.SendCommands("bind shift+v buildunit_corrad")
		--t1 aa
        Spring.SendCommands("bind v buildunit_armrl")
        Spring.SendCommands("bind shift+v buildunit_armrl")
        Spring.SendCommands("bind v buildunit_corrl")
        Spring.SendCommands("bind shift+v buildunit_corrl")
end
