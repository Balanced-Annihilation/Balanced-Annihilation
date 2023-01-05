--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unit_smart_select.lua
--  version: 1.36
--  brief:   Selects units as you drag over them and provides selection modifier hotkeys
--  original author: Ryan Hileman (aegis)
--
--  Copyright (C) 2011.
--  Public Domain.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function widget:GetInfo()
	return {
		name      = "SelectAllUnitsOfSameTypeVisible",
		desc      = "Press cntrl X to select every onscreen with the same type as your selection",
		author    = "aegis",
		date      = "Jan 2, 2011",
		license   = "Public Domain",
		layer     = 0,
		enabled   = false,
	}
end


function widget:Initialize() 
		--Spring.SendCommands("unbind Ctrl+X select AllMap+_InPrevSel_Not_InHotkeyGroup+_SelectAll+")

	Spring.SendCommands("unbind Ctrl+X select")
	Spring.SendCommands("bind Ctrl+X select Visible+_InPrevSel+_ClearSelection_SelectAll+")

end

