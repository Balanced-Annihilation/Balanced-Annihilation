function widget:GetInfo()
  return {
    name      = "MoreSounds",
    desc      = "More sounds",
    author    = "TheFatController",
    date      = "30 Sep 2009",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local activateSounds = {}
local GetUnitPosition = Spring.GetUnitPosition
local PlaySoundFile = Spring.PlaySoundFile
local configVolume = tonumber(Spring.GetConfigString("snd_volunitreply"))
local volume = ((configVolume or 100) / 100)

function widget:Initialize()
  for unitDefID,defs in pairs(UnitDefs) do
    if defs["sounds"]["select"][1] and (not (defs["sounds"]["activate"][1])) then
      activateSounds[unitDefID] = ("sounds/" .. defs["sounds"]["select"][1]["name"] .. ".wav")
    end
  end
end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
  if activateSounds[unitDefID] then
    local x,y,z = GetUnitPosition(unitID)
    PlaySoundFile(activateSounds[unitDefID],volume,x,y,z)
  end
end
  
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------