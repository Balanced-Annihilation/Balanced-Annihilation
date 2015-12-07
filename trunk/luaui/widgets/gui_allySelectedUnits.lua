include("colors.h.lua")
include("keysym.h.lua")
local versionNumber = "2.03"

function widget:GetInfo()
	return {
		name      = "Ally Selected Units ",
		desc      = "Shows units selected by teammates [v" .. string.format("%s", versionNumber ) .. "]",
		author    = "very_bad_soldier",
		date      = "August 1, 2008",
		license   = "GNU GPL v2",
		layer     = -10,
		enabled   = true
	}
end

--callin driven
--"hot" units

local floor                 = math.floor
local abs					= math.abs

local udefTab				= UnitDefs
local spGetUnitDefID        = Spring.GetUnitDefID
local spEcho                = Spring.Echo
local spGetUnitPosition     = Spring.GetUnitPosition
local spGetUnitBasePosition = Spring.GetUnitBasePosition
local spGetMyPlayerID       = Spring.GetMyPlayerID
local spGetPlayerInfo       = Spring.GetPlayerInfo
local spGetLocalTeamID		= Spring.GetLocalTeamID
local spGetUnitDefDimensions = Spring.GetUnitDefDimensions
local spSelectUnitMap		= Spring.SelectUnitMap
local spGetTeamColor 		= Spring.GetTeamColor
local spGetGroundHeight 	= Spring.GetGroundHeight
local spIsSphereInView  	= Spring.IsSphereInView
local spGetSpectatingState	= Spring.GetSpectatingState
local spGetGameSeconds		= Spring.GetGameSeconds
local spIsGUIHidden			= Spring.IsGUIHidden
local glDrawGroundCircle 	= gl.DrawGroundCircle
local glColor               = gl.Color
local glDepthTest           = gl.DepthTest
local glUnitShape			= gl.UnitShape
local glPopMatrix           = gl.PopMatrix
local glPushMatrix          = gl.PushMatrix
local glTranslate           = gl.Translate
local glText                = gl.Text
local glTexture             = gl.Texture
local glTexRect             = gl.TexRect
local glBillboard           = gl.Billboard
local glLineWidth 			= gl.LineWidth
local glBeginEnd			= gl.BeginEnd
local glScale				= gl.Scale
local glVertex              = gl.Vertex
local glCallList   			= gl.CallList

local GL_LINE_LOOP			= GL.LINE_LOOP

local spec = false

----------------------------------------------------------------

local scaleMultiplier			= 1.05
local maxAlpha					= 0.4
local hotFadeTime				= 0.25
local lockTeamUnits				= false --disallow selection of units selected by teammates
local showAlly					= true 		--also show allies (besides coop)
local useHotColor				= false --use RED for all hot units, if false use playerColor starting with transparency
local showAsSpectator			= true 
local circleDivsCoop			= 32  --nice circle
local circleDivsAlly			= 5  --aka pentagon
local selectPlayerUnits			= true

local hotColor = { 1.0, 0.0, 0.0, 1.0 }

local playerColorPool = {}
playerColorPool[1] = { 0.0, 1.0, 0.0 }
playerColorPool[2] = { 1.0, 1.0, 0.0 }
playerColorPool[3] = { 0.0, 0.0, 1.0 }
playerColorPool[4] = { 0.6, 0.0, 0.0 } --reserve full-red for hot units
playerColorPool[5] = { 0.0, 1.0, 1.0 }
playerColorPool[6] = { 1.0, 0.0, 1.0 }
playerColorPool[7] = { 1.0, 0.0, 0.0 }
playerColorPool[8] = { 1.0, 0.0, 0.0 }

local xRelPos, yRelPos		= 0.7, 0.6	-- (only used here for now)
local vsx, vsy				= gl.GetViewSizes()
local xPos, yPos            = xRelPos*vsx, yRelPos*vsy

local panelWidth = 200;
local panelHeight = 55;

