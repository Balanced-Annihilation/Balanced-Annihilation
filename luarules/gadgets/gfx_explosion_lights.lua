
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

-------------------------------------------------------------------------------
-- Synced
-------------------------------------------------------------------------------
local flea_ex = WeaponDefNames['flea_ex'].id
local small_unitex = WeaponDefNames['small_unitex'].id
local small_unit = WeaponDefNames['small_unit'].id

local small_unit_air = WeaponDefNames['small_unit_air'].id
local small_unitex_air = WeaponDefNames['small_unitex_air'].id
local big_unitex_air = WeaponDefNames['big_unitex_air'].id
local big_unit_air = WeaponDefNames['big_unit_air'].id



if (gadgetHandler:IsSyncedCode()) then

local cacheids = {}
cacheids[#cacheids + 1] = flea_ex
cacheids[#cacheids + 1] = small_unitex
cacheids[#cacheids + 1] = small_unit
cacheids[#cacheids + 1] = small_unit_air
cacheids[#cacheids + 1] = small_unitex_air
cacheids[#cacheids + 1] = big_unitex_air
cacheids[#cacheids + 1] = big_unit_air

			
			
			
 --local wantedList = {}

  --// find weapons which cause a shockwave
  --[[for i=1,#WeaponDefs do
    local wd = WeaponDefs[i]
    local customParams = wd.customParams or {}
	
	if wd.reload > 1 then 
		 wantedList[#wantedList + 1] = wd.id
	end
  end
	if wantedList[wd.id] then
		end ]]--
 
 --[[local wantedList = {}
		
	local unitdefInfo = {}
	for unitDefID, unitDef in pairs(UnitDefs) do
		
		
		if unitDef.canFly then
		
			if unitDef.explodeas == "SMALL_BUILDING" then -- not krow
				return
			end
		
			for i = 1, #unitDef.weapons do
				
				local WeaponDefID = unitDef.weapons[i].weaponDef
				local WeaponDef = WeaponDefs[WeaponDefID]
				wantedList[#wantedList + 1] = WeaponDefID
				--WeaponDef.reload > unitDef.reloadTime
				
			end
		
		
		end
		end]]--
		--uDef.explodeas 
		--uDef.selfdestructas
		
--local vamp = WeaponDefNames['corvamp'].id
--local hawk = WeaponDefNames['armhawk'].id
--local armfig = WeaponDefNames['armfig'].id
--local corfig = WeaponDefNames['corveng'].id
		
    local cannonWeapons = {}
	 local barrelWeapons = {}
    function gadget:Initialize()
        for wdid, wd in pairs(WeaponDefs) do
           -- if wd.type == "Flame" then
           --     Script.SetWatchExplosion(wdid, true)     -- watch weapon so explosion gets called for flame weapons
           -- end
		   
		   
		  --if (not (wd.reload < 1 and wd.damageAreaOfEffect >= 64)) then
			--	barrelWeapons[wdid] = true
		  --end
		   
				if wd.type == "Cannon" then
					cannonWeapons[wdid] = true
					Script.SetWatchExplosion(wdid, true)    -- might be getting too expensive
				end
				if wd.type == "BeamLaser" then
					Script.SetWatchExplosion(wdid, true)    -- might be getting too expensive
				end
        end
    end
    function gadget:Shutdown()
        for wdid, wd in pairs(WeaponDefs) do
            --if wd.type == "Flame" then
            --    Script.SetWatchExplosion(wdid, false)     -- watch weapon so explosion gets called for flame weapons
           -- end
            if wd.type == "Cannon" then
                Script.SetWatchExplosion(wdid, false)    -- might be getting too expensive
            end
        end
    end

    function gadget:Explosion(weaponID, px, py, pz, ownerID)
		
			--[[if(
			weaponID ~= flea_ex and
			weaponID ~= small_unitex and
			weaponID ~= small_unit and
			weaponID ~= small_unit_air and
			weaponID~= small_unitex_air and
			weaponID ~= big_unitex_air and
			weaponID  ~= big_unit_air]]--
			--)then	
		if not cacheids[weaponID] then
			
			
		

		
				SendToUnsynced("explosion_light", px, py, pz, weaponID, ownerID)
			end
    end
	


   -- function gadget:ProjectileCreated(projectileID, ownerID, weaponID)
   --    if barrelWeapons[weaponID] then
    --        local px, py, pz = Spring.GetProjectilePosition(projectileID)
    --        SendToUnsynced("barrelfire_light", px, py, pz, weaponID, ownerID)
    --    end
  --  end

else

-------------------------------------------------------------------------------
-- Unsynced
-------------------------------------------------------------------------------

    local myAllyID = Spring.GetMyAllyTeamID()
    local spGetUnitAllyTeam = Spring.GetUnitAllyTeam
    local spIsPosInLos = Spring.IsPosInLos

    function gadget:PlayerChanged(playerID)
        if (playerID == Spring.GetMyPlayerID()) then
            myAllyID = Spring.GetMyAllyTeamID()
        end
    end

    local function SpawnExplosion(_,px,py,pz, weaponID, ownerID)
        if Script.LuaUI("GadgetWeaponExplosion") then
            if ownerID ~= nil then
                if (spGetUnitAllyTeam(ownerID) == myAllyID  or  spIsPosInLos(px, py, pz, myAllyID)) then
                    Script.LuaUI.GadgetWeaponExplosion(px, py, pz, weaponID, ownerID)
                end
            else
                -- dont know when this happens and if we should show the explosion...
                Script.LuaUI.GadgetWeaponExplosion(px, py, pz, weaponID)
            end
        end
    end

   -- local function SpawnBarrelfire(_,px,py,pz, weaponID, ownerID)
        --Spring.Echo(weaponID..'  '..math.random())
   --     if Script.LuaUI("GadgetWeaponBarrelfire") then
   --         if ownerID ~= nil then
   --             if (spGetUnitAllyTeam(ownerID) == myAllyID  or  spIsPosInLos(px, py, pz, myAllyID)) then
    --                Script.LuaUI.GadgetWeaponBarrelfire(px, py, pz, weaponID, ownerID)
    --          end
    --       else
   --            Script.LuaUI.GadgetWeaponBarrelfire(px, py, pz, weaponID)
   --         end
   --     end
 --   end

    function gadget:Initialize()
        gadgetHandler:AddSyncAction("explosion_light", SpawnExplosion)
      --  gadgetHandler:AddSyncAction("barrelfire_light", SpawnBarrelfire)
    end

    function gadget:Shutdown()
        gadgetHandler.RemoveSyncAction("explosion_light")
      -- gadgetHandler.RemoveSyncAction("barrelfire_light")
    end
end