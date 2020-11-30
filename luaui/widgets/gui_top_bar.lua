function widget:GetInfo()
	return {
		name		= "Top Bar",
		desc		= "Shows Resources, wind speed, commander counter, and various options.",
		author		= "Floris",
		date		= "Feb, 2017",
		license		= "GNU GPL, v2 or later",
        layer		= -9999999,
		enabled		= true, --enabled by default
		handler		= true, --can use widgetHandler:x()
	}
end

local ui_opacity = 0.66
local ui_scale = 1



local fontfile ="LuaUI/Fonts/FreeSansBold.otf"
local vsx,vsy = Spring.GetViewGeometry()
local fontfileScale = (0.7 + (vsx*vsy / 7000000))
local fontfileSize = 44
local fontfileOutlineSize = 8
local fontfileOutlineStrength = 1.3
local font = gl.LoadFont(fontfile, fontfileSize*fontfileScale, fontfileOutlineSize*fontfileScale, fontfileOutlineStrength)
local fontfile2 =  "LuaUI/Fonts/FreeSansBold.otf"
local font2 = gl.LoadFont(fontfile2, fontfileSize*fontfileScale, fontfileOutlineSize*fontfileScale, fontfileOutlineStrength)

local orgHeight = 46
local height = orgHeight * (1+(ui_scale-1)/1.7)

local relXpos = 0.3
local borderPadding = 5
local showConversionSlider = true
local bladeSpeedMultiplier = 0.2

local armcomDefID = UnitDefNames.armcom.id
local corcomDefID = UnitDefNames.corcom.id



local barGlowCenterTexture = ":l:LuaUI/Images/barglow-center.png"
local barGlowEdgeTexture = ":l:LuaUI/Images/barglow-edge.png"
local bladesTexture = ":l:LuaUI/Images/blades.png"
local poleTexture = ":l:LuaUI/Images/pole.png"
local comTexture = ":l:LuaUI/Images/comIcon.png"
local glowTexture = ":l:LuaUI/Images/glow.dds"

local vsx, vsy = gl.GetViewSizes()
local widgetScale = (0.80 + (vsx*vsy / 6000000))
local xPos = vsx*relXpos
local currentWind = 0
local currentTidal = 0
local gameStarted = false
local displayComCounter = true

local glTranslate = gl.Translate
local glColor = gl.Color
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTexture = gl.Texture
local glRect = gl.Rect
local glTexRect = gl.TexRect
local glText = gl.Text
local glRotate = gl.Rotate
local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList

local spGetSpectatingState = Spring.GetSpectatingState
local spGetTeamResources = Spring.GetTeamResources
local spGetMyTeamID = Spring.GetMyTeamID
local spGetMouseState = Spring.GetMouseState
local spGetWind = Spring.GetWind

local spec = spGetSpectatingState()
local myAllyTeamID = Spring.GetMyAllyTeamID()
local myTeamID = Spring.GetMyTeamID()
local myPlayerID = Spring.GetMyPlayerID()
local isReplay = Spring.IsReplay()

local numTeamsInAllyTeam = #Spring.GetTeamList(myAllyTeamID)

local sformat = string.format

local glBlending = gl.Blending
local GL_SRC_ALPHA = GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local GL_ONE = GL.ONE

local minWind = Game.windMin
local maxWind = Game.windMax
local windRotation = 0

local startComs = 0
local lastFrame = -1
local topbarArea = {}
local barContentArea = {}
local resbarArea = {metal={}, energy={}}
local resbarDrawinfo = {metal={}, energy={}}
local shareIndicatorArea = {metal={}, energy={}}
local dlistResbar = {metal={}, energy={}}
local energyconvArea = {}
local windArea = {}
local comsArea = {}
local rejoinArea = {}
local buttonsArea = {}
local dlistWindText = {}
local dlistResValues = {metal={},energy={}}
local currentResValue = {metal=1000,energy=1000}
local currentStorageValue = {metal=-1,energy=-1}

local r = {metal={spGetTeamResources(myTeamID,'metal')}, energy={spGetTeamResources(myTeamID,'energy')}}


local showOverflowTooltip = {}

local allyComs = 0
local enemyComs = 0 -- if we are counting ourselves because we are a spec
local enemyComCount = 0 -- if we are receiving a count from the gadget part (needs modoption on)
local prevEnemyComCount = 0

local guishaderEnabled = false
local guishaderCheckUpdateRate = 0.5
local nextGuishaderCheck = guishaderCheckUpdateRate
local now = os.clock()
local gameFrame = Spring.GetGameFrame()

local draggingShareIndicatorValue = {}

local chobbyLoaded = false
if Spring.GetMenuName and string.find(string.lower(Spring.GetMenuName()), 'chobby') ~= nil then
	chobbyLoaded = true
	Spring.SendLuaMenuMsg("disableLobbyButton")
end

local numAllyTeams = #Spring.GetAllyTeamList()-1
local singleTeams = false
if #Spring.GetTeamList()-1 == numAllyTeams then
	singleTeams = true
end

local allyteamOverflowingMetal = false
local allyteamOverflowingEnergy = false
local overflowingMetal = false
local overflowingEnergy = false

local isCommander = {}
for unitDefID, unitDef in pairs(UnitDefs) do
	if unitDef.customParams.iscommander then
		isCommander[unitDefID] = true
	end
end

--------------------------------------------------------------------------------
-- Rejoin
--------------------------------------------------------------------------------
local showRejoinUI = false --//variable:indicate whether UI is shown or hidden.

local CATCH_UP_THRESHOLD = 10 * Game.gameSpeed -- only show the window if behind this much
local UPDATE_RATE_F = 10 -- frames
local MOVING_AVG_COUNT = 30 -- update periods

local UPDATE_RATE_S = UPDATE_RATE_F / Game.gameSpeed
local serverFrame

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function isInBox(mx, my, box)
	return mx > box[1] and my > box[2] and mx < box[3] and my < box[4]
end

function widget:ViewResize(n_vsx,n_vsy, force)
	vsx, vsy = gl.GetViewSizes()
	widgetScale = (vsy / height) * 0.046
	widgetScale = widgetScale * ui_scale
	xPos = vsx*relXpos

	local newFontfileScale = (0.5 + (vsx*vsy / 5700000)) * ui_scale
	if fontfileScale ~= newFontfileScale or force then
		fontfileScale = newFontfileScale
		gl.DeleteFont(font)
		font = gl.LoadFont(fontfile, fontfileSize*fontfileScale, fontfileOutlineSize*fontfileScale, fontfileOutlineStrength)
		gl.DeleteFont(font2)
		font2 = gl.LoadFont(fontfile2, fontfileSize*fontfileScale, fontfileOutlineSize*fontfileScale, fontfileOutlineStrength)
	end

    for n,_ in pairs(dlistWindText) do
		dlistWindText[n] = glDeleteList(dlistWindText[n])
    end
	for n,_ in pairs(dlistResValues['metal']) do
		dlistResValues['metal'][n] = glDeleteList(dlistResValues['metal'][n])
	end
	for n,_ in pairs(dlistResValues['energy']) do
		dlistResValues['energy'][n] = glDeleteList(dlistResValues['energy'][n])
	end

	init()
end


local function DrawRectRound(px,py,sx,sy,cs, tl,tr,br,bl, c1,c2)
	local csyMult = 1 / ((sy-py)/cs)

	if c2 then
		gl.Color(c1[1],c1[2],c1[3],c1[4])
	end
	gl.Vertex(px+cs, py, 0)
	gl.Vertex(sx-cs, py, 0)
	if c2 then
		gl.Color(c2[1],c2[2],c2[3],c2[4])
	end
	gl.Vertex(sx-cs, sy, 0)
	gl.Vertex(px+cs, sy, 0)

	-- left side
	if c2 then
		gl.Color(c1[1]*(1-csyMult)+(c2[1]*csyMult),c1[2]*(1-csyMult)+(c2[2]*csyMult),c1[3]*(1-csyMult)+(c2[3]*csyMult),c1[4]*(1-csyMult)+(c2[4]*csyMult))
	end
	gl.Vertex(px, py+cs, 0)
	gl.Vertex(px+cs, py+cs, 0)
	if c2 then
		gl.Color(c2[1]*(1-csyMult)+(c1[1]*csyMult),c2[2]*(1-csyMult)+(c1[2]*csyMult),c2[3]*(1-csyMult)+(c1[3]*csyMult),c2[4]*(1-csyMult)+(c1[4]*csyMult))
	end
	gl.Vertex(px+cs, sy-cs, 0)
	gl.Vertex(px, sy-cs, 0)

	-- right side
	if c2 then
		gl.Color(c1[1]*(1-csyMult)+(c2[1]*csyMult),c1[2]*(1-csyMult)+(c2[2]*csyMult),c1[3]*(1-csyMult)+(c2[3]*csyMult),c1[4]*(1-csyMult)+(c2[4]*csyMult))
	end
	gl.Vertex(sx, py+cs, 0)
	gl.Vertex(sx-cs, py+cs, 0)
	if c2 then
		gl.Color(c2[1]*(1-csyMult)+(c1[1]*csyMult),c2[2]*(1-csyMult)+(c1[2]*csyMult),c2[3]*(1-csyMult)+(c1[3]*csyMult),c2[4]*(1-csyMult)+(c1[4]*csyMult))
	end
	gl.Vertex(sx-cs, sy-cs, 0)
	gl.Vertex(sx, sy-cs, 0)

	-- bottom left
	if c2 then
		gl.Color(c1[1],c1[2],c1[3],c1[4])
	end
	if ((py <= 0 or px <= 0)  or (bl ~= nil and bl == 0)) and bl ~= 2   then
		gl.Vertex(px, py, 0)
	else
		gl.Vertex(px+cs, py, 0)
	end
	gl.Vertex(px+cs, py, 0)
	if c2 then
		gl.Color(c1[1]*(1-csyMult)+(c2[1]*csyMult),c1[2]*(1-csyMult)+(c2[2]*csyMult),c1[3]*(1-csyMult)+(c2[3]*csyMult),c1[4]*(1-csyMult)+(c2[4]*csyMult))
	end
	gl.Vertex(px+cs, py+cs, 0)
	gl.Vertex(px, py+cs, 0)
	-- bottom right
	if c2 then
		gl.Color(c1[1],c1[2],c1[3],c1[4])
	end
	if ((py <= 0 or sx >= vsx) or (br ~= nil and br == 0)) and br ~= 2 then
		gl.Vertex(sx, py, 0)
	else
		gl.Vertex(sx-cs, py, 0)
	end
	gl.Vertex(sx-cs, py, 0)
	if c2 then
		gl.Color(c1[1]*(1-csyMult)+(c2[1]*csyMult),c1[2]*(1-csyMult)+(c2[2]*csyMult),c1[3]*(1-csyMult)+(c2[3]*csyMult),c1[4]*(1-csyMult)+(c2[4]*csyMult))
	end
	gl.Vertex(sx-cs, py+cs, 0)
	gl.Vertex(sx, py+cs, 0)
	-- top left
	if c2 then
		gl.Color(c2[1],c2[2],c2[3],c2[4])
	end
	if ((sy >= vsy or px <= 0) or (tl ~= nil and tl == 0)) and tl ~= 2 then
		gl.Vertex(px, sy, 0)
	else
		gl.Vertex(px+cs, sy, 0)
	end
	gl.Vertex(px+cs, sy, 0)
	if c2 then
		gl.Color(c2[1]*(1-csyMult)+(c1[1]*csyMult),c2[2]*(1-csyMult)+(c1[2]*csyMult),c2[3]*(1-csyMult)+(c1[3]*csyMult),c2[4]*(1-csyMult)+(c1[4]*csyMult))
	end
	gl.Vertex(px+cs, sy-cs, 0)
	gl.Vertex(px, sy-cs, 0)
	-- top right
	if c2 then
		gl.Color(c2[1],c2[2],c2[3],c2[4])
	end
	if ((sy >= vsy or sx >= vsx)  or (tr ~= nil and tr == 0)) and tr ~= 2 then
		gl.Vertex(sx, sy, 0)
	else
		gl.Vertex(sx-cs, sy, 0)
	end
	gl.Vertex(sx-cs, sy, 0)
	if c2 then
		gl.Color(c2[1]*(1-csyMult)+(c1[1]*csyMult),c2[2]*(1-csyMult)+(c1[2]*csyMult),c2[3]*(1-csyMult)+(c1[3]*csyMult),c2[4]*(1-csyMult)+(c1[4]*csyMult))
	end
	gl.Vertex(sx-cs, sy-cs, 0)
	gl.Vertex(sx, sy-cs, 0)
