---
--- Created by Breno "MaDDoX" Azevedo.
--- Check gui_multi_tech for a system architecture description

function gadget:GetInfo()
    return {
        name      = "Tech Booster Level 3",
        desc      = "Speeds up all Morphs by 33%",
        author    = "MaDDoX",
        date      = "12 December 2018",
        license   = "GNU GPL, v2 or later",
        layer     = -1,
        enabled   = true,
    }
end

if gadgetHandler:IsSyncedCode() then
    -----------------
    ---- SYNCED
    -----------------

    local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
    local spEditUnitCmdDesc = Spring.EditUnitCmdDesc
    local spGetGameFrame = Spring.GetGameFrame
    local spDestroyUnit = Spring.DestroyUnit
    local spMarkerAddPoint = Spring.MarkerAddPoint--(x,y,z,"text",local? (1 or 0))
    local spGetUnitPosition = Spring.GetUnitPosition
    local spSendMessageToTeam = Spring.SendMessageToTeam

    local techCenters = {}      -- techCenters[ownerTeam][unitID]
    local upgradeState = {}     -- { [unitTeam] = { techCenterID = unitID, techProxyID = unitID,
                                --                  status = "nonupgraded","upgrading","upgraded" }, ... }
    --local CMD_CAPTURE = CMD.CAPTURE
    local internalMsg = "upgradeEvent"
    local upgradeName = "booster3"

    local color_yellow = "\255\255\255\1"   --yellow

    local techCentersDefIDs = {
        [UnitDefNames["armtech"].id] = true,
        [UnitDefNames["armtech1"].id] = true,
        [UnitDefNames["armtech2"].id] = true,
        [UnitDefNames["armtech3"].id] = true,
        [UnitDefNames["armtech4"].id] = true,
        [UnitDefNames["cortech"].id] = true,
        [UnitDefNames["cortech1"].id] = true,
        [UnitDefNames["cortech2"].id] = true,
        [UnitDefNames["cortech3"].id] = true,
        [UnitDefNames["cortech4"].id] = true,
    }

    local techProxycmdID = -UnitDefNames["techcapture"].id  -- This is the proxy unit's build CmdID

    local function setUpgradeState(teamID, status, techCenterID, techProxyID)
        upgradeState[teamID] = { status = status, techCenterID = techCenterID, techProxyID = techProxyID }
        --Spring.Echo("New State: "..status.." TechProxyID: "..(techProxyID or "nil"))
    end

    local function isUpgradedTeam(teamID)
        return upgradeState[teamID].status == "upgraded"
    end

    local function isTechProxy(unitDefID)
        local uDef = UnitDefs[unitDefID]
        if not uDef then
            return false end
        local techToGrant = uDef.customParams and uDef.customParams.granttech
        return techToGrant == upgradeName
    end

    --- checks if a given techProxy is this team's in-progress upgrade
    local function isTeamTechProxy(unitID, teamID)
        --Spring.Echo(" Unit: "..(unitID or "nil").." compared to: "..(upgradeState[teamID].techProxyID or "nil"))
        return upgradeState[teamID].techProxyID == unitID
    end

    local function startUpgrade(techProxyID, techCenterID, teamID)
        techCenters[teamID][techCenterID] = true
        setUpgradeState(teamID, "upgrading", techCenterID, techProxyID)
    end

    function gadget:Initialize()
        techCenters = {}
        upgradeState = {}
        -- Initialize upgradeStates for all valid player teams (including AI, if any, and Gaia)
        for _, teamID in ipairs(Spring.GetTeamList()) do
            setUpgradeState(teamID, "nonupgraded", nil, nil)
            techCenters[teamID] = {}
        end
    end

    local function blockUnit (unitID)
        Spring.SetUnitNoDraw (unitID, true)
        Spring.SetUnitNoSelect (unitID, true)
        Spring.SetUnitNoMinimap (unitID, true)
    end

    function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
        --- If upgrade is already completely, we have nothing to do here
        if not isUpgradedTeam(unitTeam) then
            --- Check for tech proxies being built, to set upgrade state accordingly
            if isTechProxy(unitDefID) then
                startUpgrade(unitID, builderID, unitTeam)
                blockUnit(unitID)
            end
        end
    end

    local function cancelUpgrade(unitTeam)
        setUpgradeState(unitTeam,"nonupgraded", nil, nil)
        SendToUnsynced(internalMsg, upgradeName, nil, nil, unitTeam, "nonupgraded")
    end

    function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions)
        if cmdID ~= techProxycmdID then
            return true
        end
        --- If team is already upgraded, don't allow command to go on
        if isUpgradedTeam(unitTeam) then
            return false end
        --- Otherwise, that's an upgrade command, allow it
        return true
    end

    -- This tracks the actual completion of the upgrade/tech-proxy
    function gadget:UnitFinished(unitID, unitDefID, unitTeam)
        if spGetGameFrame() <= 1 or not unitTeam then   -- Let's skip pre-spawned units (commanders etc)
            return end

        --- Let's now check if it's our target-tech proxy unit
        if not isTeamTechProxy(unitID, unitTeam) then
            return end

        --- Upgrade is complete, wrap things up
        local x,y,z = spGetUnitPosition(unitID)
        if x and y and z then
            spMarkerAddPoint(x,y,z,"", true) -- local message/marker
            spSendMessageToTeam(unitTeam, color_yellow.."Upgrade Finished: ".. upgradeName)
        end

        SendToUnsynced(internalMsg, upgradeName, nil, nil, unitTeam, "upgraded")
        setUpgradeState(unitTeam, "upgraded", nil, nil)
        spDestroyUnit(unitID,false,true)    -- Remove the proxy unit instantly (won't deadlock since TechProxyId was set to nil)

        --- Actually provides Tech (@ cmd_multi_tech) here
        GG.TechGrant(upgradeName, unitTeam, true)   -- Init = non-unit provided
        --Spring.Echo("Tech Granted: "..upgradeName)
        -- This is of no interest anymore, clean it up
        techCenters[unitTeam] = nil
    end

    function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
        --Spring.Echo("Unit destroyed: "..unitID.." state techCenter: "..(upgradeState[unitTeam].techCenterID or "nil")
        --            .." techProxy: "..(upgradeState[unitTeam].techProxyID or "nil"))

        -- An under-construction tech proxy was destroyed or cancelled
        if isTeamTechProxy(unitID, unitTeam) then
            --Spring.Echo("WIP tech proxy destroyed, team: "..unitTeam)
            cancelUpgrade(unitTeam)
        -- Below is never happening, probably because the techProxy is destroyed first
        elseif upgradeState[unitTeam].techCenterID == unitID then
            --Spring.Echo("WIP upgrade's tech center destroyed")
            cancelUpgrade(unitTeam)
        end
        if techCenters[unitTeam] then
            techCenters[unitTeam][unitID] = nil end
    end

    function gadget:UnitGiven(unitID, unitDefID, teamID)
        gadget:UnitFinished(unitID, unitDefID, teamID)
    end

else
-----------------
---- UNSYNCED
-----------------

    local internalMsg = "upgradeEvent"
    local externalMsg = "upgradeUIEvent3"

    local function handleUpgradeEvent(cmd, techID, techCenterID, techProxyID, unitTeam, status)
        ---- Now we create an event at unsynced space
        if Script.LuaUI(externalMsg) then
            Script.LuaUI[externalMsg](techID, techCenterID, techProxyID, unitTeam, status)
            --Spring.Echo("Sent event about "..unitID)
        end
    end

    ---- Wiring SendToUnsync message "upgradeEvent" to the unsync'd "handleUpgradeEvent" method
    function gadget:Initialize()
        gadgetHandler:AddSyncAction(internalMsg, handleUpgradeEvent)
    end

    function gadget:Shutdown()
        gadgetHandler:RemoveSyncAction(internalMsg)
    end

end
