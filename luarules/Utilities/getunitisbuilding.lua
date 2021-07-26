-- $Id:$
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--
-- Author: jK @2010
-- License: GPLv2 and later
--
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local function IsFeatureInRange(unitID, featureID, range)
	range = range + 100 -- fudge factor
    local x,y,z = Spring.GetFeaturePosition(featureID)
    local ux,uy,uz = Spring.GetUnitPosition(unitID)
    return ((ux - x)^2 + (uz - z)^2) <= range^2
end

local function IsGroundPosInRange(unitID, x, z, range)
    local ux,uy,uz = Spring.GetUnitPosition(unitID)
    return ((ux - x)^2 + (uz - z)^2) <= range^2
end

function Spring.Utilities.GetUnitNanoTarget(unitID)
  local type = ""
  local target
  local isFeature = false
  local inRange

  local buildID = Spring.GetUnitIsBuilding(unitID)
  if (buildID) then
    target = buildID
    type   = "building"
    inRange = true
  else
    local unitDef = UnitDefs[Spring.GetUnitDefID(unitID)] or {}
    local buildRange = unitDef.buildDistance or 0
    local cmdID, _, _, cmdParam1, cmdParam2, cmdParam3, cmdParam4, cmdParam5 = Spring.GetUnitCurrentCommand(unitID, 1)
    if cmdID then

      if cmdID == CMD.RECLAIM then
        --// anything except "#cmdParams = 1 or 5" is either invalid or discribes an area reclaim
        if not cmdParam2 or cmdParam5 then
          local id = cmdParam1
          local unitID_ = id
          local featureID = id - Game.maxUnits

          if (featureID >= 0) then
            if Spring.ValidFeatureID(featureID) then
              target    = featureID
              isFeature = true
              type      = "reclaim"
	          inRange	= IsFeatureInRange(unitID, featureID, buildRange)
            end
          else
            if Spring.ValidUnitID(unitID_) then
              target = unitID_
              type   = "reclaim"
	          inRange = Spring.GetUnitSeparation(unitID, unitID_, true) <= buildRange
            end
          end
        end

      elseif cmdID == CMD.REPAIR  then
        local repairID = cmdParam1
        if Spring.ValidUnitID(repairID) then
          target = repairID
          type   = "repair"
	      inRange = Spring.GetUnitSeparation(unitID, repairID, true) <= buildRange
        end

      elseif cmdID == CMD.RESTORE then
        local x = cmdParam1
        local z = cmdParam3
        type   = "restore"
        target = {x, Spring.GetGroundHeight(x,z)+5, z, cmd.params[4]}
	    inRange = IsGroundPosInRange(unitID, x, z, buildRange)

      elseif cmdID == CMD.CAPTURE then
        if (not cmdParam2)or(cmdParam5) then
          local captureID = cmdParam1
          if Spring.ValidUnitID(captureID) then
            target = captureID
            type   = "capture"
	        inRange = Spring.GetUnitSeparation(unitID, captureID, true) <= buildRange
          end
        end

      elseif cmdID == CMD.RESURRECT then
        local rezzID = cmdParam1 - Game.maxUnits
        if Spring.ValidFeatureID(rezzID) then
          target    = rezzID
          isFeature = true
          type      = "resurrect"
	      inRange	= IsFeatureInRange(unitID, rezzID, buildRange)
        end

      end
    end
  end

  if inRange then
    return type, target, isFeature
  else
    return
  end
end