end
function RectRound(px,py,sx,sy,cs, tl,tr,br,bl, c1,c2)		-- (coordinates work differently than the RectRound func in other widgets)
	gl.Texture(false)
	gl.BeginEnd(GL.QUADS, DrawRectRound, px,py,sx,sy,cs, tl,tr,br,bl, c1,c2)
end

local function short(n,f)
	if (f == nil) then
		f = 0
	end
	if (n > 9999999) then
		return sformat("%."..f.."fm",n/1000000)
	elseif (n > 9999) then
		return sformat("%."..f.."fk",n/1000)
	else
		return sformat("%."..f.."f",n)
	end
end


local function updateRejoin()
	local area = rejoinArea

	local catchup = gameFrame / serverFrame

	-- add background blur
	if dlistRejoinGuishader ~= nil then
		if WG['guishader'] then
			WG['guishader'].RemoveDlist('topbar_rejoin')
		end
		glDeleteList(dlistRejoinGuishader)
	end
	dlistRejoinGuishader = glCreateList( function()
		RectRound(area[1], area[2], area[3], area[4], 5.5*widgetScale)
	end)


	if dlistRejoin ~= nil then
		glDeleteList(dlistRejoin)
	end
	dlistRejoin = glCreateList( function()

		-- background
		--glColor(0,0,0,ui_opacity)
		RectRound(area[1], area[2], area[3], area[4], 5.5*widgetScale, 1,1,1,1, {0,0,0,ui_opacity}, {0.1,0.1,0.1,ui_opacity})
		local bgpadding = 3*widgetScale
		--glColor(1,1,1,ui_opacity*0.055)
		RectRound(area[1]+bgpadding, area[2]+bgpadding, area[3]-bgpadding, area[4], bgpadding*1.25, 1,1,1,1, {1,1,1,ui_opacity*0.2}, {0.3,0.3,0.3,ui_opacity*0.2})

		if WG['guishader'] then
			WG['guishader'].InsertDlist(dlistRejoinGuishader, 'topbar_rejoin')
		end

		local barHeight = (height*widgetScale/9)
		local barHeighPadding = 7*widgetScale --((height/2) * widgetScale) - (barHeight/2)
		local barLeftPadding = 7* widgetScale
		local barRightPadding = 7 * widgetScale
		local barArea = {area[1]+barLeftPadding, area[2]+barHeighPadding, area[3]-barRightPadding, area[2]+barHeight+barHeighPadding}
		local barWidth = barArea[3] - barArea[1]

		-- bar background
		RectRound(barArea[1], barArea[2], barArea[3], barArea[4], barHeight*0.2, 1,1,1,1, {0,0,0,0.27},{0.44,0.44,0.44,0.44})

		-- Bar value
		glColor(0, 1, 0, 1)
		RectRound(barArea[1], barArea[2], barArea[1]+(catchup * barWidth), barArea[4], barHeight*0.2, 1,1,1,1, {0,0.55,0,1},{0, 1, 0, 1})

		-- Bar value glow
		local glowSize = barHeight * 6
		glBlending(GL_SRC_ALPHA, GL_ONE)
		glColor(0, 1, 0, 0.085)
		glTexture(barGlowCenterTexture)
		glTexRect(barArea[1], barArea[2] - glowSize, barArea[1]+(catchup * barWidth), barArea[4] + glowSize)
		glTexture(barGlowEdgeTexture)
		glTexRect(barArea[1]-(glowSize*2), barArea[2] - glowSize, barArea[1], barArea[4] + glowSize)
		glTexRect((barArea[1]+(catchup * barWidth))+(glowSize*2), barArea[2] - glowSize, barArea[1]+(catchup * barWidth), barArea[4] + glowSize)
		glTexture(false)
		glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

		-- Text
		local fontsize = 12*widgetScale
        font2:Begin()
        font2:Print('\255\225\255\225Catching up', area[1]+((area[3]-area[1])/2), area[2]+barHeight*2+fontsize, fontsize, 'cor')
        font2:End()

	end)
	
end


local function updateButtons()
	local area = buttonsArea

	local totalWidth = area[3] - area[1]

	local text = '    '

	if (WG['teamstats'] ~= nil) then text = text..'Stats   ' end
    if (WG['commands'] ~= nil) then text = text..'Cmd   ' end
    if (WG['keybinds'] ~= nil) then text = text..'Keys   ' end
    if (WG['changelog'] ~= nil) then text = text..'Changes   ' end
    if (WG['options'] ~= nil) then text = text..'Settings   ' end
	if chobbyLoaded then
		text = text..'Lobby  '
	else
		text = text..'Quit  '
	end

	local fontsize = totalWidth / font2:GetTextWidth(text)
	if fontsize > (height*widgetScale)/3 then
		fontsize = (height*widgetScale)/3
	end

	-- add background blur
	if dlistButtonsGuishader ~= nil then
		if WG['guishader'] then
			WG['guishader'].RemoveDlist('topbar_buttons')
		end
		glDeleteList(dlistButtonsGuishader)
	end
	dlistButtonsGuishader = glCreateList( function()
		RectRound(area[1], area[2], area[3], area[4], 5.5*widgetScale)
	end)


	if dlistButtons1 ~= nil then
		glDeleteList(dlistButtons1)
	end
	dlistButtons1 = glCreateList( function()

			-- background
		--glColor(0,0,0,ui_opacity)
		RectRound(area[1], area[2], area[3], area[4], 5.5*widgetScale, 1,1,1,1, {0,0,0,0.38+(ui_opacity*0.44)}, {0.1,0.1,0.1,(ui_opacity)})
		local bgpadding = 3*widgetScale
		--glColor(1,1,1,ui_opacity*0.055)
		RectRound(area[1]+bgpadding, area[2]+bgpadding, area[3], area[4], bgpadding*1.25, 0,0,1,1, {0.2,0.2,0.2,(ui_opacity)},{0,0,0,(ui_opacity)})

		RectRound(area[1]+bgpadding, area[4]+bgpadding-((area[4]-area[2])*0.5), area[3], area[4], 3.3*widgetScale, 0,0,0,0, {1,1,1,0.07}, {1,1,1,0.21})
		RectRound(area[1]+bgpadding, area[2]+bgpadding, area[3], area[2]+bgpadding+((area[4]-area[2])*0.35), bgpadding*1.25, 0,0,1,1, {1,1,1,0.09},{0,0,0,0})


		if WG['guishader'] then
			WG['guishader'].InsertDlist(dlistButtonsGuishader, 'topbar_buttons')
		end

		if buttonsArea['buttons'] == nil then
			buttonsArea['buttons'] = {}

			local margin = height*widgetScale / 11
			local offset = margin
			local width = 0
            local buttons = 0

            if (WG['teamstats'] ~= nil) then
                buttons = buttons + 1
                if buttons > 1 then offset = offset+width end
                width = font2:GetTextWidth('   Stats ') * fontsize
                buttonsArea['buttons']['stats'] = {area[1]+offset, area[2]+margin, area[1]+offset+width, area[4] }
            end
            if (WG['commands'] ~= nil) then
                buttons = buttons + 1
                if buttons > 1 then offset = offset+width end
                width = font2:GetTextWidth('  Cmd ') * fontsize
                buttonsArea['buttons']['commands'] = {area[1]+offset, area[2]+margin, area[1]+offset+width, area[4]}
			end
            if (WG['keybinds'] ~= nil) then
                buttons = buttons + 1
                if buttons > 1 then offset = offset+width end
                width = font2:GetTextWidth('  Keys ') * fontsize
                buttonsArea['buttons']['keybinds'] = {area[1]+offset, area[2]+margin, area[1]+offset+width, area[4]}
            end
            if (WG['changelog'] ~= nil) then
                buttons = buttons + 1
                if buttons > 1 then offset = offset+width end
                width = font2:GetTextWidth('  Changes ') * fontsize
                buttonsArea['buttons']['changelog'] = {area[1]+offset, area[2]+margin, area[1]+offset+width, area[4]}
            end
            if (WG['options'] ~= nil) then
                buttons = buttons + 1
                if buttons > 1 then offset = offset+width end
                width = font2:GetTextWidth('  Settings ') * fontsize
                buttonsArea['buttons']['options'] = {area[1]+offset, area[2]+margin, area[1]+offset+width, area[4]}
            end
			if chobbyLoaded then
				offset = offset+width
				width = font2:GetTextWidth('  Lobby  ') * fontsize
				buttonsArea['buttons']['quit'] = {area[1]+offset, area[2]+margin, area[3], area[4]}
			else
				offset = offset+width
				width = font2:GetTextWidth('  Quit  ') * fontsize
				buttonsArea['buttons']['quit'] = {area[1]+offset, area[2]+margin, area[3], area[4]}
			end
		end
	end)

	if dlistButtons2 ~= nil then
		glDeleteList(dlistButtons2)
	end
	dlistButtons2 = glCreateList( function()
        font2:Begin()
		font2:Print('\255\210\210\210'..text, area[1], area[2]+((area[4]-area[2])*0.52)-(fontsize/5), fontsize, 'o')
        font2:End()
	end)