local bgcorner = ":n:"..LUAUI_DIRNAME.."Images/bgcorner.png"
local sizeMultiplier = 1

--Internals------------------------------------------------------
local playerColors = {}
local nextPlayerPoolId = 1
local myTeamID = Spring.GetMyTeamID()
local myPlayerID = Spring.GetMyPlayerID()
local playerSelectedUnits = {}
local hotUnits = {}
local circleLinesCoop
local circleLinesAlly
local lockPlayerID

-- preferred to keep these values the same as other widgets
local rectangleFactor		= 3.3
local scalefaktor			= 2.9
local unitConf ={}
------------------------------------------------------------------



function SetUnitConf()
	for udid, unitDef in pairs(UnitDefs) do
		local xsize, zsize = unitDef.xsize, unitDef.zsize
		local scale = scalefaktor*( xsize^2 + zsize^2 )^0.5
		local shape, xscale, zscale
		
		if (unitDef.isBuilding or unitDef.isFactory or unitDef.speed==0) then
			shape = 'square'
			xscale, zscale = rectangleFactor * xsize, rectangleFactor * zsize
		elseif (unitDef.isAirUnit) then
			shape = 'triangle'
			xscale, zscale = scale, scale
		else
			shape = 'circle'
			xscale, zscale = scale, scale
		end
		unitConf[udid] = {shape=shape, xscale=xscale, zscale=zscale}
	end
end

function widget:Initialize()
	SetUnitConf()
	circleLinesCoop = calcCircleLines(circleDivsCoop)
	circleLinesAlly = calcCircleLines(circleDivsAlly) 

	setPlayerColours()

	widget:PlayerChanged(myPlayerID)

	widgetHandler:RegisterGlobal('selectedUnitsRemove', selectedUnitsRemove)
	widgetHandler:RegisterGlobal('selectedUnitsClear', selectedUnitsClear)
	widgetHandler:RegisterGlobal('selectedUnitsAdd', selectedUnitsAdd)
	spec = spGetSpectatingState()
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal('selectedUnitsRemove')
	widgetHandler:DeregisterGlobal('selectedUnitsClear')
	widgetHandler:DeregisterGlobal('selectedUnitsAdd')
	gl.DeleteList(circleLines)
	if (WG['guishader_api'] ~= nil) then
		WG['guishader_api'].RemoveRect('allyselectedunits')
	end
end

function widget:PlayerAdded(playerID)
	local playerTeam = select(4,spGetPlayerInfo(playerID))
	if not playerSelectedUnits[ playerID ] then
		playerSelectedUnits[ playerID ] = {
			["units"]={},
			["coop"]=(playerTeam == myTeamID),
			["todraw"] = DoDrawPlayer(playerID),
		}
	end
	--grab color from color pool for new teammate
	--no color yet
	getPlayerColour(playerID,playerTeam)
end

function getPlayerColour(playerID,teamID)
	if playerSelectedUnits[ playerID ]["coop"] and not spec then 
		if not playerColorPool[ nextPlayerPoolId ] then
			playerColors[ playerID ] = playerColorPool[ 1 ]  --we have only 8 colors, take color 1 as default
		else
			playerColors[ playerID ] = playerColorPool[ nextPlayerPoolId ]
		end
		nextPlayerPoolId = nextPlayerPoolId + 1
	else
		playerColors[ playerID ] = { spGetTeamColor( teamID ) }--he is only ally, use his color
	end
end

function setPlayerColours()
	playerColors = {}
	for _, playerID in pairs(Spring.GetPlayerList()) do
		widget:PlayerAdded(playerID)
	end
end

function widget:PlayerChanged(playerID)
	if not spec and spGetSpectatingState() then
		spec = true
		setPlayerColours()
		if not showAsSpectator then
			widgetHandler:RemoveWidget()
			return
		end
	end
	myTeamID = spGetLocalTeamID()
	local playerTeam = select(4,spGetPlayerInfo(playerID))
	local oldCoopStatus = playerSelectedUnits[ playerID ]["coop"]
	playerSelectedUnits[ playerID ]["coop"] = (teamID == myTeamID)
	playerSelectedUnits[ playerID ]["todraw"] = DoDrawPlayer(playerID)
	
	--grab color from color pool for new teammate
	if oldCoopStatus ~= playerSelectedUnits[ playerID ]["coop"] then
		getPlayerColour(playerID,playerTeam)
	end
