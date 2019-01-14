-----------------------------------------------
-----------------------------------------------
---
--- file: unit_movingsprayangle.lua
--- brief: Reads 'customParams.movingsprayangle' and applies it when unit is moving
--- author: Breno 'MaDDoX' Azevedo
--- DateTime: 4/11/2018 1:42 AM
---
--- License: GNU GPL, v2 or later.
---
-----------------------------------------------
-----------------------------------------------

function gadget:GetInfo()
    return {
        name      = "Unit Moving SprayAngle",
        desc      = "Applies custom SprayAngle when unit is moving",
        author    = "MaDDoX",
        date      = "Apr, 2018",
        license   = "GNU GPL, v2 or later",
        layer     = 1,
        enabled   = true
    }
end

--TODO: Interpolate (LERP) between min and max move speed to calculate spray angle

VFS.Include("gamedata/taptools.lua")

local spSetUnitWeaponState  = Spring.SetUnitWeaponState
local spGetUnitWeaponState  = Spring.GetUnitWeaponState
local spGetUnitVelocity     = Spring.GetUnitVelocity
local spGetUnitDefID        = Spring.GetUnitDefID
local updateRate = 5    -- how Often, in frames, to update the value
local minMoveSpeed = 1  -- move speed above which the custom sprayangle will kick in

-- Synced only
if not gadgetHandler:IsSyncedCode() then
    return end

local trackedUnits = {}     --[unitID] = movingsprayangle:number

-- 1/45055 circle - Used for accuracy and sprayAngle.

local function toDeg(x) return x / 182.044 end

function gadget:UnitFinished(unitID, unitDefID, teamID)
    local ud = UnitDefs[unitDefID]
    if ud == nil or ud.customParams.movingsprayangle == nil then
        return end
    local mSprayAngle = tonumber(ud.customParams.movingsprayangle)
    --local defSprayAngle = WeaponDefs[UnitDefs[ud].weapons[1].weaponDef].sprayangle
    --Spring.Echo(ud.weapons[1] and (ud.weapons[1]) or "null")
    local weapDef = WeaponDefs[ud.weapons[1].weaponDef]
    local defSprayAngle = tonumber(weapDef.sprayAngle)  -- Converting from CAU to angles
    -- Default Spray Angle is stored in CAU. Divide and make it in angles
    trackedUnits[unitID] = { movingsprayangle = toDeg(mSprayAngle), sprayangle = toDeg(defSprayAngle), weaponCount = #ud.weapons }
    --Spring.Echo("Unit added: "..ud.name.."defsprayangle: "..toDeg(defSprayAngle).." msprayangle: ".. toDeg(mSprayAngle))
end

function gadget:GameFrame(f)
    if f % updateRate > 0.0001 then
        return end

    for unitID, sprayangleData in pairs(trackedUnits) do
        -- Spring.GetUnitVelocity ( number unitID ) -> nil | number velx, number vely, number velz, number velLength
        local unitMoveSpeed = select(4, spGetUnitVelocity(unitID))
        local newSprayAngle = (unitMoveSpeed > minMoveSpeed) and sprayangleData.movingsprayangle or sprayangleData.sprayangle
        for weapNum = 1, sprayangleData.weaponCount do
            spSetUnitWeaponState (unitID, weapNum, "sprayAngle", newSprayAngle)
        end
--        if unitMoveSpeed > minMoveSpeed then
--            spSetUnitWeaponState (unitID, 1, "sprayAngle", sprayangleData.movingsprayangle)
--            --Spring.Echo("new spray angle: "..msprayangle*182.044)
--        else -- restore to unitDef (default) sprayangle
--            spSetUnitWeaponState (unitID, 1, "sprayAngle", sprayangleData.sprayangle)
--        end
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
    trackedUnits[unitID] = nil
end