end


local function updateComs(forceText)
	local area = comsArea

	-- add background blur
	if dlistComsGuishader ~= nil then
		if WG['guishader'] then
			WG['guishader'].RemoveDlist('topbar_coms')
		end
		glDeleteList(dlistComsGuishader)
	end
	dlistComsGuishader = glCreateList( function()
		RectRound(area[1], area[2], area[3], area[4], 5.5*widgetScale)
	end)

	if dlistComs1 ~= nil then
		glDeleteList(dlistComs1)
	end
	dlistComs1 = glCreateList( function()

		-- background
		--glColor(0,0,0,ui_opacity)
		RectRound(area[1], area[2], area[3], area[4], 5.5*widgetScale, 1,1,1,1, {0,0,0,ui_opacity}, {0.1,0.1,0.1,ui_opacity})
		local bgpadding = 3*widgetScale
		--glColor(1,1,1,ui_opacity*0.055)
		RectRound(area[1]+bgpadding, area[2]+bgpadding, area[3]-bgpadding, area[4], bgpadding*1.25, 1,1,1,1, {1,1,1,ui_opacity*0.2},{0.15,0.15,0.15,ui_opacity*0.2})


		if WG['guishader'] then
			WG['guishader'].InsertDlist(dlistComsGuishader, 'topbar_coms')
		end
	end)

	if dlistComs2 ~= nil then
		glDeleteList(dlistComs2)
	end
	dlistComs2 = glCreateList( function()
		-- Commander icon
		local sizeHalf = (height/2.75)*widgetScale

		glTexture(comTexture)
		glTexRect(area[1]+((area[3]-area[1])/2)-sizeHalf, area[2]+((area[4]-area[2])/2)-sizeHalf, area[1]+((area[3]-area[1])/2)+sizeHalf, area[2]+((area[4]-area[2])/2)+sizeHalf)
        glTexture(false)

		-- Text
		if gameFrame > 0 or forceText then
            font2:Begin()
			local fontsize = (height/2.85)*widgetScale
            font2:Print('\255\255\000\000'..enemyComCount, area[3]-(2.8*widgetScale), area[2]+(4.5*widgetScale), fontsize, 'or')

			fontSize = (height/2.15)*widgetScale
            font2:Print("\255\000\255\000"..allyComs, area[1]+((area[3]-area[1])/2), area[2]+((area[4]-area[2])/2.05)-(fontSize/5), fontSize, 'oc')
            font2:End()
		end
	end)
	comcountChanged = nil


end


local function updateWind()
	local area = windArea

	local xPos =  area[1]
	local yPos =  area[2] + ((area[4] - area[2])/3.5)
	local oorx = 10*widgetScale
	local oory = 13*widgetScale

	local bgpadding = 3*widgetScale

	local poleWidth = 6 * widgetScale
	local poleHeight = 14 * widgetScale

	-- add background blur
	if dlistWindGuishader ~= nil then
		if WG['guishader'] then
			WG['guishader'].RemoveDlist('topbar_wind')
		end
		glDeleteList(dlistWindGuishader)
	end
	dlistWindGuishader = glCreateList( function()
		RectRound(area[1], area[2], area[3], area[4], 5.5*widgetScale)
	end)

	if dlistWind1 ~= nil then
		glDeleteList(dlistWind1)
	end
	dlistWind1 = glCreateList( function()

		-- background
		--glColor(0,0,0,ui_opacity)
		RectRound(area[1], area[2], area[3], area[4], 5.5*widgetScale, 1,1,1,1, {0,0,0,ui_opacity}, {0.1,0.1,0.1,ui_opacity})
		local bgpadding = 3*widgetScale
		--glColor(1,1,1,ui_opacity*0.055)
		RectRound(area[1]+bgpadding, area[2]+bgpadding, area[3]-bgpadding, area[4], bgpadding*1.25, 1,1,1,1, {1,1,1,ui_opacity*0.2},{0.15,0.15,0.15,ui_opacity*0.2})


		if WG['guishader'] then
			WG['guishader'].InsertDlist(dlistWindGuishader, 'topbar_wind')
		end

		glPushMatrix()
			glTranslate(xPos, yPos, 0)
			glTranslate(11*widgetScale, -((height*widgetScale)/4.4), 0) -- Spacing of icon
			glPushMatrix() -- Blades
				glTranslate(1*widgetScale, 9*widgetScale, 0)
				glTranslate(oorx, oory, 0)
	end)

	if dlistWind2 ~= nil then
		glDeleteList(dlistWind2)
	end
	dlistWind2 = glCreateList( function()
				glTranslate(-oorx, -oory, 0)
				glColor(1,1,1,0.3)
				glTexture(bladesTexture)
				glTexRect(0, 0, 27*widgetScale, 28*widgetScale)
				glTexture(false)
			glPopMatrix()

			x,y = 9*widgetScale, 2*widgetScale -- Pole
			glTexture(poleTexture)
			glTexRect(x, y, (7*widgetScale)+x, y+(18*widgetScale))
			glTexture(false)
		glPopMatrix()

		-- min and max wind
		local fontsize = (height/3.7)*widgetScale
        font2:Begin()
        font2:Print("\255\140\140\140"..minWind, area[3]-(2.8*widgetScale), area[4]-(4.5*widgetScale)-(fontsize/2), fontsize, 'or')
        font2:Print("\255\140\140\140"..maxWind, area[3]-(2.8*widgetScale), area[2]+(4.5*widgetScale), fontsize, 'or')
        font2:Print("\255\140\140\140"..maxWind, area[3]-(2.8*widgetScale), area[2]+(4.5*widgetScale), fontsize, 'or')
        font2:End()

	end)


end

