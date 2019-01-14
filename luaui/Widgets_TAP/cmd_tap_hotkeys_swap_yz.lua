function widget:GetInfo()
	return {
		name = "TAPrime Hotkeys -- swap YZ",
		desc = "Swaps Y and Z in TAP Hotkeys widget" ,
		author = "Beherith, modified by MaDDoX",
		date = "23 march 2012",
		license = "GNU LGPL, v2.1 or later",
		layer = 100, --should load AFTER TAP hotkeys
		enabled = false,
	}
end

function widget:Initialize()
    if WG.Reload_TAP_Hotkeys then
        WG.swapYZbinds = true
        WG.Reload_TAP_Hotkeys()
    else
        Spring.Echo("TAPrime Hotkeys widget not found, cannot swap YZ")
        widgetHandler:RemoveWidget(self)
    end
end

function widget:Shutdown()
    WG.swapYZbinds = nil
    if WG.Reload_TAP_Hotkeys then
        WG.Reload_TAP_Hotkeys()
    else
        Spring.Echo("TAPrime Hotkeys widget not found, cannot swap YZ")
    end
end
