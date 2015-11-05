
function widget:GetInfo()
	return {
		name		= "Bet Frontend",
		desc		= "Use player console and markers to place bets",
		author		= "BrainDamage",
		date		= "Jan,2013",
		license		= "WTFPL",
		layer		= 0,
		enabled		= false,
	}
end

local betString = {"fail at ", "fails at ", "dead at ", "dies at ", "dead by ", "die at ", "death at"}
local playerString = {"player","pro","pr0","noob","newbie","idiot","n00b","tard", "autist","retard"}
local searchRadius = 300
local myPlayerID = Spring.GetMyPlayerID()
local GetUnitsInCylinder = Spring.GetUnitsInCylinder
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitTeam = Spring.GetUnitTeam
local GetTeamList = Spring.GetTeamList
local GetGameFrame = Spring.GetGameFrame
local GetTeamStartPosition = Spring.GetTeamStartPosition
local GetPlayerInfo = Spring.GetPlayerInfo
local GetTeamInfo = Spring.GetTeamInfo
local GetTeamList = Spring.GetTeamList
local GetPlayerList = Spring.GetPlayerList
local GetUnitDefID = Spring.GetUnitDefID
local GetSelectedUnits = Spring.GetSelectedUnits
local SendCommands = Spring.SendCommands
local GetUnitRadius = Spring.GetUnitRadius
local IsUnitSelected = Spring.IsUnitSelected
local GetUnitDirection = Spring.GetUnitDirection
local GetGameRulesParam = Spring.GetGameRulesParam
local GetSpectatingState = Spring.GetSpectatingState
local Echo = Spring.Echo
local min = math.min
local cos = math.cos
local sin = math.sin
local pi = math.pi
local floor = math.floor
local ceil = math.ceil
local callbackIndexOver
local callbackIndexBet
local unitHumanNames = {} -- indexed by unitID
local unitDisplayList = {}
local viewBets = true
local simSpeed = Game.gameSpeed


local _G_INDEX = "betengine"
local MIN_BET_TIME = GetGameRulesParam(_G_INDEX.."MIN_BET_TIME")
local MIN_BET_TIME_SCALE = GetGameRulesParam(_G_INDEX.."MIN_BET_TIME_SCALE")
local BET_GRANULARITY = GetGameRulesParam(_G_INDEX.."BET_GRANULARITY")
local POINTS_PRIZE_PER_BET = {unit=GetGameRulesParam(_G_INDEX.."POINTS_PRIZE_PER_BET".."unit"),team=GetGameRulesParam(_G_INDEX.."POINTS_PRIZE_PER_BET".."team")}
local BET_COST = {unit=GetGameRulesParam(_G_INDEX.."BET_COST".."unit"),team=GetGameRulesParam(_G_INDEX.."BET_COST".."team")}
local STARTING_SCORE = GetGameRulesParam(_G_INDEX.."STARTING_SCORE")

local betStats = {}
local playerScores = {}
local betList = {}
local playerBetList = {}

local glDepthTest = gl.DepthTest
local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glDeleteList = gl.DeleteList
local glBeginEnd = gl.BeginEnd
local glColor = gl.Color
local glText = gl.Text
local glTranslate = gl.Translate
local glBillboard = gl.Billboard
local glRotate = gl.Rotate
local glScale = gl.Scale
local glVertex = gl.Vertex


local function sqDist(x1,x2,y1,y2,z1,z2)
	return (x1-x2)^2+(y1-y2)^2+(z1-z2)^2
end

local function PlayerIDtoName(playerID)
	return not playerID and "none" or GetPlayerInfo(playerID) or playerID
end

local function TeamIDtoName(teamID)
	return not select(2,GetTeamInfo(teamID)) and teamID or GetPlayerInfo(select(2,GetTeamInfo(teamID))) or teamID
end

