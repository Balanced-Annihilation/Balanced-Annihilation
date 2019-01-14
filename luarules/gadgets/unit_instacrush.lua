--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
    return {
        name      = "Unit Instant Crush",
        desc      = "Prevents crushed units from being thrown around, insta-killing them",
        author    = "MaDDoX",
        date      = "Sep 12, 2018",
        license   = "GNU GPL, v2 or later",
        layer     = -1,
        enabled   = true  --  loaded by default?
    }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (not gadgetHandler:IsSyncedCode()) then
    return false  --  silent removal
end

--local spGetUnitBasePosition = Spring.GetUnitBasePosition
--local spDestroyUnit = Spring.DestroyUnit
local spGetUnitHealth = Spring.GetUnitHealth
local crushWeaponID = -7

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer,
                               weaponID, projectileID, attackerID, attackerDefID, attackerTeam)
    local currentHealth = spGetUnitHealth(unitID)
    if not currentHealth then
        return damage, 1 end

    if weaponID == crushWeaponID and damage > currentHealth * 0.85 then
        return 999999, 0 -- damage, impulseMult (Instakill, no impulse)
    else
        return damage,1
    end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------