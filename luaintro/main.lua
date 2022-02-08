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
			Spring.SetConfigInt("immersiveborder", 0)
			end
			Spring.SetConfigString("UsePBO", "0")
Spring.SetConfigString("AdvSky", "0") --always disable this
Spring.SetConfigString("DynamicSky", "0") --always disable this
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