local function updateResbarText(res)

	if dlistResbar[res][4] ~= nil then
		glDeleteList(dlistResbar[res][4])
	end
	dlistResbar[res][4] = glCreateList( function()
		local bgpadding = 3*widgetScale
		RectRound(resbarArea[res][1]+bgpadding, resbarArea[res][2]+bgpadding, resbarArea[res][3]-bgpadding, resbarArea[res][4], bgpadding*1.25)
		RectRound(resbarArea[res][1], resbarArea[res][2], resbarArea[res][3], resbarArea[res][4], 5.5*widgetScale)
	end)
	if dlistResbar[res][5] ~= nil then
		glDeleteList(dlistResbar[res][5])
	end
	dlistResbar[res][5] = glCreateList( function()
		RectRound(resbarArea[res][1], resbarArea[res][2], resbarArea[res][3], resbarArea[res][4], 5.5*widgetScale)
	end)

	-- storage changed!
	if currentStorageValue[res] ~= r[res][2] then
		-- flush old dlist caches
		for n,_ in pairs(dlistResValues[res]) do
			glDeleteList(dlistResValues[res][n])
		end
		dlistResValues[res] = {}

		-- storage
		if dlistResbar[res][6] ~= nil then
			glDeleteList(dlistResbar[res][6])
		end
		dlistResbar[res][6] = glCreateList( function()
			font2:Begin()
			font2:Print("\255\150\150\150"..short(r[res][2]), resbarDrawinfo[res].textStorage[2], resbarDrawinfo[res].textStorage[3], resbarDrawinfo[res].textStorage[4], resbarDrawinfo[res].textStorage[5])
			font2:End()
		end)
	end

	if dlistResbar[res][3] ~= nil then
		glDeleteList(dlistResbar[res][3])
	end
    dlistResbar[res][3] = glCreateList( function()
        font2:Begin()
        -- Text: pull
        font2:Print("\255\210\100\100"..'-'..short(r[res][3]), resbarDrawinfo[res].textPull[2], resbarDrawinfo[res].textPull[3], resbarDrawinfo[res].textPull[4], resbarDrawinfo[res].textPull[5])
		-- Text: expense
		--local textcolor = "\255\150\135\110"
		--if r[res][3] == r[res][5] then
		--	textcolor = "\255\166\115\110"
		--end
       -- font2:Print(textcolor..short(r[res][5]), resbarDrawinfo[res].textExpense[2], resbarDrawinfo[res].textExpense[3], resbarDrawinfo[res].textExpense[4], resbarDrawinfo[res].textExpense[5])
		-- income
		font2:Print("\255\100\210\100"..'+'..short(r[res][4]), resbarDrawinfo[res].textIncome[2], resbarDrawinfo[res].textIncome[3], resbarDrawinfo[res].textIncome[4], resbarDrawinfo[res].textIncome[5])
		font2:End()

		if not spec and gameFrame > 90 then

			-- display overflow notification
			if (res == 'metal' and (allyteamOverflowingMetal or overflowingMetal)) or (res == 'energy' and (allyteamOverflowingEnergy or overflowingEnergy)) then
				if showOverflowTooltip[res] == nil then
					showOverflowTooltip[res] = os.clock() + 0.5
				end
				if showOverflowTooltip[res] < os.clock() then
					local bgpadding = 2.5*widgetScale
					local text = ''
					if res == 'metal' then
						text = (allyteamOverflowingMetal and 'Excessing' or 'Excessing')
						if WG['notifications'] then
							if allyteamOverflowingMetal then
								if numTeamsInAllyTeam > 1 then
									WG['notifications'].addEvent('WholeTeamWastingMetal')
								else
									WG['notifications'].addEvent('YouAreWastingMetal')
								end
							else
								WG['notifications'].addEvent('YouAreOverflowingMetal')
							end
						end
					else
						text = (allyteamOverflowingEnergy and 'Excessing' or 'Excessing')
						if WG['notifications'] then
							if allyteamOverflowingEnergy then
								if numTeamsInAllyTeam > 1 then
									WG['notifications'].addEvent('WholeTeamWastingEnergy')
								else
									WG['notifications'].addEvent('YouAreWastingEnergy')
								end
							else
								WG['notifications'].addEvent('YouAreOverflowingEnergy')
							end
						end
					end
					local textWidth = (bgpadding*2) + 22 + font2:GetTextWidth(text) * (orgHeight * (1+(ui_scale-1)/1.33)/4) * widgetScale

					-- background
					local color1,color2
					if res == 'metal' then
						if allyteamOverflowingMetal then
							color1 = {0.33,0,0,0.6}
							color2 = {0.22,0,0,0.6}
						else
							color1 = {0.33,0.33,0.33,0.4}
							color2 = {0.22,0.22,0.22,0.4}
						end
					else
						if allyteamOverflowingEnergy then
							color1 = {0.33,0,0,0.6}
							color2 = {0.22,0,0,0.6}
						else
							color1 = {0.33,0.22,0,0.6}
							color2 = {0.22,0.15,0,0.6}
						end
					end
					RectRound(resbarArea[res][3]-textWidth, resbarArea[res][4]-15.5*widgetScale, resbarArea[res][3], resbarArea[res][4], 4*widgetScale, 1,1,1,1, color1,color2)
					if res == 'metal' then
						if allyteamOverflowingMetal then
							color1 = {1,0.3,0.3,0.2}
							color2 = {1,0.3,0.3,0.33}
						else
							color1 = {1,1,1,0.15}
							color2 = {1,1,1,0.33}
						end
					else
						if allyteamOverflowingEnergy then
							color1 = {1,0.3,0.3,0.2}
							color2 = {1,0.3,0.3,0.33}
						else
							color1 = {1,0.88,0,0.2}
							color2 = {1,0.88,0,0.33}
						end
					end
					RectRound(resbarArea[res][3]-textWidth+bgpadding, resbarArea[res][4]-15.5*widgetScale+bgpadding, resbarArea[res][3]-bgpadding, resbarArea[res][4], bgpadding*1.25, 1,1,1,1, color1,color2)

                    font2:Begin()
                    font2:SetTextColor(1,0.88,0.88,1)
                    font2:SetOutlineColor(0.2,0,0,0.6)
                    font2:Print(text, resbarArea[res][3]-7*widgetScale, resbarArea[res][4]-9.5*widgetScale, (orgHeight * (1+(ui_scale-1)/1.33)/4)*widgetScale, 'or')
                    font2:End()
				end
			else
				showOverflowTooltip[res] = nil
			end
		end
	end)
end

local function updateResbar(res)
	local area = resbarArea[res]

	if dlistResbar[res][1] ~= nil then
		glDeleteList(dlistResbar[res][1])
		glDeleteList(dlistResbar[res][2])
	end
	local barHeight = (height*widgetScale/9)
	local barHeighPadding = (height/4.25)*widgetScale --((height/2) * widgetScale) - (barHeight/2)
	--local barLeftPadding = 2 * widgetScale
	local barLeftPadding = 45 * widgetScale
	local barRightPadding = 14.5 * widgetScale
	local barArea = {area[1]+(height*widgetScale)+barLeftPadding, area[2]+barHeighPadding, area[3]-barRightPadding, area[2]+barHeight+barHeighPadding}
	local sliderHeightAdd = barHeight / 1.55
	local shareSliderWidth = barHeight + sliderHeightAdd + sliderHeightAdd
	local barWidth = barArea[3] - barArea[1]
	local glowSize = barHeight * 7

	if not showQuitscreen and resbarHover ~= nil and resbarHover == res then
		sliderHeightAdd = barHeight / 0.75
		shareSliderWidth = barHeight + sliderHeightAdd + sliderHeightAdd
	end

	if res == 'metal' then
		resbarDrawinfo[res].barColor = {1,1,1,1}
	else
		resbarDrawinfo[res].barColor = {1,1,0,1}
	end
	resbarDrawinfo[res].barArea = barArea

	resbarDrawinfo[res].barTexRect = {barArea[1], barArea[2], barArea[1]+((r[res][1]/r[res][2]) * barWidth), barArea[4]}
	resbarDrawinfo[res].barGlowMiddleTexRect = {resbarDrawinfo[res].barTexRect[1], resbarDrawinfo[res].barTexRect[2] - glowSize, resbarDrawinfo[res].barTexRect[3], resbarDrawinfo[res].barTexRect[4] + glowSize}
	resbarDrawinfo[res].barGlowLeftTexRect = {resbarDrawinfo[res].barTexRect[1]-(glowSize*2.5), resbarDrawinfo[res].barTexRect[2] - glowSize, resbarDrawinfo[res].barTexRect[1], resbarDrawinfo[res].barTexRect[4] + glowSize}
	resbarDrawinfo[res].barGlowRightTexRect = {resbarDrawinfo[res].barTexRect[3]+(glowSize*2.5), resbarDrawinfo[res].barTexRect[2] - glowSize, resbarDrawinfo[res].barTexRect[3], resbarDrawinfo[res].barTexRect[4] + glowSize}

	resbarDrawinfo[res].textCurrent	= {short(r[res][1]), barArea[1]+barWidth/2, barArea[2]+barHeight*2.2, (height/2.75)*widgetScale, 'ocd'}
	resbarDrawinfo[res].textStorage	= {"\255\150\150\150"..short(r[res][2]), barArea[3], barArea[2]+barHeight*2.35, (height/3.2)*widgetScale, 'ord'}
	resbarDrawinfo[res].textPull	= {"\255\210\100\100"..short(r[res][3]), barArea[1]-(10*widgetScale), barArea[2]+barHeight*2.75, (height/3.2)*widgetScale, 'ord'}
	resbarDrawinfo[res].textExpense	= {"\255\210\100\100"..short(r[res][5]), barArea[1]+(10*widgetScale), barArea[2]+barHeight*2.2, (height/3.2)*widgetScale, 'old'}
	resbarDrawinfo[res].textIncome	= {"\255\100\210\100"..short(r[res][4]), barArea[1]-(10*widgetScale), barArea[2]-barHeight/1.65, (height/3.2)*widgetScale, 'ord'}

	-- add background blur
	if dlistResbar[res][0] ~= nil then
		if WG['guishader'] then
			WG['guishader'].RemoveDlist('topbar_'..res)
		end
		glDeleteList(dlistResbar[res][0])
	end
	dlistResbar[res][0] = glCreateList( function()
		RectRound(area[1], area[2], area[3], area[4], 5.5*widgetScale)
	end)

	dlistResbar[res][1] = glCreateList( function()

		-- background
		--glColor(0,0,0,ui_opacity)
		RectRound(area[1], area[2], area[3], area[4], 5.5*widgetScale, 1,1,1,1, {0,0,0,ui_opacity}, {0.1,0.1,0.1,ui_opacity})
		local bgpadding = 3*widgetScale
		--glColor(1,1,1,ui_opacity*0.055)
		RectRound(area[1]+bgpadding, area[2]+bgpadding, area[3]-bgpadding, area[4], bgpadding*1.25, 1,1,1,1, {1,1,1,ui_opacity*0.2},{0.15,0.15,0.15,ui_opacity*0.2})

		if WG['guishader'] then
			WG['guishader'].InsertDlist(dlistResbar[res][0], 'topbar_'..res)
		end

		-- Icon
		glColor(1,1,1,1)
		local iconPadding = (area[4] - area[2]) / 11
		if res == 'metal' then
			glTexture(":l:LuaUI/Images/metal.png")
		else
			glTexture(":l:LuaUI/Images/energy.png")
		end
		glTexRect(area[1]+iconPadding+(height*0.02*widgetScale), area[2]+iconPadding+(height*0.04*widgetScale), area[1]+(height*1.1*widgetScale)-iconPadding, area[4]-iconPadding+(height*0.04*widgetScale))
		glTexture(false)

		-- Bar background
		local addedSize = (barArea[4]-barArea[2])*0.25
		RectRound(barArea[1]-addedSize, barArea[2]-addedSize, barArea[3]+addedSize, barArea[4]+addedSize, barHeight*0.2, 1,1,1,1, {0,0,0,0.27},{0.44,0.44,0.44,0.44})
	end)

	dlistResbar[res][2] = glCreateList( function()
		-- Metalmaker Conversion slider
		if showConversionSlider and res == 'energy' then
            local convValue = Spring.GetTeamRulesParam(myTeamID, 'mmLevel')
            if draggingConversionIndicatorValue ~= nil then
                convValue = draggingConversionIndicatorValue/100
			end
			if convValue == nil then
				convValue = 1
			end
			conversionIndicatorArea = {barArea[1]+(convValue * barWidth)-(shareSliderWidth/2), barArea[2]-sliderHeightAdd, barArea[1]+(convValue * barWidth)+(shareSliderWidth/2), barArea[4]+sliderHeightAdd}
			local cornerSize
			if not showQuitscreen and resbarHover ~= nil and resbarHover == res then
				cornerSize = 2.2*widgetScale
			else
				cornerSize = 1.5*widgetScale
			end
			RectRound(conversionIndicatorArea[1], conversionIndicatorArea[2], conversionIndicatorArea[3], conversionIndicatorArea[4],cornerSize, 1,1,1,1, {0.6, 0.6, 0.45, 1}, {0.95, 0.95, 0.7, 1})
		end
		-- Share slider
        local value = r[res][6]
        if draggingShareIndicatorValue[res] ~= nil then
            value = draggingShareIndicatorValue[res]
        end
		shareIndicatorArea[res] = {barArea[1]+(value * barWidth)-(shareSliderWidth/2), barArea[2]-sliderHeightAdd, barArea[1]+(value * barWidth)+(shareSliderWidth/2), barArea[4]+sliderHeightAdd}
		local cornerSize
		if not showQuitscreen and resbarHover ~= nil and resbarHover == res then
			cornerSize = 2.2*widgetScale
		else
			cornerSize = 1.5*widgetScale
		end
		RectRound(shareIndicatorArea[res][1], shareIndicatorArea[res][2], shareIndicatorArea[res][3], shareIndicatorArea[res][4],cornerSize, 1,1,1,1, {0.4, 0, 0, 1}, {0.8, 0, 0, 1})

		glTexture(false)
	end)

	-- add tooltips
	
