function gadget:GetInfo()
  return {
    name      = "Awards",
    desc      = "AwardsAwards",
    author    = "Bluestone",
    date      = "2013-07-06",
    license   = "GPLv2",
    layer     = -1,
    enabled   = true -- loaded by default?
  }
end


if (gadgetHandler:IsSyncedCode()) then

local SpAreTeamsAllied = Spring.AreTeamsAllied

local teamInfo = {}
local coopInfo = {}
local present = {}

local econUnitDefIDs = { --better to hardcode these since its complicated to pick them out with UnitDef properties
	--land t1
	UnitDefNames.armsolar.id,
	UnitDefNames.corsolar.id,
	UnitDefNames.armadvsol.id,
	UnitDefNames.coradvsol.id,
	UnitDefNames.armwin.id,
	UnitDefNames.corwin.id,
	UnitDefNames.armmakr.id,
	UnitDefNames.cormakr.id,
	--sea t1
	UnitDefNames.armtide.id,
	UnitDefNames.cortide.id,
	UnitDefNames.armfmkr.id,
	UnitDefNames.corfmkr.id,
	--land t2
	UnitDefNames.armmmkr.id,
	UnitDefNames.cormmkr.id,
	UnitDefNames.corfus.id,
	UnitDefNames.armfus.id,
	UnitDefNames.aafus.id,
	UnitDefNames.cafus.id,
	--sea t2
	UnitDefNames.armuwfus.id,
	UnitDefNames.coruwfus.id,
	UnitDefNames.armuwmmm.id,
	UnitDefNames.coruwmmm.id,
}


function gadget:GameStart()
	--make table of teams eligible for awards
	local allyTeamIDs = Spring.GetAllyTeamList()
	local gaiaTeamID = Spring.GetGaiaTeamID()
	for i=1,#allyTeamIDs do
		local teamIDs = Spring.GetTeamList(allyTeamIDs[i])
		for j=1,#teamIDs do
			local _,_,_,isAiTeam = Spring.GetTeamInfo(teamIDs[j])
			local isLuaAI = (Spring.GetTeamLuaAI(teamIDs[j]) ~= "")
			local isGaiaTeam = (teamIDs[j] == gaiaTeamID)
			if ((not isAiTeam) and (not isLuaAi) and (not isGaiaTeam)) then
				local playerIDs = Spring.GetPlayerList(teamIDs[j])
				local numPlayers = 0
				for _,playerID in pairs(playerIDs) do
					local _,_,isSpec = Spring.GetPlayerInfo(playerID) 
					if not isSpec then 
						numPlayers = numPlayers + 1
					end
				end
				
				if numPlayers > 0 then
					present[teamIDs[j]] = true
					teamInfo[teamIDs[j]] = {ecoDmg=0, fightDmg=0, otherDmg=0, dmgDealt=0, ecoUsed=0, dmgRatio=0, ecoProd=0, lastKill=0, dmgRec=0, sleepTime=0, unitsCost=0, present=true,}
					coopInfo[teamIDs[j]] = {players=numPlayers,}
				else
					present[teamIDs[j]] = false
				end
			else
				present[teamIDs[j]] = false
			end
		end
	end
end

function isEcon(unitDefID) 
	--return true if unitDefID is an eco producer, false otherwise
	for _,id in pairs(econUnitDefIDs) do
		if unitDefID == id then
			return true
		end
	end
	return false
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeamID)
	-- add destroyed unitID cost to stats for attackerTeamID
	if not attackerTeamID then return end
	if attackerTeamID == gaiaTeamID then return end
	if not present[attackerTeamID] then return end
	if (not unitDefID) or (not teamID) then return end
	if SpAreTeamsAllied(teamID, attackerTeamID) then return end
	
	--keep track of who didn't kill for longest (sleeptimes)
	local curTime = Spring.GetGameSeconds()
	if (curTime - teamInfo[attackerTeamID].lastKill > teamInfo[attackerTeamID].sleepTime) then
		teamInfo[attackerTeamID].sleepTime = curTime - teamInfo[attackerTeamID].lastKill
	end
	teamInfo[attackerTeamID].lastKill = curTime
	
	local ud = UnitDefs[unitDefID]
	local cost = ud.energyCost + 60 * ud.metalCost
	
	--keep track of killing 
	if #(ud.weapons) > 0 then
		teamInfo[attackerTeamID].fightDmg = teamInfo[attackerTeamID].fightDmg + cost
	elseif isEcon(unitDefID) then
		teamInfo[attackerTeamID].ecoDmg = teamInfo[attackerTeamID].ecoDmg + cost
	else
		teamInfo[attackerTeamID].otherDmg = teamInfo[attackerTeamID].otherDmg + cost --currently not using this but recording it for interest
	end		
	--Spring.Echo(teamInfo[attackerTeamID].fightDmg, teamInfo[attackerTeamID].ecoDmg, teamInfo[attackerTeamID].otherDmg)
