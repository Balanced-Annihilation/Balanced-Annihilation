---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 14-Nov-18 9:19 AM
---
function gadget:GetInfo()
    return {
        name      = "Spawn Geothermals",
        desc      = "Spawn neutral geothermals on top of geovents at game start",
        author    = "MaDDoX",
        date      = "November 2018",
        license   = "GNU GPL, v2 or later",
        layer     = 0,
        enabled   = true,
    }
end

if gadgetHandler:IsSyncedCode() then
    -----------------
    ---- SYNCED
    -----------------

    local spGetAllFeatures = Spring.GetAllFeatures
    --local spGetGameFrame = Spring.GetGameFrame
    local spGetFeatureDefID = Spring.GetFeatureDefID
    local spGetFeaturePosition = Spring.GetFeaturePosition
    local spCreateUnit = Spring.CreateUnit
    local spSetUnitNeutral = Spring.SetUnitNeutral
    local initialized = false
    local geoThermal = UnitDefNames["armgeo"].id

    local geoThermals = {}  -- { [unitID]={x,y,z}, ... }
    local minSpawnDistance = 150    -- This prevents duplicated geothermals in faulty maps
    --local respawnTime = 60 -- in frames; 60f = 2s
    --local geosToRespawn = {}

    local function sqr (x)
        return math.pow(x, 2)
    end
    local function distance (x1, y1, z1, x2, y2, z2 )
        return math.sqrt(sqr(x2-x1) + sqr(y2-y1) + sqr(z2-z1))
    end

    local function GeoNearby(x,y,z)
        if x == nil or y == nil or z == nil then
            return false end
        for _, pos in pairs(geoThermals) do
            if distance(pos.x, pos.y, pos.z, x, y, z) < minSpawnDistance then
                return true
            end
        end
        return false
    end

    local function SpawnGeothermal(x,y,z)
        if not GeoNearby(x,y,z) then
            -- Spring.GetGroundHeight(x, z)
            local gaiaTeamID = Spring.GetGaiaTeamID()
            local unitID = spCreateUnit(geoThermal, x, y, z, 0, gaiaTeamID)
            geoThermals[unitID]={x=x, y=y, z=z}
            spSetUnitNeutral(unitID, true)
            --Spring.SetUnitNoSelect( unitID, true )
        end
    end

    --function gadget:GameFrame(frame)
    function gadget:GameStart()
        --if not initialized and frame > 0 then
            --Spring.Echo("Found gaia team id: "..gaiaTeamID)
            local allFeatures = spGetAllFeatures()
            for i, featureID in ipairs(allFeatures) do
                local featureDefID = spGetFeatureDefID(featureID)
                --Spring.Echo(FeatureDefs[featureDefID].name)
                if FeatureDefs[featureDefID].name == "geovent" then
                    -- Spawn Geothermal at feature position
                    local x,y,z = spGetFeaturePosition(featureID)
                    SpawnGeothermal(x,y,z)
                end
            end
            --initialized = true
        --end
    end

    --function gadget:FeaturePreDamaged(featureID, featureDefID, featureTeam, damage, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
    --    --if featureID:find("geothermal") then
    --    --Spring.Echo("Dmg feature name: "..FeatureDefs[featureDefID].name)
    --    if FeatureDefs[featureDefID].name:lower():find("armgeo") then
    --        return 0, 0 -- newDamage, impulseMult
    --    end
    --end

    --function gadget:UnitDestroyed(unitID, unitDefID, unitTeamID)
    --    local geo = geoThermals[unitID]
    --    if geo then
    --        geosToRespawn[unitID] = { x=geo.x, y=geo.y, z = geo.z, time = Spring.spGetGameFrame() + respawnTime }
    --    end
    --    --local featureDef   = FeatureDefs[featureDefID or -1] or {height=0,name=''}
    --end
    --
    --function gadget:GameFrame(n)
    --    for unitID, data in pairs(geosToRespawn) do
    --        if data.time >= n then
    --            Spring.CreateFeature("armgeo_heap", data.x, data.y, data.z)
    --        --    ( string "defName" | number featureDefID,
    --        --number x, number y, number z
    --        --[, number heading
    --        --[, number AllyTeamID
    --        --[, number featureID ]]] ) -> number featureID
    --
    --        end
    --    end
    --end

else
    -----------------
    ---- UNSYNCED
    -----------------

    ---- Here we'll make the 'capture' cursor the default action on top of geothermals
    ---- for commanders and capture-enabled builders

    local spGetMouseState = Spring.GetMouseState
    local spTraceScreenRay = Spring.TraceScreenRay
    --local spAreTeamsAllied = Spring.AreTeamsAllied
    --local spGetUnitTeam = Spring.GetUnitTeam
    local spGetUnitDefID = Spring.GetUnitDefID
    local spGetSelectedUnits = Spring.GetSelectedUnits
    --local spGetLocalTeamID = Spring.GetLocalTeamID
    local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
    local spGetUnitCmdDescs = Spring.GetUnitCmdDescs
    local CMD_CAPTURE = CMD.CAPTURE

    local strUnit = "unit"

    local geothermalsDefIDs = {
        [UnitDefNames["armgeo"].id] = true,
        [UnitDefNames["armageo"].id] = true,
        [UnitDefNames["armgmm"].id] = true,
    }

    function gadget:DefaultCommand()
        local function isGeothermal(unitDefID)
            return geothermalsDefIDs[unitDefID]
        end
        local mx, my = spGetMouseState()
        local s, targetID = spTraceScreenRay(mx, my)
        if s ~= strUnit then
            return false end

        --if not spAreTeamsAllied(myTeamID, spGetUnitTeam(targetID)) then
        --    return false
        --end

        -- Only proceed if target is one of the geothermal variations
        local targetDefID = spGetUnitDefID(targetID)
        if not isGeothermal(targetDefID) then
            return false end

        -- If any of the selected units is a capturer, default to 'capture'
        local sUnits = spGetSelectedUnits()
        --local teamID = spGetLocalTeamID()

        for i=1,#sUnits do
            local unitID = sUnits[i]
            local unitDef = UnitDefs[spGetUnitDefID(unitID)]
            if unitDef.customParams.iscommander then
                return CMD_CAPTURE
            end
            if unitDef.canCapture then
                -- Check if the units has capture enabled already
                local cmdIdx = spFindUnitCmdDesc(unitID, CMD_CAPTURE)
                local cmdDesc = spGetUnitCmdDescs(unitID, cmdIdx, cmdIdx)[1]
                if not cmdDesc.disabled then
                    return CMD_CAPTURE end
            end
        end
        return false
    end

end
