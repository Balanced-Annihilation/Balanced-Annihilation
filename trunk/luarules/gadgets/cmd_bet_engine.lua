-------------------------------------------------------------------------------
--		   DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
--				   Version 2, December 2004
--
--Copyright (C) 2010 BrainDamage
--Everyone is permitted to copy and distribute verbatim or modified
--copies of this license document, and changing it is allowed as long
--as the name is changed.
--
--		   DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
--  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
--
-- 0. You just DO WHAT THE FUCK YOU WANT TO.
-------------------------------------------------------------------------------

--[[
how the game works:
you bet as spectator the time when a player or an unit dies
your starting score is number of players -1
you can bet multiple times on the same thing, each time the cost will increase by 1
for the bet to be valid, it has to be placed at least x time before the actual death
when the player dies, the better who got closest collects the victory
the reward is equal to number of bets being made on the player
]]--

function gadget:GetInfo()
	return {
		name		= "Bet Engine",
		desc		= "Handles low level logic for spectator bets",
		author		= "BrainDamage",
		date		= "Dec,2010",
		license		= "WTFPL",
		layer		= 0,
		enabled		= true,
	}
end


if gadgetHandler:IsSyncedCode() then


local simSpeed = Game.gameSpeed
local MIN_BET_TIME = 5*60*simSpeed -- frames
local MIN_BET_TIME_SCALE = 10*60*simSpeed --frames, the time of bet will be slowly increased from 0 to MIN_BET_TIME during this period
local BET_GRANULARITY = 1*60*simSpeed -- frames
local BET_COST = {team=-1,unit=-1} -- if negative, cost BET_COST*numbets, if 0 or positive it's fixed
local POINTS_PRIZE_PER_BET = {team=1,unit=1} -- negative values instead assign the bet cost times prize to the winner
local STARTING_SCORE = #Spring.GetTeamList() -1 -(Spring.GetGaiaTeamID() and 1 or 0) -- minus one to leave last "survivor" in FFA, and minus another because of gaia
local _G_INDEX = "betengine"

