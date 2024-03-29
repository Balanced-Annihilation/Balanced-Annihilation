--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    gui_team_platter.lua
--  brief:   team colored platter for all visible units
--  author:  Dave Rodgers
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "TeamPlatter",
    desc      = "Shows a team color platter above all visible units",
    author    = "trepan",
    date      = "Apr 16, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = -3,
    enabled   = false  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Automatically generated local definitions

local GL_LINE_LOOP           = GL.LINE_LOOP
local GL_TRIANGLE_FAN        = GL.TRIANGLE_FAN
local glBeginEnd             = gl.BeginEnd
local glColor                = gl.Color
local glCreateList           = gl.CreateList
local glDeleteList           = gl.DeleteList
local glDepthTest            = gl.DepthTest
local glDrawListAtUnit       = gl.DrawListAtUnit
local glLineWidth            = gl.LineWidth
local glPolygonOffset        = gl.PolygonOffset
local glVertex               = gl.Vertex
local spDiffTimers           = Spring.DiffTimers
local spGetAllUnits          = Spring.GetAllUnits
local spGetGroundNormal      = Spring.GetGroundNormal
local spGetSelectedUnits     = Spring.GetSelectedUnits
local spGetTeamColor         = Spring.GetTeamColor
local spGetTimer             = Spring.GetTimer
local spGetUnitBasePosition  = Spring.GetUnitBasePosition
local spGetUnitDefDimensions = Spring.GetUnitDefDimensions
local spGetUnitDefID         = Spring.GetUnitDefID
local spGetUnitRadius        = Spring.GetUnitRadius
local spGetUnitTeam          = Spring.GetUnitTeam
local spGetUnitViewPosition  = Spring.GetUnitViewPosition
local spIsUnitSelected       = Spring.IsUnitSelected
local spIsUnitVisible        = Spring.IsUnitVisible
local spSendCommands         = Spring.SendCommands

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local GetGaiaTeamID = Spring.GetGaiaTeamID () --+++
function widget:PlayerChanged() --+++
	GetGaiaTeamID = Spring.GetGaiaTeamID () --+++
end --+++



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local teamColors = {}

local trackSlope = true

local circleLines  = 0
local circlePolys  = 0
local circleDivs   = 32
local circleOffset = 0

local startTimer = spGetTimer()

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Initialize()
  circleLines = glCreateList(function()
    glBeginEnd(GL_LINE_LOOP, function()
      local radstep = (2.0 * math.pi) / circleDivs
      for i = 1, circleDivs do
        local a = (i * radstep)
        glVertex(math.sin(a), circleOffset, math.cos(a))
      end
    end)
  end)

  circlePolys = glCreateList(function()
    glBeginEnd(GL_TRIANGLE_FAN, function()
      local radstep = (2.0 * math.pi) / circleDivs
      for i = 1, circleDivs do
        local a = (i * radstep)
        glVertex(math.sin(a), circleOffset, math.cos(a))
      end
    end)
  end)


end


function widget:Shutdown()
  glDeleteList(circleLines)
  glDeleteList(circlePolys)

end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local realRadii = {}


local function GetUnitDefRealRadius(udid)
  local radius = realRadii[udid]
  if (radius) then
    return radius
  end

  local ud = UnitDefs[udid]
  if (ud == nil) then return nil end

  local dims = spGetUnitDefDimensions(udid)
  if (dims == nil) then return nil end

  local scale = ud.hitSphereScale -- missing in 0.76b1+
  scale = ((scale == nil) or (scale == 0.0)) and 1.0 or scale
  radius = dims.radius / scale /1.275
  
  if (ud.isBuilding or ud.isFactory or ud.speed==0) then
		radius = dims.radius / scale /1.5
	end
  
  realRadii[udid] = radius
  

  
  return radius
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local teamColors = {}


local function GetTeamColorSet(teamID)
  local colors = teamColors[teamID]
  if (colors) then
    return colors
  end
  local r,g,b = spGetTeamColor(teamID)
  
  colors = {{ r, g, b, 0.235 },
            { r, g, b, 0.235 }}
  teamColors[teamID] = colors
  return colors
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:DrawWorldPreUnit()
  --glLineWidth(3.0)

  glDepthTest(true)
  
  glPolygonOffset(-50, -2)

  local lastColorSet = nil
  for _,unitID in ipairs(spGetAllUnits()) do
    if (spIsUnitVisible(unitID)) then
      local teamID = spGetUnitTeam(unitID)
      if (teamID and teamID~=GetGaiaTeamID) then	--+++
        local udid = spGetUnitDefID(unitID)
        local radius = GetUnitDefRealRadius(udid)
        if (radius) then
          local colorSet  = GetTeamColorSet(teamID)
          if (trackSlope and (not UnitDefs[udid].canFly)) then
            local x, y, z = spGetUnitBasePosition(unitID)
            local gx, gy, gz = spGetGroundNormal(x, z)
            local degrot = math.acos(gy) * 180 / math.pi
            glColor(colorSet[1])
            glDrawListAtUnit(unitID, circlePolys, false,
                             radius, 1.0, radius,
                             degrot, gz, 0, -gx)

          else
            glColor(colorSet[1])
            glDrawListAtUnit(unitID, circlePolys, false,
                             radius, 1.0, radius)

          end
        end
      end
    end
  end

  glPolygonOffset(false)
end
              

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
