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

-- project page on github: https://github.com/jamerlan/unit_crawling_bomb_range

--Changelog
-- v2 [teh]decay Advanced Crawling Bombs are cloaked by default (you can configure using "cloakAdvCrawlingBombs" variable) + hide circles when GUI is hidden
-- v3 [teh]decay Draw decloak range for Advanced Crawling Bomb
-- v4 [teh]decay Draw blow radius for adv geos too
local spGetUnitHealth	= Spring.GetUnitHealth
local spGetUnitNearestEnemy	= Spring.GetUnitNearestEnemy
local spGetUnitNearestAlly	= Spring.GetUnitNearestAlly
local myAllyTeam = Spring.GetMyAllyTeamID()
local spGetActiveCommand = Spring.GetActiveCommand
local spGetActiveCmdDesc = Spring.GetActiveCmdDesc

local spGetUnitPosition     = Spring.GetUnitPosition
local diag					= math.diag
local cloakAdvCrawlingBombs = true
local linewidth = 0
local glLineWidth				= gl.LineWidth
local GetUnitPosition     = Spring.GetUnitPosition
local glColor = gl.Color
local glDepthTest = gl.DepthTest
local glDrawGroundCircle  = gl.DrawGroundCircle
local GetUnitDefID = Spring.GetUnitDefID
local lower                 = string.lower
local spGetAllUnits = Spring.GetAllUnits
local spGetSpectatingState = Spring.GetSpectatingState
local spGetMyPlayerID		= Spring.GetMyPlayerID
local spGetPlayerInfo		= Spring.GetPlayerInfo
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spIsGUIHidden = Spring.IsGUIHidden
local spGetCameraPosition	= Spring.GetCameraPosition

local cmdFireState = CMD.FIRE_STATE
local cmdCloack = CMD.CLOAK

local blastCircleDivs   = 100
local weapNamTab		= WeaponDefNames
local weapTab		    = WeaponDefs
local udefTab			= UnitDefs

local selfdTag = "selfDExplosion"
local aoeTag = "damageAreaOfEffect"

local coreCrawling = UnitDefNames["corroach"]
local coreAdvCrawling = UnitDefNames["corsktl"]
local armCrawling = UnitDefNames["armvader"]
local armAdvGEO = UnitDefNames["amgeo"]
local coreAdvGEO = UnitDefNames["cmgeo"]

local coreCrawlingId = coreCrawling.id
local coreAdvCrawlingId = coreAdvCrawling.id
local armCrawlingId = armCrawling.id
local armAdvGEOId = armAdvGEO.id
local coreAdvGEOId = coreAdvGEO.id

local coreCom = UnitDefNames["corcom"]
local armCom = UnitDefNames["armcom"]
local coreComId = coreCom.id
local armComId = armCom.id





local crawlingBombs = {}

local spectatorMode = false
local notInSpecfullmode = false

function setBombStates(unitID, unitDefID)

	if isHoldFire(unitDefID) then 
		spGiveOrderToUnit(unitID, cmdFireState, { 0 }, {  })

		--if unitDefID == coreAdvCrawlingId and cloakAdvCrawlingBombs then
		--	spGiveOrderToUnit(unitID, cmdCloack, { 1 }, {})
		--end
	end
end

function isBomb(unitDefID)
    if  unitDefID == coreCrawlingId or coreAdvCrawlingId == unitDefID or unitDefID == armCrawlingId then
        return true
    end
    return false
end

function isHoldFire(unitDefID)
    if unitDefID == coreCrawlingId or coreAdvCrawlingId == unitDefID or unitDefID == armCrawlingId then
        return true
    end
    return false
end


function widget:UnitFinished(unitID, unitDefID, unitTeam)
    if isBomb(unitDefID) then
        crawlingBombs[unitID] = true
        setBombStates(unitID, unitDefID)
    end
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
    if crawlingBombs[unitID] then
        crawlingBombs[unitID] = nil
    end
end

function widget:UnitEnteredLos(unitID, unitTeam)
    if not spectatorMode then
        local unitDefID = GetUnitDefID(unitID)
        if isBomb(unitDefID) then
            crawlingBombs[unitID] = true
        end
    end
end

function widget:UnitCreated(unitID, unitDefID, teamID, builderID)
    if isBomb(unitDefID) then
        crawlingBombs[unitID] = true
        setBombStates(unitID, unitDefID)
    end
end

function widget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
    if isBomb(unitDefID) then
        crawlingBombs[unitID] = true
        setBombStates(unitID, unitDefID)
    end
end


function widget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
    if isBomb(unitDefID) then
        crawlingBombs[unitID] = true
        setBombStates(unitID, unitDefID)
    end
end

function widget:UnitLeftLos(unitID, unitDefID, unitTeam)
    if not spectatorMode then
        if crawlingBombs[unitID] then
            crawlingBombs[unitID] = nil
        end
    end
end


function widget:ViewResize(viewSizeX, viewSizeY)
  resize()
end

function widget:PlayerChanged(playerID)
    detectSpectatorView()
    return true
end

function widget:Initialize()

	resize()

    detectSpectatorView()
    return true
end

function resize()
vsx, vsy = gl.GetViewSizes()
	if(vsy > 2000) then
		lineWidth = 2
		else
		lineWidth = 1
	end
end

function detectSpectatorView()
   --local _, _, spec, teamId = spGetPlayerInfo(spGetMyPlayerID())

    --if spec then
    --    spectatorMode = true
    --end

    local visibleUnits = spGetAllUnits()
    if visibleUnits ~= nil then
        for _, unitID in ipairs(visibleUnits) do
            local udefId = GetUnitDefID(unitID)
            if udefId ~= nil then
                if isBomb(udefId) then
                    crawlingBombs[unitID] = true
                end
            end
        end
    end
end