end



function init()

	r = {metal={spGetTeamResources(myTeamID,'metal')}, energy={spGetTeamResources(myTeamID,'energy')}}

	topbarArea = {xPos, math.floor(vsy-(borderPadding*widgetScale)-(height*widgetScale)), vsx, vsy}
	barContentArea = {xPos+(borderPadding*widgetScale), math.floor(vsy-(height*widgetScale)), vsx, vsy}

	--Spring.Echo((borderPadding*widgetScale)-(height*widgetScale))
	--Spring.Echo(ui_scale..'   '..topbarArea[2])

	local filledWidth = 0
	local totalWidth = barContentArea[3] - barContentArea[1]
	local areaSeparator = (borderPadding*widgetScale)

	if dlistBackground then
		glDeleteList(dlistBackground)
	end
	dlistBackground = glCreateList( function()

		--glColor(0, 0, 0, 0.66)
		--RectRound(topbarArea[1], topbarArea[2], topbarArea[3], topbarArea[4], 6*widgetScale)
		--
		--glColor(1,1,1,0.025)
		--RectRound(barContentArea[1], barContentArea[2], barContentArea[3], barContentArea[4]+(10*widgetScale), 5*widgetScale)

	end)

	-- metal
	local width = (totalWidth/4)
	resbarArea['metal'] = {barContentArea[1]+filledWidth, barContentArea[2], barContentArea[1]+filledWidth+width, barContentArea[4]}
	filledWidth = filledWidth + width + areaSeparator
	updateResbar('metal')

	--energy
	resbarArea['energy'] = {barContentArea[1]+filledWidth, barContentArea[2], barContentArea[1]+filledWidth+width, barContentArea[4]}
	filledWidth = filledWidth + width + areaSeparator
	updateResbar('energy')

	-- wind
	width = ((height*1.18)*widgetScale)
	windArea = {barContentArea[1]+filledWidth, barContentArea[2], barContentArea[1]+filledWidth+width, barContentArea[4]}
	filledWidth = filledWidth + width + areaSeparator
	updateWind()

	-- coms
	if displayComCounter then
		comsArea = {barContentArea[1]+filledWidth, barContentArea[2], barContentArea[1]+filledWidth+width, barContentArea[4]}
		filledWidth = filledWidth + width + areaSeparator
        updateComs()
	end

	-- rejoin
	width = (totalWidth/4) / 3.3
	rejoinArea = {barContentArea[1]+filledWidth, barContentArea[2], barContentArea[1]+filledWidth+width, barContentArea[4]}
	filledWidth = filledWidth + width + areaSeparator

	-- buttons
	width = (totalWidth/4)
	buttonsArea = {barContentArea[3]-width, barContentArea[2], barContentArea[3], barContentArea[4]}
	filledWidth = filledWidth + width + areaSeparator
	updateButtons()

	WG['topbar'].GetPosition = function()
		return {topbarArea[1], topbarArea[2], topbarArea[3], topbarArea[4], widgetScale, barContentArea[2]}
	end

	updateResbarText('metal')
	updateResbarText('energy')
end

function checkStatus()
	myAllyTeamID = Spring.GetMyAllyTeamID()
    myTeamID = Spring.GetMyTeamID()
	myPlayerID = Spring.GetMyPlayerID()
end


function widget:GameStart()
	gameStarted = true
	checkStatus()
	if displayComCounter then
		countComs(true)
	end
end


function widget:GameFrame(n)
	spec = spGetSpectatingState()

    windRotation = windRotation + (currentWind * bladeSpeedMultiplier)
    gameFrame = n

    --functionContainer(n) --function that are able to remove itself. Reference: gui_take_reminder.lua (widget by EvilZerggin, modified by jK)
end

local uiOpacitySec = 0
local sec = 0
local sec2 = 0
local secComCount = 0
local t = UPDATE_RATE_S
local blinkDirection = true
local blinkProgress = 0
function widget:Update(dt)
	if chobbyInterface then return end

    local prevMyTeamID = myTeamID
    if spec and spGetMyTeamID() ~= prevMyTeamID then  -- check if the team that we are spectating changed
        checkStatus()
    end

	local mx,my = spGetMouseState()

	if blinkDirection then
		blinkProgress = blinkProgress + (dt*9)
		if blinkProgress > 1 then
			blinkProgress = 1
			blinkDirection = false
		end
	else
		blinkProgress = blinkProgress - (dt/(blinkProgress*1.5))
		if blinkProgress < 0 then
			blinkProgress = 0
			blinkDirection = true
		end
	end

    now = os.clock()
	if now > nextGuishaderCheck and widgetHandler.orderList["GUI Shader"] ~= nil then
        nextGuishaderCheck = now+guishaderCheckUpdateRate
		if guishaderEnabled == false and widgetHandler.orderList["GUI Shader"] ~= 0 then
			guishaderEnabled = true
			init()
		elseif guishaderEnabled and (widgetHandler.orderList["GUI Shader"] == 0) then
			guishaderEnabled = false
		end
	end

	sec = sec + dt
	if sec > 0.033 then
		sec = 0
		r = {metal={spGetTeamResources(myTeamID,'metal')}, energy={spGetTeamResources(myTeamID,'energy')}}
		if not spec and not showQuitscreen then
			if isInBox(mx, my, resbarArea['energy']) then
				if resbarHover == nil then
					resbarHover = 'energy'
					updateResbar('energy')
				end
			elseif resbarHover ~= nil and resbarHover == 'energy' then
				resbarHover = nil
				updateResbar('energy')
			end
			if isInBox(mx, my, resbarArea['metal']) then
				if resbarHover == nil then
					resbarHover = 'metal'
					updateResbar('metal')
				end
			elseif resbarHover ~= nil and resbarHover == 'metal' then
				resbarHover = nil
				updateResbar('metal')
			end
		elseif spec and myTeamID ~= prevMyTeamID then  -- check if the team that we are spectating changed
			draggingShareIndicatorValue = {}
			draggingConversionIndicatorValue = nil
			if sec ~= 0 then
				r = {metal={spGetTeamResources(myTeamID,'metal')}, energy={spGetTeamResources(myTeamID,'energy')}}
			end
			updateResbar('metal')
			updateResbar('energy')
		end
	end

	sec2 = sec2 + dt
	if sec2 >= 1 then
		sec2 = 0
		updateResbarText('metal')
		updateResbarText('energy')
		updateAllyTeamOverflowing()
	end

	-- wind
	if (gameFrame ~= lastFrame) then
		currentWind = sformat('%.1f', select(4,spGetWind()))
	end


 	-- coms
	if displayComCounter then
        secComCount = secComCount + dt
        if secComCount>0.5 then
            secComCount = 0
            countComs()
        end
	end

	-- rejoin
	if not isReplay and serverFrame then
		t = t - dt
		if t <= 0 then
			t = t + UPDATE_RATE_S

			--Estimate Server Frame
			local speedFactor, _, isPaused = Spring.GetGameSpeed()
			if gameStarted and not isPaused then
				serverFrame = serverFrame + math.ceil(speedFactor * UPDATE_RATE_F)
			end

			local framesLeft = serverFrame - gameFrame
			if framesLeft > CATCH_UP_THRESHOLD then
				showRejoinUI = true
				updateRejoin()
			elseif showRejoinUI then
				showRejoinUI = false
				updateRejoin()
			end
		end
	end

	uiOpacitySec = uiOpacitySec + dt
	if uiOpacitySec > 0.5 then
		uiOpacitySec = 0
		if ui_opacity ~= 0.66 then
			ui_opacity = 0.66
			init()
		end
		if ui_scale ~= 1 then
			ui_scale = 1
			height = orgHeight * (1+(ui_scale-1)/1.7)
			shutdown()
			widget:ViewResize(vsx,vsy)
		end
	end
end

