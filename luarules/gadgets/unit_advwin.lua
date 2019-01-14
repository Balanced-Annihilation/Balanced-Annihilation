-----------------------------------------------
-----------------------------------------------
---
--- file: unit_advwin.lua
--- brief: Adds 50% more energy to Advanced Wind Generators
--- author: Breno 'MaDDoX' Azevedo
--- DateTime: 4/11/2018 1:42 AM
---
--- License: GNU GPL, v2 or later.
---
-----------------------------------------------
-----------------------------------------------

function gadget:GetInfo()
    return {
        name      = "Unit Adv Wind",
        desc      = "Adds additional energy output to Advanced Wind Generators",
        author    = "MaDDoX",
        date      = "Apr, 2018",
        license   = "GNU GPL, v2 or later",
        layer     = 1,
        enabled   = true
    }
end

local spWind                = Spring.GetWind
local gmMinWind             = Game.windMin
local gmMaxWind             = Game.windMax
local windMultiplier        = 4.5
local spSetUnitResourcing   = Spring.SetUnitResourcing
local updateRate = 6    -- how Often, in frames, to update the value

-- Synced only
if not gadgetHandler:IsSyncedCode() then
    return end

local advWinds = {}     --[unitID] = true

-- Check if an adv. windgen was built, adding it to the table if so
function gadget:UnitFinished(unitID, unitDefID, teamID)
    local ud = UnitDefs[unitDefID]
    if ud == nil then
        return end
    --Spring.Echo("Unit added, specialty: "..ud.customParams.specialty.." Tier: "..ud.customParams.tier)
    if ud.customParams.specialty == "wind" and ud.customParams.tier == "2" then
        advWinds[unitID]=true
        --Spring.Echo("Added adv. wind generator")
    end
end

function gadget:GameFrame(f)
    if f % updateRate > 0.0001 then
        return end

    local _, _, _, currentWind = spWind()
    -- 25 is the maximum wind speed in TA Prime and BA
    currentWind = math.min(math.min(currentWind, gmMaxWind), 25)
    --Spring.Echo("max:"..gmMaxWind.."current: "..currentWind)
    for unitID,_ in pairs(advWinds) do
        --Spring.AddUnitResource(unitID, 'energy',  math.round(currentWind / 10))
        spSetUnitResourcing (unitID, 'ume', currentWind * windMultiplier)
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
    advWinds[unitID] = nil
end