end

function calcCircleLines(divs)
	local circleOffset = 0
	local lines = gl.CreateList(function()
		gl.BeginEnd(GL.LINE_LOOP, function()
			local radstep = (2.0 * math.pi) / divs
			for i = 1, divs do
				local a = (i * radstep)
				gl.Vertex(math.sin(a), circleOffset, math.cos(a))
			end
		end)
	end)
  
	return lines
end


function widget:CommandsChanged( id, params, options )
	if ( lockTeamUnits ) then
		deselectAllTeamSelected()
	end
end

function widget:UnitDestroyed(unitID, attacker )
	hotUnits[ unitID ] = nil
	
	for playerID, selUnits in pairs( playerSelectedUnits ) do
		selUnits["units"][ unitID ] = nil
	end
end

function newHotUnit( unitId, coop, playerID )
	if not playerSelectedUnits[playerID]["todraw"] then
		return
	end
	local udef = spGetUnitDefID( unitId )
	if ( udef ~= nil ) then
		local realDefRadius = unitConf[udef].xscale*1.5
		if ( realDefRadius ~= nil ) then
			local defRadius = realDefRadius * scaleMultiplier
			hotUnits[ unitId ] = { ts = os.clock(), coop = coop, defRadius = defRadius, playerID = playerID }
		end
	end
end 


function selectedUnitsClear(playerID)
	isSpec = select(3,spGetPlayerInfo(playerID))
	if not isSpec or (lockPlayerID ~= nil and playerID == lockPlayerID) then
		if not playerSelectedUnits[ playerID ] then
			widget:PlayerAdded(playerID)
		end
		--make all hot
		for unitId, defRadius in pairs(playerSelectedUnits[ playerID ]["units"]) do
			newHotUnit( unitId, playerSelectedUnits[ playerID ]["coop"], playerID )
		end
		--clear all
		playerSelectedUnits[ playerID ]["units"] = {}
	end
	if lockPlayerID ~= nil and playerID == lockPlayerID and selectPlayerUnits then
		selectPlayerSelectedUnits(lockPlayerID)
	end
end

function selectedUnitsAdd(playerID,unitID)
	isSpec = select(3,spGetPlayerInfo(playerID))
	if not isSpec or (lockPlayerID ~= nil and playerID == lockPlayerID) then
		if not playerSelectedUnits[ playerID ] then
			widget:PlayerAdded(playerID)
		end
		--add unit
		local udefID = spGetUnitDefID(unitID)
		if spGetUnitDefID(unitID) ~= nil then
			local realDefRadius = unitConf[udefID].xscale*1.5
			if realDefRadius then
				playerSelectedUnits[ playerID ]["units"][ unitID] = realDefRadius * scaleMultiplier
				--un-hot it
				hotUnits[  unitID ] = nil
			end
		end
	end
	if lockPlayerID ~= nil and playerID == lockPlayerID and selectPlayerUnits then
		selectPlayerSelectedUnits(lockPlayerID)
	end
end

function selectedUnitsRemove(playerID,unitID)
	isSpec = select(3,spGetPlayerInfo(playerID))
	if not isSpec or (lockPlayerID ~= nil and playerID == lockPlayerID) then
		if not playerSelectedUnits[ playerID ] then
			widget:PlayerAdded(playerID)
		end
		--remove unit
		playerSelectedUnits[ playerID ]["units"][unitID] = nil
		--make it hot
		newHotUnit( unitID, playerSelectedUnits[ playerID ]["coop"], playerID )
	end
	if lockPlayerID ~= nil and playerID == lockPlayerID and selectPlayerUnits then
		selectPlayerSelectedUnits(lockPlayerID)
	end
