function gadget:GetInfo()
  return {
    name      = "Substitution",
    desc      = "Allows players absent at gamestart to be replaced by specs\nPrevents joinas to non-empty teams",
    author    = "Bluestone",
    date      = "June 2014",
    license   = "GNU GPL, v3 or later",
    layer     = 2, --run after game initial spawn and mo_coop (because we use readyStates)
    enabled   = true  
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-----------------------------
if gadgetHandler:IsSyncedCode() then 
-----------------------------

-- TS difference required for substitutions 
-- idealDiff is used if possible, validDiff as fall-back, otherwise no
local validDiff = 4 
local idealDiff = 2

local substitutes = {}
local players = {}
local absent = {}
local replaced = false
local gameStarted = false

local gaiaTeamID = Spring.GetGaiaTeamID()
local SpGetPlayerList = Spring.GetPlayerList
local SpIsCheatingEnabled = Spring.IsCheatingEnabled

function gadget:RecvLuaMsg(msg, playerID)
    local checkChange = (msg=='\144' or msg=='\145')

	if msg=='\145' then
        substitutes[playerID] = nil
        --Spring.Echo("received removal", playerID)
    end
    if msg=='\144' then
        -- do the same eligibility check as in unsynced
        local customtable = select(11,Spring.GetPlayerInfo(playerID))
        local tsMu = customtable.skill 
        local tsSigma = customtable.skilluncertainty
        ts = tsMu and tonumber(tsMu:match("%d+%.?%d*"))
        tsSigma = tonumber(tsSigma)
        local eligible = tsMu and tsSigma and (tsSigma<=2) and (not string.find(tsMu, ")")) and (not players[playerID]) 
        if eligible then
            substitutes[playerID] = ts
        end
        --Spring.Echo("received", playerID, eligible, ts)
    end

    if checkChange then
        --Spring.Echo("FindSubs", "RecvLuaMsg")
        FindSubs(false)
    end
end

function gadget:AllowStartPosition(playerID, teamID, readyState, x, y, z)
    FindSubs(false)
    return true
end


function gadget:Initialize()
    -- record a list of which playersIDs are players on which teamID
    local teamList = Spring.GetTeamList()
    for _,teamID in pairs(teamList) do
    if teamID~=gaiaTeamID then
        local playerList = Spring.GetPlayerList(teamID)
        for _,playerID in pairs(playerList) do
            local _,_,spec = Spring.GetPlayerInfo(playerID)
            if not spec then
                players[playerID] = teamID
            end
        end
    end
    end
end

function FindSubs(real)
    --Spring.Echo("FindSubs", "real=", real)
    
    -- make a copy of the substitutes table
    local substitutesLocal = {}
    local i = 0
    for pID,ts in pairs(substitutes) do
        substitutesLocal[pID] = ts
        i = i + 1
    end
    absent = {}
    
    --local theSubs = ""
    --for k,v in pairs(substitutesLocal) do theSubs = theSubs .. tostring(k) .. "[" .. v .. "]" .. "," end
    --Spring.Echo("#subs: " .. i , theSubs)
    
    -- make a list of absent players (only ones with valid ts)
    for playerID,_ in pairs(players) do
        local _,active,spec = Spring.GetPlayerInfo(playerID)
        local readyState = Spring.GetGameRulesParam("player_" .. playerID .. "_readyState")
        local noStartPoint = (readyState==3) or (readyState==0)
        local present = active and (not spec) and (not noStartPoint)
        if not present then
            local customtable = select(11,Spring.GetPlayerInfo(playerID)) -- player custom table
            local tsMu = customtable.skill
            ts = tsMu and tonumber(tsMu:match("%d+%.?%d*")) 
            if ts then
                absent[playerID] = ts
                --Spring.Echo("absent:", playerID, ts)
            end
        end
        -- if present, tell LuaUI that won't be substituted
        if not absent[playerID] then
            Spring.SetGameRulesParam("Player" .. playerID .. "willSub", 0)
        end
    end
    --Spring.Echo("#absent: " .. #absent)
    
    -- for each one, try and find a suitable replacement & substitute if so
    for playerID,ts in pairs(absent) do
        -- construct a table of who is ideal/valid 
        local idealSubs = {}
        local validSubs = {}
        for subID,subts in pairs(substitutesLocal) do
            local _,active,spec = Spring.GetPlayerInfo(subID)
            if active and spec then
                if  math.abs(ts-subts)<=validDiff then 
                    validSubs[#validSubs+1] = subID
                end
				if math.abs(ts-subts)<=idealDiff then
                    idealSubs[#idealSubs+1] = subID 
                end
            end
        end
        --Spring.Echo("ideal: " .. #idealSubs .. " for pID " .. playerID)
        --Spring.Echo("valid: " .. #validSubs .. " for pID " .. playerID)

        local wouldSub = false -- would we substitute this player if the game started now
        if #validSubs>0 then
            -- choose who
            local sID
            if #idealSubs>0 then
                sID = (#idealSubs>1) and idealSubs[math.random(1,#idealSubs)] or idealSubs[1]
                --Spring.Echo("picked ideal sub", sID)
            else
                sID = (#validSubs>1) and validSubs[math.random(1,#validSubs)] or validSubs[1]
                --Spring.Echo("picked valid sub", sID)
            end
            
            --Spring.Echo("real", real)
            if real then
                -- do the replacement 
                local teamID = players[playerID]
                Spring.AssignPlayerToTeam(sID, teamID)
                players[sID] = teamID
                replaced = true
                
                local incoming,_ = Spring.GetPlayerInfo(sID)
                local outgoing,_ = Spring.GetPlayerInfo(playerID)            
                Spring.Echo("Player " .. incoming .. " was substituted in for " .. outgoing)
            end
            substitutesLocal[sID] = nil
            wouldSub = true
        end
        
        -- tell luaui that if would substitute if the game started now
        --Spring.Echo("wouldSub: " .. (sID or "-1") .. " for pID " .. playerID)
        Spring.SetGameRulesParam("Player" .. playerID .. "wouldSub", wouldSub and 1 or 0)
    end

end

function gadget:GameStart()
    gameStarted = true
    FindSubs(true)
end

function gadget:GameFrame(n)
    if n==1 and replaced then
        -- if at least one player was replaced, reveal startpoints to all       
        local coopStartPoints = GG.coopStartPoints or {} 
        local revealed = {}
        for pID,p in pairs(coopStartPoints) do --first do the coop starts
            local name,_,tID = Spring.GetPlayerInfo(pID)
            SendToUnsynced("MarkStartPoint", p[1], p[2], p[3], name, tID)
            revealed[pID] = true
        end
            
        local teamStartPoints = GG.teamStartPoints or {}
        for tID,p in pairs(teamStartPoints) do
            p = teamStartPoints[tID]
            local playerList = Spring.GetPlayerList(tID)
            local name = ""
            for _,pID in pairs(playerList) do --now do all pIDs for this team which were not coop starts
                if not revealed[pID] then
                    local pName,active,spec = Spring.GetPlayerInfo(pID) 
                    if pName and absent[pID]==nil and active and not spec then --AIs might not have a name, don't write the name of the dropped player
                        name = name .. pName .. ", "
                        revealed[pID] = true
                    end
                end
            end
            if name ~= "" then
                name = string.sub(name, 1, math.max(string.len(name)-2,1)) --remove final ", "
            end
            SendToUnsynced("MarkStartPoint", p[1], p[2], p[3], name, tID)
        end
    end
    
    if n%5==0 then
        CheckJoined() -- there is no PlayerChanged or PlayerAdded in synced code
    end
end


--------------------------- 

function CheckJoined()
    local pList = SpGetPlayerList(true)
    local cheatsOn = SpIsCheatingEnabled() 
    if cheatsOn then return end
    
    for _,pID in ipairs(pList) do
        if not players[pID] then
            local _,active,spec,_,aID = Spring.GetPlayerInfo(pID)
            if active and not spec then 
                --Spring.Echo("handle join", pID, active, spec)
                HandleJoinedPlayer(pID,aID)
            end
        end
    end
end

function HandleJoinedPlayer(jID, aID)
    -- ForceSpec(jID)
    -- currently this is no use, because players who joinas see themselves as always having been present, so it doesn't get called...
end

-----------------------------
else -- begin unsynced section
-----------------------------

local scale = 1
local myPlayerID = Spring.GetMyPlayerID()
local spec,_ = Spring.GetSpectatingState()
local isReplay = Spring.IsReplay()

local font

local vsx, vsy

local buttonOfferText = "Offer to play"
local buttonWithdrawText = "Withdraw offer"
local buttonPadding = 0.5
local buttonX = 0.8
local buttonY = 0.8
local buttonX1, buttonX2, buttonY1, buttonY2

local eligible
local offer = false

function gadget:Initialize()
  if isReplay or (tonumber(Spring.GetModOptions().mo_ffa) or 0) == 1 then
      gadgetHandler:RemoveGadget() -- don't run in FFA mode
      return 
  end

  font = gl.LoadFont("LuaUI/Fonts/FreeSansBold.otf", 29, 2, 10.0, true)

  gadgetHandler:AddSyncAction("MarkStartPoint", MarkStartPoint)
  gadgetHandler:AddSyncAction("ForceSpec", ForceSpec)
  
  -- match the equivalent check in synced
  local customtable = select(11,Spring.GetPlayerInfo(myPlayerID)) 
  local tsMu = "30"--customtable.skill 
	local tsSigma = "0"--customtable.skilluncertainty
  ts = tsMu and tonumber(tsMu:match("%d+%.?%d*"))
  tsSigma = tonumber(tsSigma)
  eligible = tsMu and tsSigma and (tsSigma<=2) and (not string.find(tsMu, ")")) and spec
end

function gadget:ViewResize(width, height)
    vsx, vsy = width, height

    local textWidth = math.max(font:GetTextWidth(buttonOfferText), font:GetTextWidth(buttonWithdrawText))
    local textHeightOffer, descenderOffer = font:GetTextHeight(buttonOfferText)
    local textHeightWithdraw, descenderWithdraw = font:GetTextHeight(buttonWithdrawText)
    local textHeight = math.max(textHeightOffer, textHeightWithdraw)
    local descender = math.min(descenderOffer, descenderWithdraw)

    local w = (textWidth + buttonPadding) * font.size * scale / vsx
    local h = (textHeight - descender + buttonPadding) * font.size * scale / vsy

    buttonX1 = buttonX - w / 2;
    buttonX2 = buttonX + w / 2;
    buttonY1 = buttonY - h / 2;
    buttonY2 = buttonY + h / 2;
end

function gadget:DrawScreen()
    if eligible then
        -- ask each spectator if they would like to replace an absent player

        -- draw button and its text
        local x,y = Spring.GetMouseState()
        x = x / vsx
        y = y / vsy

        local border = 0.002 * scale

        if x > buttonX1 and x < buttonX2 and y > buttonY1 and y < buttonY2 then
            local c1 = {0.35,0.32,0,0.75}
            local c2 = {0.5,0.5,0.5,0.75}
            Spring.Draw.Rectangle(buttonX1, buttonY1, buttonX2, buttonY2, {relative=true, colors={c1,c1,c2,c2}, border=border, bordercolor={0,0,0,0.75}})
            colorString = "\255\255\222\0"
        else
            Spring.Draw.Rectangle(buttonX1, buttonY1, buttonX2, buttonY2, {relative=true, color={0,0,0,0.6}, border=border, bordercolor={0,0,0,0.75}})
            colorString = "\255\255\255\255"
        end

        local buttonText
        if not offer then
            buttonText = buttonOfferText
        else
            buttonText = buttonWithdrawText
        end
        font:Print(colorString .. buttonText, buttonX, buttonY, scale, "NcvoS")
    else
        gadgetHandler:RemoveCallIn("DrawScreen") -- no need to waste cycles
    end
end

function gadget:MousePress(x, y)
    x = x / vsx
    y = y / vsy

    -- pressing button
    if eligible and x > buttonX1 and x < buttonX2 and y > buttonY1 and y < buttonY2 then
        if not offer then
            Spring.SendLuaRulesMsg('\144')
            Spring.Echo("If player(s) are afk when the game starts, you might be used as a substitute")
            offer = true
        else
            Spring.SendLuaRulesMsg('\145')
            Spring.Echo("Your offer to substitute has been withdrawn")
            offer = false
        end
        return true
    end
    return false
end

function gadget:MouseRelease(x,y)
end

function gadget:GameStart()
    eligible = false -- no substitutions after game start
end


local revealed = false
function MarkStartPoint(_,x,y,z,name,tID)
    local _,_,spec = Spring.GetPlayerInfo(myPlayerID)
    if not spec then
        Spring.MarkerAddPoint(x, y, z, colourNames(tID) .. name, true)
        revealed = true
    end
end

function colourNames(teamID)
    	nameColourR,nameColourG,nameColourB,nameColourA = Spring.GetTeamColor(teamID)
		R255 = math.floor(nameColourR*255)  
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

function gadget:GameFrame(n)
    if n~=5 then return end
    if revealed then    
        Spring.Echo("Substitution occurred, revealed start positions to all")
    end
  
    gadgetHandler:RemoveCallIn("GameFrame")
end

--[[function ForceSpec(_,pID)
    local myID = Spring.GetMyPlayerID()
    if pID==myID then
		Spring.Echo("You have been made a spectator - adding players is only allowed before the game starts!")
        Spring.SendCommands("spectator")
    end
end]]

function gadget:Shutdown()
    gadgetHandler:RemoveSyncAction("MarkStartPoint")
    gadgetHandler:RemoveSyncAction("ForceSpec")
end

-----------------------------
end -- end unsynced section
-----------------------------
