function widget:GetInfo()
	return {
		name      = "SelectVisibleUnitsOfSameType",
		desc      = "Press cntrl X to select every onscreen with the same type as selection",
		author    = "Ares",
		date      = "",
		license   = "gplv2",
		layer     = 0,
		enabled   = true
	}
end

function widget:Initialize() 
	Spring.SendCommands("unbindkeyset any+x")
	Spring.SendCommands("unbind Ctrl+X select")
	Spring.SendCommands("bind Ctrl+X select Visible+_InPrevSel+_ClearSelection_SelectAll+")
end

