--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "mo_preventcombomb",
    desc      = "Commanders survive commander blast and DGun",
    author    = "TheFatController",
    date      = "Aug 31, 2009",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (not gadgetHandler:IsSyncedCode()) then
	return false
end

-- remove gadget if modoption is not set

local GetTeamInfos = Spring.GetTeamInfos
local GetUnitPosition = Spring.GetUnitPosition
local GetGroundHeight = Spring.GetGroundHeight
local MoveCtrl = Spring.MoveCtrl
local GetGameFrame = Spring.GetGameFrame
local DestroyUnit = Spring.DestroyUnit


function gadget:Initialize()
	if (tonumber(Spring.GetModOptions().mo_preventcombomb) or 0) == 1 then
	COM_BLAST = {
	[WeaponDefNames['commanderexplosion'].id] = true,
	[WeaponDefNames['commanderexplosion1'].id] = true,
	[WeaponDefNames['commanderexplosion2'].id] = true,
	[WeaponDefNames['commanderexplosion3'].id] = true,
	[WeaponDefNames['commanderexplosion4'].id] = true,
	[WeaponDefNames['commanderexplosion5'].id] = true,
	[WeaponDefNames['commanderexplosion6'].id] = true,
	}
	else
	COM_BLAST = {}
	end
end


local DGUN = {
    [WeaponDefNames['armcom_arm_disintegrator'].id] = true,
    [WeaponDefNames['corcom_arm_disintegrator'].id] = true,
    [WeaponDefNames['armcom2_arm_disintegrator'].id] = true,
    [WeaponDefNames['corcom2_arm_disintegrator'].id] = true,
    [WeaponDefNames['armcom3_arm_disintegrator'].id] = true,
    [WeaponDefNames['corcom3_arm_disintegrator'].id] = true,
    [WeaponDefNames['armcom4_arm_disintegrator'].id] = true,
    [WeaponDefNames['corcom4_arm_disintegrator'].id] = true,
    [WeaponDefNames['armcom5_arm_disintegrator'].id] = true,
    [WeaponDefNames['corcom5_arm_disintegrator'].id] = true,
    [WeaponDefNames['armcom6_arm_disintegrator'].id] = true,
    [WeaponDefNames['corcom6_arm_disintegrator'].id] = true,
}

local COMMANDER = {
  [UnitDefNames["corcom"].id] = true,
  [UnitDefNames["armcom"].id] = true,
  [UnitDefNames["corcom2"].id] = true,
  [UnitDefNames["armcom2"].id] = true,
  [UnitDefNames["corcom3"].id] = true,
  [UnitDefNames["armcom3"].id] = true,
  [UnitDefNames["corcom4"].id] = true,
  [UnitDefNames["armcom4"].id] = true,
  [UnitDefNames["corcom5"].id] = true,
  [UnitDefNames["armcom5"].id] = true,
  [UnitDefNames["corcom6"].id] = true,
  [UnitDefNames["armcom6"].id] = true,
}


local immuneDgunList = {}
local ctrlCom = {}
local cantFall = {}

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer,
                            weaponID, projectileID, attackerID, attackerDefID, attackerTeam)
	--falling & debris damage
	if weaponID < 0 and cantFall[unitID] then
		return 0, 0
	end
	
	local hp,_ = Spring.GetUnitHealth(unitID) 
	hp = hp or 0
	local combombDamage = math.min(hp*0.33, math.max(0,hp-200-math.random(1,10))) -- lose hp*0.4 damage but don't let health get <200
	combombDamage = math.min(damage,combombDamage) 

	if DGUN[weaponID] then
		if immuneDgunList[unitID] then
			-- immune
			return 0, 0
		elseif COMMANDER[attackerDefID] and COMMANDER[unitDefID] then
			-- make unitID immune to DGun, kill attackedID
			immuneDgunList[unitID] = GetGameFrame() + 45
			Spring.AddUnitDamage(attackerID,damage,0,unitID,weaponID)
			return combombDamage, 0
		end
	elseif COM_BLAST[weaponID] and COMMANDER[unitDefID] then
		if unitID ~= attackerID then
			--prevent falling damage to the unitID, and lock position
			MoveCtrl.Enable(unitID)
			ctrlCom[unitID] = GetGameFrame() + 30
			cantFall[unitID] = GetGameFrame() + 30
			return combombDamage, 0
		else
			--com blast hurts the attackerID 
			return damage
		end
	end
	
	return damage
end

function gadget:GameFrame(currentFrame)
	for unitID,expirationTime in pairs(immuneDgunList) do
		if currentFrame > expirationTime then
			immuneDgunList[unitID] = nil
		end
	end
	for unitID,expirationTime in pairs(ctrlCom) do
		if currentFrame > expirationTime then
			--if the game was actually a draw then this unitID is not valid anymore
			--if that is the case then just remove it from the cantFall list and clear the ctrlCom flag
			local x,_,z = GetUnitPosition(unitID)
			if x then
				local y = GetGroundHeight(x,z)
				MoveCtrl.SetPosition(unitID, x,y,z)
				MoveCtrl.Disable(unitID)
				cantFall[unitID] = currentFrame + 220
			else
				cantFall[unitID] = nil
			end

			ctrlCom[unitID] = nil
		end
	end
	for unitID,expirationTime in pairs(cantFall) do
		if currentFrame > expirationTime then
			cantFall[unitID] = nil
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
