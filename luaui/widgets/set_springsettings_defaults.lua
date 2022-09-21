function widget:GetInfo()
    return {
        name = "set springsettings defaults",
        desc = "default settings",
        author = "Niobium",
        date = "3 April 2010",
        license = "GNU GPL, v2 or later",
        layer = -99999999999999,
        handler = true,
        enabled = true
    }
end

function widget:Initialize()
    Spring.SetConfigString("bafirstlaunchsetupiscomplete", "done")
    Spring.SetConfigString("bafirstlaunchsetupiscomplete2", "done")
    Spring.SetConfigString("bafirstlaunchsetupiscomplete3", "done")

	
    local bafirstlaunchsetupiscomplete = Spring.GetConfigString("bafirstlaunchsetupiscomplete4", "missing") --remove later
    if bafirstlaunchsetupiscomplete ~= "done" then
        widgetHandler:DisableWidget("TeamPlatter")
        widgetHandler:DisableWidget("SmartSelect")
        Spring.SetConfigInt("CamSetting", 1)
        widgetHandler:EnableWidget("SmoothCam")
        Spring.SetConfigInt("smoothcam", 1)
        Spring.SetConfigString("bafirstlaunchsetupiscomplete4", "done")

        if (gl.CreateShader) then
            Spring.SetConfigString("advgraphics", "2")
        else
            Spring.SetConfigString("advgraphics", "1")
        end
        ---Spring.SendCommands("CamTimeFactor 1")
        --- Spring.SendCommands("CamTimeExponent 4")
        -- Spring.SendCommands("viewta ")
        --Spring.SetConfigString("ScrollWheelSpeed", "51")
        --Spring.SetConfigString("CamSpringScrollSpeed", "51")
        --Spring.SetConfigString("FPSScrollSpeed", "0.001")
		Spring.SetConfigInt("GroundDetail", 80)   	
        Spring.SetConfigInt("MaxNanoParticles", 3000)
        Spring.SetConfigInt("MaxParticles", 30000)
        Spring.SetConfigString("UseNetMessageSmoothingBuffer", "0")
        Spring.SetConfigString("NetworkLossFactor", "2")
        Spring.SetConfigString("LinkOutgoingBandwidth", "262144")
        Spring.SetConfigString("LinkIncomingSustainedBandwidth", "262144")
        Spring.SetConfigString("LinkIncomingPeakBandwidth", "262144")
        Spring.SetConfigString("LinkIncomingMaxPacketRate", "2048")

        Spring.SetConfigInt("mapborder", 1)
        Spring.SetConfigInt("MSAALevel", 0)
        Spring.SetConfigString("Water", "1")
        Spring.SetConfigString("ProfanityFilter", "1")
        Spring.SetConfigString("chatsound", "1")
        Spring.SetConfigString("reduceping", "1")
        Spring.SetConfigString("GroundDecals", "1")

       

        Spring.SetConfigInt("EdgeMoveWidth", 0.1)
        Spring.SetConfigString("MouseDragScrollThreshold", "0.3")
        Spring.SetConfigInt("UnitIconDist", 200)
        Spring.SetConfigInt("alwaysrenderwrecksandtrees", 1)
        Spring.SetConfigString("FeatureDrawDistance", "999999")
        Spring.SetConfigString("FeatureFadeDistance", "999999")
        --Spring.SetConfigInt("3DTrees", 0)
        -- Spring.SendCommands("FeatureDrawDistance 900000")
        --Spring.SendCommands("FeatureFadeDistance 900001")
        --	Spring.SetConfigString("3DTrees", "0")
        Spring.SetConfigInt("Shadows", 1)
    end

    local value = tonumber(Spring.GetConfigInt("ScrollWheelSpeed", 25) or 25)
    if (value == 0) then
        Spring.SetConfigInt("ScrollWheelSpeed", 25)
    end

    value = tonumber(Spring.GetConfigInt("MaxParticles", 30000) or 30000)
    if ((value == 5000) and (value ~= 0)) then
        Spring.SetConfigInt("MaxParticles", 30000)
    end

    Spring.SetConfigInt("TreeRadius", 9999)

    Spring.SetConfigInt("ShadowMapSize", 6144)
    Spring.SetConfigString("FPSMouseScale", Spring.SetConfigString("FPSMouseScale", "0.0025") or "0.0025")
    Spring.SetConfigString("CamSpringScrollSpeed", Spring.SetConfigString("CamSpringScrollSpeed", "10") or "10")

    --Spring.SetConfigInt("ScrollWheelSpeed", Spring.GetConfigInt("ScrollWheelSpeed", 51))

    --Spring.SetConfigInt("OverheadScrollSpeed", Spring.GetConfigInt("OverheadScrollSpeed", 51))
    --	Spring.SetConfigInt("RotOverheadScrollSpeed", Spring.GetConfigInt("RotOverheadScrollSpeed", 51))
    --Spring.SetConfigInt("CamFreeScrollSpeed", Spring.GetConfigInt("CamFreeScrollSpeed", 51))
    --		Spring.SetConfigInt("CamSpringScrollSpeed", Spring.GetConfigInt("CamSpringScrollSpeed", 51))

    Spring.SetConfigString("UnitLodDist", "999999")

    Spring.SetConfigInt("HangTimeout", -1)
    Spring.SetConfigInt("snd_airAbsorption", 0)

    Spring.SetConfigInt("snd_volbattle", 100)
    Spring.SetConfigInt("snd_volgeneral", 100)
    Spring.SetConfigInt("snd_volmusic", 100)
    Spring.SetConfigInt("snd_volui", 100)
    Spring.SetConfigInt("snd_volunitreply", 100)

    Spring.SetConfigString("GuiOpacity", "0.6")
    Spring.SetConfigString("AdvSky", "0") --always disable this
    Spring.SetConfigString("DynamicSky", "0") --always disable this
    Spring.SetConfigString("Vsync", "0")
    Spring.SetConfigString("GrassDetail", "0")
    Spring.SetConfigString("MiniMapDrawProjectiles", "0")
    Spring.SetConfigString("UsePBO", "0")
    local value = tonumber(Spring.GetConfigInt("advgraphics", 1) or 1)
    Spring.SetConfigInt("advgraphics", value) --add 1 to advgraphics value, if there was no BA version recorded

    --if(value > 0) then
    --		local watervalue = (Spring.GetConfigInt("Water", 1) > 0)
    --		Spring.SetConfigInt("Water", 1)
    --		Spring.SendCommands("Water 1")
    --end

    --value =  tonumber(Spring.GetConfigString("ScrollWheelSpeed",25))
    --	Spring.SetConfigInt("ScrollWheelSpeed", value) --add 1 to advgraphics value, if there was no BA version recorded

    --value =  tonumber(Spring.GetConfigString("CamSpringScrollSpeed", 25))
    --	Spring.SetConfigInt("CamSpringScrollSpeed", value) --add 1 to advgraphics value, if there was no BA version recorded

    --value = tonumber(Spring.GetConfigString("FPSScrollSpeed", 2))
    --Spring.SetConfigInt("FPSScrollSpeed", value)

    if (gl.CreateShader) then
        Spring.SetConfigInt("AdvMapShading", 1)
        Spring.SetConfigInt("AdvModelShading", 1)
        Spring.SetConfigInt("LuaShaders", 1)
        Spring.SetConfigInt("AllowDeferredMapRendering", 1)
        Spring.SetConfigInt("AllowDeferredModelRendering", 1)
    else
        Spring.SetConfigInt("LuaShaders", 0)
        Spring.SetConfigInt("AllowDeferredMapRendering", 0)
        Spring.SetConfigInt("AllowDeferredModelRendering", 0)

        Spring.SetConfigInt("AdvMapShading", 0)
        Spring.SetConfigInt("AdvUnitShading", 0)
        Spring.SetConfigInt("UseVBO", 0)
        Spring.SetConfigInt("advgraphics", 0)
        Spring.SetConfigInt("mapborder", 1)
		
    end
	
	Spring.SetConfigString("LuaGarbageCollectionMemLoadMult", "1.33")
	Spring.SetConfigString("LuaGarbageCollectionRunTimeMult", "5")
	
    local font = "FreeSansBold.otf"
    Spring.SetConfigString("FontOutlineWeight", "25")
    Spring.SetConfigString("FontOutlineWidth", "3")
    Spring.SetConfigString("FontSize", "23")
    Spring.SetConfigString("SmallFontOutlineWeight", "10")
    Spring.SetConfigString("SmallFontOutlineWidth", "2")
    Spring.SetConfigString("SmallFontSize", "14")
    Spring.SetConfigString("SmallFontFile", "FreeSansBold.otf")
    Spring.SetConfigString("FontFile", "FreeSansBold.otf")
    Spring.SetConfigString("ba_font", "FreeSansBold.otf")
    Spring.SetConfigString("ba_font2", "FreeSansBold.otf")

    widgetHandler:RemoveWidget(self)
end
