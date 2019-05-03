function gadget:GetInfo()
    return {
        name 	= "Unit Upgrade - Dgun",
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

local metalCost = 200
local energyCost = 1200
local upgradeTime = 5 * 30 --5 seconds, in frames
local upgradingUnits = {}

local spUseUnitResource = Spring.UseUnitResource
local spGetUnitDefID = Spring.GetUnitDefID
local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
local spInsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local spEditUnitCmdDesc = Spring.EditUnitCmdDesc
local spSetUnitRulesParam = Spring.SetUnitRulesParam

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
        Spring.Echo("Added "..unitID..", count: "..#upgradingUnits)
        upgradingUnits[#upgradingUnits+1] = { unitID = unitID, progress = 0 }
        spSetUnitRulesParam(unitID,"upgrade", 0)
    end
    return true
end

local function finishUpgrade(unitID)
    local cmdDescId = spFindUnitCmdDesc(unitID, CMD_UPG_DGUN)
    spEditUnitCmdDesc(unitID, cmdDescId, { disabled=true })

    local cmdDescId = spFindUnitCmdDesc(unitID, CMD_MANUALFIRE)
    spEditUnitCmdDesc(unitID, cmdDescId, { disabled=false })

    spSetUnitRulesParam(unitID,"upgrade", nil)
end

function gadget:Update()
    Spring.Echo("Count: "..#upgradingUnits)
    for _,data in ipairs(upgradingUnits) do
        local unitID = data.unitID
        local progress = data.progress
        Spring.Echo("Unit: "..unitID.." progress: "..progress)
        if spUseUnitResource(unitID, { ["m"] = metalCost/upgradeTime, ["e"] = energyCost/upgradeTime }) then
            local progress = progress + 1 / upgradeTime -- TODO: Add "Morph speedup" bonus maybe?
            upgradingUnits[unitID] = progress
            spSetUnitRulesParam(unitID,"upgrade", progress)
            if progress >= 1.0 then
                finishUpgrade(unitID)
            end
        end
    end
end