end

function DoDrawPlayer(playerID,teamID)	
	if playerID == myPlayerID then
		return false
	end
	if teamID ~= myTeamID and not showAlly then
		return false
	end
	return true
		 
end

function deselectAllTeamSelected()
	local selectedUnits = array2Table( spGetSelectedUnits() )
	for playerID, selUnits in pairs( playerSelectedUnits ) do
		for unitId, defRadius in pairs( selUnits["units"] ) do
			selectedUnits[unitId] = nil
		end
	end
	spSelectUnitMap( selectedUnits )
end

function array2Table( arr )
	tab = {}
	for i,v in ipairs(arr) do
		tab[v] = true
	end
	return tab
end

local updateTime = 0
local checkLockPlayerInterval = 1
function widget:Update(dt)
	if (WG['advplayerlist_api'] ~= nil) then
		updateTime = updateTime + dt
		if updateTime > checkLockPlayerInterval then
			lockPlayerID = WG['advplayerlist_api'].GetLockPlayerID()
			if lockPlayerID ~= nil and selectPlayerUnits then
				selectPlayerSelectedUnits(lockPlayerID)
			end
			updateTime = 0
		end
	end
end
  
function widget:ViewResize(viewSizeX, viewSizeY)
	vsx, vsy = viewSizeX, viewSizeY
	xPos, yPos            = xRelPos*vsx, yRelPos*vsy
	sizeMultiplier = 0.55 + (vsx*vsy / 8000000)
end

function selectPlayerSelectedUnits(playerID)
	local units = {}
	for pID, selUnits in pairs( playerSelectedUnits ) do
		if pID == playerID then
			for unitId, _ in pairs( selUnits["units"] ) do
				table.insert(units, unitId)
			end
		end
	end
	Spring.SelectUnitArray(units)
end

function widget:DrawScreen()
	if lockPlayerID ~= nil then
		glColor(0, 0, 0, 0.6)
		RectRound(xPos, yPos, xPos + (panelWidth*sizeMultiplier), yPos + (panelHeight*sizeMultiplier), 8*sizeMultiplier)
		glColor(1, 1, 1, 1)
		glText("Ally Selected Units", xPos + (10*sizeMultiplier), yPos + ((panelHeight - 19)*sizeMultiplier), 13*sizeMultiplier, "n")
		glColor(1, 1, 1, 0.2)
		drawCheckbox(xPos + (12*sizeMultiplier), yPos + (10*sizeMultiplier), selectPlayerUnits,  "Select tracked player units")
		if (WG['guishader_api'] ~= nil) then
			WG['guishader_api'].InsertRect(xPos, yPos, xPos + (panelWidth*sizeMultiplier), yPos + (panelHeight*sizeMultiplier), 'allyselectedunits')
		end
	else
		if (WG['guishader_api'] ~= nil) then
			WG['guishader_api'].RemoveRect('allyselectedunits')
		end
	end
end