function widget:MapDrawCmd(playerID, cmdType, px, py, pz, labeltext)
	if playerID ~= myPlayerID then
		return
	end
	if cmdType ~= "point" then
		return
	end
	labeltext = labeltext:lower()
	local isPlayerBet = false
	for _,tempPlayerID in pairs(GetPlayerList()) do
		isPlayerBet = isPlayerBet or labeltext:find(PlayerIDtoName(tempPlayerID):lower())
		if isPlayerBet then
			break
		end
	end
	for _,string in ipairs(playerString) do
		isPlayerBet = isPlayerBet or labeltext:find(string)
		if isPlayerBet then
			break
		end
	end
	local start
	local stop
	for _,string in ipairs(betString) do
		start,stop = labeltext:find(string)
		if start and stop then
			break
		end
	end
	if not start or not stop then
		-- not a bet label
		return
	end
	local timeLabel = labeltext:sub(stop+1,#labeltext)
	local spacepos = timeLabel:find(" ")
	if spacepos then
		timeLabel = timeLabel:sub(1,spacepos) -- truncate at the first space if present
	end
	local time = tonumber(timeLabel)
	if not time then
		Echo("malformed time")
		return
	end
	time = time*BET_GRANULARITY -- conver to minutes

	local betID
	local betType

	if GetGameFrame() == 0 then
		local closest
		local mindist
		for _,teamID in ipairs(GetTeamList()) do
			local teamX,teamY,teamZ = GetTeamStartPosition(teamID)
			local dist = sqDist(px,teamX,py,teamY,pz,teamZ)
			if not mindist then
				closest = teamID
				mindist = dist
			else
				if mindist > dist then
					closest = teamID
					mindist = dist
				end
			end
		end
		if not closest then
			-- no start pos were found
			Echo("no nearbry players to chose a target from")
			return
		end
		betType = "team"
		betID = closest
	else
		local closest
		local mindist
		-- find closest unit
		for _,unitID in ipairs(GetUnitsInCylinder(px,pz,searchRadius)) do
			local unitX,unitY,unitZ = GetUnitPosition(unitID)
			local dist = sqDist(px,unitX,py,unitY,pz,unitZ)
			if not mindist then
				closest = unitID
				mindist = dist
			else
				if mindist > dist then	
					closest = unitID
					mindist = dist
				end
			end
		end
		if not closest then
			-- no units were found
			Echo("no nearbry units to chose a target from")
			return
		end
		if isPlayerBet then
			betID = GetUnitTeam(closest)
			betType = "team"
		else
			betID = closest
			betType = "unit"
		end
	end
	SendCommands("luarules placebet " .. betType .. " " .. betID .. " " .. time)
end

function RecvPlaceBet(ok,reason)
	if not ok and reason then
		Echo(reason)
	end
end

local function playerNameToTeamID(playerName)
	for _,teamID in pairs(GetTeamList()) do
		for _,playerID in pairs(GetPlayerList(teamID)) do
			local name,_,spectator = GetPlayerInfo(playerID)
			if not spectator and name == playerName then
				return teamID
			end
		end
	end
	-- if not found
	return nil
end


local function unitIDtoMeaningfulName(unitID)
	local unitOwner = GetUnitTeam(unitID)
	local unitDefID = GetUnitDefID(unitID)
	local unitName = unitID
	local playerName = ""
	if unitDefID then
		local unitDef = UnitDefs[unitDefID]
		if unitDef and unitDef.humanName then
			unitName = unitDef.humanName
		end
	end
	if unitOwner then
		local _,teamLeader = GetTeamInfo(unitOwner)
		if unitOwner then
			playerName = unitOwner
		end
		local leaderName = GetPlayerInfo(teamLeader)
		if leaderName then
			playerName = leaderName
		end
	end
	return playerName .. " \'s " .. unitName
end

function betKey(_,_,params)
	local betType = params[1]
	if not betType then
		Echo("betting: wrong input params, espect betType")
		return
	end
	local selUnits = GetSelectedUnits()
	if #selUnits == 0 then
		Echo("betting: you need to select a unit to bet")
		return
	end
	if #selUnits > 1 then
		Echo("betting: too many units selected")
		return
	end
	local selUnit = selUnits[1]
	if betType == "team" then
		betID = GetUnitTeam(selUnit)
	else
		betID = selUnit
	end
	
	SendCommands({"chatall", "pastetext /placebet " .. betType .. " " .. betID .. " "})
end

local function getMinBetTimeDelta()
	--the min time of bet will be slowly increased from 0 to MIN_BET_TIME in the period from game start to MIN_BET_TIME_SCALE
	return floor(min(1,GetGameFrame()/MIN_BET_TIME_SCALE)*max(MIN_BET_TIME,0))
end


--copied off directly because handling callback is such a pain
local function getMinBetTime()
	return GetGameFrame() + getMinBetTimeDelta(), getMinBetTimeDelta()
end

function getBetTime(_,_,params)
	local absTime, relTime = getMinBetTime()
	Echo("min absolute bet time: " .. ceil(absTime/BET_GRANULARITY) .. " min bet time increment: " .. floor(relTime/BET_GRANULARITY+0.5))
end

--copied off directly because handling callback is such a pain
local function getBetCost(playerID,betType,betID)
	if not playerID or not betType or not betID then
		return
	end
	if not BET_COST[betType] then
		return
	end
	local betCount = 0
	if playerBetList[playerID] and playerBetList[playerID][betType] and playerBetList[playerID][betType][betID] then
		betCount = #playerBetList[playerID][betType][betID]
	end
	 -- with negative best costs, first bet on the same element costs abs(BET_COST), second 2*abs(BET_COST), etc
	return BET_COST[betType] >= 0 and BET_COST[betType] or (betCount+1)*abs(BET_COST[betType])
end

function toggleViewBets(_,_,params)
	local oldVal = viewBets
	viewBets = not viewBets
	if tonumber(params[1]) then
		viewBets = params[1] ~= 0
	end
	if viewBets then
		Echo("displaying bets over units")
	else
		Echo("disabled display of bets over units")
	end
	if oldVal == true and viewBets == false then
		--delete all display lists
		for _,displayList in pairs(unitDisplayList) do
			glDeleteList(displayList)
			displayList = nil
		end
	end
	if oldVal == false and viewBets == true then
		for unitID, betInfo in pairs(betList.unit or {}) do
			updateDisplayList(unitID,betInfo)
		end
	end
end

function placeBet(_,_,params)
	if #params < 3 then
		Echo("too few params: betType betID time")
		return
	end
	local betType = params[1]
	local betID = params[2]
	if betType == "team" then
		if not tonumber(betID) then
			betID = playerNameToTeamID(betID)
		end
	end
	local time
	if params[3] == "soon" then
		time = floor(getMinBetTime()/BET_GRANULARITY+0.5)*BET_GRANULARITY
	elseif params[3]:find("+") then -- it's a time displacement
		local displacement = tonumber(params[3]:sub(2))
		if not time then
			Echo("invalid bet time")
			return
		end
		time = ceil(GetGameFrame()/BET_GRANULARITY)*BET_GRANULARITY + displacement*BET_GRANULARITY
	else 
		time = tonumber(params[3])
		if not time then
			Echo("invalid bet time")
			return
		end
		time = time*BET_GRANULARITY
	end
	local ok,text = placeMyBet(betType, betID,time)
	if not ok then
		Echo(text)
	end
end

function printbets(_,_,params)
	local bets =  betList
	-- filter to only 1 betType if params is fed
	if params[1] then
		local tempBets = bets
		local betType = params[1]
		bets = {}
		bets[betType] = tempBets[betType]
		if not bets then
			Echo("invalid betType or no bets placed of that type")
			return
		end
	end
	for betType, betArray in pairs(bets) do
		local tempBetList = betArray
		-- filter to only 1 element if params is fed
		if betType == "team" then
			if params[2] then
				local index = playerNameToTeamID(params[2])
				if not index then
					Echo("Invalid playername")
					return
				end
				betArray = {}
				betArray[index] = tempBetList[index]
				if not betArray[index] then
					Echo("No bets available for selected player")
					return
				end
			end
		elseif betType == "unit" then
			if params[2] then
				local index = params[2]
				if not index then
					Echo("Invalid unitID")
					return
				end
				betArray = {}
				betArray[index] = tempBetList[index]
				if not betArray[index] then
					Echo("No bets available for selected unit")
					return
				end
			end
		end
		for betID, betsinfo in pairs(betArray) do
			if betType == "team" then
				local humanName = betID
				local _,teamLeader = GetTeamInfo(betID)
				local leaderName = GetPlayerInfo(teamLeader)
				if leaderName then
					humanName = leaderName
				end
				Echo("bets for player: " .. humanName )
			elseif betType == "unit" then
				local humanName
				if unitHumanNames[betID] then
					humanName = unitHumanNames[betID]
				else
					-- try to generate it anwyay
					humanName = unitIDtoMeaningfulName(betID)
				end
				Echo("bets for " .. humanName )
			end
			for timeSlot,betEntry in pairs(betsinfo) do
				local playerID = PlayerIDtoName(betEntry.player)
				local validBet = GetGameFrame() >= betEntry.validFrom
				Echo((validBet and "-" or "x") .. " time: " .. (betEntry.betTime/(BET_GRANULARITY)) .. " by: " .. playerID .. " cost: " .. betEntry.betCost .. (validBet and "" or (" valid from: " .. floor(betEntry.validFrom/BET_GRANULARITY+0.5)) ))
			end
			local numBets, totalScore, totalWin = getBetWinScore(betType,betID)
			Echo("total bets: " .. numBets .. " total points bet: " .. totalScore .. " prize: " .. totalWin )
		end
	end
end

function printscores()
	for playerID, score in pairs(playerScores) do
		playerID = PlayerIDtoName(playerID)
		Echo(playerID .. ": score: " .. score.score .. " currently running bets: " .. score.currentlyRunning .." won: " .. score.won .. " lost: " .. score.lost .. " total bets placed: " .. score.totalPlaced)
	end
end

function widget:GameOver()
	if next(playerScores) ~= nil then
		Echo("Betting game over! Scores are:")
	end
	printscores()
end

function betOverCallback(betType, betID, winnerID, prizePoints)
	SendCommands({"luarules getbetsstats","luarules getplayerscores", "luarules getbetlist", "luarules getplayerbetlist"})
	winnerID = PlayerIDtoName(winnerID)
	local textstring = ""
	if betType == "team" then
		textstring = "team " .. TeamIDtoName(betID)
	elseif betType == "unit" then
		textstring = unitHumanNames[betID] or unitIDtoMeaningfulName(betID)
		-- delete to avoid errors when recycling ids
		unitHumanNames[betID] = nil
	end
	Echo( textstring .. " has died! " .. winnerID .. " has won " .. prizePoints .. " points.")
end

function receivedBetCallback(playerID, betType, betID, betTime, betCost)
	SendCommands({"luarules getbetsstats","luarules getplayerscores", "luarules getbetlist", "luarules getplayerbetlist"})
	playerID = PlayerIDtoName(playerID)
	local textstring = ""
	if betType == "team" then
		textstring = "team " .. TeamIDtoName(betID)
	elseif betType == "unit" then
		textstring = unitIDtoMeaningfulName(betID)
		-- save the unit's text string because unitID will be invalid after it dies
		-- and we won't be able to fetch infos
		unitHumanNames[betID] = textstring
	end
	Echo( playerID .. " has bet " .. betCost .. " points on " .. textstring .. " to die at " .. betTime/(BET_GRANULARITY) .. " minutes")
end

function betValidCallback()
	SendCommands({"luarules getbetsstats", "luarules getbetlist"})
end

function widget:SetConfigData(data)
	viewBets = data.viewBets
end

function widget:GetConfigData()
	return
	{
		viewBets = viewBets
	}
end

function RecvBetStats(newBetStats)
	betStats = newBetStats or {}
	widget:GameFrame(GetGameFrame())
end

function RecvPlayerScores(newPlayerScores)
	playerScores = newPlayerScores or {}
end

function RecvBetList(newBetList)
	betList = newBetList or {}
	widget:GameFrame(GetGameFrame())
end

function RecvPlayerBetList(newPlayerBetList)
	playerBetList = newPlayerBetList or {}
end

function widget:PlayerChanged()
	local newstate = GetSpectatingState()
	if newstate and oldspectatingstate ~= newstate then
		-- we just become spectators, we can be a player now!
		--refresh information
		SendCommands({"luarules getbetsstats","luarules getplayerscores", "luarules getbetlist", "luarules getplayerbetlist"})
	end
	oldspectatingstate = newstate
end

function widget:Initialize()
	widgetHandler:RegisterGlobal('getBetsStats', RecvBetStats)
	widgetHandler:RegisterGlobal('getPlayerScores', RecvPlayerScores)
	widgetHandler:RegisterGlobal('getBetList', RecvBetList)
	widgetHandler:RegisterGlobal('getPlayerBetList', RecvPlayerBetList)
	widgetHandler:RegisterGlobal('placeBet', RecvPlaceBet)

	widgetHandler:RegisterGlobal('betOverCallback', betOverCallback)
	widgetHandler:RegisterGlobal('receivedBetCallback', receivedBetCallback)
	widgetHandler:RegisterGlobal('betValidCallback', betValidCallback)

	widgetHandler:AddAction("placebet", placeBet, nil, "t")
	widgetHandler:AddAction("printbets", printbets, nil, "t")
	widgetHandler:AddAction("printscores", printscores, nil, "t")
	widgetHandler:AddAction("viewbets", toggleViewBets, nil, "t")
	widgetHandler:AddAction("bettime", getBetTime, nil, "t")
	widgetHandler:AddAction("bet", betKey, nil, "t")

	SendCommands({"bind ctrl+alt+b bet unit","bind ctrl+shift+alt+b bet team"})

	--FIXME: why is the engine retarded and blocks commands to luarules before frame2???
	if GetGameFrame() > 2 then
		SendCommands({"luarules getbetsstats","luarules getplayerscores", "luarules getbetlist", "luarules getplayerbetlist"})
	end
end

function widget:Shutdown()

	widgetHandler:DeregisterGlobal('betOverCallback')
	widgetHandler:DeregisterGlobal('receivedBetCallback')
	widgetHandler:DeregisterGlobal('betValidCallback')

	widgetHandler:DeregisterGlobal('getBetsStats')
	widgetHandler:DeregisterGlobal('getPlayerScores')
	widgetHandler:DeregisterGlobal('getBetList')
	widgetHandler:DeregisterGlobal('getPlayerBetList')
	widgetHandler:DeregisterGlobal('placeBet')

	for _,displayList in pairs(unitDisplayList) do
		glDeleteList(displayList)
		displayList = nil
	end
end

function widget:UnitDestroyed(unitID)
	if unitDisplayList[unitID] then
		glDeleteList(unitDisplayList[unitID])
		unitDisplayList[unitID] = nil
	end
end


function drawCylinder(radius, halfLength)
	local slices = 20
	gl.MatrixMode(GL.MODELVIEW)
	for i = 0, slices do
		local theta = i*(2.0*pi/slices)
		local nextTheta = (i+1)*(2.0*pi/slices)
		glBeginEnd(GL.TRIANGLE_STRIP, function()
			--vertex at middle of end
			glVertex(0.0, halfLength, 0.0)
			--vertices at edges of circle*
			glVertex(radius*cos(theta), halfLength, radius*sin(theta))
			glVertex(radius*cos(nextTheta), halfLength, radius*sin(nextTheta))
			--the same vertices at the bottom of the cylinder
			glVertex(radius*cos(nextTheta), -halfLength, radius*sin(nextTheta))
			glVertex(radius*cos(theta), -halfLength, radius*sin(theta))
			glVertex(0.0, -halfLength, 0.0)
		end)
	end
end



function updateDisplayList(unitID,betInfo)
	local stepSize = 15
	local cubeShift = 25
	local numBets, totalScore, totalWin = getBetWinScore("unit",unitID)
	local cubeScaleFactor = (totalWin)^0.5 --while it should be cube root to make the volume linear with the total win, i prefer square, or it grows too little 
	local cubeFactor = 5*cubeScaleFactor
	if unitDisplayList[unitID] then
		glDeleteList(unitDisplayList[unitID])
	end
	unitDisplayList[unitID] = glCreateList( function()
		glPushMatrix()
			local unitPos = {GetUnitPosition(unitID,true,true)}
			glTranslate(unitPos[4],unitPos[5]+GetUnitRadius(unitID),unitPos[6])
			if IsUnitSelected(unitID) then
				glBillboard()
				for timeSlot,betEntry in pairs(betInfo) do
					glTranslate(0,stepSize,0)
					local playerName = PlayerIDtoName(betEntry.player)
					local validBet = GetGameFrame() >= betEntry.validFrom
					glText((validBet and "-" or "x") .. " time: " .. (betEntry.betTime/(BET_GRANULARITY)) .. " by: " .. playerName .. (validBet and "" or (" valid from: " .. floor(betEntry.minBetTime/BET_GRANULARITY+0.5)) ) .. " cost: " .. betEntry.betCost, 0, 0,stepSize, "co")
				end
				glTranslate(0,stepSize,0)
				local betCost = getBetCost(myPlayerID,"unit",unitID)
				glText("total bets: " .. numBets .. " total points bet: " .. totalScore .. " prize: " .. totalWin .. " betting cost: " .. betCost, 0, 0,stepSize, "co")
			else
				glColor({1,1,0,0.4})
				glTranslate(0,cubeShift+cubeFactor,0)
				drawCylinder(3*cubeFactor, cubeFactor)
			end
		glPopMatrix()
	end)
end

function widget:GameFrame(n)
	--FIXME: why is the engine retarded and blocks commands to luarules before frame2???
	if n == 2 then
		SendCommands({"luarules getbetsstats","luarules getplayerscores", "luarules getbetlist", "luarules getplayerbetlist"})
	end
	if not viewBets or not betList.unit then
		return
	end
	for unitID, betInfo in pairs(betList.unit) do
		updateDisplayList(unitID,betInfo)
	end
end


function widget:DrawWorld()
	glPushMatrix()
		for _,displayList in pairs(unitDisplayList) do
			glCallList(displayList)
		end
	glPopMatrix()
end