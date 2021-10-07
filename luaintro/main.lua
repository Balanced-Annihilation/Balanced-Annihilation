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



local firstlaunchsetupDone = Spring.GetConfigString('bafirstlaunchsetupDone1', "missing")
   
if firstlaunchsetupDone ~= "done" then
Spring.SetConfigInt("AllowDeferredMapRendering", 1)
Spring.SetConfigInt("AllowDeferredModelRendering", 1)

end
Spring.SetConfigInt("AdvMapShading", 1)

local enableimmersiveborderonce = Spring.GetConfigString('enableimmersiveborderfirst', "missing") --remove later
if enableimmersiveborderonce ~= "done" then
   		Spring.SetConfigString("enableimmersiveborderfirst", 'done')
		Spring.SetConfigString("immersiveborder", '1')
		--Spring.SetConfigString("advgraphics", '1')
		--Spring.SetConfigString("MSAALevel", '2')
end
Spring.SetConfigInt("HangTimeout", -1)
--Spring.SetConfigInt("Sound", "false")
Spring.SetConfigInt("snd_airAbsorption", 0)

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
