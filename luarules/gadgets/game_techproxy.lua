---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 14-Nov-18 9:19 AM
---
function gadget:GetInfo()
    return {
        name      = "Tech Proxy",
        desc      = "Once a Tech-Proxy unit is finished, grant tech and destroy unit",
        author    = "MaDDoX",
        date      = "20 November 2018",
        license   = "GNU GPL, v2 or later",
        layer     = -1,
        enabled   = false,
    }
end

include("LuaRules/Configs/customcmds.h.lua")

if gadgetHandler:IsSyncedCode() then
-----------------
---- SYNCED
-----------------

    local spGetUnitDefID = Spring.GetUnitDefID
    --local spGetAllUnits	= Spring.GetAllUnits
    --local spGetUnitIsCloaked = Spring.GetUnitIsCloaked
    --local spSetUnitStealth = Spring.SetUnitStealth --spSetUnitStealth(unitID, iscloaked)
    local spGetUnitTeam = Spring.GetUnitTeam

    function gadget:UnitFinished(unitID, unitDefID)
        local uDef = UnitDefs[unitDefID]
        local techToGrant = uDef.customParams.granttech
        if not uDef or not techToGrant then
            return end
        Spring.Echo("Tech Proxy found: "..uDef.name)
        local ownerTeam = spGetUnitTeam(unitID)
        GG.TechGrant(uDef.name, ownerTeam, true)
        --TODO: Enable unit buttons which use this tech
        -- Search in allUnits for cmdDescs with the same name (or maybe bt_tech)
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
