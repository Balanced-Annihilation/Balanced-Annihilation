function gadget:GetInfo()
    return {
        name 	= "Unit Upgrade - D-gun",
        desc	= "Enables D-gun command for Commanders",
        author	= "MaDDoX",
        date	= "Sept 24th 2019",
        license	= "GNU GPL, v2 or later",
        layer	= -1,
        enabled = true,
    }
end

if not gadgetHandler:IsSyncedCode() then
    return end

CMD.UPG_DGUN = 41999
CMD_UPG_DGUN = 41999
local CMD_MANUALFIRE = CMD.MANUALFIRE
local spUseUnitResource = Spring.UseUnitResource
local metalCost = 200
local energyCost = 1200

local spGetUnitDefID = Spring.GetUnitDefID
local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
local spInsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local spEditUnitCmdDesc = Spring.EditUnitCmdDesc

local UpgDgunDesc = {
    id      = CMD_UPG_DGUN,
    type    = CMDTYPE.ICON,
    name    = 'Upg D-Gun',
    cursor = 'Morph',
    action  = 'dgunupgrade',
    tooltip = 'Enables D-gun ability / command',
}

function gadget:Initialize()
    for ct, unitID in pairs(Spring.GetAllUnits()) do
        gadget:UnitCreated(unitID)
    end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
    if UnitDefs[spGetUnitDefID(unitID)].customParams.iscommander then
        spInsertUnitCmdDesc(unitID, CMD_UPG_DGUN, UpgDgunDesc)
        local cmdDescID = spFindUnitCmdDesc(unitID, CMD_MANUALFIRE)
        spEditUnitCmdDesc(unitID, cmdDescID, { disabled=true })--, queueing=false,
    end
end

function gadget:AllowCommand(unitID,_,unitTeam,cmdID,cmdParams)
    -- Require Tech1 for Upgrade
    -- TODO: Progress, progress percentage (check unit_morph.lua)
    if cmdID == CMD_UPG_DGUN and GG.TechCheck("Tech1", unitTeam) then
        if not spUseUnitResource(unitID, { ["m"] = metalCost, ["e"] = energyCost }) then
            return false
        end
        local cmdDescId = spFindUnitCmdDesc(unitID, CMD_UPG_DGUN)
        spEditUnitCmdDesc(unitID, cmdDescId, { disabled=true })

        local cmdDescId = spFindUnitCmdDesc(unitID, CMD_MANUALFIRE)
        spEditUnitCmdDesc(unitID, cmdDescId, { disabled=false })
        ----if cmdParams[1] == 1 then
        ----    Spring.EditUnitCmdDesc(unitID, cmdDescId, LowAltDesc)
        ----    if UnitDefs[Spring.GetUnitDefID(unitID)].hoverAttack == false then
        ----        Spring.MoveCtrl.SetAirMoveTypeData(unitID, "wantedHeight", 30)
        ----    else
        ----        Spring.MoveCtrl.SetGunshipMoveTypeData(unitID, "wantedHeight", 30)
        ----    end
        ----
        ----end
    end
    return true
end