end

function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
    if not teamID then return end
    if teamID==gaiaTeamID then return end
    if not present[teamID] then return end
    if not unitDefID then return end
    
    local ud = UnitDefs[unitDefID]
	local cost = ud.energyCost + 60 * ud.metalCost
    
    if #(ud.weapons) > 0 and not ud.customParams.iscommander then
        teamInfo[teamID].unitsCost = teamInfo[teamID].unitsCost + cost   
    end
    --Spring.Echo(teamID, teamInfo[teamID].unitsCost)
end

function gadget:UnitTaken(unitID, unitDefID, teamID, newTeam)
	if not newTeam then return end 
    if newTeam==gaiaTeamID then return end
	if not present[newTeam] then return end
    if not present[teamID] then return end
	if not unitDefID then return end --should never happen

	local ud = UnitDefs[unitDefID]
	local cost = ud.energyCost + 60 * ud.metalCost

	teamInfo[newTeam].ecoUsed = teamInfo[newTeam].ecoUsed + cost 
    if #(ud.weapons) > 0 then
        teamInfo[teamID].unitsCost = teamInfo[teamID].unitsCost + cost   
    end
end


function gadget:GameOver(winningAllyTeams)
	--calculate average damage dealt
	local avgTeamDmg = 0 
	local numTeams = 0
	for teamID,_ in pairs(teamInfo) do
		local cur_max = Spring.GetTeamStatsHistory(teamID)
		local stats = Spring.GetTeamStatsHistory(teamID, 0, cur_max)
		avgTeamDmg = avgTeamDmg + stats[cur_max].damageDealt / coopInfo[teamID].players
		numTeams = numTeams + 1
	end
	avgTeamDmg = avgTeamDmg / (math.max(1,numTeams))
	
	--get other stuff from engine stats
	for teamID,_ in pairs(teamInfo) do
		local cur_max = Spring.GetTeamStatsHistory(teamID)
		local stats = Spring.GetTeamStatsHistory(teamID, 0, cur_max)
		teamInfo[teamID].dmgDealt = teamInfo[teamID].dmgDealt + stats[cur_max].damageDealt	
		teamInfo[teamID].ecoUsed = teamInfo[teamID].ecoUsed + stats[cur_max].energyUsed + 60 * stats[cur_max].metalUsed
		if teamInfo[teamID].unitsCost > 175000 and teamInfo[teamID].dmgDealt >= 0.75 * avgTeamDmg then 
			teamInfo[teamID].dmgRatio = teamInfo[teamID].dmgDealt / teamInfo[teamID].unitsCost * 100
		else
			teamInfo[teamID].dmgRatio = 0
		end
		teamInfo[teamID].dmgRec = stats[cur_max].damageReceived
		teamInfo[teamID].ecoProd = stats[cur_max].energyProduced + 60 * stats[cur_max].metalProduced
	end

	--take account of coop
	for teamID,_ in pairs(teamInfo) do
		teamInfo[teamID].ecoDmg = teamInfo[teamID].ecoDmg / coopInfo[teamID].players
		teamInfo[teamID].fightDmg = teamInfo[teamID].fightDmg / coopInfo[teamID].players
		teamInfo[teamID].otherDmg = teamInfo[teamID].otherDmg / coopInfo[teamID].players
		teamInfo[teamID].dmgRec = teamInfo[teamID].dmgRec / coopInfo[teamID].players 
		teamInfo[teamID].dmgRatio = teamInfo[teamID].dmgRatio / coopInfo[teamID].players
	end
	
	
	--award awards
	local ecoKillAward, ecoKillAwardSec, ecoKillAwardThi, ecoKillScore, ecoKillScoreSec, ecoKillScoreThi = -1,-1,-1,0,0,0
	local fightKillAward, fightKillAwardSec, fightKillAwardThi, fightKillScore, fightKillScoreSec, fightKillScoreThi = -1,-1,-1,0,0,0
	local effKillAward, effKillAwardSec, effKillAwardThi, effKillScore, effKillScoreSec, effKillScoreThi = -1,-1,-1,0,0,0
	local ecoAward, ecoScore = -1,0
	local dmgRecAward, dmgRecScore = -1,0
	local sleepAward, sleepScore = -1,0
	for teamID,_ in pairs(teamInfo) do	
		--deal with sleep times
		local curTime = Spring.GetGameSeconds()
		if (curTime - teamInfo[teamID].lastKill > teamInfo[teamID].sleepTime) then
			teamInfo[teamID].sleepTime = curTime - teamInfo[teamID].lastKill
		end
		--eco killing award
		if ecoKillScore < teamInfo[teamID].ecoDmg then
			ecoKillScoreThi = ecoKillScoreSec
			ecoKillAwardThi = ecoKillAwardSec
			ecoKillScoreSec = ecoKillScore
			ecoKillAwardSec = ecoKillAward
			ecoKillScore = teamInfo[teamID].ecoDmg
			ecoKillAward = teamID
		elseif ecoKillScoreSec < teamInfo[teamID].ecoDmg then
			ecoKillScoreThi = ecoKillScoreSec
			ecoKillAwardThi = ecoKillAwardSec
			ecoKillScoreSec = teamInfo[teamID].ecoDmg
			ecoKillAwardSec = teamID
		elseif ecoKillScoreThi < teamInfo[teamID].ecoDmg then
			ecoKillScoreThi = teamInfo[teamID].ecoDmg
			ecoKillAwardThi = teamID		
		end
		--fight killing award
		if fightKillScore < teamInfo[teamID].fightDmg then
			fightKillScoreThi = fightKillScoreSec
			fightKillAwardThi = fightKillAwardSec
			fightKillScoreSec = fightKillScore
			fightKillAwardSec = fightKillAward
			fightKillScore = teamInfo[teamID].fightDmg
			fightKillAward = teamID
		elseif fightKillScoreSec < teamInfo[teamID].fightDmg then
			fightKillScoreThi = fightKillScoreSec
			fightKillAwardThi = fightKillAwardSec
			fightKillScoreSec = teamInfo[teamID].fightDmg
			fightKillAwardSec = teamID
		elseif fightKillScoreThi < teamInfo[teamID].fightDmg then
			fightKillScoreThi = teamInfo[teamID].fightDmg
			fightKillAwardThi = teamID		
		end
		--efficiency ratio award
		if effKillScore < teamInfo[teamID].dmgRatio then
			effKillScoreThi = effKillScoreSec
			effKillAwardThi = effKillAwardSec
			effKillScoreSec = effKillScore
			effKillAwardSec = effKillAward
			effKillScore = teamInfo[teamID].dmgRatio 
			effKillAward = teamID
		elseif effKillScoreSec < teamInfo[teamID].dmgRatio then
			effKillScoreThi = effKillScoreSec
			effKillAwardThi = effKillAwardSec
			effKillScoreSec = teamInfo[teamID].dmgRatio 
			effKillAwardSec = teamID
		elseif effKillScoreThi < teamInfo[teamID].dmgRatio then
			effKillScoreThi = teamInfo[teamID].dmgRatio 
			effKillAwardThi = teamID		
		end
		
		--eco prod award
		if ecoScore < teamInfo[teamID].ecoProd then
			ecoScore = teamInfo[teamID].ecoProd
			ecoAward = teamID		
		end
		--most damage rec award
		if dmgRecScore < teamInfo[teamID].dmgRec then
			dmgRecScore = teamInfo[teamID].dmgRec
			dmgRecAward = teamID		
		end
		--longest sleeper award
		if sleepScore < teamInfo[teamID].sleepTime and teamInfo[teamID].sleepTime > 12*60 then
			sleepScore = teamInfo[teamID].sleepTime
			sleepAward = teamID		
		end
	end	
	
	--is the cow awarded?
	local cowAward = -1
	if ecoKillAward ~= -1 and (ecoKillAward == fightKillAward) and (fightKillAward == effKillAward) and ecoKillAward ~= -1 then --check if some team got all the awards
		if winningAllyTeams and winningAllyTeams[1] then
			local won = false
			local _,_,_,_,_,cowAllyTeamID = Spring.GetTeamInfo(ecoKillAward)
			for _,allyTeamID in pairs(winningAllyTeams) do
				if cowAllyTeamID == allyTeamID then --check if this team won the game
					cowAward = ecoKillAward 
					break
				end
			end
		end
	end

	
	--tell unsynced
	SendToUnsynced("ReceiveAwards", ecoKillAward, ecoKillAwardSec, ecoKillAwardThi, ecoKillScore, ecoKillScoreSec, ecoKillScoreThi, 
									fightKillAward, fightKillAwardSec, fightKillAwardThi, fightKillScore, fightKillScoreSec, fightKillScoreThi, 
									effKillAward, effKillAwardSec, effKillAwardThi, effKillScore, effKillScoreSec, effKillScoreThi, 
									ecoAward, ecoScore, 
									dmgRecAward, dmgRecScore, 
									sleepAward, sleepScore,
									cowAward)
	
