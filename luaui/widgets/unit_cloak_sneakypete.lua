function widget:GetInfo()
    return {
        name      = "unit_cloak_sneaky_pete",
        desc      = "cloak sneaky petes",
        author    = "Bluestone, based on similar widgets by vbs, tfc, decay  (made fancy by Floris)",
        date      = "14 february 2015",
        license   = "GPL v3 or later",
        layer     = 0,
        enabled   = false,
    }
end

local CMD_CLOAK = 37382
local armpete = UnitDefNames["armjamt"]
local armpeteid = armpete.id
local spGiveOrderToUnit = Spring.GiveOrderToUnit


function widget:UnitFinished(unitID, unitDefID, unitTeam)
    if unitDefID == armpeteid then
		spGiveOrderToUnit(unitID, CMD_CLOAK, { 1 }, {})
    end
end

function maybeRemoveSelf()
    if Spring.GetSpectatingState() and (Spring.GetGameFrame() > 0 or gameStarted) then
        widgetHandler:RemoveWidget()
    end
end

function widget:GameStart()
    gameStarted = true
    maybeRemoveSelf()
end

function widget:PlayerChanged(playerID)
    maybeRemoveSelf()
end

function widget:Initialize()
    if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
        maybeRemoveSelf()
    end
end