-- dynamic data tables, hold infos about bets, scores and other players
local playerBets = {} -- indexed by playerID: {[betType]={[betID]={{[1]=time,[2]=time}, [betID]=... }}
local playerScores = {} -- indexed by playerID: {points,currentlyRunning,won,lost,totalPlaced}
local timeBets = {} -- indexed by betType: {[betID]={[betSlot]={playerID,timestamp,betTime,betCost,betType,validFrom}, [betTime2]=..}
local betStats = {} -- indexed by betType: {[betID]={numBets,totalSpent,prizePoints}
local deadTeams = {} -- indexed by TeamID: {[teamID] = true}
local betValid = {} -- indexed by frame: {1={betType,betID,timeSlot,scoreIncrease,playerID},2=...}

local GetTeamUnitCount = Spring.GetTeamUnitCount
local GaiaTeam = Spring.GetGaiaTeamID()
local GetGameFrame = Spring.GetGameFrame
local GetPlayerInfo = Spring.GetPlayerInfo
local GetTeamInfo = Spring.GetTeamInfo
local ValidUnitID = Spring.ValidUnitID
local GetUnitIsDead = Spring.GetUnitIsDead
local SetGameRulesParam = Spring.SetGameRulesParam
local abs = math.abs
local min = math.min
local max = math.max
local floor = math.floor
local append = table.append

local function getMinBetTimeDelta()
	--the min time of bet will be slowly increased from 0 to MIN_BET_TIME in the period from game start to MIN_BET_TIME_SCALE
	return floor(min(1,GetGameFrame()/MIN_BET_TIME_SCALE)*max(MIN_BET_TIME,0))
end

local function getMinBetTime()
	return GetGameFrame() + getMinBetTimeDelta(), getMinBetTimeDelta()
end

local function getBetTimeSlot(betTime)
	return floor(betTime/BET_GRANULARITY+0.5)*BET_GRANULARITY
end

local function getCreatePlayerScores(playerID)
	if not playerScores[playerID] then
		playerScores[playerID] = {score=STARTING_SCORE,currentlyRunning=0,won=0,lost=0,totalPlaced=0}
	end
	return playerScores[playerID]
end

local function getCreateTimeBets(betType,betID)
	if not timeBets[betType] then
		timeBets[betType] = {}
	end
	if not timeBets[betType][betID] then
		timeBets[betType][betID] = {}
	end
	return timeBets[betType][betID]
end

local function getCreatePlayerBets(playerID,betType,betID)
	if not playerBets[playerID] then
		playerBets[playerID] = {}
	end
	if not playerBets[playerID][betType] then
		playerBets[playerID][betType] = {}
	end
	if not playerBets[playerID][betType][betID] then
		playerBets[playerID][betType][betID] = {}
	end
	return playerBets[playerID][betType][betID]
end

local function getCreateBetStats(betType,betID)
	if not betStats[betType] then
		betStats[betType] = {}
	end
	if not betStats[betType][betID] then
		betStats[betType][betID] = {numBets = 0, totalScore = 0, prizePoints = 0}
	end
	return betStats[betType][betID]
end

local function getCreateValidFrom(frame)
	if not validFrom[frame] then
		validFrom[frame] = {}
	end
	return validFrom[frame]
end

local function getBetCost(playerID,betType,betID)
	if not playerID or not betType or not betID then
		return
	end
	if not BET_COST[betType] then
		return
	end
	local betCount = 0
	if playerBets[playerID] and playerBets[playerID][betType] and playerBets[playerID][betType][betID] then
		betCount = #playerBets[playerID][betType][betID]
	end
	 -- with negative best costs, first bet on the same element costs abs(BET_COST), second 2*abs(BET_COST), etc
	return BET_COST[betType] >= 0 and BET_COST[betType] or (betCount+1)*abs(BET_COST[betType])
end

local function isValidBet(playerID, betType, betID, betTime)
	if not playerID then
		return false, "playerID is nil"
	end
	if not betType then
		return false, "betType is nil"
	end
	if not betID then
		return false, "betID is nil"
	end
	if not betTime then
		return false, "betTime is nil"
	end
	if not tonumber(betTime) then
		return false, "betTime must be a number"
	end
	if betTime < 0 then
		return false, "betTime must be positive"
	end
	local _,betteractive,betterspectator = GetPlayerInfo(playerID)
	if betterspectator == nil then
		return false, "betting playerID (" .. playerID .. ") does not exist"
	end
	if betterspectator == false then
		return false, "only spectators can bet"
	end
	if betteractive == false then
		return false, "only active spectators can bet"
	end
	if betType == "team" then
		local _,_,deadTeam = GetTeamInfo(betID)
		if deadTeam == nil then
			return false, "betted teamID (" .. betID .. ") does not exists"
		end
		if deadTeam or deadTeams[betID] then
			return false, "cannot bet on dead teams ..(" .. betID .. ")"
		end
	elseif betType == "unit" then
		local validUnit = ValidUnitID(betID)
		if not validUnit then
			return false, "betted unitID (" .. unitID .. ") does not exist"
		end
		local isDead = GetUnitIsDead(betID)
		if isDead then
			return false, "cannot bet on dead units (" .. unitID ..  ")"
		end
	else
		return false, "invalid betType (" .. betType .. ")"
	end
	local playerScore = getCreatePlayerScores(playerID)
	local betCost = getBetCost(playerID,betType,betID)
	if playerScore.score < betCost then
		return false, "not enough points to bet ( got: " .. playerScore.score .. " cost: " .. betCost .. " )"
	end
	-- check if there are already existing bets on the player within the same time slot
	local timeSlot = getBetTimeSlot(betTime)
	if timeBets[betType] then
		if timeBets[betType][betID] then
			if timeBets[betType][betID][timeSlot] ~= nil then
				return false, "bet time "  .. betTime .. ": slot already taken"
			end
		end
	end

	return true, ""
end


local function placedBet(playerID, betType, betID, betTime)
	if not isValidBet(playerID, betType, betID, betTime) then
		return
	end
	local validFrom = getMinBetTime()
	-- decrement points and save infos
	local playerpersonalbets = getCreatePlayerBets(playerID,betType,betID)
	local betCost = getBetCost(playerID,betType,betID)
	local bet = getCreateTimeBets(betType,betID) -- only needed to create the table entry
	local betStat = getCreateBetStats(betType,betID)
	getCreateValidFrom(validFrom)
	-- in this case the cost has same value of the next element
	playerpersonalbets[betCost] = betTime
	playerBets[playerID][betType][betID] = playerpersonalbets
	local playerScore = getCreatePlayerScores(playerID)
	playerScores[playerID].score = playerScore.score - betCost
	playerScores[playerID].totalPlaced = playerScores[playerID].totalPlaced + 1
	playerScores[playerID].currentlyRunning = playerScores[playerID].currentlyRunning + 1
	local timeSlot = getBetTimeSlot(betTime)
	timeBets[betType][betID][timeSlot] = {player=playerID, betTime = betTime, timestamp=GetGameFrame(), betCost=betCost, betType = betType, validFrom = validFrom}
	local scoreIncrease = (POINTS_PRIZE_PER_BET[betType] < 0 and abs(POINTS_PRIZE_PER_BET[betType])*betCost or POINTS_PRIZE_PER_BET[betType])
	betStats[betType][betID].numBets = betStat.numBets + 1
	betStats[betType][betID].totalSpent = betStat.totalSpent + betCost
	betStats[betType][betID].prizePoints = betStat.prizePoints + (getMinBetTimeDelta() == 0 and scoreIncrease or 0)
	append(betValid[validFrom],{betType = betType, betID = betID, timeSlot = timeSlot, scoreIncrease = scoreIncrease, playerID = playerID})
	-- updated exported tables
	local exporttable = _G[_G_INDEX]
	exporttable.playerScores = playerScores
	exporttable.timeBets = timeBets
	exporttable.playerBets = playerBets
	exporttable.betStats = betStats
	_G[_G_INDEX] = exporttable
	-- run received bet callback
	SendToUnsynced("receivedBetCallback",playerID, betType, betID, betTime, betCost, validFrom)
end

local function betOver(betType, betID)
	if not timeBets[betType] then
		return
	end
	if not timeBets[betType][betID] then
		return
	end
	local betList = timeBets[betType][betID]
	local currentFrame = GetGameFrame()
	local minValue = nil
	local winnerID = nil
	--local prizePoints = #betList
	-- give 1 point reward for every bet to the winner
	local prizePoints = 0
	for timeSlot,betEntry in pairs(betList) do
		prizePoints = prizePoints + (POINTS_PRIZE_PER_BET[betEntry.betType] < 0 and abs(POINTS_PRIZE_PER_BET[betEntry.betType])*betEntry.betCost or POINTS_PRIZE_PER_BET[betEntry.betType])
		local validBet = currentFrame >= betEntry.validFrom and select(3,GetPlayerInfo(betEntry.player)) and select(2,GetPlayerInfo(betEntry.player))
		local deltavalue = abs(currentFrame-betEntry.betTime)
		if betValid[betEntry.validFrom] then
			--bet was not valid at gameover, it'll never be, remove from checking queue
			for toDelete,betData in pairs(betValid[betEntry.validFrom]) do
				if betData.betType == betEntry.betType and betData.betID == betEntry.betID and betData.timeSlot == timeSlot then
					betValid[betEntry.validFrom][timeSlot] = nil
					break
				end
			end
		end
		--prevent bet "sniping" ( ignore bets that were made too close to the actual death ), and player must be active and a spec
		if validBet then
			if not minValue then
				minValue = deltavalue
				winnerID = betEntry.player
			else
				if deltavalue < minValue then -- find player who got closest
					minValue = deltavalue
					winnerID = betEntry.player
				end
			end
		end
	end
	if prizePoints == 0 then
		-- no bets were made
		return
	end
	for playerID, scores in pairs(playerScores) do
		-- get the amount of bets the player placed on the item
		if playerBets[playerID] then
			if playerBets[playerID][betType] then
				if playerBets[playerID][betType][betID] then
					local numBets = #playerBets[playerID][betType][betID]
					if numBets > 0 then
						-- update score for the winner, set also win/loss count
						if playerID == winnerID then
							--we got a winner!
							scores.score = scores.score + prizePoints
							scores.won = scores.won + 1
						else
							scores.lost = scores.lost + 1
						end
						scores.currentlyRunning = scores.currentlyRunning - numBets
						playerScores[playerID] = scores
					end
					--delete the bets at the same time  ( needed because unitID can be recycled )
					playerBets[playerID][betType][betID] = nil
				end
			end
		end
	end
	--delete the bet infos ( needed because unitID can be recycled )
	timeBets[betType][betID] = nil
	betStats[betType][betID] = nil

	-- update shared tables
	_G[_G_INDEX].playerScores = playerScores
	_G[_G_INDEX].timeBets = timeBets
	_G[_G_INDEX].playerBets = playerBets
	_G[_G_INDEX].betStats = betStats
	-- run bet over callback
	SendToUnsynced("betOverCallback", betType, betID, winnerID, prizePoints)
end

function gadget:GameFrame(n)
	if betValid[n] then
		for _,betData in pairs(betValid[n]) do
			if betStats[betData.betType] and betStats[betData.betType][betData.betID] then
				betStats[betData.betType][betData.betID].prizePoints = betStats[betData.betType][betData.betID].prizePoints + betData.scoreIncrease
				_G[_G_INDEX].betStats = betStats
				SendToUnsynced("betValidCallback",betData.playerID, betData.betType, betData.betID, betData.timeSlot,betData.scoreIncrease)
			end
		end
		betValid[n] = nil
	end
end

local function teamDeath(teamID)
	-- ignore gaia
	if teamID == GaiaTeam then
		return
	end
	if deadTeams[teamID] then -- don't count a dead team multiple times
		return
	end
	deadTeams[teamID] = true
	betOver("team",teamID)
end

function gadget:TeamDied(teamID)
	teamDeath(teamID)
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeamID)
	betOver("unit",unitID)
	if GetTeamUnitCount(teamID) == 0 then
		teamDeath(teamID)
	end
end


function gadget:RecvLuaMsg(msg, playerID)
	if msg:match("bet %l+ %d+ %d+")then
		msg = msg:sub(#"bet "+1) -- crop the "bet " string
		-- here we receive each player's bets, including our own
		--search for betType, separated by space
		local spaceposition = msg:find(" ")
		local betType = msg:sub(1,spaceposition-1)
		msg = msg:sub(spaceposition+1)
		-- now search for betID
		spaceposition = msg:find(" ")
		local betID = tonumber(msg:sub(1,spaceposition-1))
		--rest is time
		local time = tonumber(msg:sub(spaceposition+1))
		placedBet(playerID,betType,betID,time)
		return true
	end
end

function gadget:Initialize()
	SetGameRulesParam(_G_INDEX.."MIN_BET_TIME",MIN_BET_TIME,{public=true})
	SetGameRulesParam(_G_INDEX.."MIN_BET_TIME_SCALE",MIN_BET_TIME_SCALE,{public=true})
	SetGameRulesParam(_G_INDEX.."BET_GRANULARITY",BET_GRANULARITY,{public=true})
	SetGameRulesParam(_G_INDEX.."POINTS_PRIZE_PER_BET".."unit",POINTS_PRIZE_PER_BET.unit,{public=true})
	SetGameRulesParam(_G_INDEX.."POINTS_PRIZE_PER_BET".."team",POINTS_PRIZE_PER_BET.team,{public=true})
	SetGameRulesParam(_G_INDEX.."BET_COST".."unit",BET_COST.unit,{public=true})
	SetGameRulesParam(_G_INDEX.."BET_COST".."team",BET_COST.team,{public=true})
	SetGameRulesParam(_G_INDEX.."STARTING_SCORE",STARTING_SCORE,{public=true})


	-- publish all available API functions and tables in the gadget shared table
	local exporttable = {}
	-- API functions
	exporttable.isValidBet = isValidBet
	exporttable.getMinBetTime = getMinBetTime
	exporttable.placeMyBet = placeMyBet
	exporttable.getBetCost = getBetCost
	-- dynamic data tables
	exporttable.playerScores = playerScores
	exporttable.timeBets = timeBets
	exporttable.playerBets = playerBets
	exporttable.betStats = betStats

	_G[_G_INDEX] = exporttable
end

function gadget:Shutdown()
	_G[_G_INDEX] = nil
end

else
--- BEGIN UNSYNCED CODE
	
local GetSpectatingState = Spring.GetSpectatingState

function gadget:Initialize()
	gadgetHandler:AddSyncAction("betOverCallback", handleBetOverCallback)
	gadgetHandler:AddSyncAction("receivedBetCallback", handleReceivedBetCallback)
	gadgetHandler:AddSyncAction("betValidCallback", handleBetValidCallback)

	gadgetHandler:AddChatAction("getminbettime", PushGetMinBetTime, nil, "t")
	gadgetHandler:AddChatAction("isvalidbet", PushIsValidBet, nil, "t")
	gadgetHandler:AddChatAction("placebet", PushPlaceBet, nil, "t")
	gadgetHandler:AddChatAction("getbetcost", PushGetBetCost, nil, "t")
	gadgetHandler:AddChatAction("getbetsstats", PushGetBetsStats, nil, "t")
	gadgetHandler:AddChatAction("getplayerscores", PushGetPlayerScores, nil, "t")
	gadgetHandler:AddChatAction("getbetlist", PushGetBetList, nil, "t")
	gadgetHandler:AddChatAction("getplayerbetlist", PushGetPlayerBetList, nil, "t")

end

function gadget:Shutdown()
	gadgetHandler:RemoveSyncAction("betOverCallback")
	gadgetHandler:RemoveSyncAction("receivedBetCallback")
	gadgetHandler:RemoveSyncAction("betValidCallback")

	gadgetHandler:RemoveChatAction("getminbettime")
	gadgetHandler:RemoveChatAction("isvalidbet")
	gadgetHandler:RemoveChatAction("placebet")
	gadgetHandler:RemoveChatAction("getbetcost")
	gadgetHandler:RemoveChatAction("getbetsstats")
	gadgetHandler:RemoveChatAction("getplayerscores")
	gadgetHandler:RemoveChatAction("getbetlist")
	gadgetHandler:RemoveChatAction("getplayerbetlist")
end


function PushGetMinBetTime()
	if Script.LuaUI("getMinBetTime") then
		Script.LuaUI.getMinBetTime(SYNCED.getMinBetTime())
	end
end

function PushIsValidBet(_,_,params)
	if Script.LuaUI("isValidBet") then
		if not select(2,GetSpectatingState()) then
			Script.LuaUI.isValidBet()
		else
			Script.LuaUI.isValidBet(SYNCED.isValidBet(unpack(params)))
		end
	end
end

function PushPlaceBet(_,_,params)
	if Script.LuaUI("placeBet") then
		if not select(2,GetSpectatingState()) then
			Script.LuaUI.placeBet()
		else
			local ok, result = SYNCED.isValidBet(unpack(params))
			if ok then
				SendLuaRulesMsg("bet " .. params[1] .. " " .. params[2] .. " " .. params[3])
				result = "Bet" .. betType .. "sent on " .. betID .. "at time " .. time
			end
			Script.LuaUI.placeBet(ok,result)
		end
	end
end

function PushGetBetCost(_,_,params)
	if Script.LuaUI("getBetCost") then
		if not select(2,GetSpectatingState()) then
			Script.LuaUI.getBetCost()
		else
			Script.LuaUI.getBetCost(SYNCED.getBetCost(unpack(params)))
		end
	end
end

function PushGetBetsStats(_,_,params)
	if Script.LuaUI("getBetsStats") then
		if not select(2,GetSpectatingState()) then
			Script.LuaUI.getBetsStats()
		else
			Script.LuaUI.getBetsStats(SYNCED.betStats)
		end
	end
end


function PushGetPlayerScores()
	if Script.LuaUI("getPlayerScores") then
		if not select(2,GetSpectatingState()) then
			Script.LuaUI.getPlayerScores()
		else
			Script.LuaUI.getPlayerScores(SYNCED.playerScores)
		end
	end
end

function PushGetBetList()
	if Script.LuaUI("getBetList") then
		if not select(2,GetSpectatingState()) then
			Script.LuaUI.getBetList()
		else
			Script.LuaUI.getBetList(SYNCED.timeBets)
		end
	end
end

function PushGetPlayerBetList()
	if Script.LuaUI("getPlayerBetList") then
		if not select(2,GetSpectatingState()) then
			Script.LuaUI.getPlayerBetList()
		else
			Script.LuaUI.getPlayerBetList(SYNCED.playerBets)
		end
	end
end


function handleBetOverCallback(_,betType, betID, winnerID, prizePoints)
	if not select(2,GetSpectatingState()) then
		return
	end
	if Script.LuaUI("betOverCallback") then
		Script.LuaUI.betOverCallback(betType, betID, winnerID, prizePoints)
	end
end

function handleReceivedBetCallback(_,playerID, betType, betID, betTime, betCost, validFrom)
	if not select(2,GetSpectatingState()) then
		return
	end
	if Script.LuaUI("receivedBetCallback") then
		Script.LuaUI.receivedBetCallback(playerID, betType, betID, betTime, betCost, validFrom)
	end
end

function handleBetValidCallback(_,playerID, betType, betID, timeSlot, scoreIncrease)
	if not select(2,GetSpectatingState()) then
		return
	end
	if Script.LuaUI("betValidCallback") then
		Script.LuaUI.betValidCallback(playerID, betType, betID, timeSlot, scoreIncrease)
	end
end

function gadget:GameOver()
	-- report scores to be stored in the replay
	for playerID, score in pairs(playerScores) do
		SendLuaRulesMsg("betreport: player " .. playerID .. " score " .. score.score .. " unfinished " .. score.currentlyRunning .." won " .. score.won .. " lost " .. score.lost .. " totalplaced " .. score.totalPlaced)
	end
end

end
