function gadget:GetInfo()
	return {
		name      = "Crashing Aircraft",
		desc      = "Make aircraft crash-land instead of exploding",
		author    = "Beherith",
		date      = "aug 2012",
		license   = "GNU GPL, v2 or later",
		layer     = 1000,
		enabled   = true,
	}
end

if gadgetHandler:IsSyncedCode() then

	local random = math.random
	local GetUnitHealth = Spring.GetUnitHealth
	local SetUnitCOBValue = Spring.SetUnitCOBValue
	local SetUnitNoSelect = Spring.SetUnitNoSelect
	local SetUnitNoMinimap = Spring.SetUnitNoMinimap
	local SetUnitSensorRadius = Spring.SetUnitSensorRadius
	local SetUnitWeaponState = Spring.SetUnitWeaponState
	local SetUnitStealth = Spring.SetUnitStealth
	local SetUnitNeutral = Spring.SetUnitNeutral
	local SetUnitAlwaysVisible = Spring.SetUnitAlwaysVisible
	local DestroyUnit = Spring.DestroyUnit

	local COB_CRASHING = COB.CRASHING
	local COM_BLAST = WeaponDefNames['commander_blast'].id

	local isAircon = {}
	local crashable  = {}
	local alwaysCrash = {}
	for udid,UnitDef in pairs(UnitDefs) do
		if UnitDef.canFly == true and UnitDef.transportSize == 0 and string.sub(UnitDef.name, 1, 7) ~= "critter" then
			crashable[UnitDef.id] = true
			if UnitDef.buildSpeed > 1 then
				isAircon[udid] = true
			end
		end
		if string.find(UnitDef.name, 'corcrw') or string.find(UnitDef.name, 'armcybr') then
			alwaysCrash[UnitDef.id] = true
		end
	end
	
	local nonCrashable = {'armpeep', 'corfink', 'bladew'} 
	for udid, ud in pairs(UnitDefs) do
		for _, unitname in pairs(nonCrashable) do
			if string.find(ud.name, unitname) then
				crashable[udid] = nil
			end
		end
	end

	local crashing = {}
	local crashingCount = 0



	function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
		if paralyzer then return damage,1 end
		if crashing[unitID] then
			return 0,0
		end

		if  (crashable[unitDefID] and (damage>GetUnitHealth(unitID)) and random()<0.4) or alwaysCrash[unitDefID] then -- and weaponDefID ~= COM_BLAST
			--if Spring.GetGameSeconds() - totalUnitsTime > 5 then
			--	totalUnitsTime = Spring.GetGameSeconds()
			--	local totalUnits = #Spring.GetAllUnits()
			--	percentage = (1 - (totalUnits/10000))
			--	if percentage < 0.6 then
			--		percentage = 0.6
			--	end
			--end
			--if random() < percentage or alwaysCrash[unitDefID] then
			-- increase gravity so it crashes faster
			
			local moveTypeData = Spring.GetUnitMoveTypeData(unitID)
			if moveTypeData['myGravity'] then
				Spring.MoveCtrl.SetAirMoveTypeData(unitID, 'myGravity', moveTypeData['myGravity'] * 1.4)
			end
			
			-- make it crash
			crashingCount = crashingCount + 1
			crashing[unitID] = Spring.GetGameFrame() + 230
			SetUnitCOBValue(unitID, COB_CRASHING, 1)
			SetUnitNoSelect(unitID,true)
			SetUnitNoMinimap(unitID,true)
			SetUnitStealth(unitID, true)
			SetUnitAlwaysVisible(unitID, false)
			SetUnitNeutral(unitID, true)
			for weaponID, weapon in pairs(UnitDefs[unitDefID].weapons) do
				SetUnitWeaponState(unitID, weaponID, "reloadState", 0)
				SetUnitWeaponState(unitID, weaponID, "reloadTime", 9999)
				SetUnitWeaponState(unitID, weaponID, "range", 0)
				SetUnitWeaponState(unitID, weaponID, "burst", 0)
				SetUnitWeaponState(unitID, weaponID, "aimReady", 0)
				SetUnitWeaponState(unitID, weaponID, "salvoLeft", 0)
				SetUnitWeaponState(unitID, weaponID, "nextSalvo", 9999)
			end
			-- remove sensors
			SetUnitSensorRadius(unitID, "los", 0)
			SetUnitSensorRadius(unitID, "airLos", 0)
			SetUnitSensorRadius(unitID, "radar", 0)
			SetUnitSensorRadius(unitID, "sonar", 0)

			-- make sure aircons stop building
			if isAircon[unitDefID] then
				Spring.GiveOrderToUnit(unitID, CMD.STOP, {}, 0)
			end

			SendToUnsynced("crashingAircraft", unitID, unitDefID, unitTeam)

			if attackerID then
				local kills = Spring.GetUnitRulesParam(attackerID, "kills") or 0
				Spring.SetUnitRulesParam(attackerID, "kills", kills + 1)
			end
		end
		return damage,1
	end

	function gadget:GameFrame(gf)
		if crashingCount > 0 and gf % 44 == 1 then
			for unitID,deathGameFrame in pairs(crashing) do
				if gf >= deathGameFrame then
					DestroyUnit(unitID, false, true) --dont seld, but also dont leave wreck at all
				end
			end
		end
	end

	function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeamID)
		if crashing[unitID] then
			crashingCount = crashingCount - 1
			crashing[unitID] = nil
		end
	end


else	-- UNSYNCED


	local IsUnitInView = Spring.IsUnitInView

	local function crashingAircraft(_,unitID,unitDefID,unitTeam)
		local _, fullView = Spring.GetSpectatingState()
		local myTeamID = Spring.GetMyTeamID()
		if fullView or CallAsTeam(myTeamID, IsUnitInView, unitID) then
			if Script.LuaUI("GadgetCrashingAircraft") then
				Script.LuaUI.GadgetCrashingAircraft(unitID, unitDefID, unitTeam)
			end
			if Script.LuaUI("GadgetCrashingAircraft1") then
				Script.LuaUI.GadgetCrashingAircraft1(unitID, unitDefID, unitTeam)
			end
			if Script.LuaUI("GadgetCrashingAircraft2") then
				Script.LuaUI.GadgetCrashingAircraft2(unitID, unitDefID, unitTeam)
			end
			if Script.LuaUI("GadgetCrashingAircraft3") then
				Script.LuaUI.GadgetCrashingAircraft3(unitID, unitDefID, unitTeam)
			end
			if Script.LuaUI("GadgetCrashingAircraft4") then
				Script.LuaUI.GadgetCrashingAircraft4(unitID, unitDefID, unitTeam)
			end
		end
	end

	function gadget:Initialize()
		gadgetHandler:AddSyncAction("crashingAircraft", crashingAircraft)
	end

	function gadget:Shutdown()
		gadgetHandler:RemoveSyncAction("crashingAircraft")
	end

end
