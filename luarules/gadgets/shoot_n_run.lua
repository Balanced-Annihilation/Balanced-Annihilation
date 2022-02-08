local allowenable = false

if tonumber(Spring.GetModOptions().mo_allowuserwidgets) == 1 then
	allowenable = true 
end

function gadget:GetInfo()
    return {
        name = "Shoot'n'Run",
        desc = "Turn RTS to HnS/SnR",
        author = "zwzsg",
        date = "10th of November 2009",
        license = "Public Domain",
        layer = 120,
        enabled = false
    }
end

--local isHero= {
--	[corcom]=true,
--	[armcom]=true,
--
--}

local AllowOtherUnitsControl = true
if Spring.GetModOptions()["homf"] == "1" and Spring.GetModOptions()["homf_rightclick"] == "0" then
    AllowOtherUnitsControl = false
end

if (gadgetHandler:IsSyncedCode()) then
    --SYNCED

    local IsIt82 = nil
    local LastHeroesCheck = 0
    local ptu = {}
     -- Player to Unit
    local utp = {}
     -- Unit to Player
    local usd = {}
     -- Unit Self Destruct engaged so discard subsequent self-d orders as they would cancel it
    local ptf = {}
     -- Player to frame he was last given a hero
    local RecMsg = {}
     -- To bufferize Received Messages bewteen each call to GameFrame
    local ScoreBoard = {}
    local MovedLast = {} -- Just to remember which heroes moved last frame
    local weirdSelection = {}

    function gadget:Initialize()
        IsIt82 = true
        for v = 70, 81 do
        end
    end

    --function gadget:GameStart()
    --end

    -- Return the list of active, non spectator, players of a team
    -- If second argument is zero, then only return those with no hero, sorted by order of last respawn (oldest first)
    local function GetBetterPlayerList(team, ZeroForHeroLessPlayers)
        PlayerList = {}
        for _, p in ipairs(Spring.GetPlayerList(team, true)) do
            local _, active, spectator = Spring.GetPlayerInfo(p)
            if active and not spectator then
                if ZeroForHeroLessPlayers == 0 then
                    if not ptu[p] then
                        local inserted = false
                        for i, q in pairs(PlayerList) do
                            if (ptf[p] or 0) < (ptf[q] or 0) then
                                table.insert(PlayerList, i, p)
                                inserted = true
                                break
                            end
                        end
                        if not inserted then
                            table.insert(PlayerList, p)
                        end
                    end
                else
                    table.insert(PlayerList, p)
                end
            end
        end
        return PlayerList
    end

    local function GiveHero(u)
        local team = Spring.GetUnitTeam(u)
        local PlayerList = GetBetterPlayerList(team, 0)
        if #PlayerList >= 1 then
            local p = PlayerList[1]
            ptf[p] = Spring.GetGameFrame()
            ptu[p] = u
            utp[u] = p
            --Spring.SendMessage("<PLAYER"..p.."> got "..UnitDefs[Spring.GetUnitDefID(u)].humanName.."!")
            Spring.SetUnitCOBValue(u, 3, 0)
             -- 3 is STANDINGFIREORDERS
            if not ScoreBoard[p] then
                ScoreBoard[p] = {}
            end
        end
    end

    function gadget:GameFrame(frame) --
        -- Age half the hackers
        --[[if frame==3 then
			if Spring.GetModOptions()["homf"] and Spring.GetModOptions()["homf"]~="0" then
				for _,t in ipairs(Spring.GetTeamList()) do
					local _,_,_,_,_,_,CustomTeamOptions=Spring.GetTeamInfo(t)
					if math.random(1,2)==2 and (not ((tonumber(Spring.GetModOptions()["removeunits"]) or 0)~=0))
						and (not ((tonumber(CustomTeamOptions["removeunits"]) or 0)~=0)) then
						for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,UnitDefNames.hole.id)) do
							table.insert(weirdSelection,u)
						end
					end
				end
			end
			Spring.GiveOrderToUnitArray(weirdSelection,CMD.MOVE_STATE,{2},{})
		elseif frame==4 then
			Spring.GiveOrderToUnitArray(weirdSelection,CMD.MOVE_STATE,{0},{})
		elseif frame==5 then
			Spring.GiveOrderToUnitArray(weirdSelection,CMD.MOVE_STATE,{1},{})
		end]] -- Shouldn't be needed anymore with this new version of the gadget
        --if IsIt82 and frame%4~=1 then
        --	return
        --end

        -- Make unsynced run that function once per frame
        -- Share the table telling which unit are controllled
        _G.Shoot_n_Run = {utp = utp, ptu = ptu, ScoreBoard = ScoreBoard}

        -- Parse the messages from unsynced
        for _, msg in pairs(RecMsg) do
            local u = tonumber(string.match(msg, "U:(%d+)"))

            

            local dx = tonumber(string.match(msg, "MX:(%-?%d+)"))
            local dz = tonumber(string.match(msg, "MZ:(%-?%d+)"))

            --local cx=tonumber(string.match(msg,"CX:(%-?%d+)"))
            --local cz=tonumber(string.match(msg,"CZ:(%-?%d+)"))

            local tx = tonumber(string.match(msg, "TX:(%-?%d+%.?%d+)"))
            local ty = tonumber(string.match(msg, "TY:(%-?%d+%.?%d+)"))
            local tz = tonumber(string.match(msg, "TZ:(%-?%d+%.?%d+)"))
            local tu = tonumber(string.match(msg, "TU:(%d+)"))
            local fa = string.match(msg, "LMB")
            local fb = string.match(msg, "RMB")
            local fc = string.match(msg, "MMB")
            local sd = string.match(msg, "SD")
            local sb = string.match(msg, "SB")

            --local speed=math.sqrt((dx or 0)^2+(dz or 0)^2)
            dx = dx or 0
            dz = dz or 0

            if Spring.ValidUnitID(u) and u then
				
				
				if sb then
                    for j, p in pairs(utp) do
                        if (j == u) then
                            _, active, spectator, team = Spring.GetPlayerInfo(p)
                            --Spring.SendMessage("Player["..p.."] lost connection: removing player["..p.."]'s control over "..UnitDefs[Spring.GetUnitDefID(u)].humanName)
                            Spring.GiveOrderToUnit(u, CMD.STOP, {}, {}) --command unit to reclaim and rez
                            Spring.GiveOrderToUnit(u, CMD.FIRE_STATE, {2}, 0)

                            ptf[p] = nil
                            ptu[p] = nil
                            utp[j] = nil
                            MovedLast[j] = nil
                        end
                    end
                elseif (utp[u] == nil) then
                --local ud = UnitDefs[Spring.GetUnitDefID(u)]
                --if(UnitDefs[Spring.GetUnitDefID(u)].canFly) then
                --end
				
                GiveHero(u)
				if(UnitDefs[Spring.GetUnitDefID(u)].canFly) then
				Spring.GiveOrderToUnit(u, 145, {0}, {})
				end
				end
			
			
				if (fa) then
						if tu then
						
						Spring.SetUnitTarget(u,tu)
						
					elseif tx and tz then
						if ty then
							
							Spring.SetUnitTarget(u,tx,ty,tz)
							
	 --Spring.SetUnitTarget(u,tx,ty,tz, true) dgun

						else
							local ty=Spring.GetGroundHeight(tx,tz)
							
							Spring.SetUnitTarget(u,tx,ty,tz)
							
						end
					end
                elseif(fb) then
				
						if tu then
						
						Spring.SetUnitTarget(u,tu,true)
						
					elseif tx and tz then
						if ty then
							
							Spring.SetUnitTarget(u,tx,ty,tz,true)
							
	 --Spring.SetUnitTarget(u,tx,ty,tz, true) dgun

						else
							local ty=Spring.GetGroundHeight(tx,tz)
							
							Spring.SetUnitTarget(u,tx,ty,tz,true)
							
						end
					end
              
				else
					Spring.SetUnitTarget(u,nil)
					
				end
				

                --	if(UnitDefs[Spring.GetUnitDefID(u)] == armComId or UnitDefs[Spring.GetUnitDefID(u)] == corComId) then

                if
                    (Spring.GetUnitWeaponState(u, Game.gameName and 1, "reloadFrame") ~= nil) and not fa and not fb and
                        frame >= Spring.GetUnitWeaponState(u, Game.gameName and 1, "reloadFrame")
                 then -- Since 95 , weapon index changed
                    Spring.SetUnitWeaponState(u, 1, "reloadFrame", frame) -- Assuming one and only one weapon
                end
                if
                    (Spring.GetUnitWeaponState(u, Game.gameName and 2, "reloadFrame") ~= nil) and not fa and not fb and
                        frame >= Spring.GetUnitWeaponState(u, Game.gameName and 2, "reloadFrame")
                 then -- Since 95 , weapon index changed
                    Spring.SetUnitWeaponState(u, 2, "reloadFrame", frame ) -- Assuming one and only one weapon
                end
                if
                    (Spring.GetUnitWeaponState(u, Game.gameName and 3, "reloadFrame") ~= nil) and not fa and not fb and
                        frame >= Spring.GetUnitWeaponState(u, Game.gameName and 3, "reloadFrame")
                 then -- Since 95 , weapon index changed
                    Spring.SetUnitWeaponState(u, 3, "reloadFrame", frame ) -- Assuming one and only one weapon
                end
                if
                    (Spring.GetUnitWeaponState(u, Game.gameName and 4, "reloadFrame") ~= nil) and not fa and not fb and
                        frame >= Spring.GetUnitWeaponState(u, Game.gameName and 4, "reloadFrame")
                 then -- Since 95 , weapon index changed
                    Spring.SetUnitWeaponState(u, 4, "reloadFrame", frame ) -- Assuming one and only one weapon
                end
                if
                    (Spring.GetUnitWeaponState(u, Game.gameName and 5, "reloadFrame") ~= nil) and not fa and not fb and
                        frame >= Spring.GetUnitWeaponState(u, Game.gameName and 5, "reloadFrame")
                 then -- Since 95 , weapon index changed
                    Spring.SetUnitWeaponState(u, 5, "reloadFrame", frame) -- Assuming one and only one weapon
                end
				
				
				

                if sd and not usd[u] then
                    Spring.GiveOrderToUnit(u, CMD.SELFD, {}, {})
                    usd[u] = frame
                end

                
                if dx ~= 0 or dz ~= 0 then
                    local x, _, z = Spring.GetUnitPosition(u)
                    local y = Spring.GetGroundHeight(x, z)
                    x = x + 64 * dx
                    z = z + 64 * dz
                    Spring.SetUnitMoveGoal(u, x, y, z)
                    MovedLast[u] = true
                elseif MovedLast[u] then
                    Spring.GiveOrderToUnit(u, CMD.STOP, {}, {})
                    MovedLast[u] = false
                end
            end
        end
        RecMsg = {}

        if frame > LastHeroesCheck + 139 then
            LastHeroesCheck = frame
            -- Removing heroes control from players that went inactive or spec
            for u, p in pairs(utp) do
                _, active, spectator, team = Spring.GetPlayerInfo(p)
                if not active then
                    --Spring.SendMessage("Player["..p.."] lost connection: removing player["..p.."]'s control over "..UnitDefs[Spring.GetUnitDefID(u)].humanName)
                    ptf[p] = nil
                    ptu[p] = nil
                    utp[u] = nil
                    MovedLast[u] = nil
                elseif spectator then
                    --Spring.SendMessage("<PLAYER"..p.."> is now spectating: removing <PLAYER"..p..">'s control over "..UnitDefs[Spring.GetUnitDefID(u)].humanName)
                    ptf[p] = nil
                    ptu[p] = nil
                    utp[u] = nil
                    MovedLast[u] = nil
                elseif team ~= Spring.GetUnitTeam(u) then
                    --Spring.SendMessage("<PLAYER"..p.."> switched to team["..team.."]: removing <PLAYER"..p..">'s control over team["..Spring.GetUnitTeam(u).."]".." "..UnitDefs[Spring.GetUnitDefID(u)].humanName)
                    ptf[p] = nil
                    ptu[p] = nil
                    utp[u] = nil
                    MovedLast[u] = nil
                end
            end
        -- Give heroless players control over playerless heroes
        --for _,team in ipairs(Spring.GetTeamList()) do
        --	for _,u in ipairs(Spring.GetTeamUnitsByDefs(team,hero)) do
        --		if not utp[u] and not Spring.GetUnitIsDead(u) then
        --			GiveHero(u,team)
        --		end
        --	end
        --end
        end
		        SendToUnsynced("Shoot_n_Run_Unsynced_GameFrame", frame)

    end

    function gadget:UnitCreated(u, ud, team)
        --if isHero[ud] then
        --GiveHero(u,team)
        --	LastHeroesCheck=-8888
        --end
    end

    function gadget:UnitDestroyed(u, ud, team, atk, atkd, atkteam)
        if utp[u] then
          --  Spring.SendCommands("luaui enablewidget SmartSelect")

            ScoreBoard[utp[u]].deaths = (ScoreBoard[utp[u]].deaths or 0) + 1
            ScoreBoard[utp[u]].kills = 0
            --Spring.SendMessage("<PLAYER"..utp[u].."> was killed driving a "..UnitDefs[ud].humanName)
            ptu[utp[u]] = nil
            utp[u] = nil
            MovedLast[u] = nil
        end
        if utp[atk] and not Spring.AreTeamsAllied(atkteam, team) then
            ScoreBoard[utp[atk]].kills = (ScoreBoard[utp[atk]].kills or 0) + 1
            ScoreBoard[utp[atk]].totalkills = (ScoreBoard[utp[atk]].totalkills or 0) + 1
        end
    end

    function gadget:AllowUnitTransfer(u, ud, oldteam, newteam, capture)
        --if isHero[ud] then
        --	return false
        --else
        return true
        --end
    end

    function gadget:AllowUnitCreation(ud, b, team, x, y, z)
        --if isHero[ud] and Spring.GetModOptions()["homf"] and Spring.GetModOptions()["homf"]~="0" then
        --if #GetBetterPlayerList(team)-#Spring.GetTeamUnitsByDefs(team,hero)>0 then
        return true
        --else
        --	return false
        --end
        --end
        --return true
    end

    if not AllowOtherUnitsControl then
        function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag, synced)
            if (not synced) and #GetBetterPlayerList(team) > 0 then
                return false
            end
            return true
        end
    end

    function gadget:RecvLuaMsg(msg, player)
        if string.sub(msg, 1, 12) == "Shoot'n'Run:" then
            local u = tonumber(string.match(msg, "U:(%d+)"))
            RecMsg[u] = msg
        end
    end
