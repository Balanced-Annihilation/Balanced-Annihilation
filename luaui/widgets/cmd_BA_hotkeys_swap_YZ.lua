function widget:GetInfo()
	return {
<<<<<<< HEAD
		name = "BA Hotkeys swap YZ",
=======
		name = "BA Hotkeys - swap YZ",
>>>>>>> adf5f5e23602909fbae9e0f44f2186f972a66f1b
		desc = "Swaps Y and Z in BA Hotkeys widget" ,
		author = "Beherith",
		date = "23 march 2012",
		license = "GNU LGPL, v2.1 or later",
		layer = 100, --should load AFTER BA hotkeys
		enabled = false
	}
end

function widget:Initialize()
    if WG.Reload_BA_Hotkeys then
        WG.swapYZbinds = true
        WG.Reload_BA_Hotkeys()
    else
        Spring.Echo("BA Hotkeys widget not found, cannot swap YZ")
        widgetHandler:RemoveWidget(self)
    end
end

function widget:Shutdown()
    WG.swapYZbinds = nil
    if WG.Reload_BA_Hotkeys then
        WG.Reload_BA_Hotkeys()
    else
        Spring.Echo("BA Hotkeys widget not found, cannot swap YZ")
    end
end
