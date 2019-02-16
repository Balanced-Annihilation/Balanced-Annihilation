function gadget:GetInfo()
	return {
		name = "ReverseMovementHandler",
		desc = "Disables reverse-move for unit's with move commands, when ctrl is held",
		author = "[Fx]Doo, modified by MaDDoX",
		date = "27 of July 2017",
		license = "Free",
		layer = 0,
		enabled = false, --true,
	}
end

include("LuaRules/Configs/customcmds.h.lua")

if (gadgetHandler:IsSyncedCode()) then
	reverseUnit = {}
	refreshList = {}

	function gadget:UnitCreated(unitID)
		local unitDefID = Spring.GetUnitDefID(unitID)
		if UnitDefs[unitDefID].rSpeed ~= nil and UnitDefs[unitDefID].rSpeed ~= 0 then
			reverseUnit[unitID] = unitDefID
		end
	end
	
	function gadget:UnitDestroyed(unitID) -- Erase killed units from table
			reverseUnit[unitID] = nil
			refreshList[unitID] = nil
	end
	
	function gadget:Initialize()
		for ct, unitID in pairs(Spring.GetAllUnits()) do
			gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
		end
	end
	
	function gadget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag, synced)
        if reverseUnit[unitID] and
            cmdID == CMD.MOVE or cmdID == CMD.ATTACK or cmdID == CMD_AREAATTACK then
			refreshList[unitID] = unitDefID
		end
	end
	
	function gadget:UnitIdle(unitID, unitDefID)
		if reverseUnit[unitID] then
			refreshList[unitID] = unitDefID
		end
	end
	
	function gadget:UnitCmdDone(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOpts, cmdTag)
		if reverseUnit[unitID] then
			refreshList[unitID] = unitDefID
		end
	end

    local function setMoveOptions (unitID, maxSpeed, maxReverseSpeed)
        Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxSpeed", maxSpeed)
        Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxReverseSpeed", maxReverseSpeed)
    end
	
	function gadget:GameFrame(f)
			for unitID, unitDefID in pairs(refreshList) do
                if not UnitDefs[unitDefID].canFly then
                    local cmd = Spring.GetUnitCommands(unitID, 1)
                    if cmd and cmd[1] and cmd[1]["options"] and cmd[1]["options"].ctrl then
                        setMoveOptions (unitID, UnitDefs[unitDefID].speed, 0)
                    else
                        setMoveOptions (unitID, UnitDefs[unitDefID].speed, UnitDefs[unitDefID].rSpeed)
                    end
                end
				refreshList[unitID] = nil
			end
	end
end