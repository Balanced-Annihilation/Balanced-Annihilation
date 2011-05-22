
function gadget:GetInfo()
	return {
		name      = 'Coop II',
		desc      = 'Implements mo_coop modoption',
		author    = 'Niobium',
		date      = 'May 2011',
		license   = 'GNU GPL, v2 or later',
		layer     = 1,
		enabled   = true
	}
end

-- Modoption check
if (tonumber((Spring.GetModOptions() or {}).mo_coop) or 0) == 0 then
    return false
end

if gadgetHandler:IsSyncedCode() then
    
    ----------------------------------------------------------------
    -- Synced Var
    ----------------------------------------------------------------
    local coopStartPoints = {} -- coopStartPoints[playerID] = {x,y,z} -- Also acts as is-player-a-coop-player
    
    _G.coopStartPoints = coopStartPoints -- Share it to unsynced
    GG.coopStartPoints = coopStartPoints -- Share it to other gadgets
    
    ----------------------------------------------------------------
    -- Synced Callins
    ----------------------------------------------------------------
    
    -- Commented out Initialize due to set of GG.coopMode and layer of 1
    -- Previously layer was -1 (and so initialize ran first), however this made the unsynced drawing code draw UNDER the green startbox
    -- Could have a separate :GetInfo in both synced and unsynced sections, but that is asking for trouble
    
    --function gadget:Initialize()
    do
        local coopHasEffect = false
        local teamHasPlayers = {}
        local playerList = Spring.GetPlayerList()
        for i = 1, #playerList do
            local playerID = playerList[i]
            local _, _, isSpec, teamID = Spring.GetPlayerInfo(playerID)
            if not isSpec then
                if teamHasPlayers[teamID] then
                    coopStartPoints[playerID] = {-1, -1, -1}
                    coopHasEffect = true
                else
                    teamHasPlayers[teamID] = true
                end
            end
        end
        
        if coopHasEffect then
            GG.coopMode = true -- Inform other gadgets that coop needs to be taken into account
        --else
        -- Could remove the gadget here, but spring does not like gadgets removing themselves on initialize.
        -- Get the same problem with trying to remove the unsynced side (It won't be drawing anything though, so it's not too bad)
        end
    end
    
    function gadget:AllowStartPosition(x, y, z, playerID)
        if coopStartPoints[playerID] then
            local _, _, _, _, allyID = Spring.GetPlayerInfo(playerID)
            local bx1, bz1, bx2, bz2 = Spring.GetAllyTeamStartBox(allyID)
            x = math.min(math.max(x, bx1), bx2)
            z = math.min(math.max(z, bz1), bz2)
            coopStartPoints[playerID] = {x, Spring.GetGroundHeight(x, z), z}
            return false
        end
        return true
    end
    
    local function SpawnTeamStartUnit(teamID, allyID, x, z)
        local startUnit = Spring.GetTeamRulesParam(teamID, 'startUnit')
        if x <= 0 or z <= 0 then
            local xmin, zmin, xmax, zmax = Spring.GetAllyTeamStartBox(allyID)
            x = 0.5 * (xmin + xmax)
            z = 0.5 * (zmin + zmax)
        end
        Spring.CreateUnit(startUnit, x, Spring.GetGroundHeight(x, z), z, 0, teamID)
    end
    
    function gadget:GameFrame(n)
        
        if GG.coopMode then
            for playerID, startPos in pairs(coopStartPoints) do
                local _, _, _, teamID, allyID = Spring.GetPlayerInfo(playerID)
                SpawnTeamStartUnit(teamID, allyID, startPos[1], startPos[3])
            end
        end
        
        gadgetHandler:RemoveGadget(self)
        SendToUnsynced('RemoveGadget') -- Remove unsynced side too
    end
else
    
    ----------------------------------------------------------------
    -- Unsynced Var
    ----------------------------------------------------------------
    local coneList
    
    local playerNames = {} -- playerNames[playerID] = playerName
    local playerTeams = {} -- playerTeams[playerID] = playerTeamID
    
    ----------------------------------------------------------------
    -- Unsynced speedup
    ----------------------------------------------------------------
    local glPushMatrix = gl.PushMatrix
    local glPopMatrix = gl.PopMatrix
    local glTranslate = gl.Translate
    local glColor = gl.Color
    local glCallList = gl.CallList
    local glBeginText = gl.BeginText
    local glEndText = gl.EndText
    local glText = gl.Text
    local spGetTeamColor = Spring.GetTeamColor
    local spWorldToScreenCoords = Spring.WorldToScreenCoords
    
    ----------------------------------------------------------------
    -- Stolen funcs from from minimap_startbox.lua (And cleaned up a bit)
    ----------------------------------------------------------------
    local function ColorChar(x)
        local c = math.min(math.max(math.floor(x * 255), 1), 255)
        return string.char(c)
    end
    
    local teamColorStrs = {}
    local function GetTeamColorStr(teamID)
        
        local colorStr = teamColorStrs[teamID]
        if colorStr then
            return colorStr
        end
        
        local r, g, b = Spring.GetTeamColor(teamID)
        local colorStr = '\255' .. ColorChar(r) .. ColorChar(g) .. ColorChar(b)
        teamColorStrs[teamID] = colorStr
        return colorStr
    end
    
    ----------------------------------------------------------------
    -- Unsynced Callins
    ----------------------------------------------------------------
    function gadget:Initialize()
        
        -- Speed things up
        local playerList = Spring.GetPlayerList()
        for i = 1, #playerList do
            local playerID = playerList[i]
            local playerName, _, _, teamID = Spring.GetPlayerInfo(playerID)
            playerNames[playerID] = playerName
            playerTeams[playerID] = teamID
        end
        
        -- Cone code taken directly from minimap_startbox.lua
        coneList = gl.CreateList(function()
                local h = 100
                local r = 25
                local divs = 32
                gl.BeginEnd(GL.TRIANGLE_FAN, function()
                        gl.Vertex( 0, h,  0)
                        for i = 0, divs do
                            local a = i * ((math.pi * 2) / divs)
                            local cosval = math.cos(a)
                            local sinval = math.sin(a)
                            gl.Vertex(r * sinval, 0, r * cosval)
                        end
                    end)
            end)
    end
    
    function gadget:Shutdown()
        gl.DeleteList(coneList)
    end
    
    function gadget:DrawWorld()
        for playerID, startPosition in spairs(SYNCED.coopStartPoints) do
            local sx, sy, sz = startPosition[1], startPosition[2], startPosition[3]
            if sx > 0 or sz > 0 then
                local tr, tg, tb = spGetTeamColor(playerTeams[playerID])
                glPushMatrix()
                    glTranslate(sx, sy, sz)
                    glColor(tr, tg, tb, 0.5) -- Alpha would oscillate, but gadgets can't get time
                    glCallList(coneList)
                glPopMatrix()
            end
        end
    end
    
    function gadget:DrawScreenEffects()
        glBeginText()
        for playerID, startPosition in spairs(SYNCED.coopStartPoints) do
            local sx, sy, sz = startPosition[1], startPosition[2], startPosition[3]
            if sx > 0 or sz > 0 then
                local scx, scy, scz = spWorldToScreenCoords(sx, sy + 120, sz)
                if scz < 1 then
                    local colorStr, outlineStr = GetTeamColorStr(playerTeams[playerID])
                    glText(colorStr .. playerNames[playerID], scx, scy, 18, 'cs')
                end
            end
        end
        glEndText()
    end
    
    function gadget:RecvFromSynced(arg1, ...)
        if arg1 == 'RemoveGadget' then
            gadgetHandler:RemoveGadget(self)
        end
    end
end