end




-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
else  -- UNSYNCED
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local glTexture = gl.Texture

local vsx, vsy

local imageWidth
local imageHeight = 0.1

local bigFont
local font

local drawAwards = false

local red = "\255"..string.char(171)..string.char(51)..string.char(51)
local blue = "\255"..string.char(51)..string.char(51)..string.char(151)
local green = "\255"..string.char(51)..string.char(151)..string.char(51)
local white = "\255"..string.char(251)..string.char(251)..string.char(251)
local yellow = "\255"..string.char(251)..string.char(251)..string.char(11)
local buttonNormal = "\255"..string.char(201)..string.char(201)..string.char(201)
local buttonHover = "\255"..string.char(201)..string.char(51)..string.char(51)

local playerListByTeam = {} --does not contain specs
local myPlayerID = Spring.GetMyPlayerID()

local awardList = {}

function gadget:Initialize()
    --register actions to SendToUnsynced messages
    gadgetHandler:AddSyncAction("ReceiveAwards", ProcessAwards)

    bigFont = gl.LoadFont("LuaUI/Fonts/FreeSansBold.otf", 20, 1, 1.5, true)
    font = gl.LoadFont("LuaUI/Fonts/FreeSansBold.otf", 16, 1, 1.5, true)

    --for testing
    if false then
        CreateAward('fuscup',0,'Destroying enemy resource production', white, 1,1,1,24378,1324,132)
        CreateAward('bullcup',0,'Destroying enemy units and defences',white, 1,1,1,24378,1324,132)
        CreateAward('comwreath',0,'Effective use of resources',white,1,1,1,24378,1324,132)
        CreateAward('cow',1,'Doing everything',white,1,1,1,24378,1324,132)
        CreateAward('',2,'',white,1,1,1,3,100,1000)
        drawAwards = true
    end

    --load a list of players for each team into playerListByTeam
    local teamList = Spring.GetTeamList()
    for _,teamID in pairs(teamList) do
        local playerList = Spring.GetPlayerList(teamID)
        local list = {} --without specs
        for _,playerID in pairs(playerList) do
            local name, _, isSpec = Spring.GetPlayerInfo(playerID)
            if not isSpec then
                table.insert(list, name)
            end
        end
        playerListByTeam[teamID] = list
    end
