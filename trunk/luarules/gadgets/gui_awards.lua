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
	--make table of teams eligable for awards
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
				present[teamIDs[j] ] = true
				teamInfo[teamIDs[j] ] = {ecoDmg=0, fightDmg=0, otherDmg=0, dmgDealt=0, ecoUsed=0, dmgRatio=0, ecoProd=0, lastKill=0, dmgRec=0, sleepTime=0, present=true,}
				coopInfo[teamIDs[j] ] = {players=#playerIDs,}
			else
				present[teamIDs[j] ] = false
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

function gadget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
	if not newTeam then return end 
	if not present[newTeam] then return end
	if not unitDefID then return end --should never happen

	local ud = UnitDefs[unitDefID]
	teamInfo[newTeam].ecoUsed = ud.energyCost + 60 * ud.metalCost 
end


function gadget:GameOver()
	--get stuff from engine stats
	for teamID,_ in pairs(teamInfo) do
		local cur_max = Spring.GetTeamStatsHistory(teamID)
		local stats = Spring.GetTeamStatsHistory(teamID, 0, cur_max)
		teamInfo[teamID].dmgDealt = teamInfo[teamID].dmgDealt + stats[cur_max].damageDealt	
		teamInfo[teamID].ecoUsed = teamInfo[teamID].ecoUsed + stats[cur_max].energyUsed + 60 * stats[cur_max].metalUsed
		if teamInfo[teamID].ecoUsed > 5000 then
			teamInfo[teamID].dmgRatio = teamInfo[teamID].dmgDealt / teamInfo[teamID].ecoUsed * 100
		else
			teamInfo[teamID].dmgRatio = 0
		end
		teamInfo[teamID].dmgRec = stats[cur_max].damageReceived
		teamInfo[teamID].ecoProd = stats[cur_max].energyProduced + 60 * stats[cur_max].metalProduced
	end

	--take account of coop
	for teamID,_ in pairs(teamInfo) do
		if coopInfo[teamID].players == 0 then coopInfo[teamID].players = 1 end --should never happen
		teamInfo[teamID].ecoDmg = teamInfo[teamID].ecoDmg / coopInfo[teamID].players
		teamInfo[teamID].fightDmg = teamInfo[teamID].fightDmg / coopInfo[teamID].players
		teamInfo[teamID].otherDmg = teamInfo[teamID].otherDmg / coopInfo[teamID].players
		teamInfo[teamID].dmgRec = teamInfo[teamID].dmgRec / coopInfo[teamID].players 
		--no need to divide dmgRatio since it's a ratio
	end
		
	--award awards
	--TODO get second and third & pass also to unsynced
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
		if sleepScore < teamInfo[teamID].sleepTime then
			sleepScore = teamInfo[teamID].sleepTime
			sleepAward = teamID		
		end
	end	
	
	--tell unsynced
	SendToUnsynced("RecieveAwards", ecoKillAward, ecoKillAwardSec, ecoKillAwardThi, ecoKillScore, ecoKillScoreSec, ecoKillScoreThi, 
									fightKillAward, fightKillAwardSec, fightKillAwardThi, fightKillScore, fightKillScoreSec, fightKillScoreThi, 
									effKillAward, effKillAwardSec, effKillAwardThi, effKillScore, effKillScoreSec, effKillScoreThi, 
									ecoAward, ecoScore, 
									dmgRecAward, dmgRecScore, 
									sleepAward, sleepScore)
end




-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
else  -- UNSYNCED
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList
local glBeginEnd = gl.BeginEnd
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glColor = gl.Color
local glVertex = gl.Vertex
local glRect = gl.Rect
local glTexture = gl.Texture
local glTexRect = gl.TexRect
local GL_LINE_LOOP = GL.LINE_LOOP
local glText = gl.Text


local drawAwards = false 
local cx,cy --coords for center of screen
local bx,by --coords for top left hand corner of box
local w = 800 
local h = 500

local cow = false
local Background
local FirstAward
local SecondAward
local ThirdAward
local CowAwards
local OtherAwards

local red = "\255"..string.char(171)..string.char(51)..string.char(51)
local blue = "\255"..string.char(51)..string.char(51)..string.char(151)
local green = "\255"..string.char(51)..string.char(151)..string.char(51)
local white = "\255"..string.char(251)..string.char(251)..string.char(251)
local yellow = "\255"..string.char(251)..string.char(251)..string.char(11)
local quitColour  
local graphColour

function gadget:Initialize()
	--register actions to SendToUnsynced messages
	gadgetHandler:AddSyncAction("RecieveAwards", ProcessAwards)	
	
	CreateBackground()
	
	--for testing
	--FirstAward = CreateAward('fuscup',0,'Destroying enemy resource production', white, 1,1,1,24378,1324,132,100) 
	--SecondAward = CreateAward('bullcup',0,'Destroying enemy units and defences',white, 1,1,1,24378,1324,132,200) 
	--ThirdAward = CreateAward('comwreath',0,'Effective use of resources',white,1,1,1,24378,1324,132,300) 
	--CowAward = CreateAward('cow',1,'Doing everything',white,1,1,1,24378,1324,132,400) 	
	--OtherAwards = CreateAward('',2,'',white,1,1,1,3,100,1000,400)
	
	
end

function ProcessAwards(_,ecoKillAward, ecoKillAwardSec, ecoKillAwardThi, ecoKillScore, ecoKillScoreSec, ecoKillScoreThi, 
						fightKillAward, fightKillAwardSec, fightKillAwardThi, fightKillScore, fightKillScoreSec, fightKillScoreThi, 
						effKillAward, effKillAwardSec, effKillAwardThi, effKillScore, effKillScoreSec, effKillScoreThi, 
						ecoAward, ecoScore, 
						dmgRecAward, dmgRecScore, 
						sleepAward, sleepScore)

	FirstAward = CreateAward('fuscup',0,'Destroying enemy resource production', white, ecoKillAward, ecoKillAwardSec, ecoKillAwardThi, ecoKillScore, ecoKillScoreSec, ecoKillScoreThi, 100) 
	SecondAward = CreateAward('bullcup',0,'Destroying enemy units and defences',white, fightKillAward, fightKillAwardSec, fightKillAwardThi, fightKillScore, fightKillScoreSec, fightKillScoreThi, 200) 
	ThirdAward = CreateAward('comwreath',0,'Effective use of resources',white,effKillAward, effKillAwardSec, effKillAwardThi, effKillScore, effKillScoreSec, effKillScoreThi, 300) 
	if (ecoKillAward == fightKillAward) and (fightKillAward == effKillAward) and ecoKillAward ~= -1 then
		cow = true
		CowAward = CreateAward('cow',1,'Doing everything',white, ecoKillAward, 1,1,1,1,1, 400) 	
	else
		OtherAwards = CreateAward('',2,'',white, ecoAward, dmgRecAward, sleepAward, ecoScore, dmgRecScore, sleepScore, 400)		
	end
	drawAwards = true
	Spring.SendCommands('endgraph 0')		

end

function ProcessOtherAwards(a,b,c,d,e,f,g)
end

function CreateBackground()	
	if Background then
		glDeleteList(Background)
	end
	
	Background = glCreateList(function()	
	-- draws background rectangle
	glColor(0,0,0.15,0.75)                              
	glRect(bx, by, bx + w, by + h)	

	-- draws black border
	glBeginEnd(GL_LINE_LOOP, function()
	glColor(0,0,0,1)
	glVertex(bx, by)
	glVertex(bx, by+h)
	glVertex(bx+w, by+h)
	glVertex(bx+w, by)
	end)

	glColor(1,1,1,1)
	glTexture(':l:LuaRules/Images/awards.png')
	glTexRect(bx + w/2 - 220, by + h - 75, bx + w/2 + 120, by + h - 5)
	
	glText('Score', bx + w/2 + 275, by + h - 65, 15, "o") 
	
	end)	
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

function CreateAward(pic, award, note, noteColour, winnerID, secondID, thirdID, winnerScore, secondScore, thirdScore, offset)
	local winnerName, winnerCoop, secondName, secondCoop, thirdName, thirdCoop
	
	if winnerID >= 0 then
		winnerName = Spring.GetPlayerInfo(Spring.GetPlayerList(winnerID)[1])
		winnerCoop = (#(Spring.GetPlayerList(winnerID)) > 1)
		if winnerCoop then winnerName = winnerName  .. ' (coop)' end
	else
		winnerName = "(not awarded)"
	end
	
	if secondID >= 0 then
		secondName = Spring.GetPlayerInfo(Spring.GetPlayerList(secondID)[1])
		secondCoop = (#(Spring.GetPlayerList(winnerID)) > 1)
		if secondCoop then secondName = secondName  .. ' (coop)' end
	else
		secondName = "(not awarded)"
	end
	
	if thirdID >= 0 then
		thirdName = Spring.GetPlayerInfo(Spring.GetPlayerList(thirdID)[1])
		thirdCoop = (#(Spring.GetPlayerList(winnerID)) > 1)
		if thirdCoop then thirdName = thirdName  .. ' (coop)' end
	else
		thirdName = "(not awarded)"
	end
		
	thisAward = glCreateList(function()

		if award ~= 2 then	--if its a normal award
			glColor(1,1,1,1)
			local pic = ':l:LuaRules/Images/' .. pic ..'.png'
			glTexture(pic)
			glTexRect(bx + 12, by + h - offset - 70, bx + 108, by + h - offset + 25)

			glText(colourNames(winnerID) .. winnerName, bx + 120, by + h - offset - 10, 20, "o")
			glText(noteColour .. note, bx + 120, by + h - offset - 50, 16, "o") 
		else --if the cow is not awarded, we replace it with minor awards (just text)
			local heightoffset = 0
			if winnerID >=0 then
				glText(colourNames(winnerID) .. winnerName .. white .. ' produced the most resources (' .. math.floor(winnerScore) .. ').', bx + 70, by + h - offset - 10 - heightoffset, 14, "o")
				heightoffset = heightoffset + 17
			end
			if secondID >= 0 then
				glText(colourNames(secondID) .. secondName .. white .. ' took the most damage (' .. math.floor(secondScore) .. ').', bx + 70, by + h - offset - 10 - heightoffset, 14, "o")
				heightoffset = heightoffset + 17
			end
			if thirdID >= 0  and thirdScore >= 12*60 then
				glText(colourNames(secondID) .. thirdName .. white .. ' slept longest, for ' .. math.floor(thirdScore/60) .. ' minutes.', bx + 70, by + h - offset - 10 - heightoffset, 14, "o")
			end
		end
		
		if award == 0 then --normal awards	
			
			if winnerID >= 0 then
				if pic == 'comwreath' then winnerScore = round(winnerScore, 2) end --we roudn ratios to 2dp
				glText(colourNames(winnerID) .. winnerScore, bx + w/2 + 275, by + h - offset - 5, 14, "o")
			else
				glText('-', bx + w/2 + 275, by + h - offset - 5, 17, "o")			
			end
			glText('Runners up:', bx + 500, by + h - offset - 5, 14, "o")

			if secondScore > 0 then
				if pic == 'comwreath' then secondScore = round(secondScore, 2) end --we roudn ratios to 2dp
				glText(colourNames(secondID) .. secondName, bx + 520, by + h - offset - 25, 14, "o")
				glText(colourNames(secondID) .. secondScore, bx + w/2 + 275, by + h - offset - 25, 14, "o")
			end
			
			if thirdScore > 0 then
				if pic == 'comwreath' then thirdScore = round(thirdScore, 2) end --we round ratios to 2dp
				glText(colourNames(thirdID) .. thirdName, bx + 520, by + h - offset - 45, 14, "o")
				glText(colourNames(thirdID) .. thirdScore, bx + w/2 + 275, by + h - offset - 45, 14, "o")
			end
		end
		
		if award == 1 then --extra text for cow award
			glText(yellow .. 'Memorial WarCow', bx+9, by+15, 12, "o")
		end
	
	end)
	
	return thisAward
end


function gadget:ViewResize(vsx, vsy)
        cx = vsx/2 
        cy = vsy/2 
		bx = cx - w/2
		by = cy - h/2 - 50
end

gadget:ViewResize(Spring.GetViewGeometry())

local quitX = 100
local graphsX = 250

function gadget:MousePress(x,y,button)
	if button ~= 1 then return end
	if drawAwards then
		if (x > bx+w-quitX-5) and (x < bx+w-quitX+16*gl.GetTextWidth('Quit')+5) and (y>by+50-5) and (y<by+50+16+5) then --quit button
			Spring.SendCommands("quitforce")
		end
		if (x > bx+w-graphsX-5) and (x < bx+w-graphsX+16*gl.GetTextWidth('Show Graphs')+5) and (y>by+50-5) and (y<by+50+16+5) then
			Spring.SendCommands('endgraph 1')
			drawAwards = false
		end	
	end
end




function DrawScreen()
	if not drawAwards then return end
	
	if Background then
		glCallList(Background)
	end 
	
	if FirstAward and SecondAward and ThirdAward then
		glCallList(FirstAward)
		glCallList(SecondAward)
		glCallList(ThirdAward)
	end
	
	if cow and CowAward then
		glCallList(CowAward)
	elseif OtherAwards then
		glCallList(OtherAwards)
	end
	
	--draw buttons, wastefully, but it doesnt matter now game is over
	local x,y = Spring.GetMouseState()
	if (x > bx+w-quitX-5) and (x < bx+w-quitX+16*gl.GetTextWidth('Quit')+5) and (y>by+50-5) and (y<by+50+16+5) then
		quitColour = "\255"..string.char(201)..string.char(51)..string.char(51)
	else
		quitColour = "\255"..string.char(201)..string.char(201)..string.char(201)
	end
	if (x > bx+w-graphsX-5) and (x < bx+w-graphsX+16*gl.GetTextWidth('Show Graphs')+5) and (y>by+50-5) and (y<by+50+16+5) then
		graphColour = "\255"..string.char(201)..string.char(51)..string.char(51)
	else
		graphColour = "\255"..string.char(201)..string.char(201)..string.char(201)
	end
	glText(quitColour .. 'Quit', bx+w-quitX, by+50, 16, "o")
	glText(graphColour .. 'Show Graphs', bx+w-graphsX, by+50, 16, "o")	
end

function gadget:ShutDown()
	Spring.SendCommands('endgraph 1')
end

end