else
    --UNSYNCED
    local u
    local function GetTheOne()
        if SYNCED.Shoot_n_Run and SYNCED.Shoot_n_Run.ptu then
            u = SYNCED.Shoot_n_Run.ptu[Spring.GetLocalPlayerID()]
            if u and Spring.ValidUnitID(u) then
                return u
				
            end
        end
        return nil
    end
	

    function gadget:Update() -- Is called more than once per frame
       
		--if(Spring.GetUnitTeam(u) == Spring.GetMyTeamID()) then
                
			if(not Spring.GetSpectatingState()) then	
	   local u = GetTheOne()
		
        if u then
			
			--if(Spring.GetUnitTeam(u) == Spring.GetMyTeamID()) then

            Spring.SelectUnitArray({}, false)
            local x, _, z = Spring.GetUnitPosition(u)
            local _, v, paused = Spring.GetGameSpeed()
            v = paused and 0 or v
            local vx, _, vz = Spring.GetUnitVelocity(u)
            local r = UnitDefs[Spring.GetUnitDefID(u)].maxWeaponRange
            Spring.SetCameraState(
                {
                    name = ta,
                    mode = 1,
                    px = x + 9 * v * vx,
                    py = 0,
                    pz = z + 9 * v * vz,
                    flipped = -1,
                    dy = -0.9,
                    zscale = 0.5,
                    height = (2.2 * r) + 600,
                    dx = 0,
                    dz = -0.45
                },
                1
            )
			--end
        else
            --if Spring.GetModOptions()["homf"] and Spring.GetModOptions()["homf"]~="0" and not Spring.GetSpectatingState() then
            --	Spring.SelectUnitArray({},false)
            --	local x,y,z=Spring.GetTeamStartPosition(Spring.GetLocalTeamID())
            --	if x<0 or z<0 then
            --		x,z=Game.mapSizeX/2,Game.mapSizeZ/2
            --		y=Spring.GetGroundHeight(x,z)
            --	end
            --	Spring.SetCameraState({name=ta,mode=1,px=x,py=0,pz=z,flipped=-1,dy=-0.9,zscale=0.5,height=1200,dx=0,dz=-0.45},5)
            --end
        end
		end
		
    end

    local pressFrame = 0
    local GetSelectedUnits = Spring.GetSelectedUnits
    local function Unsynced_GameFrame(caller, frame)
		
	   local u = GetTheOne()
		if(not Spring.GetSpectatingState()) then	
        if u then
            local MoveX = 0
            local MoveZ = 0
            local TargetX = nil
            local TargetY = nil
            local TargetZ = nil
            local TargetU = nil
            local FireA = false
            local FireB = false
            local FireC = false
            local SelfD = false
			
			 -- Write message to synced
            local msg = "Shoot'n'Run:"
            --if u then

            msg = msg .. " U:" .. u

			  if Spring.GetKeyState(112) and (frame > (pressFrame + 45)) then --down o --was 15
			
                local alt, ctrl, meta, shift = Spring.GetModKeyState()
                if (ctrl) then
                    msg = msg .. " SB"
					--  Spring.SendCommands("luaui enablewidget SmartSelect")

					
           
                end
            else
            -- Get mouse input
            local mx, my, LeftButton, MiddleButton, RightButton = Spring.GetMouseState()
            local _, pos = Spring.TraceScreenRay(mx, my, true, false)
            local kind, unit = Spring.TraceScreenRay(mx, my, false, false)
            if type(pos) == "table" and pos[1] and pos[3] then
                TargetX = math.floor(0.5 + pos[1])
                TargetY = math.floor(0.5 + pos[2])
                TargetZ = math.floor(0.5 + pos[3])
            end
            if kind == "unit" and unit ~= u then
                TargetU = unit
            else
                TargetU = nil
            end

            -- Get keyboard input
            if Spring.GetKeyState(276) or Spring.GetKeyState(97) or Spring.GetKeyState(113) then --left
                MoveX = MoveX - 1
            end

            if Spring.GetKeyState(275) or Spring.GetKeyState(100) then --right
                local alt, ctrl, meta, shift = Spring.GetModKeyState()
                if ctrl then
                    SelfD = true
                else
                    MoveX = MoveX + 1
                end
            end

            if Spring.GetKeyState(273) or Spring.GetKeyState(119) or Spring.GetKeyState(122) then --up
                MoveZ = MoveZ - 1
            end
            if Spring.GetKeyState(274) or Spring.GetKeyState(115) then --down
                MoveZ = MoveZ + 1
            end

           

          
                if MoveX and MoveZ then
                    msg = msg .. " MX:" .. MoveX .. " MZ:" .. MoveZ
                end
                if TargetU then
                    msg = msg .. " TU:" .. TargetU
                elseif TargetX and TargetY and TargetZ then
                    msg = msg .. " TX:" .. TargetX .. " TY:" .. TargetY .. " TZ:" .. TargetZ
                end
                if LeftButton then
                    msg = msg .. " LMB"
                end
                if RightButton then
                    msg = msg .. " RMB"
                end
                if SelfD then
                    msg = msg .. " SD"
                end
            end

            --end

            Spring.SendLuaRulesMsg(msg)
        else
            if Spring.GetKeyState(112) then --111 down o
                local alt, ctrl, meta, shift = Spring.GetModKeyState()

                if (ctrl) then
                    local msg = "Shoot'n'Run:"
                    local selUnits = GetSelectedUnits()

                    if ((not (selUnits == nil)) and table.getn(selUnits) > 0) then
					
					
                        --msg=msg.." U:"..selUnits[1]

                        --msg=msg.." CX:"..selUnits[1].." CZ:"..Spring.GetUnitTeam(selUnits[1])
                        --		Spring.SendLuaRulesMsg(msg)
                        Spring.SendCommands("luaui disablewidget SmartSelect")
                        pressFrame = frame
                        msg = msg .. " U:" .. selUnits[1]
                        Spring.SendLuaRulesMsg(msg)
                        --Spring.Echo("Entered " .. UnitDefs[Spring.GetUnitDefID(selUnits[1])].humanName)
                    end
                end
            end
        end
		end
    end

	
    --function gadget:MouseMove(x,y,dx,dy,button)
    --end

    --function gadget:MousePress(x,y,button)
    --	if GetTheOne() then
    --		if button==1 then
    --			return true
    --		end
    --	end
    --end

    --function gadget:MouseRelease(x,y,button)
    --end

    -- Must use Spring.GetKeyState instead
    function gadget:KeyPress(pressed_key)
        if SYNCED.Shoot_n_Run and SYNCED.Shoot_n_Run.ptu and SYNCED.Shoot_n_Run.ptu[Spring.GetLocalPlayerID()] then
            for _, hero_action in ipairs({"hero_south", "hero_north", "hero_west", "hero_east"}) do
                for _, hero_action_key in ipairs(Spring.GetActionHotKeys(hero_action)) do
                    if pressed_key == Spring.GetKeyCode(hero_action_key) then
                        return true
                    end
                end
            end
        end
        return false
    end

    function gadget:Initialize()
        gadgetHandler:AddSyncAction("Shoot_n_Run_Unsynced_GameFrame", Unsynced_GameFrame)
    end

    local shiva = UnitDefNames["shiva"]
    local shivaId = shiva.id
	local CallAsTeam = CallAsTeam
    local blastCircleDivs = 100
    local count = 0
    function gadget:DrawWorld()
	

        if SYNCED.Shoot_n_Run and SYNCED.Shoot_n_Run.ptu and not Spring.GetSpectatingState() then
            for _, p in ipairs(Spring.GetPlayerList()) do
                local u = SYNCED.Shoot_n_Run.ptu[p]
                if u and Spring.ValidUnitID(u) then
                    local x, y, z = Spring.GetUnitPosition(u)
                    if p ~= Spring.GetLocalPlayerID() then --
                        --[[-- Other Player Contolled Unit
						local f=1+(Spring.GetGameSeconds()/2)%1.5
						f=f^f^f
						gl.PushMatrix()
						gl.Translate(-f*x,-f*y,-f*z)
						gl.Scale(f,f,f)
						gl.Translate(x/f,y/f,z/f)
						gl.Blending(GL.ONE_MINUS_SRC_COLOR,GL.ONE)
						gl.Unit(u)
						gl.Blending(GL.SRC_ALPHA,GL.ONE_MINUS_SRC_ALPHA)
						gl.PopMatrix()]]
                    else
                        -- My Player Controlled Unit
                        --local r=UnitDefs[Spring.GetUnitDefID(u)].maxWeaponRange

                      
                            count = 0
                            for _, wt in ipairs(UnitDefs[Spring.GetUnitDefID(u)].weapons) do
                                local wd = WeaponDefs[wt.weaponDef]
                                if (wd) and count < 2 then
                                    count = count + 1
                                    r = wd.range
                                    gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
                                    --gl.Color(1,0.5,0.5,0.08)

                                    gl.LineWidth(2)
                                    gl.Color(1, 0.35, 0.15, 0.5)
                                    gl.DrawGroundCircle(x, y, z, r, blastCircleDivs)

                                    --gl.BeginEnd(GL.TRIANGLE_FAN,
                                    --	function()
                                    --		for a=0,2*math.pi,math.pi/18 do
                                    --			local px=x+r*math.cos(a)
                                    --			local pz=z+r*math.sin(a)
                                    --			local py=Spring.GetGroundHeight(px,pz)
                                    --			gl.Vertex(px,py,pz)
                                    --		end
                                    --	end
                                    --	)
                                    gl.Color(1, 1, 1, 1)
                                end
                            end
                 
                    end
                end
            end
        end
		
    end
	
	
	
	local isFa

	if tonumber(Spring.GetModOptions().anon_ffa) == 1 then --is fa
		isFa = true
	end
	
    local ScoreBoard = {}

    local xRelPos, yRelPos = 0.93, 0.93

    local vsx, vsy = Spring.GetViewGeometry()
    vsx = vsx * xRelPos
    vsy = vsy * yRelPos
    ScoreBoard.Show = false
    local TextWidthFixHack = 1

    local myteam = Spring.GetMyTeamID()

	
	function gadget:GameFrame(frame)
	
	
	end
	
    function gadget:DrawScreen()
        if SYNCED.Shoot_n_Run and SYNCED.Shoot_n_Run.ScoreBoard and (u ~= nil) and not Spring.IsGUIHidden() and not isFa and not Spring.GetSpectatingState() then
            -- Draw the Score Board
            --ScoreBoard.FontSize = ScoreBoard.FontSize or vsy*0.02
            ScoreBoard.FontSize = 22
            ScoreBoard.xSize = ScoreBoard.xSize or 0
            ScoreBoard.ySize = ScoreBoard.ySize or 0
            ScoreBoard.xPos =
                math.min(
                vsx - ScoreBoard.xSize - ScoreBoard.FontSize,
                math.max(ScoreBoard.FontSize, ScoreBoard.xPos or vsx)
            )
            ScoreBoard.yPos = math.min(vsy, math.max(ScoreBoard.ySize, ScoreBoard.yPos or vsy - 60))
            local line = 0
            local MaxScoreTxtxSize = 0
            for _, p in pairs(Spring.GetPlayerList()) do
                local score = SYNCED.Shoot_n_Run.ScoreBoard[p]
                if score then
                    ScoreBoard.Show = true
                    name, _, _, team = Spring.GetPlayerInfo(p)
                    local teamcolor = {Spring.GetTeamColor(team)}
                    gl.Color(teamcolor[1], teamcolor[2], teamcolor[3], 1)
                    local ScoreTxt =
                        ((ScoreBoard.ySize > 1.5 * ScoreBoard.FontSize) and name .. "  " or "") ..
                        "Kills: " ..
                            (score.kills or 0) .. "/" .. (score.totalkills or 0) .. "   Deaths: " .. (score.deaths or 0)
                    gl.Text(
                        ScoreTxt,
                        ScoreBoard.xPos,
                        ScoreBoard.yPos - line * ScoreBoard.FontSize,
                        ScoreBoard.FontSize,
                        "tn"
                    )
                    line = line + 1
                    MaxScoreTxtxSize = math.max(MaxScoreTxtxSize, gl.GetTextWidth(ScoreTxt))
                end
            end
            ScoreBoard.xSize = TextWidthFixHack * MaxScoreTxtxSize * ScoreBoard.FontSize
            ScoreBoard.ySize = line * ScoreBoard.FontSize
            if line > 0 then
                --gl.Color(0.5,0.5,0.5,0.5)
                --gl.LineWidth(1)
                --gl.Shape(GL.LINE_LOOP,{
                --	{v={ScoreBoard.xPos,ScoreBoard.yPos}},{v={ScoreBoard.xPos+ScoreBoard.xSize,ScoreBoard.yPos}},
                --	{v={ScoreBoard.xPos+ScoreBoard.xSize,ScoreBoard.yPos-ScoreBoard.ySize}},{v={ScoreBoard.xPos,ScoreBoard.yPos-ScoreBoard.ySize}},})
                gl.Color(1, 1, 1, 1)
            end
        end
        if SYNCED.Shoot_n_Run and SYNCED.Shoot_n_Run.ptu and not isFa then
            -- Draw the heroes name
            for _, p in ipairs(Spring.GetPlayerList()) do
                local u = SYNCED.Shoot_n_Run.ptu[p]
					
					
					
                if u and Spring.ValidUnitID(u) and p ~= Spring.GetLocalPlayerID() then
				
					local isvisible = CallAsTeam(Spring.GetMyTeamID(),
					function ()
					return Spring.IsUnitVisible(u, 0, true)
					end
					)
				
                    if (isvisible) then -- does this mean is in los? or radar dot
                        local FontSize = 20
                        local ux, uy, uz = Spring.GetUnitPosition(u)
                        local sx, sy, sz = Spring.WorldToScreenCoords(ux, uy, uz + 1.3 * Spring.GetUnitRadius(u))
                        local name, _, _, team = Spring.GetPlayerInfo(p)
                        local teamcolor = {Spring.GetTeamColor(team)}
                        local xsize = gl.GetTextWidth(name) * TextWidthFixHack * FontSize / 2
                        if sx < xsize or sy < FontSize or sx > vsx - xsize or sy > vsy or sz > 1 then
                            sx, sy, sz = sx - vsx / 2, sy - vsy / 2, sz < 1 and 1 or -1
                            sx, sy =
                                math.max(xsize, math.min(vsx - xsize, vsx / 2 + (vsy / 2) / math.abs(sy) * sx * sz)),
                                math.max(FontSize, math.min(vsy, vsy / 2 + (vsx / 2) / math.abs(sx) * sy * sz))
                        end
                        gl.Color(teamcolor[1], teamcolor[2], teamcolor[3], 1)
                        gl.Text(name, sx, sy, FontSize, "ac")
                        gl.Color(1, 1, 1, 1)
                    end
                end
            end
        end
    end

    function gadget:MouseMove(x, y, dx, dy, button)
        if ScoreBoard.Show and ScoreBoard.Moving then
            ScoreBoard.xPos = ScoreBoard.xPos + dx
            ScoreBoard.yPos = ScoreBoard.yPos + dy
            return true
        elseif GetTheOne() then
            return true
        end
    end

    function gadget:MousePress(x, y, button)
        if button == 1 then
            if
                ScoreBoard.Show and x > ScoreBoard.xPos and y < ScoreBoard.yPos and
                    x < ScoreBoard.xPos + ScoreBoard.xSize and
                    y > ScoreBoard.yPos - ScoreBoard.ySize
             then
                ScoreBoard.Moving = true
                return true
            elseif GetTheOne() then
                return true
            end
        end
        return false
    end

    function gadget:MouseRelease(x, y, button)
        if ScoreBoard.Moving then
            ScoreBoard.Moving = nil
            return true
        else
            return false
        end
    end

    function gadget:MouseWheel(up, value)
        local alt, ctrl, meta, shift = Spring.GetModKeyState()
        if (u ~= nil and not ctrl) then
            return true
        end
        if ScoreBoard.Show then
            local x, y = Spring.GetMouseState()
            if
                x > ScoreBoard.xPos and y < ScoreBoard.yPos and x < ScoreBoard.xPos + ScoreBoard.xSize and
                    y > ScoreBoard.yPos - ScoreBoard.ySize
             then
                if up then
                    ScoreBoard.FontSize = math.max(ScoreBoard.FontSize - 1, 2)
                else
                    ScoreBoard.FontSize = ScoreBoard.FontSize + 1
                end
                return true
            end
        end
        return false
    end
	


    function gadget:IsAbove(x, y)
        if
            ScoreBoard.Show and x > ScoreBoard.xPos and y < ScoreBoard.yPos and x < ScoreBoard.xPos + ScoreBoard.xSize and
                y > ScoreBoard.yPos - ScoreBoard.ySize
         then
            return true
        else
            return false
        end
    end
	
	
end