function drawResbarValues(res)
	local barHeight = resbarDrawinfo[res].barArea[4] - resbarDrawinfo[res].barArea[2]
	local barWidth = resbarDrawinfo[res].barArea[3] - resbarDrawinfo[res].barArea[1]
	local glowSize = (resbarDrawinfo[res].barArea[4] - resbarDrawinfo[res].barArea[2]) * 7

	local cappedCurRes = r[res][1]	-- limit so when production dies the value wont be much larger than what you can store
	if r[res][1] > r[res][2]*1.07 then
		cappedCurRes = r[res][2]*1.07
	end
	if res == 'energy' then
		glColor(1,1,0, 0.04)
		glTexture(glowTexture)
		local iconPadding = (resbarArea[res][4] - resbarArea[res][2])
		glTexRect(resbarArea[res][1]+iconPadding, resbarArea[res][2]+iconPadding, resbarArea[res][1]+(height*widgetScale)-iconPadding, resbarArea[res][4]-iconPadding)
		glTexture(false)
	end

	-- Bar value
	local valueWidth = ((cappedCurRes/r[res][2]) * barWidth)
	local color1,color2
	if res == 'metal' then
		color1 = {0.56,0.56,0.55,1}
		color2 = {1,1,1,1}
	else
		color1 = {0.7,0.66,0,1}
		color2 = {1,0.99,0.33,1}
	end
	RectRound(resbarDrawinfo[res].barTexRect[1], resbarDrawinfo[res].barTexRect[2], resbarDrawinfo[res].barTexRect[1]+valueWidth, resbarDrawinfo[res].barTexRect[4], barHeight*0.2, 1,1,1,1, color1,color2)

	-- Bar value glow
	glBlending(GL_SRC_ALPHA, GL_ONE)
	glColor(resbarDrawinfo[res].barColor[1], resbarDrawinfo[res].barColor[2], resbarDrawinfo[res].barColor[3], 0.09)
	glTexture(barGlowCenterTexture)
	glTexRect(
		resbarDrawinfo[res].barGlowMiddleTexRect[1],
		resbarDrawinfo[res].barGlowMiddleTexRect[2],
		resbarDrawinfo[res].barGlowMiddleTexRect[1] + valueWidth,
		resbarDrawinfo[res].barGlowMiddleTexRect[4]
	)
	glTexture(barGlowEdgeTexture)
	glTexRect(
		resbarDrawinfo[res].barGlowLeftTexRect[1],
		resbarDrawinfo[res].barGlowLeftTexRect[2],
		resbarDrawinfo[res].barGlowLeftTexRect[3],
		resbarDrawinfo[res].barGlowLeftTexRect[4]
	)
	glTexRect((resbarDrawinfo[res].barGlowMiddleTexRect[1]+valueWidth)+(glowSize*3), resbarDrawinfo[res].barGlowRightTexRect[2], resbarDrawinfo[res].barGlowMiddleTexRect[1]+valueWidth, resbarDrawinfo[res].barGlowRightTexRect[4])
	glTexture(false)
	glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

	currentResValue[res] = short(cappedCurRes)
	if not dlistResValues[res][currentResValue[res]] then
		dlistResValues[res][currentResValue[res]] = glCreateList( function()
			-- Text: current
            font2:Begin()
            font2:Print(currentResValue[res], resbarDrawinfo[res].textCurrent[2], resbarDrawinfo[res].textCurrent[3], resbarDrawinfo[res].textCurrent[4], resbarDrawinfo[res].textCurrent[5])
            font2:End()
        end)
	end
	glCallList(dlistResValues[res][currentResValue[res]])
end

function widget:RecvLuaMsg(msg, playerID)
	if msg:sub(1,18) == 'LobbyOverlayActive' then
		chobbyInterface = (msg:sub(1,19) == 'LobbyOverlayActive1')
	end
end

function updateAllyTeamOverflowing()
	allyteamOverflowingMetal = false
	allyteamOverflowingEnergy = false
	overflowingMetal = false
	overflowingEnergy = false
	local totalEnergy = 0
	local totalEnergyStorage = 0
	local totalMetal = 0
	local totalMetalStorage = 0
	local energyPercentile, metalPercentile
	for i, teamID in pairs(Spring.GetTeamList(Spring.GetMyAllyTeamID())) do
		local energy, energyStorage,_,_,_,energyShare, energySent = spGetTeamResources(teamID, "energy")
		totalEnergy = totalEnergy + energy
		totalEnergyStorage = totalEnergyStorage + energyStorage
		local metal, metalStorage,_,_,_,metalShare, metalSent = spGetTeamResources(teamID, "metal")
		totalMetal = totalMetal + metal
		totalMetalStorage = totalMetalStorage + metalStorage
		if teamID == myTeamID then
			energyPercentile = energySent / totalEnergyStorage
			metalPercentile = metalSent / totalMetalStorage
			if energyPercentile > 0.0001 then
				overflowingEnergy = energyPercentile * (1/0.025)
				if overflowingEnergy > 1 then overflowingEnergy = 1 end
			end
			if metalPercentile > 0.0001 then
				overflowingMetal = metalPercentile * (1/0.025)
				if overflowingMetal > 1 then overflowingMetal = 1 end
			end
		end
	end
	energyPercentile = totalEnergy / totalEnergyStorage
	metalPercentile = totalMetal / totalMetalStorage
	if energyPercentile > 0.975 then
		allyteamOverflowingEnergy = (energyPercentile - 0.975) * (1/0.025)
		if allyteamOverflowingEnergy > 1 then allyteamOverflowingEnergy = 1 end
	end
	if metalPercentile > 0.975 then
		allyteamOverflowingMetal = (metalPercentile - 0.975) * (1/0.025)
		if allyteamOverflowingMetal > 1 then allyteamOverflowingMetal = 1 end
	end
end

