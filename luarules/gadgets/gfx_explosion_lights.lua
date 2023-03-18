
function gadget:GetInfo()
    return {
        name      = "Explosion_lights",
        desc      = "",
        author    = "Floris",
        date      = "April 2017",
        license   = "GNU GPL, v2 or later",
        layer     = 0,
        enabled   = true
    }
end

local big_unitex_air = WeaponDefNames['big_unitex_air'].id

if gadgetHandler:IsSyncedCode() then

    local cannonWeapons = {}

    function gadget:Initialize()
        for wdid, wd in pairs(WeaponDefs) do
			if wd.type == "Cannon" then
				cannonWeapons[wdid] = true
				Script.SetWatchExplosion(wdid, true)
				if wd.damages[0] >= 20 then
					Script.SetWatchProjectile(wdid, true)
				end
			end
			if wd.type == "BeamLaser" then
				cannonWeapons[wdid] = true
				Script.SetWatchExplosion(wdid, true)
				if wd.damages[0] >= 10 then
					Script.SetWatchProjectile(wdid, true)
				end
			end
        end
    end
    function gadget:Shutdown()
        for wdid, wd in pairs(WeaponDefs) do
            if wd.type == "Cannon" then
                Script.SetWatchExplosion(wdid, false)
				if wd.damages[0] >= 20 then
					Script.SetWatchProjectile(wdid, false)
				end
            end
			if wd.type == "BeamLaser" then
				Script.SetWatchExplosion(wdid, false)
				if wd.damages[0] >= 10 then
					Script.SetWatchProjectile(wdid, false)
				end
			end
        end
    end

    function gadget:Explosion(weaponID, px, py, pz, ownerID)
			if(weaponID ~= big_unitex_air)then
				SendToUnsynced("explosion_light", px, py, pz, weaponID, ownerID)
			end
	end

    function gadget:ProjectileCreated(projectileID, ownerID, weaponID)		-- needs: Script.SetWatchProjectile(weaponDefID, true)
		if cannonWeapons[weaponID] then	-- optionally disable this to pass through missiles too
			local px, py, pz = Spring.GetProjectilePosition(projectileID)
			SendToUnsynced("barrelfire_light", px, py, pz, weaponID, ownerID)
		end
    end

else

-------------------------------------------------------------------------------
-- Unsynced
-------------------------------------------------------------------------------
	local spGetMyAllyTeamID    	= Spring.GetMyAllyTeamID
    local myAllyID = spGetMyAllyTeamID()
	local spGetMyPlayerID		= Spring.GetMyPlayerID
    local spGetUnitAllyTeam = Spring.GetUnitAllyTeam
	local spIsPosInLos = Spring.IsPosInLos
	local spGetSpectatingState	= Spring.GetSpectatingState
	local spGetSpectatingState	= Spring.GetSpectatingState
	
    function gadget:PlayerChanged(playerID)
        if playerID == spGetMyPlayerID() then
            myAllyID = spGetMyAllyTeamID()
        end
    end
	
	 local function SpawnExplosion(_,px,py,pz, weaponID, ownerID)
        if Script.LuaUI("GadgetWeaponExplosion") then
            if ownerID ~= nil then
                if spGetUnitAllyTeam(ownerID) == myAllyID or spIsPosInLos(px, py, pz, myAllyID) or spGetSpectatingState() then
                    Script.LuaUI.GadgetWeaponExplosion(px, py, pz, weaponID, ownerID)
                end
            else
                -- dont know when this happens and if we should show the explosion...
                Script.LuaUI.GadgetWeaponExplosion(px, py, pz, weaponID)
            end
        end
    end

    local function SpawnBarrelfire(_,px,py,pz, weaponID, ownerID)
        if Script.LuaUI("GadgetWeaponBarrelfire") then
            if ownerID ~= nil then
                if spGetUnitAllyTeam(ownerID) == myAllyID or spIsPosInLos(px, py, pz, myAllyID) or spGetSpectatingState() then
                    Script.LuaUI.GadgetWeaponBarrelfire(px, py, pz, weaponID, ownerID)
                end
            else
                -- dont know when this happens and if we should show the explosion...
                Script.LuaUI.GadgetWeaponBarrelfire(px, py, pz, weaponID)
            end
        end
    end

    function gadget:Initialize() --disable barrel lights on regular
        gadgetHandler:AddSyncAction("explosion_light", SpawnExplosion)
        gadgetHandler:AddSyncAction("barrelfire_light", SpawnBarrelfire)
    end

    function gadget:Shutdown()
        gadgetHandler.RemoveSyncAction("explosion_light")
        gadgetHandler.RemoveSyncAction("barrelfire_light")
    end
end