local function DrawRectRound(px,py,sx,sy,cs)
	gl.TexCoord(0.8,0.8)
	gl.Vertex(px+cs, py, 0)
	gl.Vertex(sx-cs, py, 0)
	gl.Vertex(sx-cs, sy, 0)
	gl.Vertex(px+cs, sy, 0)
	
	gl.Vertex(px, py+cs, 0)
	gl.Vertex(px+cs, py+cs, 0)
	gl.Vertex(px+cs, sy-cs, 0)
	gl.Vertex(px, sy-cs, 0)
	
	gl.Vertex(sx, py+cs, 0)
	gl.Vertex(sx-cs, py+cs, 0)
	gl.Vertex(sx-cs, sy-cs, 0)
	gl.Vertex(sx, sy-cs, 0)
	
	local offset = 0.07		-- texture offset, because else gaps could show
	local o = offset
	-- top left
	--if py <= 0 or px <= 0 then o = 0.5 else o = offset end
	gl.TexCoord(o,o)
	gl.Vertex(px, py, 0)
	gl.TexCoord(o,1-o)
	gl.Vertex(px+cs, py, 0)
	gl.TexCoord(1-o,1-o)
	gl.Vertex(px+cs, py+cs, 0)
	gl.TexCoord(1-o,o)
	gl.Vertex(px, py+cs, 0)
	-- top right
	--if py <= 0 or sx >= vsx then o = 0.5 else o = offset end
	gl.TexCoord(o,o)
	gl.Vertex(sx, py, 0)
	gl.TexCoord(o,1-o)
	gl.Vertex(sx-cs, py, 0)
	gl.TexCoord(1-o,1-o)
	gl.Vertex(sx-cs, py+cs, 0)
	gl.TexCoord(1-o,o)
	gl.Vertex(sx, py+cs, 0)
	-- bottom left
	--if sy >= vsy or px <= 0 then o = 0.5 else o = offset end
	gl.TexCoord(o,o)
	gl.Vertex(px, sy, 0)
	gl.TexCoord(o,1-o)
	gl.Vertex(px+cs, sy, 0)
	gl.TexCoord(1-o,1-o)
	gl.Vertex(px+cs, sy-cs, 0)
	gl.TexCoord(1-o,o)
	gl.Vertex(px, sy-cs, 0)
	-- bottom right
	--if sy >= vsy or sx >= vsx then o = 0.5 else o = offset end
	gl.TexCoord(o,o)
	gl.Vertex(sx, sy, 0)
	gl.TexCoord(o,1-o)
	gl.Vertex(sx-cs, sy, 0)
	gl.TexCoord(1-o,1-o)
	gl.Vertex(sx-cs, sy-cs, 0)
	gl.TexCoord(1-o,o)
	gl.Vertex(sx, sy-cs, 0)
end


function RectRound(px,py,sx,sy,cs)
	local px,py,sx,sy,cs = math.floor(px),math.floor(py),math.ceil(sx),math.ceil(sy),math.floor(cs)
	
	gl.Texture(bgcorner)
	gl.BeginEnd(GL.QUADS, DrawRectRound, px,py,sx,sy,cs)
	gl.Texture(false)
end

function drawCheckbox(x, y, state, text)
    glPushMatrix()
    glTranslate(x, y, 0)
    glColor(1, 1, 1, 0.2)
    RectRound(0, 0, 16*sizeMultiplier, 16*sizeMultiplier, 3*sizeMultiplier)
    glColor(1, 1, 1, 1)
    if state then
        glTexture('LuaUI/Images/tick.png')
        glTexRect(0, 0, 16*sizeMultiplier, 16*sizeMultiplier)
        glTexture(false)
    end
    glText(text, 23*sizeMultiplier, 4*sizeMultiplier, 12*sizeMultiplier, "n")
    glPopMatrix()
end

function widget:DrawWorldPreUnit()
	if spIsGUIHidden() then return end
	gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)      -- disable layer blending
	DrawSelectedUnits()
	DrawHotUnits()
end

function DrawSelectedUnits()
	glColor(0.0, 1.0, 0.0, 1.0)
	glLineWidth(2)
	gl.PointSize(1)
	local now = spGetGameSeconds()
	for playerID, selUnits in pairs( playerSelectedUnits ) do
	
		if lockPlayerID == nil or lockPlayerID ~= playerID or (lockPlayerID == playerID and not selectPlayerUnits) then
			if selUnits["todraw"] then
				glColor( playerColors[ playerID ][1],  playerColors[ playerID ][2],  playerColors[ playerID ][3], maxAlpha)  
				for unitId, defRadius in pairs( selUnits["units"] ) do
					local x, y, z = spGetUnitBasePosition(unitId)
					local inView = false
					if ( z ~= nil ) then --checking z should be enough insteady of x,y,z
						inView = spIsSphereInView( x, y, z, defRadius )
					end
					if ( inView ) then
						local lines = circleLinesAlly
						if ( selUnits["coop"] == true and not spec) then
							lines = circleLinesCoop
						end

						glPushMatrix()
						glTranslate( x, y, z)
						glScale( defRadius, 1, defRadius)
						glCallList(lines)
						glPopMatrix()
					end
				end
			end
		end
	end
	
 	glColor(1, 1, 1, 1)
	glLineWidth(1)
