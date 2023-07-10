function widget:GetInfo()
	return {
		name      = "SelectVisibleUnitsExceptAirAndCons",
		desc      = "Press ctrl V or cntrl s to select onscreen mobile units except air and cons",
		author    = "Ares",
		date      = "",
		license   = "gplv2",
		layer     = 0,
		enabled   = false
	}
end

function widget:Initialize() 
	Spring.SendCommands("unbindkeyset any+s")
	Spring.SendCommands("unbind Ctrl+s select")
	Spring.SendCommands("bind ctrl+s select Visible+_Not_Builder_Not_Building_Not_Aircraft+_ClearSelection_SelectAll+")
	
	Spring.SendCommands("unbindkeyset any+v")
	Spring.SendCommands("unbind Ctrl+v select")
	Spring.SendCommands("bind ctrl+v select Visible+_Not_Builder_Not_Building_Not_Aircraft+_ClearSelection_SelectAll+")
end

