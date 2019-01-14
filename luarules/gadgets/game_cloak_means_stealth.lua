---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 20-Nov-18 3:45 AM
---
function gadget:GetInfo()
    return {
        name      = "Cloak means Stealth",
        desc      = "Makes unit become stealth whenever cloak is active",
        author    = "MaDDoX",
        date      = "20 November 2018",
        license   = "GNU GPL, v2 or later",
        layer     = 1,
        enabled   = true,
    }
end

if gadgetHandler:IsSyncedCode() then
-----------------
---- SYNCED
-----------------
    --local spGetGameFrame = Spring.GetGameFrame
    --local spGetFeaturePosition = Spring.GetFeaturePosition
    --local spCreateUnit = Spring.CreateUnit
    --local spSetUnitNeutral = Spring.SetUnitNeutral
    local spGetUnitDefID = Spring.GetUnitDefID
    local spGetAllUnits	= Spring.GetAllUnits
    local spGetUnitIsCloaked = Spring.GetUnitIsCloaked
    local spSetUnitStealth = Spring.SetUnitStealth --spSetUnitStealth(unitID, iscloaked)
    local initialized = false

    local trackedUnits = {}     -- [unitID] = true
    local mines = {}            -- {unitID=true, ..}
    local updateRate = 2        -- Update frame rate (every 2 frames)
    local customPingRate = 90   -- 1 ping every 3 seconds

    local mineIDs = {
        [UnitDefNames["armmine1"].id] = true,   -- Poker anti-inf mine
        [UnitDefNames["armmine3"].id] = true,   -- Poker anti-veh mine
        [UnitDefNames["cormine4"].id] = true,   -- Commando Flak mine
    }

    function gadget:UnitFinished(unitID, unitDefID)
        local uDef = UnitDefs[unitDefID]
        --Spring.Echo("unit "..unitID.." stealth: ".. (tostring(uDef.stealth) or "nul")
        --        .." can cloak: ".. (tostring(uDef.canCloak) or "nul"))

        -- We won't track mines and units which are already stealth or can't cloak
        if uDef == nil or uDef.stealth or (not uDef.canCloak) then
            return end
        if mineIDs[unitDefID] then
            --Spring.AddUnitSeismicPing(unitID, 1)
            mines[unitID]=true
            --Spring.SetUnitNoSelect( unitID, true )    -- return
        end
        trackedUnits[unitID]=true
    end

    function gadget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
        gadget:UnitFinished(unitID, unitDefID)
    end

    function gadget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
        gadget:UnitFinished(unitID, unitDefID)
    end

    function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
        trackedUnits[unitID] = nil
        mines[unitID]=nil
    end

    function gadget:GameFrame(frame)
        -- Add all supported game-start spawned units (aka. commanders)
        if not initialized and frame > 0 then
            local allUnits = spGetAllUnits()
            for _, unitID in ipairs(allUnits) do
                local unitDefID = spGetUnitDefID(unitID)
                gadget:UnitFinished(unitID, unitDefID)
            end
            initialized = true
        end
        if frame % customPingRate < 0.001 then
            for unitID,_ in pairs(mines) do
                Spring.AddUnitSeismicPing(unitID, 1)
            end
        end
        if frame % updateRate < 0.001 then
            for unitID,_ in pairs(trackedUnits) do
                --Spring.Echo("UnitID: "..unitID.." stealth = "..tostring(spGetUnitIsCloaked(unitID)) or "nil")
                spSetUnitStealth(unitID, spGetUnitIsCloaked(unitID))
            end
        end
    end

else
-----------------
---- UNSYNCED
-----------------

--local spGetMouseState = Spring.GetMouseState
--local spTraceScreenRay = Spring.TraceScreenRay
--local spAreTeamsAllied = Spring.AreTeamsAllied
--local spGetUnitTeam = Spring.GetUnitTeam
--local spGetUnitDefID = Spring.GetUnitDefID
--local spGetSelectedUnits = Spring.GetSelectedUnits
--local CMD_CAPTURE = CMD.CAPTURE
--
--local strUnit = "unit"
--
--local geothermalsDefIDs = {
--    [UnitDefNames["armgeo"].id] = true,
--    [UnitDefNames["amgeo"].id] = true,
--    [UnitDefNames["armgmm"].id] = true,
--}
--
--function gadget:DefaultCommand()
--    local function isGeothermal(unitDefID)
--        return geothermalsDefIDs[unitDefID]
--    end
--    local mx, my = spGetMouseState()
--    local s, targetID = spTraceScreenRay(mx, my)
--    if s ~= strUnit then
--        return false end
--
--    --if not spAreTeamsAllied(myTeamID, spGetUnitTeam(targetID)) then
--    --    return false
--    --end
--
--    -- Only proceed if target is one of the geothermal variations
--    local targetDefID = spGetUnitDefID(targetID)
--    if not isGeothermal(targetDefID) then
--        return false end
--
--    -- If any of the selected units is a commander, default to 'capture'
--    local sUnits = spGetSelectedUnits()
--    for i=1,#sUnits do
--        local unitID = sUnits[i]
--        --TODO: Should become `all capture-enabled units` (with the upgrade)
--        if UnitDefs[spGetUnitDefID(unitID)].customParams.iscommander then
--            return CMD_CAPTURE
--        end
--    end
--    return false
--end

end