end


function DrawHotUnits()
	glDepthTest(false)
	glLineWidth( 2 )

	local toDelete = {}
	 
	for unitID, val in pairs( hotUnits ) do
		if lockPlayerID == nil or val.playerID ~= lockPlayerID or (val.playerID == lockPlayerID and not selectPlayerUnits) then
			local x, y, z = spGetUnitBasePosition(unitID)
			local defRadius = val["defRadius"]
			local inView = false
			if ( z ~= nil ) then --checking z should be enough insteady of x,y,z
				inView = spIsSphereInView( x, y, z, defRadius )
			end
			if ( inView ) then
				local timeDiff = (os.clock() - val["ts"])
				
				if ( timeDiff <= hotFadeTime ) then
					if ( useHotColor ) then
						hotColor[4] = 1.0 - ( timeDiff / hotFadeTime )
						glColor( hotColor )
					else
						local cl = playerColors[ val["playerID"] ]
						cl[4] = maxAlpha - maxAlpha * ( timeDiff / hotFadeTime )
						glColor( cl )  
					end
				else
					toDelete[unitID] = true
				end
				
				if ( toDelete[unitID] == nil ) then
					local lines = circleLinesAlly
					if ( val["coop"] == true and not spec) then
						lines = circleLinesCoop
					end

					glPushMatrix()
					glTranslate(x,y,z)
					glScale( defRadius, 1, defRadius)
					glCallList(lines)
					glPopMatrix()
				end
			end
		end
	end
	
	for unitID, val in pairs( toDelete ) do
		hotUnits[unitID] = nil
	end
	
	glDepthTest(false)
 	glColor(1, 1, 1, 1)
	glLineWidth( 1 )
end


function widget:IsAbove(mx, my)
	return mx > xPos and my > yPos and mx < xPos + (panelWidth*sizeMultiplier) and my < yPos + (panelHeight*sizeMultiplier)
end

function widget:MousePress(mx, my, mb)
	if lockPlayerID ~= nil then
		if mb == 1 then
			if mx > xPos + (12*sizeMultiplier) and my > yPos + (10*sizeMultiplier) and mx < (xPos + ((panelWidth - 12)*sizeMultiplier)) and my < (yPos + ((10 + 16)*sizeMultiplier)) then
				selectPlayerUnits = not selectPlayerUnits
			end
			if lockPlayerID ~= nil and widget:IsAbove(mx,my) then
				return false
			end
		end
	end
end

function widget:TweakMousePress(mx, my, mb)
    if lockPlayerID ~= nil and  mb == 2 and widget:IsAbove(mx,my) then
        return true
    end
end 

function widget:TweakMouseMove(mx, my, dx, dy)
    if xPos + dx >= -1 and xPos + (panelWidth*sizeMultiplier) + dx - 1 <= vsx then
		xRelPos = xRelPos + dx/vsx
	end
    if yPos + dy >= -1 and yPos + (panelHeight*sizeMultiplier) + dy - 1<= vsy then 
		yRelPos = yRelPos + dy/vsy
	end
	xPos, yPos = xRelPos * vsx,yRelPos * vsy
end

function widget:GetConfigData()
    return {
        selectPlayerUnits = selectPlayerUnits,
        xRelPos = xRelPos, yRelPos = yRelPos
    }
end

function widget:SetConfigData(data)
	if data.selectPlayerUnits ~= nil then
		selectPlayerUnits = data.selectPlayerUnits
	end
	if data.xRelPos ~= nil then
		xRelPos = data.xRelPos or xRelPos
		yRelPos = data.yRelPos or yRelPos
		xPos = xRelPos * vsx
		yPos = yRelPos * vsy
	end
end
