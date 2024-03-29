--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    group_label.lua
--  brief:   displays label on units in a group
--  author:  gunblob
--
--  Copyright (C) 2008.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Group Label",
    desc      = "Displays label on units in a group",
    author    = "gunblob",
    date      = "June 12, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

local glPushMatrix				= gl.PushMatrix
local glTranslate				= gl.Translate
local glPopMatrix				= gl.PopMatrix
local glColor					= gl.Color
local glText					= gl.Text
local glBillboard				= gl.Billboard

local spGetGroupList			= Spring.GetGroupList
local spGetGroupUnits			= Spring.GetGroupUnits
local spGetUnitViewPosition 	= Spring.GetUnitViewPosition
local textColor = {0.7, 1.0, 0.7, 1.0}
local textSize = 12.0

local textSize = 14
local font
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Rendering
--

function widget:ViewResize()
	font = WG['fonts'].getFont(nil, 1.4, 0.35, 1.4)
end

function widget:DrawWorld()
   local groups = spGetGroupList()
   for group, _ in pairs(groups) do
      units = spGetGroupUnits(group)
      for _, unit in ipairs(units) do
         if Spring.IsUnitInView(unit) then
            local ux, uy, uz = spGetUnitViewPosition(unit)
            glPushMatrix()
            glTranslate(ux, uy, uz)
            glBillboard()
            glColor(textColor)
            font:Begin()
			font:Print("\255\200\255\200" .. group, -15.0, -10.0, textSize, "cno")
			font:End()
            glPopMatrix()
         end
      end
   end
end