function widget:DrawScreen()
	if chobbyInterface then return end

	glPushMatrix()
	if dlistBackground then
		glCallList(dlistBackground)
	end

	local now = os.clock()
	local x,y,b = spGetMouseState()

	local res = 'metal'
	if dlistResbar[res][1] and dlistResbar[res][2] and dlistResbar[res][3] then
		glCallList(dlistResbar[res][1])

		if not spec and gameFrame > 90 then
			if allyteamOverflowingMetal then
				glColor(1,0,0,0.13*allyteamOverflowingMetal*blinkProgress)
			elseif overflowingMetal then
				glColor(1,1,1,0.05*overflowingMetal*(0.6+(blinkProgress*0.4)))
			end
			if allyteamOverflowingMetal or overflowingMetal then
				glCallList(dlistResbar[res][4])
			end
		end
		-- low energy background
		if r[res][1] < 1000 then
			process = (r[res][1]/r[res][2]) * 13
			if process < 1 then
				process = 1 - process
				glColor(0.9,0.4,1,0.08*process)
				glCallList(dlistResbar[res][5])
			end
		end
		drawResbarValues(res)
		glCallList(dlistResbar[res][6])
     	glCallList(dlistResbar[res][3])
		glCallList(dlistResbar[res][2])
	end
	res = 'energy'
	if dlistResbar[res][1] and dlistResbar[res][2] and dlistResbar[res][3] then
		glCallList(dlistResbar[res][1])

		if not spec and gameFrame > 90 then
			if allyteamOverflowingEnergy then
				glColor(1,0,0,0.13*allyteamOverflowingEnergy*blinkProgress)
			elseif overflowingEnergy then
				glColor(1,1,0,0.05*overflowingEnergy*(0.6+(blinkProgress*0.4)))
			end
			if allyteamOverflowingEnergy or overflowingEnergy then
				glCallList(dlistResbar[res][4])
			end
			-- low energy background
			if r[res][1] < 2000 then
				process = (r[res][1]/r[res][2]) * 13
				if process < 1 then
					process = 1 - process
					glColor(0.9,0.55,1,0.08*process)
					glCallList(dlistResbar[res][5])
				end
			end
		end
		drawResbarValues(res)
		glCallList(dlistResbar[res][6])
      	glCallList(dlistResbar[res][3])
		glCallList(dlistResbar[res][2])
	end

	if dlistWind1 then
		glPushMatrix()
		glCallList(dlistWind1)
		glRotate(windRotation, 0, 0, 1)
		glCallList(dlistWind2)
		glPopMatrix()
		-- current wind
		if gameFrame > 0 then
			local fontSize = (height/2.66)*widgetScale
			if not dlistWindText[currentWind] then
				dlistWindText[currentWind] = glCreateList( function()
                    font2:Begin()
                    font2:Print("\255\255\255\255"..currentWind, windArea[1]+((windArea[3]-windArea[1])/2), windArea[2]+((windArea[4]-windArea[2])/2.05)-(fontSize/5), fontSize, 'oc') -- Wind speed text
                    font2:End()
                end)
			end
			glCallList(dlistWindText[currentWind])
		else
			
		end
	end

	if displayComCounter and dlistComs1 then
		glCallList(dlistComs1)
		if allyComs == 1 and (gameFrame % 12 < 6) then
			glColor(1,0.6,0,0.6)
		else
			glColor(1,1,1,0.3)
		end
		glCallList(dlistComs2)
	end

	if dlistRejoin and showRejoinUI then
		glCallList(dlistRejoin)
	elseif dlistRejoin ~= nil then
		if dlistRejoin ~= nil then
			glDeleteList(dlistRejoin)
			dlistRejoin = nil
		end
		if WG['guishader'] then
			WG['guishader'].RemoveDlist('topbar_rejoin')
		end
		
	end

	if dlistButtons1 then
		glCallList(dlistButtons1)
		-- hovered?
		if not showQuitscreen and buttonsArea['buttons'] ~= nil and IsOnRect(x, y, buttonsArea[1], buttonsArea[2], buttonsArea[3], buttonsArea[4]) then
			buttonsAreaHovered = nil
			for button, pos in pairs(buttonsArea['buttons']) do
				if IsOnRect(x, y, pos[1], pos[2], pos[3], pos[4]) then
					glBlending(GL_SRC_ALPHA, GL_ONE)
					RectRound(buttonsArea['buttons'][button][1], buttonsArea['buttons'][button][2], buttonsArea['buttons'][button][3], buttonsArea['buttons'][button][4], 3.5*widgetScale, 0,0,1,1, {1,1,1,b and 0.15 or 0.055}, {0.44,0.44,0.44,b and 0.45 or 0.22})
					local mult = 1
					RectRound(buttonsArea['buttons'][button][1], buttonsArea['buttons'][button][4]-((buttonsArea['buttons'][button][4]-buttonsArea['buttons'][button][2])*0.5), buttonsArea['buttons'][button][3], buttonsArea['buttons'][button][4], 3.3*widgetScale, 0,0,0,0, {1,1,1,0.05*mult}, {1,1,1,0.18*mult})
					RectRound(buttonsArea['buttons'][button][1], buttonsArea['buttons'][button][2], buttonsArea['buttons'][button][3], buttonsArea['buttons'][button][2]+((buttonsArea['buttons'][button][4]-buttonsArea['buttons'][button][2])*0.35), 3.3*widgetScale, 0,0,2,2, {1,1,1,0.07*mult}, {1,1,1,0})
					glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
					break
				end
			end
		end
		glCallList(dlistButtons2)
	end

    if dlistQuit ~= nil then
        if WG['guishader'] then
            WG['guishader'].removeRenderDlist(dlistQuit)
        end
        glDeleteList(dlistQuit)
        dlistQuit = nil
    end
	if showQuitscreen ~= nil then
		local fadeoutBonus = 0
		local fadeTime = 0.2
		local fadeProgress = (now - showQuitscreen) / fadeTime
		if fadeProgress > 1 then fadeProgress = 1 end

		Spring.SetMouseCursor('cursornormal')

        dlistQuit = glCreateList( function()
			if WG['guishader'] then
            	glColor(0,0,0,(0.18*fadeProgress))
			else
				glColor(0,0,0,(0.35*fadeProgress))
			end
            glRect( 0, 0, vsx, vsy)

            if hideQuitWindow == nil then	-- when terminating spring, keep the faded screen

                local w = 335*widgetScale
                local h = w/3.5
                local padding = w/70
                local buttonPadding = w/90
                local buttonMargin = w/30
                local buttonHeight = h*0.55

                quitscreenArea = {(vsx/2)-(w/2), (vsy/1.8)-(h/2), (vsx/2)+(w/2), (vsy/1.8)+(h/2)}
                quitscreenResignArea = {(vsx/2)-(w/2)+buttonMargin, (vsy/1.8)-(h/2)+buttonMargin, (vsx/2)-(buttonMargin/2), (vsy/1.8)-(h/2)+buttonHeight-buttonMargin}
                quitscreenQuitArea = {(vsx/2)+(buttonMargin/2), (vsy/1.8)-(h/2)+buttonMargin, (vsx/2)+(w/2)-buttonMargin, (vsy/1.8)-(h/2)+buttonHeight-buttonMargin}

                -- window
                glColor(1,1,1,0.6+(0.34*fadeProgress))
                RectRound(quitscreenArea[1], quitscreenArea[2], quitscreenArea[3], quitscreenArea[4], 5.5*widgetScale)
                RectRound(quitscreenArea[1]+padding, quitscreenArea[2]+padding, quitscreenArea[3]-padding, quitscreenArea[4]-padding, padding*0.8, 1,1,1,1, {0.55,0.55,0.5,0.025+(0.025*fadeProgress)}, {0.2,0.2,0.2,0.025+(0.025*fadeProgress)})

                local fontSize = h/6
                font:Begin()
                font:SetTextColor(0,0,0,1)
                if not spec then
                    font:Print("Want to resign or quit to desktop?", quitscreenArea[1]+((quitscreenArea[3]-quitscreenArea[1])/2), quitscreenArea[4]-padding-padding-padding-fontSize, fontSize, "cn")
                else
                    font:Print("Really want to quit?", quitscreenArea[1]+((quitscreenArea[3]-quitscreenArea[1])/2), quitscreenArea[4]-padding-padding-padding-padding-fontSize, fontSize, "cn")
                end

                -- quit button
				local color1,color2
				local mult = 0.85
                if IsOnRect(x, y, quitscreenQuitArea[1], quitscreenQuitArea[2], quitscreenQuitArea[3], quitscreenQuitArea[4]) then
					color1 = {0.4,0,0,0.4+(0.5*fadeProgress)}
					color2 = {0.6,0.05,0.05,0.4+(0.5*fadeProgress)}
					mult = 1.4
                else
					color1 = {0.25,0,0,0.35+(0.5*fadeProgress)}
					color2 = {0.5,0,0,0.35+(0.5*fadeProgress)}
                end
				RectRound(quitscreenQuitArea[1], quitscreenQuitArea[2], quitscreenQuitArea[3], quitscreenQuitArea[4], 3.3*widgetScale, 1,1,1,1, color1,color2)

				glBlending(GL_SRC_ALPHA, GL_ONE)
				RectRound(quitscreenQuitArea[1], quitscreenQuitArea[4]-((quitscreenQuitArea[4]-quitscreenQuitArea[2])*0.5), quitscreenQuitArea[3], quitscreenQuitArea[4], 3.3*widgetScale, 2,2,0,0, {1,1,1,0.06*mult}, {1,1,1,0.2*mult})
				RectRound(quitscreenQuitArea[1], quitscreenQuitArea[2], quitscreenQuitArea[3], quitscreenQuitArea[2]+((quitscreenQuitArea[4]-quitscreenQuitArea[2])*0.35), 3.3*widgetScale, 0,0,2,2, {1,1,1,0.16*mult}, {1,1,1,0})
				glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

				font:End()

                fontSize = fontSize*0.92
				font2:Begin()
                font2:SetTextColor(1,1,1,1)
                font2:SetOutlineColor(0,0,0,0.23)
                font2:Print("Quit", quitscreenQuitArea[1]+((quitscreenQuitArea[3]-quitscreenQuitArea[1])/2), quitscreenQuitArea[2]+((quitscreenQuitArea[4]-quitscreenQuitArea[2])/2)-(fontSize/3), fontSize, "con")

                -- resign button
				mult = 0.85
                if not spec then
                    if IsOnRect(x, y, quitscreenResignArea[1], quitscreenResignArea[2], quitscreenResignArea[3], quitscreenResignArea[4]) then
						color1 = {0.28,0.28,0.28,0.4+(0.5*fadeProgress)}
						color2 = {0.45,0.45,0.45,0.4+(0.5*fadeProgress)}
						mult = 1.3
					else
						color1 = {0.18,0.18,0.18,0.4+(0.5*fadeProgress)}
						color2 = {0.33,0.33,0.33,0.4+(0.5*fadeProgress)}
					end
					RectRound(quitscreenResignArea[1], quitscreenResignArea[2], quitscreenResignArea[3], quitscreenResignArea[4], 3.3*widgetScale, 1,1,1,1, color1,color2)

					glBlending(GL_SRC_ALPHA, GL_ONE)
					RectRound(quitscreenResignArea[1], quitscreenResignArea[4]-((quitscreenResignArea[4]-quitscreenResignArea[2])*0.5), quitscreenResignArea[3], quitscreenResignArea[4], 3.3*widgetScale, 2,2,0,0, {1,1,1,0.06*mult}, {1,1,1,0.2*mult})
					RectRound(quitscreenResignArea[1], quitscreenResignArea[2], quitscreenResignArea[3], quitscreenResignArea[2]+((quitscreenResignArea[4]-quitscreenResignArea[2])*0.35), 3.3*widgetScale, 0,0,2,2, {1,1,1,0.16*mult}, {1,1,1,0})
					glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

					font2:Print("Resign", quitscreenResignArea[1]+((quitscreenResignArea[3]-quitscreenResignArea[1])/2), quitscreenResignArea[2]+((quitscreenResignArea[4]-quitscreenResignArea[2])/2)-(fontSize/3), fontSize, "con")
                end
                font2:End()
            end
        end)

        -- background
        if WG['guishader'] then
            WG['guishader'].setScreenBlur(true)
            WG['guishader'].insertRenderDlist(dlistQuit)
        else
            glCallList(dlistQuit)
        end
    end
	glColor(1,1,1,1)
	glPopMatrix()
end


function IsOnRect(x, y, BLcornerX, BLcornerY,TRcornerX,TRcornerY)
	return x >= BLcornerX and x <= TRcornerX and y >= BLcornerY and y <= TRcornerY
end


local function adjustSliders(x, y)
	if draggingShareIndicator ~= nil and not spec then
		local shareValue =	(x - resbarDrawinfo[draggingShareIndicator]['barArea'][1]) / (resbarDrawinfo[draggingShareIndicator]['barArea'][3] - resbarDrawinfo[draggingShareIndicator]['barArea'][1])
		if shareValue < 0 then shareValue = 0 end
		if shareValue > 1 then shareValue = 1 end
		Spring.SetShareLevel(draggingShareIndicator, shareValue)
        draggingShareIndicatorValue[draggingShareIndicator] = shareValue
		updateResbar(draggingShareIndicator)
	end
	if showConversionSlider and draggingConversionIndicator and not spec then
		local convValue = math.floor((x - resbarDrawinfo['energy']['barArea'][1]) / (resbarDrawinfo['energy']['barArea'][3] - resbarDrawinfo['energy']['barArea'][1]) * 100)
		if convValue < 12 then convValue = 12 end
		if convValue > 88 then convValue = 88 end
		Spring.SendLuaRulesMsg(sformat(string.char(137)..'%i', convValue))
        draggingConversionIndicatorValue = convValue
		updateResbar('energy')
	end
end

function widget:MouseMove(x, y)
	adjustSliders(x, y)
end


local function hideWindows()
	if (WG['options'] ~= nil) then
		WG['options'].toggle(false)
	end
	if (WG['scavengerinfo'] ~= nil) then
		WG['scavengerinfo'].toggle(false)
	end
	if (WG['changelog'] ~= nil) then
		WG['changelog'].toggle(false)
	end
	if (WG['keybinds'] ~= nil) then
		WG['keybinds'].toggle(false)
	end
	if (WG['commands'] ~= nil) then
		WG['commands'].toggle(false)
	end
	if (WG['gameinfo'] ~= nil) then
		WG['gameinfo'].toggle(false)
	end
    if (WG['teamstats'] ~= nil) then
        WG['teamstats'].toggle(false)
	end
	showQuitscreen = nil
	if WG['guishader'] then
		WG['guishader'].setScreenBlur(false)
	end
end

