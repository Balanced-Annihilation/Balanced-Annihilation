-- $Id: gui_xp.lua 3395 2008-12-09 16:28:55Z lurker $
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Rank Icons",
    desc      = "Shows a rank icon depending on experience next to units",
    author    = "trepan (idea quantum,jK)",
    date      = "Feb, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 5,
    enabled   = true  -- loaded by default?
  }
end
--Version = 1.1 (fix on line 173-178 for crash at line 179, commit on 19.12.2011, xponen)
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

-- speed-ups
local GetUnitDefID         = Spring.GetUnitDefID
local GetUnitDefDimensions = Spring.GetUnitDefDimensions
local GetUnitExperience    = Spring.GetUnitExperience
local GetTeamList          = Spring.GetTeamList
local GetTeamUnits         = Spring.GetTeamUnits
local GetAllUnits          = Spring.GetAllUnits
local GetMyAllyTeamID      = Spring.GetMyAllyTeamID
local IsUnitAllied         = Spring.IsUnitAllied
local GetSpectatingState   = Spring.GetSpectatingState

local glDepthTest      = gl.DepthTest
local glDepthMask      = gl.DepthMask
local glAlphaTest      = gl.AlphaTest
local glTexture        = gl.Texture
local glTexRect        = gl.TexRect
local glTranslate      = gl.Translate
local glBillboard      = gl.Billboard
local glDrawFuncAtUnit = gl.DrawFuncAtUnit
local IsUnitInView = Spring.IsUnitInView
local spGetCameraPosition = Spring.GetCameraPosition


local GL_GREATER = GL.GREATER

local floor = math.floor
local min = math.min
local max = math.max

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

local unitHeights  = {}
local ranks = {
	[0] = {},
	[1] = {},
	[2] = {},
	[3] = {},
	[4] = {},
	[5] = {},
	[6] = {},
	[7] = {},
	[8] = {},

}
local numRanks = #ranks
local PWUnits = {}

local myAllyTeamID = 666


local iconsize   = 6
local iconoffset = 28

local rankTexBase = 'LuaUI/Images/Ranks/'
local rankTextures = {
	[0] = nil,
	[1] = rankTexBase .. 'rank1.png',
	[2] = rankTexBase .. 'rank2.png',
	[3] = rankTexBase .. 'rank3.png',
	[4] = rankTexBase .. 'rank4.png',
	[5] = rankTexBase .. 'rank5.png',
	[6] = rankTexBase .. 'rank6.png',
	[7] = rankTexBase .. 'rank7.png',
	[8] = rankTexBase .. 'rank8.png',

}

local numRanks = #ranks
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function PWCreate(unitID)
  PWUnits[unitID] = true
  SetUnitRank(unitID)
end

local function getRank(unitDefID, xp)
	return max(0, min(floor(xp / UnitDefs[unitDefID].power_xp_coeffient),numRanks))
end


function widget:Initialize()

	WG['rankicons'] = {}
	WG['rankicons'].getRank = function(unitDefID, xp)
		return getRank(unitDefID, xp)
	end
	WG['rankicons'].getRankTextures = function(unitDefID, xp)
		return rankTextures
	end


  for udid, ud in pairs(UnitDefs) do
    -- 0.15+2/(1.2+math.exp(Unit.power/1000))
    --ud.power_xp_coeffient  = ((ud.power / 1000) ^ -0.2) / numRanks  -- dark magic
	ud.power_xp_coeffient  = ((ud.power / 1000) ^ -0.2) / numRanks  -- dark magic
  end

  for _,unitID in pairs( GetAllUnits() ) do
    SetUnitRank(unitID)
  end
end

function widget:Shutdown()
  for _,rankTexture in ipairs(rankTextures) do
    gl.DeleteTexture(rankTexture)
  end
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------



function SetUnitRank(unitID)
  local ud = UnitDefs[GetUnitDefID(unitID)]
  if (ud == nil) then
    unitHeights[unitID] = nil
    return
  end

  local xp = GetUnitExperience(unitID)
  if (not xp) then
    unitHeights[unitID] = nil
    return
  end
  xp = min(floor(xp / ud.power_xp_coeffient),numRanks)

  unitHeights[unitID] = ud.height + iconoffset
    if (xp>0) then
      ranks[xp][unitID] = true
    end

end

function widget:UnitExperience(unitID,unitDefID,unitTeam, xp, oldXP)
  local ud = UnitDefs[unitDefID]
  if (ud == nil) then
    unitHeights[unitID] = nil
    return
  end
  if (not unitHeights[unitID]) then
    unitHeights[unitID] = { nil, ud.height + iconoffset}
  end
  if xp < 0 then xp = 0 end
  if oldXP < 0 then oldXP = 0 end
  
  local rank    = min(floor(xp / ud.power_xp_coeffient),numRanks)
  local oldRank = min(floor(oldXP / ud.power_xp_coeffient),numRanks)

  if (rank~=oldRank) then
    unitHeights[unitID] = ud.height + iconoffset
      for i=0,rank-1 do ranks[i][unitID] = nil end
      ranks[rank][unitID] = true
   
  end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
  if (IsUnitAllied(unitID)or(GetSpectatingState())) then
    SetUnitRank(unitID)
  end
end


function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
  unitHeights[unitID] = nil
  for i=0,numRanks do ranks[i][unitID] = nil end
  PWUnits[unitID] = nil
end


function widget:UnitGiven(unitID, unitDefID, oldTeam, newTeam)
  if (not IsUnitAllied(unitID))and(not GetSpectatingState())  then
    unitHeights[unitID] = nil
    for i=0,numRanks do ranks[i][unitID] = nil  end
  end
end


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local function DrawUnitFunc(yshift)
  glTranslate(1.25*iconsize,yshift,1.2*iconsize)
  glBillboard()
  glTexRect(-iconsize, -iconsize, iconsize, iconsize)
end


function widget:DrawWorld()
  if Spring.IsGUIHidden() then return end
  if (next(unitHeights) == nil) then
    return -- avoid unnecessary GL calls
  end

  	local camX, camY, camZ = spGetCameraPosition()


	
	

  if (camY <2500) then 
  
    local opacitymult = 1-((camY - 1290)/1290)
	if(opacitymult > 1) then
		opacitymult = 1
	end
  
  gl.Color(1,1,1,opacitymult)
  glDepthMask(true)
  glDepthTest(true)
  glAlphaTest(GL_GREATER, 0.001)
  
  for i=1,numRanks do
    if (next(ranks[i])) then
      glTexture( rankTextures[i] )
      for unitID,_ in pairs(ranks[i]) do
	  if IsUnitInView(unitID) then
        glDrawFuncAtUnit(unitID, false, DrawUnitFunc, unitHeights[unitID])
		end
      end
    end
  end
  
   glTexture(false)

  glAlphaTest(false)
  glDepthTest(false)
  glDepthMask(false)
end
 
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
