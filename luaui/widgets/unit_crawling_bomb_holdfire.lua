function widget:GetInfo()
    return {
        name      = "crawling bomb holdfire",
        desc      = "set crawlings to hold fire",
        author    = "Bluestone, based on similar widgets by vbs, tfc, decay  (made fancy by Floris)",
        date      = "14 february 2015",
        license   = "GPL v3 or later",
        layer     = 0,
        enabled   = true  -- loaded by default
    }
end

local cmdFireState = CMD.FIRE_STATE
local spGiveOrderToUnit = Spring.GiveOrderToUnit

local coreCrawling = UnitDefNames["corroach"]
local coreAdvCrawling = UnitDefNames["corsktl"]
local armCrawling = UnitDefNames["armvader"]

local coreCrawlingId = coreCrawling.id
local coreAdvCrawlingId = coreAdvCrawling.id
local armCrawlingId = armCrawling.id

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    if  unitDefID == coreCrawlingId or coreAdvCrawlingId == unitDefID or unitDefID == armCrawlingId then
        spGiveOrderToUnit(unitID, cmdFireState, { 0 }, {  })
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