end

function gadget:ViewResize(width, height)
    vsx, vsy = width, height
    imageWidth = imageHeight * vsy / vsx
end

function gadget:Shutdown()
    Spring.SendCommands("endgraph 1")
end

function ProcessAwards(_, ecoKillAward, ecoKillAwardSec, ecoKillAwardThi, ecoKillScore, ecoKillScoreSec, ecoKillScoreThi,
                       fightKillAward, fightKillAwardSec, fightKillAwardThi, fightKillScore, fightKillScoreSec, fightKillScoreThi,
                       effKillAward, effKillAwardSec, effKillAwardThi, effKillScore, effKillScoreSec, effKillScoreThi,
                       ecoAward, ecoScore,
                       dmgRecAward, dmgRecScore,
                       sleepAward, sleepScore,
                       cowAward)

    --record who won which awards in chat message (for demo parsing by replays.springrts.com)
    --make all values positive, as unsigned ints are easier to parse
    local ecoKillLine    = '\161' .. tostring(1+ecoKillAward) .. ':' .. tostring(ecoKillScore) .. '\161' .. tostring(1+ecoKillAwardSec) .. ':' .. tostring(ecoKillScoreSec) .. '\161' .. tostring(1+ecoKillAwardThi) .. ':' .. tostring(ecoKillScoreThi)
    local fightKillLine  = '\162' .. tostring(1+fightKillAward) .. ':' .. tostring(fightKillScore) .. '\162' .. tostring(1+fightKillAwardSec) .. ':' .. tostring(fightKillScoreSec) .. '\162' .. tostring(1+fightKillAwardThi) .. ':' .. tostring(fightKillScoreThi)
    local effKillLine    = '\163' .. tostring(1+effKillAward) ..  ':' .. tostring(effKillScore) .. '\163' .. tostring(1+effKillAwardSec) .. ':' .. tostring(effKillScoreSec) .. '\163' .. tostring(1+effKillAwardThi) .. ':' .. tostring(effKillScoreThi)
    local otherLine      = '\164' .. tostring(1+cowAward) .. '\165' ..  tostring(1+ecoAward) .. ':' .. tostring(ecoScore).. '\166' .. tostring(1+dmgRecAward) .. ':' .. tostring(dmgRecScore) ..'\167' .. tostring(1+sleepAward) .. ':' .. tostring(sleepScore)
    local awardsMsg = ecoKillLine .. fightKillLine .. effKillLine .. otherLine
    Spring.SendLuaRulesMsg(awardsMsg)

    --create awards
    CreateAward('fuscup',0,'Destroying enemy resource production', white, ecoKillAward, ecoKillAwardSec, ecoKillAwardThi, ecoKillScore, ecoKillScoreSec, ecoKillScoreThi)
    CreateAward('bullcup',0,'Destroying enemy units and defences',white, fightKillAward, fightKillAwardSec, fightKillAwardThi, fightKillScore, fightKillScoreSec, fightKillScoreThi)
    CreateAward('comwreath',0,'Efficient use of units',white,effKillAward, effKillAwardSec, effKillAwardThi, effKillScore, effKillScoreSec, effKillScoreThi)
    if cowAward ~= -1 then
        CreateAward('cow',1,'Doing everything',white, ecoKillAward, 1,1,1,1,1)
    else
        CreateAward('',2,'',white, ecoAward, dmgRecAward, sleepAward, ecoScore, dmgRecScore, sleepScore)
    end
    drawAwards = true

    --don't show graph
    Spring.SendCommands("endgraph 0")
