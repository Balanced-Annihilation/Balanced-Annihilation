--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    gui_game_type_info.lua
--  brief:   informs players of the game type at start (i.e. Comends, lineage, com continues(killall) , commander control or commander mode)
--  author:  Riku Eischer
--
--  Copyright (C) 2008.
--  Licensed under the terms of the GNU GPL, v2 or later.
--  Thanks to trepan (Dave Rodgers) for the original CommanderEnds widget
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "GameTypeInfo",
    desc      = "informs players of the game type at start",
    author    = "Teutooni",
    date      = "Jul 6, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Automatically generated local definitions

local glPopMatrix      = gl.PopMatrix
local glPushMatrix     = gl.PushMatrix
local glRotate         = gl.Rotate
local glScale          = gl.Scale
local glText           = gl.Text
local glTranslate      = gl.Translate
local spGetGameSeconds = Spring.GetGameSeconds

local message = ""
local message2 = ""
local message3 = ""

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local font
include("colors.h.lua")

local floor = math.floor


local vsx, vsy = widgetHandler:GetViewSizes()
function widget:ViewResize(viewSizeX, viewSizeY)
		font = WG['fonts'].getFont(nil, 1.4, 0.35, 1.4)

  vsx = viewSizeX
  vsy = viewSizeY
end

function widget:Initialize()
  if Spring.GetModOptions().deathmode=="com" then
    message = "Kill all enemy Commanders"
  elseif Spring.GetModOptions().deathmode=="killall" then
    message = "Kill all enemy units"
  elseif Spring.GetModOptions().deathmode=="neverend" then
    widgetHandler:RemoveWidget()
  end
  
  if (tonumber(Spring.GetModOptions().mo_preventcombomb) or 0) ~= 0 then
	message2 = "Commanders survive DGuns and commander explosions"
  end
  
  if (tonumber(Spring.GetModOptions().mo_armageddontime) or -1) > 0 then
    plural = ""
    if tonumber(Spring.GetModOptions().mo_armageddontime) ~= 1 then
        plural = "s"
    end
    message3 = "Armageddon at " .. Spring.GetModOptions().mo_armageddontime .. " minute" .. plural
  end
end
	


function widget:DrawScreen()
  if (spGetGameSeconds() > 0) then
    widgetHandler:RemoveWidget()
  end
  
  local timer = widgetHandler:GetHourTimer()
  local colorStr = WhiteStr
 		
  local msg = colorStr .. string.format("%s %s", "Gametype: ",  message)
  local msg2 = colorStr .. message2
  local msg3 = "\255\255\0\0" .. message3
  glPushMatrix()
  glTranslate((vsx * 0.5), (vsy * 0.22), 0) --has to be below where newbie info appears!
  glScale(2, 2, 1)
  
  
 font:Begin()
			font:Print("\255\255\255\255" .. msg, 0, 0, 24, "oc")
			font:Print("\255\255\255\255" .. msg2, 0, -30, 14, "oc")
			font:Print("\255\255\255\255" .. msg3, 0, -50, 12, "oc")

font:End()
  

  glPopMatrix()
end

function widget:GameOver()
  widgetHandler:RemoveWidget()
end

