function widget:GetInfo()
	return {
		name = "set springsettings defaults",
		desc = "default settings",
		author = "Niobium",
		date = "3 April 2010",
		license = "GNU GPL, v2 or later",
		layer = -9999,
		handler = true,
		enabled = true
	}
end

local minMaxparticles = 25000

local function reducePing()
	--Spring.SendCommands("UseNetMessageSmoothingBuffer ".."0")
	--Spring.SendCommands("NetworkLossFactor ".."2")
	--Spring.SendCommands("LinkOutgoingBandwidth ".."262144")
	--Spring.SendCommands("LinkIncomingSustainedBandiwdth ".."262144")
	--Spring.SendCommands("LinkIncomingPeakBandiwdth ".."262144")
	--Spring.SendCommands("LinkIncomingMaxPacketRate ".."2048")
	Spring.SetConfigString("UseNetMessageSmoothingBuffer", "0")
	Spring.SetConfigString("NetworkLossFactor", "2")
	Spring.SetConfigString("LinkOutgoingBandwidth", "262144")
	Spring.SetConfigString("LinkIncomingSustainedBandwidth", "262144")
	Spring.SetConfigString("LinkIncomingPeakBandwidth", "262144")
	Spring.SetConfigString("LinkIncomingMaxPacketRate", "2048")
	--Spring.SendCommands("FeatureDrawDistance ".."90000")
	--Spring.SendCommands("FeatureFadeDistance ".."90000")
end

local function setEngineFont()
	local font = "FreeSansBold.otf"
	Spring.SetConfigString("FontOutlineWeight", "25")
	Spring.SetConfigString("FontOutlineWidth", "3")
	Spring.SetConfigString("FontSize", "23")
	Spring.SetConfigString("SmallFontOutlineWeight", "10")
	Spring.SetConfigString("SmallFontOutlineWidth", "2")
	Spring.SetConfigString("SmallFontSize", "14")
	Spring.SendCommands("font " .. font)
	Spring.SendCommands("font " .. "")
	Spring.SetConfigString("SmallFontFile", "FreeSansBold.otf")
	Spring.SetConfigString("FontFile", "FreeSansBold.otf")
	Spring.SetConfigString("ba_font", "FreeSansBold.otf")
	Spring.SetConfigString("ba_font2", "FreeSansBold.otf")
end

function widget:Initialize()
	--Spring.SendCommands("UnitLodDist ".."90000") --need this to remove it from springsettings
	if tonumber(Spring.GetConfigInt("reduceping", 1) or 1) == 1 then
		reducePing()
	end

	local firstlaunchsetupDone = Spring.GetConfigString("bafirstlaunchsetupDone1", "missing")

	if tonumber(Spring.GetConfigInt("water", 1) or 1) == 2 then
		Spring.SetConfigString("Water", "1")
	end

	if firstlaunchsetupDone ~= "done" then
		--Spring.SetConfigString("FeatureDrawDistance", "90000")
		Spring.SetConfigString("immersiveborder", "1")
		Spring.SetConfigString("bafirstlaunchsetupDone1", "done")
		Spring.SetConfigString("advgraphics", "1")
		Spring.SetConfigString("MSAALevel", "0")
		Spring.SetConfigString("UseNetMessageSmoothingBuffer", "0")
		Spring.SetConfigString("Water", "1")
		Spring.SetConfigString("ProfanityFilter", "1")
		Spring.SetConfigString("immersiveborder", "1")
		Spring.SetConfigString("chatsound", "1")
		Spring.SetConfigString("reduceping", "1")
		Spring.SetConfigString("GroundDecals", "1")
		reducePing()
		Spring.SetConfigString("LuaShaders", "1")
		Spring.SetConfigInt("GroundDetail", 80)
		Spring.SetConfigInt("MaxNanoParticles", 3000)
		Spring.SetConfigInt("MaxParticles", minMaxparticles)
		Spring.SetConfigInt("AdvMapShading", 1)
		Spring.SetConfigInt("AdvUnitShading", 1)
		Spring.SetConfigInt("EdgeMoveWidth", 0.1)
		Spring.SetConfigString("MouseDragScrollThreshold", "0.3")
		Spring.SetConfigInt("UnitIconDist", 200)
		Spring.SendCommands("disticon " .. 200)
		Spring.SetConfigInt("ShadowMapSize", 2048)
		Spring.SendCommands("Shadows 2 2048")
	end

	local camState = Spring.GetCameraState()
	camState.mode = 1
	Spring.SetCameraState(camState, 0)
	Spring.SetConfigString("UnitLodDist", "90000")
	Spring.SetConfigString("FeatureFadeDistance", "90000")
	Spring.SetConfigString("GuiOpacity", "0.6")
	Spring.SetConfigString("AdvSky", "0") --always disable this
	Spring.SetConfigString("Vsync", "0")
	Spring.SetConfigString("GrassDetail", "0")
	Spring.SetConfigString("MiniMapDrawProjectiles", "0")
	Spring.SetConfigString("UsePBO", "0")
	--local setGraphicsPreset = Spring.GetConfigString("setGraphicsPreset", "missing")
	--if setGraphicsPreset ~= "done" then
	--	Spring.SetConfigString("setGraphicsPreset", "done")   
	--	Spring.SetConfigString("advgraphics", 1)
	--end
	value = tonumber(Spring.GetConfigString("advgraphics", 1)) --set ultra graphics on first launch, otherwise to 1
	Spring.SetConfigString("advgraphics", value) --add 1 to advgraphics value, if there was no BA version recorded
	----
	-- Spring.SendCommands("AllowDeferredMapRendering ".. true)
	-- Spring.SendCommands("AllowDeferredModelRendering ".. true)
	--Spring.SendCommands("AllowDeferredMapRendering "..1)
	--Spring.SendCommands ("AllowDeferredMapRendering " .. 1)
	--Spring.SendCommands ("AllowDeferredModelRendering " .. 1)
	--Spring.SendCommands ("AllowDeferredMapRendering " .. 1)
	--Spring.SendCommands ("AllowDeferredModelRendering " .. 1)
	----------
	--Spring.SetConfigInt("ScrollWheelSpeed", 40)  
	--local scrollspeed = 40
	--Spring.SetConfigInt("FPSScrollSpeed", scrollspeed)			-- spring default: 10
	--	 Spring.SetConfigInt("OverheadScrollSpeed", scrollspeed)		-- spring default: 10
	--	 Spring.SetConfigInt("RotOverheadScrollSpeed", scrollspeed)	-- spring default: 10
	--	 Spring.SetConfigInt("CamFreeScrollSpeed", scrollspeed*50)	-- spring default: 500
	--	 Spring.SetConfigInt("CamSpringScrollSpeed", scrollspeed)		-- spring default: 10
	setEngineFont()
	widgetHandler:RemoveWidget(self)
end