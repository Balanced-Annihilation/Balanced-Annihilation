function gadget:GetInfo()
	return {
		name = "Tech Setup",
		desc = "Sets up unselectable units",
		author = "MaDD0X",
		date = "22/10/2018",
		license = "Public domain",
		layer = 1,
		enabled = false, --true	(TODO: Deprecated, moving func to game_techproxy.lua)
	}
end

--local CMD_AREAATTACK = 39954
local spSetUnitNoDraw = Spring.SetUnitNoDraw
local spSetUnitNoSelect = Spring.SetUnitNoSelect
local spSetUnitNoMinimap = Spring.SetUnitNoMinimap
local spUnitAttach = Spring.UnitAttach

if (gadgetHandler:IsSyncedCode()) then

---- SYNCED

local attackList={}
local closeList={}
local range={}

--UnitDefs[ud].customParams.canareaattack=="1"

function gadget:UnitCreated(uid, udefid, team, builderID)
	if UnitDefs[udefid].customParams.techproxy=="1" then
		spSetUnitNoDraw (uid, true )
		spSetUnitNoSelect (uid, true )
		spSetUnitNoMinimap(uid, true )
		spUnitAttach(builderID, uid, 1) --airbaseID, unitID, padPieceNum
	end
end

function gadget:Initialize()
	--gadgetHandler:RegisterCMDID(CMD_AREAATTACK)
end

else

--- UNSYNCED code

function gadget:Initialize()

end

--return false

end
