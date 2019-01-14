--
-- Created by IntelliJ IDEA.
-- User: Breno Azevedo
-- Date: 8/19/2017
-- Time: 9:17 PM
--
-- So that's what this does:
-- 1. Has a 'allPlayerUnits' table, ignoring NPC units (fed during unitCreation)
--      1.5. Sync/update only this players' units, let the others do their work
--      -- Fix/TODO: spectator mode should require Spring.GetAllyTeamList and Spring.GetGaiaTeamID( ) -> number teamID
-- 2. Stores the defaultMapHeight on start (optional -> map based `minMapHeight` value)
-- 3. Update all those units every 10 FPS (optimization -> have 5 or so tables, update on different times)
-- -- 3.5. Math will always be losScaler = math.max((unit.y / defaultMapHeight), maxLosScaler)
-- --       unit.LOS = baseLOS * losScaler

--Spring.SetUnitSensorRadius ( number unitID, string type, number radius ) -> nil | number newRadius
--type can be:
--"los","airLos","radar","sonar","seismic","radarJammer","sonarJammer"

-- TODO: Increase LOS only when close to edge of cliff. Code sample: https://github.com/ZeroK-RTS/Zero-K/blob/master/LuaRules/Gadgets/unit_spherical_los.lua

function gadget:GetInfo()
    return {
        name = "LOS Scaler",
        desc = "Updates Units LOS according to height",
        author = "Breno 'MaDDoX' Azevedo",
        date = "Aug 20 2017",
        license = "Free",
        layer = 0,
        version = 1,
        enabled = true,
    }
end

if (not gadgetHandler:IsSyncedCode()) then
    return false
end

VFS.Include("gamedata/taptools.lua")

local allUnits = {}        -- all units' unitIDs
local maxLosScaler = 1.75  -- 2.5
local minMapHeight = 100        -- We get this from the map, this is just a default
local maxMapHeightDelta = 464   -- 564 is DSD's highest, 100 is its lowest. Using that as reference.
local maxMapHeight = 565        -- Any y Position above this delta will cap @ maxLosScaler
local gaiaTeam = 2
--local unitDefs -- = DEFS.unitDefs
--local unitDefsData = VFS.Include("gamedata/unitdefs_data.lua")
--local myTeamID = Spring.GetMyTeamID
--local allyTeamVec = Spring.GetAllyTeamList

---- Support /luarules reload
function gadget:Initialize()
    gaiaTeam = Spring.GetGaiaTeamID()
    local readHeight = Spring.GetMapOptions().minMapHeight
    minMapHeight = (readHeight == nil)
            and Spring.GetGroundExtremes()
            or readHeight
    maxMapHeight = minMapHeight + maxMapHeightDelta
--    if (readHeight ~= nil) then
--        minMapHeight = readHeight
--    else
--        minMapHeight = Spring.GetGroundExtremes()
--    end
    Spring.Echo("unit_los_scaler :: Found MinMapHeight = "..minMapHeight)
    for _,unitID in ipairs(Spring.GetAllUnits()) do
        local teamID = Spring.GetUnitTeam(unitID)
        local unitDefID = Spring.GetUnitDefID(unitID)
        gadget:UnitCreated(unitID, unitDefID, teamID)
    end
end

---- Adds valid units to the myUnits table
function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
    -- TODO: Only add/remove mobile units from the list
    --Spring.Echo(" spawned team: "..teamID.." Gaia: "..Spring.GetGaiaTeamID())
    --if teamID == gaiaTeam then
    --    return end
    allUnits[#allUnits +1] = unitID
end

---- Remove valid units from the myUnits table
function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeam)
    --if teamID == gaiaTeam then
    --    return end

    local list_size = #allUnits
    local i = 1
    while i <= list_size do
        if allUnits[i] == unitID then
            table.remove(allUnits, i)
            list_size = list_size - 1
        else
            i = i + 1
        end
    end
end

-- Runs every 10 frames (3 FPS)
function gadget:GameFrame(frame)
    if (frame % 10 == 0) then
        for _,unitID in ipairs(allUnits) do
            local unitDefID = Spring.GetUnitDefID(unitID)   -- optimize by cache?
            if unitDefID then
                local uDef = UnitDefs[unitDefID]
                local defaultLOS = uDef.losRadius
                local defaultAirLOS = uDef.airLosRadius
                local _,unitYpos,_ = Spring.GetUnitPosition(unitID)
                local losScaler = lerp(1, maxLosScaler, inverselerp(minMapHeight, maxMapHeight, unitYpos))
                Spring.SetUnitSensorRadius ( unitID, "los", defaultLOS * losScaler )
                Spring.SetUnitSensorRadius ( unitID, "airLos", defaultAirLOS * losScaler )
                --Spring.Echo(" new LOS: "..newLOS)
            end
        end
    end
end
