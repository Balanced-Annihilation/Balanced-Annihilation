--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    main.lua
--  brief:   the entry point from LuaUI
--  author:  jK
--
--  Copyright (C) 2011-2013.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

LUA_NAME    = Script.GetName()
LUA_DIRNAME = Script.GetName() .. "/"
LUA_VERSION = Script.GetName() .. " v1.0"

_G[("%s_DIRNAME"):format(LUA_NAME:upper())] = LUA_DIRNAME -- creates LUAUI_DIRNAME
_G[("%s_VERSION"):format(LUA_NAME:upper())] = LUA_VERSION -- creates LUAUI_VERSION

VFS.DEF_MODE = VFS.RAW_FIRST


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- Initialize the Lua LogSection (else messages with level "info" wouldn't been shown)
--

if Spring.SetLogSectionFilterLevel then
	Spring.SetLogSectionFilterLevel(LUA_NAME, "info")
else
	-- backward compability
	local origSpringLog = Spring.Log

	Spring.Log = function(name, level, ...)
		if (type(level) == "string")and(level == "info") then
			Spring.Echo(("[%s]"):format(name), ...)
		else
			origSpringLog(name, level, ...)
		end
	end
end

--------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- Load
--

VFS.Include("LuaHandler/Utilities/utils.lua", nil, VFS.DEF_MODE)

--// the addon handler
include "LuaHandler/handler.lua"

--// print Lua & LuaUI version
Spring.Log(LUA_NAME, "info", LUA_VERSION .. " (" .. _VERSION .. ")")


   



local bafirstlaunchsetupiscomplete = Spring.GetConfigString('bafirstlaunchsetupiscomplete', "missing") --remove later
if bafirstlaunchsetupiscomplete ~= "done" then
   		Spring.SetConfigString("bafirstlaunchsetupiscomplete", 'done')
		
		
		Spring.SetConfigString("UseNetMessageSmoothingBuffer", "0")
	Spring.SetConfigString("NetworkLossFactor", "2")
	Spring.SetConfigString("LinkOutgoingBandwidth", "262144")
	Spring.SetConfigString("LinkIncomingSustainedBandwidth", "262144")
	Spring.SetConfigString("LinkIncomingPeakBandwidth", "262144")
	Spring.SetConfigString("LinkIncomingMaxPacketRate", "2048")

		
		Spring.SetConfigInt("immersiveborder", 0)
			Spring.SetConfigInt("MSAALevel", 0)

			
		--widgetHandler:EnableWidget("Adaptive graphics")
		--widgetHandler:EnableWidget("Commands FX")
		Spring.SetConfigString("immersiveborder", "0")
		Spring.SetConfigString("advgraphics", "1")
		Spring.SetConfigString("MSAALevel", "0")
		Spring.SetConfigString("UseNetMessageSmoothingBuffer", "0")
		Spring.SetConfigString("Water", "1")
		Spring.SetConfigString("ProfanityFilter", "1")
		Spring.SetConfigString("chatsound", "1")
		Spring.SetConfigString("reduceping", "1")
		Spring.SetConfigString("GroundDecals", "1")
		Spring.SetConfigString("LuaShaders", "1")
		Spring.SetConfigString("GroundDetail" , "80")
		Spring.SetConfigInt("MaxNanoParticles", 3000)
		Spring.SetConfigInt("MaxParticles", 30000)
		Spring.SetConfigInt("AdvMapShading", 1)
		Spring.SetConfigInt("AdvUnitShading", 1)
		Spring.SetConfigInt("EdgeMoveWidth", 0.1)
		Spring.SetConfigString("MouseDragScrollThreshold", "0.3")
		Spring.SetConfigInt("UnitIconDist", 200)
	
		Spring.SetConfigInt("FeatureDrawDistance", 99999999)
		Spring.SetConfigInt("FeatureFadeDistance", 99999999)
		Spring.SetConfigInt("Shadows", 1)
Spring.SetConfigInt("ShadowMapSize", 4096)
end

			Spring.SetConfigInt("AllowDeferredMapRendering", 1)
			Spring.SetConfigInt("AllowDeferredModelRendering", 1)
			Spring.SetConfigInt("AdvMapShading", 1)
			Spring.SetConfigInt("AdvModelShading", 1)
Spring.SetConfigString("UnitLodDist", "99999999")

Spring.SetConfigInt("HangTimeout", -1)
Spring.SetConfigInt("snd_airAbsorption", 0)

	Spring.SetConfigString("GuiOpacity", "0.6")
	Spring.SetConfigString("AdvSky", "0") --always disable this
	Spring.SetConfigString("Vsync", "0")
	Spring.SetConfigString("GrassDetail", "0")
	Spring.SetConfigString("MiniMapDrawProjectiles", "0")
	Spring.SetConfigString("UsePBO", "0")
	local value = tonumber(Spring.GetConfigInt("advgraphics", 1) or 1) --set ultra graphics on first launch, otherwise to 1
	Spring.SetConfigInt("advgraphics", value) --add 1 to advgraphics value, if there was no BA version recorded
	
	
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
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