end

function colourNames(teamID)
        if teamID < 0 then return "" end
        nameColourR,nameColourG,nameColourB,nameColourA = Spring.GetTeamColor(teamID)
        R255 = math.floor(nameColourR*255)  --the first \255 is just a tag (not colour setting) no part can end with a zero due to engine limitation (C)
        G255 = math.floor(nameColourG*255)
        B255 = math.floor(nameColourB*255)
        if ( R255%10 == 0) then
                R255 = R255+1
        end
        if( G255%10 == 0) then
                G255 = G255+1
        end
        if ( B255%10 == 0) then
                B255 = B255+1
        end
    return "\255"..string.char(R255)..string.char(G255)..string.char(B255) --works thanks to zwzsg
end

function round(num, idp)
  return string.format("%." .. (idp or 0) .. "f", num)
end

function FindPlayerName(teamID)
    local plList = playerListByTeam[teamID]
    local name
    if plList[1] then
        name = plList[1]
        if #plList > 1 then
            name = name .. " (coop)"
        end
    else
        name = "(unknown)"
    end

    return name
end

function CreateAward(pic, award, note, noteColour, winnerID, secondID, thirdID, winnerScore, secondScore, thirdScore)
    awardList[#awardList+1] = {pic, award, note, noteColour, winnerID, secondID, thirdID, winnerScore, secondScore, thirdScore}
end

function RenderAward(awardData, index)
    local pic, award, note, noteColour, winnerID, secondID, thirdID, winnerScore, secondScore, thirdScore = unpack(awardData)

    local winnerName, secondName, thirdName

    --award is: 0 for a normal award, 1 for the cow award, 2 for the no-cow awards

    if winnerID >= 0 then
        winnerName = FindPlayerName(winnerID)
    else
        winnerName = "(not awarded)"
    end

    if secondID >= 0 then
        secondName = FindPlayerName(secondID)
    else
        secondName = "(not awarded)"
    end

    if thirdID >= 0 then
        thirdName = FindPlayerName(thirdID)
    else
        thirdName = "(not awarded)"
    end

    local x = 0.27
    local o = 0.765 - index * imageHeight

    --names
    if award ~= 2 then    --if its a normal award or a cow award
        local pic = ':l:LuaRules/Images/' .. pic ..'.png'
        glTexture(pic)
        Spring.Draw.Rectangle(x, o - imageHeight, x + imageWidth, o, {relative=true})
        bigFont:Print(colourNames(winnerID) .. winnerName, x + imageWidth + 0.02, o - 0.03, 1, "oSN")
        font:Print(noteColour .. note, x + imageWidth + 0.02, o - 0.05, 1, "oSN")
        glTexture(false)

        --extra text for cow award
        if award == 1 then
            font:Print(yellow .. 'Memorial WarCow', x + imageWidth/2, o - 0.08, 1, "ctoSN")
        end

    else --if the cow is not awarded, we replace it with minor awards (just text)
        local y = o - 0.05
        if winnerID >=0 then
            font:Print(colourNames(winnerID) .. winnerName .. white .. ' produced the most resources (' .. math.floor(winnerScore) .. ').', x, y, 1, "oSN")
            y = y - font.size / vsy
        end
        if secondID >= 0 then
            font:Print(colourNames(secondID) .. secondName .. white .. ' took the most damage (' .. math.floor(secondScore) .. ').', x, y, 1, "oSN")
            y = y - font.size / vsy
        end
        if thirdID >= 0 then
            font:Print(colourNames(thirdID) .. thirdName .. white .. ' slept longest, for ' .. math.floor(thirdScore/60) .. ' minutes.', x, y, 1, "oSN")
        end
    end

    --scores
    if award == 0 then --normal awards
        local x1 = 0.6
        local x2 = 0.73
        local y = o - 0.03

        if winnerID >= 0 then
            if pic == 'comwreath' then winnerScore = round(winnerScore, 2) else winnerScore = math.floor(winnerScore) end
            bigFont:Print(colourNames(winnerID) .. winnerScore, x2, y, 1, "roSN")
        else
            bigFont:Print('-', x2, y, 1, "roSN")
        end
        font:Print('Runners up:', x1, y, 1, "oSN")
        y = y - bigFont.size / vsy

        if secondScore > 0 then
            if pic == 'comwreath' then secondScore = round(secondScore, 2) else secondScore = math.floor(secondScore) end
            font:Print(colourNames(secondID) .. secondName, x1, y, 1, "oSN")
            font:Print(colourNames(secondID) .. secondScore, x2, y, 1, "roSN")
            y = y - font.size / vsy
        end

        if thirdScore > 0 then
            if pic == 'comwreath' then thirdScore = round(thirdScore, 2) else thirdscore = math.floor (thirdScore) end
            font:Print(colourNames(thirdID) .. thirdName, x1, y, 1, "oSN")
            font:Print(colourNames(thirdID) .. thirdScore, x2, y, 1, "roSN")
        end
    end
end

function QuitButtonPressed()
    Spring.SendCommands("quitforce")
end

function GraphsButtonPressed()
    Spring.SendCommands("endgraph 1")
    drawAwards = false
end

local buttonList = {
    {label="Quit", x=0.64, y=0.26, callback=QuitButtonPressed},
    {label="Show Graphs", x=0.70, y=0.26, callback=GraphsButtonPressed},
}

function IsOnButton(x, y, button)
    local labelWidth = font:GetTextWidth(button.label) * font.size
    local x1 = button.x * vsx - labelWidth / 2
    local x2 = button.x * vsx + labelWidth / 2
    local y1 = button.y * vsy
    local y2 = button.y * vsy + font.size
    return (x >= x1) and (x <= x2) and (y >= y1) and (y <= y2)
end

function RenderButtons()
    local x, y = Spring.GetMouseState()
    for i = 1, #buttonList, 1 do
        local buttonColour
        if IsOnButton(x, y, buttonList[i]) then
            buttonColour = buttonHover
        else
            buttonColour = buttonNormal
        end
        font:Print(buttonColour .. buttonList[i].label, buttonList[i].x, buttonList[i].y, 1, "cdoSN")
    end
end

function gadget:MousePress(x, y, button)
    if (not drawAwards) or (button ~= 1) then return end

    for i = 1, #buttonList, 1 do
        if IsOnButton(x, y, buttonList[i]) then
            buttonList[i].callback()
        end
    end
end

function gadget:DrawScreen()
    if not drawAwards then return end

    -- background
    local s = 0.25
    Spring.Draw.Rectangle(s, s, 1-s, 1-s, {relative=true, color={0,0,0,0.65}, radius=0.01, border=0.004, bordercolor={0,0,0,0.8}})

    -- title
    glTexture(':l:LuaRules/Images/awards.png')
    Spring.Draw.Rectangle(0.5 - 0.12, 1-s - 0.07, 0.5 + 0.12, 1-s - 0.01, {relative=true})
    glTexture(false)

    font:Print('Score', 0.665, 0.68, 1, "cvoSN")

    -- awards
    for i = 1, #awardList, 1 do
        RenderAward(awardList[i], i)
    end

    -- buttons
    RenderButtons()
end

end
