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
local bafirstlaunchsetupiscomplete = Spring.GetConfigString('bafirstlaunchsetupiscomplete', "missing") --remove later
if bafirstlaunchsetupiscomplete ~= "done" then
   		Spring.SetConfigString("bafirstlaunchsetupiscomplete", 'done')
		
		Spring.SetConfigString("ScrollWheelSpeed", "25")
		Spring.SetConfigString("UseNetMessageSmoothingBuffer", "0")
	Spring.SetConfigString("NetworkLossFactor", "2")
	Spring.SetConfigString("LinkOutgoingBandwidth", "262144")
	Spring.SetConfigString("LinkIncomingSustainedBandwidth", "262144")
	Spring.SetConfigString("LinkIncomingPeakBandwidth", "262144")
	Spring.SetConfigString("LinkIncomingMaxPacketRate", "2048")

		
		Spring.SetConfigInt("immersiveborder", 0)
			Spring.SetConfigInt("MSAALevel", 0)
		Spring.SetConfigString("UseNetMessageSmoothingBuffer", "0")
		Spring.SetConfigString("Water", "1")
		Spring.SetConfigString("ProfanityFilter", "1")
		Spring.SetConfigString("chatsound", "1")
		Spring.SetConfigString("reduceping", "1")
		Spring.SetConfigString("GroundDecals", "1")
		
		Spring.SetConfigString("GroundDetail" , "80")
		Spring.SetConfigInt("MaxNanoParticles", 3000)
		Spring.SetConfigInt("MaxParticles", 30000)
		Spring.SetConfigInt("Smoothcam", 1)
		Spring.SetConfigInt("EdgeMoveWidth", 0.1)
		Spring.SetConfigString("MouseDragScrollThreshold", "0.3")
		Spring.SetConfigInt("UnitIconDist", 200)
	
		Spring.SetConfigInt("FeatureDrawDistance", 99999999)
		Spring.SetConfigInt("FeatureFadeDistance", 99999999)
		Spring.SetConfigInt("Shadows", 1)

end
Spring.SetConfigInt("ShadowMapSize", 6144)



			

Spring.SetConfigString("UnitLodDist", "99999999")

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
	local value = tonumber(Spring.GetConfigInt("advgraphics", 1) or 1) --set ultra graphics on first launch, otherwise to 1
	Spring.SetConfigInt("advgraphics", value) --add 1 to advgraphics value, if there was no BA version recorded
	
	if (gl.CreateShader)then
			Spring.SetConfigInt("AdvMapShading", 1)
			Spring.SetConfigInt("AdvModelShading", 1)
			Spring.SetConfigInt("LuaShaders", 1)
			Spring.SetConfigInt("AllowDeferredMapRendering", 1)
			Spring.SetConfigInt("AllowDeferredModelRendering", 1)
			else

				Spring.SetConfigInt("LuaShaders", 0)
			Spring.SetConfigInt("AllowDeferredMapRendering", 0)
			Spring.SetConfigInt("AllowDeferredModelRendering", 0)
			Spring.SetConfigInt("advgraphics", 0)
			Spring.SetConfigInt("AdvMapShading", 0)
			Spring.SetConfigInt("AdvUnitShading", 0)
			Spring.SetConfigInt("UseVBO", 0)
			Spring.SetConfigInt("advgraphics", 0)
			Spring.SetConfigInt("immersiveborder", 0)
			end
	
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