local function applyButtonAction(button)



	local isvisible = false
	if button == 'quit' then
		if chobbyLoaded then
			Spring.SendLuaMenuMsg("showLobby")
		else
			local oldShowQuitscreen
			if showQuitscreen ~= nil then
				oldShowQuitscreen = showQuitscreen
				isvisible = true
			end
			hideWindows()
			if oldShowQuitscreen ~= nil then
				if isvisible ~= true then
					showQuitscreen = oldShowQuitscreen
					if WG['guishader'] then
						WG['guishader'].setScreenBlur(true)
					end
				end
			else
				showQuitscreen = os.clock()
			end
		end
	elseif button == 'options' then
		if (WG['options'] ~= nil) then
			isvisible = WG['options'].isvisible()
		end
		hideWindows()
		if (WG['options'] ~= nil and isvisible ~= true) then
			WG['options'].toggle()
		end
	elseif button == 'changelog' then
		if (WG['changelog'] ~= nil) then
			isvisible = WG['changelog'].isvisible()
		end
		hideWindows()
		if (WG['changelog'] ~= nil and isvisible ~= true) then
			WG['changelog'].toggle()
		end
	elseif button == 'keybinds' then
		if (WG['keybinds'] ~= nil) then
			isvisible = WG['keybinds'].isvisible()
		end
		hideWindows()
		if (WG['keybinds'] ~= nil and isvisible ~= true) then
			WG['keybinds'].toggle()
		end
    elseif button == 'stats' then
		if (WG['teamstats'] ~= nil) then
			isvisible = WG['teamstats'].isvisible()
		end
        hideWindows()
        if (WG['teamstats'] ~= nil and isvisible ~= true) then
            WG['teamstats'].toggle()
        end
	end
end

function widget:MouseWheel(up,value) --up = true/false , value = -1/1
	if showQuitscreen ~= nil and quitscreenArea ~= nil then
		return true
	end
end

function widget:KeyPress(key)
	if key == 27 then	-- ESC
		if not WG['options'] or (WG['options'].disallowEsc and not WG['options'].disallowEsc()) then
			hideWindows()
		end
	end
	if showQuitscreen ~= nil and quitscreenArea ~= nil then
		return true
	end
end

function widget:MousePress(x, y, button)

	if button == 1 then
		if showQuitscreen ~= nil and quitscreenArea ~= nil then

			if IsOnRect(x, y, quitscreenArea[1], quitscreenArea[2], quitscreenArea[3], quitscreenArea[4]) then

				if IsOnRect(x, y, quitscreenQuitArea[1], quitscreenQuitArea[2], quitscreenQuitArea[3], quitscreenQuitArea[4]) then
					
					Spring.SendCommands("QuitForce")
					showQuitscreen = nil
					hideQuitWindow = os.clock()
					return true
				end
				if not spec and IsOnRect(x, y, quitscreenResignArea[1], quitscreenResignArea[2], quitscreenResignArea[3], quitscreenResignArea[4]) then
				
					Spring.SendCommands("spectator")
					showQuitscreen = nil
					if WG['guishader'] then
						WG['guishader'].setScreenBlur(false)
					end
					return true
				end
				return true
			else
				showQuitscreen = nil
				if WG['guishader'] then
					WG['guishader'].setScreenBlur(false)
				end
				return true
			end

			return true
		end


		if not spec then
			if IsOnRect(x, y, shareIndicatorArea['metal'][1], shareIndicatorArea['metal'][2], shareIndicatorArea['metal'][3], shareIndicatorArea['metal'][4]) then
				draggingShareIndicator = 'metal'
			end
			if IsOnRect(x, y, resbarDrawinfo['metal'].barArea[1], shareIndicatorArea['metal'][2], resbarDrawinfo['metal'].barArea[3], shareIndicatorArea['metal'][4]) then
				draggingShareIndicator = 'metal'
				adjustSliders(x, y)
			end
			if IsOnRect(x, y, shareIndicatorArea['energy'][1], shareIndicatorArea['energy'][2], shareIndicatorArea['energy'][3], shareIndicatorArea['energy'][4]) then
				draggingShareIndicator = 'energy'
			end
			if draggingShareIndicator == nil and showConversionSlider and IsOnRect(x, y, conversionIndicatorArea[1], conversionIndicatorArea[2], conversionIndicatorArea[3], conversionIndicatorArea[4]) then
				draggingConversionIndicator = true
			end
			if draggingConversionIndicator == nil and IsOnRect(x, y, resbarDrawinfo['energy'].barArea[1], shareIndicatorArea['energy'][2], resbarDrawinfo['energy'].barArea[3], shareIndicatorArea['energy'][4]) then
				draggingShareIndicator = 'energy'
				adjustSliders(x, y)
			end
			if draggingShareIndicator or draggingConversionIndicator then
			
				return true
			end
		end

		if buttonsArea['buttons'] ~= nil then
			for button, pos in pairs(buttonsArea['buttons']) do
				if IsOnRect(x, y, pos[1], pos[2], pos[3], pos[4]) then
					applyButtonAction(button)
					return true
				end
			end
		end
	else
		if showQuitscreen ~= nil and quitscreenArea ~= nil then
			return true
		end
	end
end

function widget:MouseRelease(x, y, button)
	if showQuitscreen ~= nil and quitscreenArea ~= nil then
		return true
	end
	if draggingShareIndicator ~= nil then
		adjustSliders(x, y)
        draggingShareIndicator = nil
	end
	if draggingConversionIndicator ~= nil then
		adjustSliders(x, y)
		draggingConversionIndicator = nil
	end

	--if button == 1 then
	--	if buttonsArea['buttons'] ~= nil then	-- reapply again because else the other widgets disable when there is a click outside of their window
	--		for button, pos in pairs(buttonsArea['buttons']) do
	--			if IsOnRect(x, y, pos[1], pos[2], pos[3], pos[4]) then
	--				applyButtonAction(button)
	--			end
	--		end
	--	end
	--end
end

function widget:PlayerChanged()
	spec = spGetSpectatingState()
	checkStatus()
	numTeamsInAllyTeam = #Spring.GetTeamList(myAllyTeamID)
	if displayComCounter then
		countComs(true)
	end
	if spec then
		resbarHover = nil
	end
end


function countComs(forceUpdate)
	-- recount my own ally team coms
	local prevAllyComs = allyComs
	local prevEnemyComs = enemyComs
	allyComs = 0
	local myAllyTeamList = Spring.GetTeamList(myAllyTeamID)
	for _,teamID in ipairs(myAllyTeamList) do
		allyComs = allyComs + Spring.GetTeamUnitDefCount(teamID, armcomDefID) + Spring.GetTeamUnitDefCount(teamID, corcomDefID)
	end

    local newEnemyComCount = Spring.GetTeamRulesParam(myTeamID, "enemyComCount")
    if type(newEnemyComCount) == 'number' then
        enemyComCount = newEnemyComCount
        if enemyComCount ~= prevEnemyComCount then
            comcountChanged = true
            prevEnemyComCount = enemyComCount
        end
    end

	if forceUpdate or allyComs ~= prevAllyComs or enemyComs ~= prevEnemyComs then
		comcountChanged = true
	end

	if comcountChanged then
		updateComs()
	end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	if not isCommander[unitDefID] then
		return
	end
	--record com created
	if select(6,Spring.GetTeamInfo(unitTeam,false)) == myAllyTeamID then
		allyComs = allyComs + 1
	elseif spec then
		enemyComs = enemyComs + 1
	end
	comcountChanged = true
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	if not isCommander[unitDefID] then
		return
	end
	--record com died
	if select(6,Spring.GetTeamInfo(unitTeam,false)) == myAllyTeamID then
		allyComs = allyComs - 1
	elseif spec then
		enemyComs = enemyComs - 1
	end
	comcountChanged = true
end


-- used for rejoin progress functionality
function widget:GameProgress (n) -- happens every 300 frames
	serverFrame = n
end

function widget:Initialize()
	gameFrame = Spring.GetGameFrame()
	Spring.SendCommands("resbar 0")

	-- determine if we want to show comcounter
    local allteams   = Spring.GetTeamList()
    local teamN = table.maxn(allteams) - 1               --remove gaia
	if teamN > 2 then
		displayComCounter = true
	end

	WG['topbar'] = {}
	WG['topbar'].showingRejoining = function()
		return showRejoinUI
	end
	WG['topbar'].showingQuit = function()
		return showQuitscreen
	end


	widget:ViewResize(vsx,vsy)

	if gameFrame > 0 then
		widget:GameStart()
	end
end

function shutdown()
	if dlistBackground ~= nil then
		dlistWindGuishader = glDeleteList(dlistWindGuishader)
		dlistWind1 = glDeleteList(dlistWind1)
		dlistWind2 = glDeleteList(dlistWind2)
		dlistComsGuishader = glDeleteList(dlistComsGuishader)
		dlistComs1 = glDeleteList(dlistComs1)
		dlistComs2 = glDeleteList(dlistComs2)
		dlistButtonsGuishader = glDeleteList(dlistButtonsGuishader)
		dlistButtons1 = glDeleteList(dlistButtons1)
		dlistButtons2 = glDeleteList(dlistButtons2)
		dlistRejoinGuishader = glDeleteList(dlistRejoinGuishader)
		dlistRejoin = glDeleteList(dlistRejoin)
		dlistQuit = glDeleteList(dlistQuit)

		for n,_ in pairs(dlistWindText) do
			dlistWindText[n] = glDeleteList(dlistWindText[n])
		end
		for n,_ in pairs(dlistResbar['metal']) do
			dlistResbar['metal'][n] = glDeleteList(dlistResbar['metal'][n])
		end
		for n,_ in pairs(dlistResbar['energy']) do
			dlistResbar['energy'][n] = glDeleteList(dlistResbar['energy'][n])
		end
		for n,_ in pairs(dlistResValues['metal']) do
			dlistResValues['metal'][n] = glDeleteList(dlistResValues['metal'][n])
		end
		for n,_ in pairs(dlistResValues['energy']) do
			dlistResValues['energy'][n] = glDeleteList(dlistResValues['energy'][n])
		end
	end
	--gl.DeleteFont(font)
	--gl.DeleteFont(font2)
	--font = nil
	--font2 = nil
	if WG['guishader'] then
		WG['guishader'].RemoveDlist('topbar_energy')
		WG['guishader'].RemoveDlist('topbar_metal')
		WG['guishader'].RemoveDlist('topbar_wind')
		WG['guishader'].RemoveDlist('topbar_coms')
		WG['guishader'].RemoveDlist('topbar_buttons')
		WG['guishader'].RemoveDlist('topbar_rejoin')
	end
	
end

function widget:Shutdown()
	shutdown()
	gl.DeleteFont(font)
	gl.DeleteFont(font2)
	font = nil
	font2 = nil
	WG['topbar'] = nil
	Spring.SendCommands("resbar 0")
end
