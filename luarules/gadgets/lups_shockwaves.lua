function gadget:GetInfo()
    return {
        name = "Shockwaves",
        desc = "",
        author = "jK",
        date = "Jan. 2008",
        license = "GNU GPL, v2 or later",
        layer = 0,
        enabled = true
    }
end

if (gadgetHandler:IsSyncedCode()) then
    local SHOCK_WEAPONS = {
        ["armcom_arm_disintegrator"] = true,
        ["corcom_arm_disintegrator"] = true,
        ["armdecom_decoy_disintegrator"] = true,
        ["cordecom_decoy_disintegrator"] = true,
        ["armthund_armbomb"] = true,
        ["armpnix_armadvbomb"] = true,
        ["armsb_arm_seaadvbomb"] = true,
        ["armshock_shocker"] = true,
        ["armfboy_arm_fatboy_notalaser"] = true,
        ["armsb_seaadvbomb"] = true
    }
    local hasShockwave = {} -- other gadgets can do Script.SetWatchWeapon and it is a global setting

    --// find weapons which cause a shockwave
    for i = 1, #WeaponDefs do
        local wd = WeaponDefs[i]
        local speed = 1
        local life = 1
        local damageAreaOfEffect = 1

        if SHOCK_WEAPONS[wd.name] then
            Script.SetWatchWeapon(wd.id, true)
            SHOCK_WEAPONS[wd.id] = {
                wdtype = wd.type,
                damageAreaOfEffect = wd.damageAreaOfEffect
            }
        --[[ else
            local customParams = wd.customParams or {}
            if (not customParams.lups_noshockwave) then
                speed = 1
                life = 1
                local normalShockwave =
                    (wd.damageAreaOfEffect > 59 and not wd.paralyzer and not customParams.disarmdamageonly)

                if customParams.lups_explodespeed then
                    speed = wd.customParams.lups_explodespeed
                    normalShockwave = true
                end
                if customParams.lups_explodelife then
                    life = wd.customParams.lups_explodelife
                    normalShockwave = true
                end
                if wd.description == "Implosion Bomb" then
                elseif normalShockwave then
                    hasShockwave[wd.id] = {
                        life = 9 * life,
                        speed = speed * 1.6,
                        growth = wd.damageAreaOfEffect / 16 * speed
                    }
                    Script.SetWatchWeapon(wd.id, true)
                end
            end]]--
        end
		
    end

    function gadget:Explosion(weaponID, px, py, pz, ownerID)
        if SHOCK_WEAPONS[weaponID] then
            local wd = SHOCK_WEAPONS[weaponID]
            if (wd.wdtype == "DGun") then
                SendToUnsynced("lups_shockwave", px, py, pz, 4.0, 18, 0.13, true)
            else
                local growth = (wd.damageAreaOfEffect * 1.1) / 20
                SendToUnsynced("lups_shockwave", px, py, pz, growth, false)
            end
        --[[ else
           local shockwave = hasShockwave[weaponID]
           if shockwave then
          SendToUnsynced("lups_shockwave", px, py, pz, shockwave.growth, shockwave.life, false, false, true)
            end]]--
        end
        return false
    end
else
    local function SpawnShockwave(_, px, py, pz, growth, life, strength, desintergrator, shock)
        local Lups = GG["Lups"]
        --[[  if (shock == true) then
             Lups.AddParticles("ShockWave", {pos = {px, py, pz}, growth = growth, life = life})
          else]]--
        if (desintergrator) then
            Lups.AddParticles(
                "SphereDistortion",
                {pos = {px, py, pz}, life = life, strength = strength, growth = growth}
            )
        else
            Lups.AddParticles("ShockWave", {pos = {px, py, pz}, growth = growth})
        end
    end

    function gadget:Initialize()
        gadgetHandler:AddSyncAction("lups_shockwave", SpawnShockwave)
    end

    function gadget:Shutdown()
        gadgetHandler.RemoveSyncAction("lups_shockwave")
    end
end
