function widget:GetInfo()
	return {
		name = "Idle Builders",
		desc = "Idle Indicator",
		author = "Floris (original by Ray)",
		date = "15 april 2015",
		license = "GNU GPL, v2 or later",
		layer = 0,
		enabled = false  --  loaded by default?
	}
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local vsx, vsy = Spring.GetViewGeometry()

local enabledAsSpec = false

local MAX_ICONS = 10
local iconsize = 37
local CONDENSE = false -- show one icon for all builders of same type
local POSITION_X = 0.5 -- horizontal centre of screen
local POSITION_Y = 0.095 -- near bottom
local NEAR_IDLE = 0 -- this means that factories with only X build items left will be shown as idle

local ui_opacity = 0.66
local ui_scale = 1

local ICON_SIZE_X = iconsize * (1 + (ui_scale - 1) / 1.5)
local ICON_SIZE_Y = ICON_SIZE_X

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local cornerSize = 7
local bgcornerSize = cornerSize



local hoversize = 0
local rot = 0

local X_MIN = 0
local X_MAX = 0
local Y_MIN = 0
local Y_MAX = 0
local drawTable = {}
local IdleList = {}
local activePress = false
local QCount = {}
local noOfIcons = 0
local displayList = {}

local spGetSpectatingState = Spring.GetSpectatingState
local enabled = true

local isBuilder = {}
local isFactory = {}
for unitDefID, unitDef in pairs(UnitDefs) do
	if unitDef.buildSpeed > 0 and unitDef.buildOptions[1] then
		isBuilder[unitDefID] = true
	end
	if unitDef.isFactory then
		isFactory[unitDefID] = true
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local glColor = gl.Color
local glShape = gl.Shape
local glDepthTest = gl.DepthTest
local glDepthMask = gl.DepthMask
local glCulling = gl.Culling
local glLighting = gl.Lighting
local glBlending = gl.Blending
local glMaterial = gl.Material
local glTranslate = gl.Translate
local glTexture = gl.Texture
local glScissor = gl.Scissor
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glUnitShape = gl.UnitShape
local glUnitShapeTextures = gl.UnitShapeTextures
local glClear = gl.Clear
local glText = gl.Text
local glUnit = gl.Unit
local glScale = gl.Scale
local glRotate = gl.Rotate
local glRect = gl.Rect
local glCallList = gl.CallList
local glCreateList = gl.CreateList
local glDeleteList = gl.DeleteList
local glBeginEnd = gl.BeginEnd
local glTexCoord = gl.TexCoord
local glVertex = gl.Vertex
local glLoadIdentity = gl.LoadIdentity
local glGetScreenViewTrans = gl.GetScreenViewTrans

local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local GL_LINE_LOOP = GL.LINE_LOOP
local GL_FRONT = GL.FRONT
local GL_SRC_ALPHA = GL.SRC_ALPHA
local GL_ONE = GL.ONE
local GL_QUADS = GL.QUADS
local GL_DEPTH_BUFFER_BIT = GL.DEPTH_BUFFER_BIT

local GetUnitDefID = Spring.GetUnitDefID
local GetFullBuildQueue = Spring.GetFullBuildQueue
local GetUnitHealth = Spring.GetUnitHealth
local GetCommandQueue = Spring.GetCommandQueue
local GetMyTeamID = Spring.GetMyTeamID
local GetTeamUnitsSorted = Spring.GetTeamUnitsSorted
local GetMouseState = Spring.GetMouseState
local GetUnitPosition = Spring.GetUnitPosition
local SendCommands = Spring.SendCommands
local SelectUnitArray = Spring.SelectUnitArray
local GetModKeyState = Spring.GetModKeyState
local GetUnitDefDimensions = Spring.GetUnitDefDimensions

local GetViewGeometry = Spring.GetViewGeometry
local ValidUnitID = Spring.ValidUnitID
local GetGameFrame = Spring.GetGameFrame
local GetCameraPosition = Spring.GetCameraPosition
local GetCameraDirection = Spring.GetCameraDirection
local SetCameraTarget = Spring.SetCameraTarget

local math_sin = math.sin
local math_pi = math.pi

local getn = table.getn

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local sizeMultiplier = 1
local function init()
	vsx, vsy = GetViewGeometry()
	sizeMultiplier = (((vsx + vsy) / 2000) * 1) * (1 + (ui_scale - 1) / 1.5)

	ICON_SIZE_X = iconsize * sizeMultiplier
	ICON_SIZE_Y = ICON_SIZE_X

	bgcornerSize = cornerSize * (sizeMultiplier - 1)
	noOfIcons = 0   -- this fixes positioning when resolution change
end

function widget:ViewResize()
	vsx, vsy = Spring.GetViewGeometry()
	font = WG['fonts'].getFont(nil, 1, 0.2, 1.3)
	init()
end

function widget:PlayerChanged(playerID)
	if enabledAsSpec == false and Spring.GetGameFrame() > 0 and Spring.GetSpectatingState() then
		widgetHandler:RemoveWidget(self)
	end
end

function widget:Initialize()
	widget:ViewResize()
	widget:PlayerChanged()
	enabled = true
	if not enabledAsSpec then
		enabled = not spGetSpectatingState()
	end
	init()
end

function widget:GameOver()
	widgetHandler:RemoveWidget(self)
end

local function IsIdleBuilder(unitID)
	local udef = GetUnitDefID(unitID)
	local qCount = 0
	if isBuilder[udef] then
		--- can build
		local bQueue = GetFullBuildQueue(unitID)
		if not bQueue[1] then
			--- has no build queue
			local _, _, _, _, buildProg = GetUnitHealth(unitID)
			if buildProg == 1 then
				--- isnt under construction
				if isFactory[udef] then
					return true
				else
					if GetCommandQueue(unitID, 0) == 0 then
						return true
					end
				end
			end
		elseif isFactory[udef] then
			for _, thing in ipairs(bQueue) do
				for _, count in pairs(thing) do
					qCount = qCount + count
				end
			end
			if qCount <= NEAR_IDLE then
				QCount[unitID] = qCount
				return true
			end
		end
	end
	return false
end

local function DrawBoxes(number)
	glColor({ 0, 0, 0, 0.7 })
	local X1 = X_MIN
	local ct = 0
	while (ct < number) do
		ct = ct + 1
		local X2 = X1 + ICON_SIZE_X

		if widgetHandler:InTweakMode() then
			glShape(GL_LINE_LOOP, {
				{ v = { X1, Y_MIN } },
				{ v = { X2, Y_MIN } },
				{ v = { X2, Y_MAX } },
				{ v = { X1, Y_MAX } },
			})
			X1 = X2
		else
			--DrawIconQuad((ct-1), { 0, 0, 0, 0.4 }, 1.2)
		end
	end
	--Spring.Echo(X2)
end--]]

local function CenterUnitDef(unitDefID)
	local ud = UnitDefs[unitDefID]
	if (not ud) then
		return
	end
	if (not ud.dimensions) then
		ud.dimensions = GetUnitDefDimensions(unitDefID)
	end
	if (not ud.dimensions) then
		return
	end

	local d = ud.dimensions
	local xSize = (d.maxx - d.minx)
	local ySize = (d.maxy - d.miny)
	local zSize = (d.maxz - d.minz)

	local hSize -- maximum horizontal dimension
	if (xSize > zSize) then
		hSize = xSize
	else
		hSize = zSize
	end

	-- aspect ratios
	local mAspect = hSize / ySize
	local vAspect = ICON_SIZE_X / ICON_SIZE_Y

	-- scale the unit to the box (maxspect)
	local scale
	if (mAspect > vAspect) then
		scale = (ICON_SIZE_X / hSize)
	else
		scale = (ICON_SIZE_Y / ySize)
	end
	scale = scale * 0.8
	glScale(scale, scale, scale)

	-- translate to the unit's midpoint
	local xMid = 0.5 * (d.maxx + d.minx)
	local yMid = 0.5 * (d.maxy + d.miny)
	local zMid = 0.5 * (d.maxz + d.minz)
	glTranslate(-xMid, -yMid, -zMid)
end

local function DrawUnitIcons(number)
	if not drawTable then
		return -1
	end
	local ct = 0
	local X1, X2

	local cpx, cpy, cpz = GetCameraPosition()
	local ctx, cty, ctz = glGetScreenViewTrans()

	-- magic to keep UnitShape fog under control
	SetCameraTarget(ctx, cty, ctz, -1.0)

	glTexture(false)
	glScissor(true)

	while (ct < number) do
		ct = ct + 1
		local unitID = drawTable[ct][2]

		if (type(unitID) == 'number' and ValidUnitID(unitID)) or type(unitID) == 'table' then

			X1 = X_MIN + (ICON_SIZE_X * (ct - 1))
			X2 = X1 + ICON_SIZE_X

			glPushMatrix()
			glLoadIdentity()
			glTranslate(ctx, cty, ctz)

			glScissor(X1, Y_MIN, X2 - X1, Y_MAX - Y_MIN)

			glTranslate(0.5 * (X2 + X1), 0.5 * (Y_MAX + Y_MIN), 0)
			glRotate(18, 1, 0, 0)
			glRotate(rot, 0, 1, 0)

			CenterUnitDef(drawTable[ct][1])

			--glUnitShapeTextures(drawTable[ct][1], true)
			glUnitShape(drawTable[ct][1], GetMyTeamID(), false, true, true)
			--glUnitShapeTextures(drawTable[ct][1], false)

			glScissor(false)
			glPopMatrix()

			if CONDENSE then
				local NumberCondensed = table.getn(drawTable[ct][2])
				if NumberCondensed > 1 then
					font:Begin()
					font:Print(NumberCondensed, X1, Y_MIN, 8 * sizeMultiplier, "o")
					font:End()
				end
			end

			if type(unitID) == 'table' then
				unitID = unitID[1]
			end
			if ValidUnitID(unitID) and QCount[unitID] then
				font:Begin()
				font:Print(QCount[unitID], X1 + (0.5 * ICON_SIZE_X), Y_MIN, 10 * sizeMultiplier, "ocn")
				font:End()
			end
		end
	end

	SetCameraTarget(cpx, cpy, cpz, -1.0)
end

local function MouseOverIcon(x, y)
	if not drawTable then
		return -1
	end

	local NumOfIcons = table.getn(drawTable)
	if (x < X_MIN) then
		return -1
	end
	if (x > X_MAX) then
		return -1
	end
	if (y < Y_MIN) then
		return -1
	end
	if (y > Y_MAX) then
		return -1
	end

	local icon = math.floor((x - X_MIN) / ICON_SIZE_X)
	if (icon < 0) then
		icon = 0
	end
	if (icon >= NumOfIcons) then
		icon = (NumOfIcons - 1)
	end
	return icon
end

local function DrawRectRound(px, py, sx, sy, cs, tl, tr, br, bl, c1, c2)
	local csyMult = 1 / ((sy - py) / cs)

	if c2 then
		gl.Color(c1[1], c1[2], c1[3], c1[4])
	end
	gl.Vertex(px + cs, py, 0)
	gl.Vertex(sx - cs, py, 0)
	if c2 then
		gl.Color(c2[1], c2[2], c2[3], c2[4])
	end
	gl.Vertex(sx - cs, sy, 0)
	gl.Vertex(px + cs, sy, 0)

	-- left side
	if c2 then
		gl.Color(c1[1] * (1 - csyMult) + (c2[1] * csyMult), c1[2] * (1 - csyMult) + (c2[2] * csyMult), c1[3] * (1 - csyMult) + (c2[3] * csyMult), c1[4] * (1 - csyMult) + (c2[4] * csyMult))
	end
	gl.Vertex(px, py + cs, 0)
	gl.Vertex(px + cs, py + cs, 0)
	if c2 then
		gl.Color(c2[1] * (1 - csyMult) + (c1[1] * csyMult), c2[2] * (1 - csyMult) + (c1[2] * csyMult), c2[3] * (1 - csyMult) + (c1[3] * csyMult), c2[4] * (1 - csyMult) + (c1[4] * csyMult))
	end
	gl.Vertex(px + cs, sy - cs, 0)
	gl.Vertex(px, sy - cs, 0)

	-- right side
	if c2 then
		gl.Color(c1[1] * (1 - csyMult) + (c2[1] * csyMult), c1[2] * (1 - csyMult) + (c2[2] * csyMult), c1[3] * (1 - csyMult) + (c2[3] * csyMult), c1[4] * (1 - csyMult) + (c2[4] * csyMult))
	end
	gl.Vertex(sx, py + cs, 0)
	gl.Vertex(sx - cs, py + cs, 0)
	if c2 then
		gl.Color(c2[1] * (1 - csyMult) + (c1[1] * csyMult), c2[2] * (1 - csyMult) + (c1[2] * csyMult), c2[3] * (1 - csyMult) + (c1[3] * csyMult), c2[4] * (1 - csyMult) + (c1[4] * csyMult))
	end
	gl.Vertex(sx - cs, sy - cs, 0)
	gl.Vertex(sx, sy - cs, 0)

	local offset = 0.15        -- texture offset, because else gaps could show

	-- bottom left
	if c2 then
		gl.Color(c1[1], c1[2], c1[3], c1[4])
	end
	if ((py <= 0 or px <= 0) or (bl ~= nil and bl == 0)) and bl ~= 2 then
		gl.Vertex(px, py, 0)
	else
		gl.Vertex(px + cs, py, 0)
	end
	gl.Vertex(px + cs, py, 0)
	if c2 then
		gl.Color(c1[1] * (1 - csyMult) + (c2[1] * csyMult), c1[2] * (1 - csyMult) + (c2[2] * csyMult), c1[3] * (1 - csyMult) + (c2[3] * csyMult), c1[4] * (1 - csyMult) + (c2[4] * csyMult))
	end
	gl.Vertex(px + cs, py + cs, 0)
	gl.Vertex(px, py + cs, 0)
	-- bottom right
	if c2 then
		gl.Color(c1[1], c1[2], c1[3], c1[4])
	end
	if ((py <= 0 or sx >= vsx) or (br ~= nil and br == 0)) and br ~= 2 then
		gl.Vertex(sx, py, 0)
	else
		gl.Vertex(sx - cs, py, 0)
	end
	gl.Vertex(sx - cs, py, 0)
	if c2 then
		gl.Color(c1[1] * (1 - csyMult) + (c2[1] * csyMult), c1[2] * (1 - csyMult) + (c2[2] * csyMult), c1[3] * (1 - csyMult) + (c2[3] * csyMult), c1[4] * (1 - csyMult) + (c2[4] * csyMult))
	end
	gl.Vertex(sx - cs, py + cs, 0)
	gl.Vertex(sx, py + cs, 0)
	-- top left
	if c2 then
		gl.Color(c2[1], c2[2], c2[3], c2[4])
	end
	if ((sy >= vsy or px <= 0) or (tl ~= nil and tl == 0)) and tl ~= 2 then
		gl.Vertex(px, sy, 0)
	else
		gl.Vertex(px + cs, sy, 0)
	end
	gl.Vertex(px + cs, sy, 0)
	if c2 then
		gl.Color(c2[1] * (1 - csyMult) + (c1[1] * csyMult), c2[2] * (1 - csyMult) + (c1[2] * csyMult), c2[3] * (1 - csyMult) + (c1[3] * csyMult), c2[4] * (1 - csyMult) + (c1[4] * csyMult))
	end
	gl.Vertex(px + cs, sy - cs, 0)
	gl.Vertex(px, sy - cs, 0)
	-- top right
	if c2 then
		gl.Color(c2[1], c2[2], c2[3], c2[4])
	end
	if ((sy >= vsy or sx >= vsx) or (tr ~= nil and tr == 0)) and tr ~= 2 then
		gl.Vertex(sx, sy, 0)
	else
		gl.Vertex(sx - cs, sy, 0)
	end
	gl.Vertex(sx - cs, sy, 0)
	if c2 then
		gl.Color(c2[1] * (1 - csyMult) + (c1[1] * csyMult), c2[2] * (1 - csyMult) + (c1[2] * csyMult), c2[3] * (1 - csyMult) + (c1[3] * csyMult), c2[4] * (1 - csyMult) + (c1[4] * csyMult))
	end
	gl.Vertex(sx - cs, sy - cs, 0)
	gl.Vertex(sx, sy - cs, 0)
end
function RectRound(px, py, sx, sy, cs, tl, tr, br, bl, c1, c2)
	-- (coordinates work differently than the RectRound func in other widgets)
	gl.Texture(false)
	gl.BeginEnd(GL.QUADS, DrawRectRound, px, py, sx, sy, cs, tl, tr, br, bl, c1, c2)
end

function DrawIconQuad(iconPos, color, size)
	local X1 = X_MIN + (ICON_SIZE_X * iconPos)
	local X2 = X1 + (ICON_SIZE_X)
	local corneradjust = (bgcornerSize / (3 + (math.abs(hoversize)))) * size

	glColor(color)
	RectRound(X1 - corneradjust, Y_MIN - corneradjust, X2 + corneradjust, Y_MAX + corneradjust, bgcornerSize)

	if WG['guishader'] then
		WG['guishader'].InsertDlist(glCreateList(function()
			RectRound(X1 - corneradjust, Y_MIN - corneradjust, X2 + corneradjust, Y_MAX + corneradjust, bgcornerSize)
		end), 'idlebuilders')
	end

end--]]


------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
local Clicks = {}
local mouseOnUnitID = nil

function widget:GetConfigData(data)
	return {
		position_x = POSITION_X,
		position_y = POSITION_Y,
		max_icons = MAX_ICONS
	}
end

function widget:SetConfigData(data)
	POSITION_X = data.position_x or POSITION_X
	POSITION_Y = data.position_y or POSITION_Y
	MAX_ICONS = data.max_icons or MAX_ICONS
end

local sec = 0
local doUpdate = true
local uiOpacitySec = 0.5
function widget:Update(dt)

	if chobbyInterface then
		return
	end

	if not enabled then
		return
	end

	uiOpacitySec = uiOpacitySec + dt
	if uiOpacitySec > 0.5 then
		uiOpacitySec = 0
		if ui_scale ~= Spring.GetConfigFloat("ui_scale", 1) then
			ui_scale = Spring.GetConfigFloat("ui_scale", 1)
			widget:ViewResize(Spring.GetViewGeometry())
		end
		uiOpacitySec = 0
		if ui_opacity ~= Spring.GetConfigFloat("ui_opacity", 0.66) then
			ui_opacity = Spring.GetConfigFloat("ui_opacity", 0.66)
		end
	end

	local iconNum = MouseOverIcon(GetMouseState())
	if iconNum < 0 then
		mouseOnUnitID = nil
	else
		local unitID = drawTable[iconNum + 1][2]
		local unitDefID = drawTable[iconNum + 1][1]
		if not Clicks[unitDefID] then
			Clicks[unitDefID] = 1
		end
		if type(unitID) == 'table' then
			unitID = unitID[(Clicks[unitDefID] + 1) % getn(unitID) + 1]
		end
		mouseOnUnitID = unitID
	end

	sec = sec + dt
	hoversize = math_sin(math_pi * (sec))
	rot = 30 * math_sin(math_pi * (sec / 2.5))

	if GetGameFrame() % 31 == 0 or doUpdate then
		doUpdate = false
		IdleList = {}
		QCount = {}
		local myUnits = GetTeamUnitsSorted(GetMyTeamID())
		local unitCount = 0
		for unitDefID, unitTable in pairs(myUnits) do
			if type(unitTable) == 'table' then
				for count, unitID in pairs(unitTable) do
					if count ~= 'n' and IsIdleBuilder(unitID) then
						unitCount = unitCount + 1
						if IdleList[unitDefID] then
							IdleList[unitDefID][#IdleList[unitDefID] + 1] = unitID
						else
							IdleList[unitDefID] = { unitID }
						end
					end
				end
			end
		end

		if unitCount >= MAX_ICONS then
			CONDENSE = true
		else
			CONDENSE = false
		end

		oldNoOfIcons = noOfIcons
		noOfIcons = 0
		drawTable = {}
		local drawTableCount = 0
		for unitDefID, units in pairs(IdleList) do
			if CONDENSE then
				drawTableCount = drawTableCount + 1
				drawTable[drawTableCount] = { unitDefID, units }
				noOfIcons = noOfIcons + 1
			else
				for _, unitID in pairs(units) do
					drawTableCount = drawTableCount + 1
					drawTable[drawTableCount] = { unitDefID, unitID }
				end
				noOfIcons = noOfIcons + table.getn(units)
			end
		end
		if noOfIcons > MAX_ICONS then
			noOfIcons = MAX_ICONS
		end
		if noOfIcons ~= oldNoOfIcons then
			calcSizes(noOfIcons)
		end
	end
end

function calcSizes(numIcons)
	X_MIN = POSITION_X * vsx - 0.5 * numIcons * ICON_SIZE_X
	X_MAX = POSITION_X * vsx + 0.5 * numIcons * ICON_SIZE_X
	Y_MIN = POSITION_Y * vsy - 0.5 * ICON_SIZE_Y
	Y_MAX = POSITION_Y * vsy + 0.5 * ICON_SIZE_Y
end

function widget:RecvLuaMsg(msg, playerID)
	if msg:sub(1, 18) == 'LobbyOverlayActive' then
		chobbyInterface = (msg:sub(1, 19) == 'LobbyOverlayActive1')
	end
end

function widget:DrawScreen()
	if chobbyInterface then
		return
	end

	if widgetHandler:InTweakMode() then
		calcSizes(MAX_ICONS)
		DrawBoxes(MAX_ICONS)
		calcSizes(noOfIcons)
		local line1 = "Idle cons tweak mode"
		local line2 = "Click and drag here to move icons around, hover over icons and move mouse wheel to change max number of icons"
		font:Begin()
		font:Print(line1, POSITION_X * vsx, POSITION_Y * vsy, 15, "c")
		font:Print(line2, POSITION_X * vsx, (POSITION_Y * vsy) - 10, 10, "c")
		font:End()
		return
	end

	if WG['guishader'] then
		WG['guishader'].DeleteDlist('idlebuilders')
	end

	if enabled and noOfIcons > 0 then
		local x, y, lb, mb, rb = GetMouseState()

		if not WG['topbar'] or not WG['topbar'].showingQuit() then
			local icon = MouseOverIcon(x, y)
			if (icon >= 0) then

				if (lb or mb or rb) then
					DrawIconQuad(icon, { 0.5, 0.2, 0, 0.5 }, 1.1)
				else
					DrawIconQuad(icon, { 0, 0, 0.1, 0.4 }, 1.1)
				end
			end
		end
		glClear(GL_DEPTH_BUFFER_BIT)
		DrawUnitIcons(noOfIcons)
	end
end

function widget:TweakMouseMove(x, y, dx, dy, button)
	local right = (x + (0.5 * MAX_ICONS * ICON_SIZE_X)) / vsx
	local left = (x - (0.5 * MAX_ICONS * ICON_SIZE_X)) / vsx
	local top = (y + (0.5 * ICON_SIZE_Y)) / vsy
	local bottom = (y - (0.5 * ICON_SIZE_Y)) / vsy
	if right > 1 then
		right = 1
		left = 1 - (MAX_ICONS * ICON_SIZE_X) / vsx
	end
	if left < 0 then
		left = 0
		right = (MAX_ICONS * ICON_SIZE_X) / vsx
	end
	if top > 1 then
		top = 1
		bottom = 1 - ICON_SIZE_Y / vsy
	end
	if bottom < 0 then
		bottom = 0
		top = ICON_SIZE_Y / vsy
	end

	POSITION_X = 0.5 * (right + left)
	POSITION_Y = 0.5 * (top + bottom)
end

function widget:TweakMousePress(x, y, button)
	local iconNum = MouseOverIcon(x, y)
	if iconNum >= 0 then
		return true
	end
end

function widget:MouseWheel(up, value)
	if not widgetHandler:InTweakMode() then
		return false
	end

	local x, y, _, _, _ = GetMouseState()
	local iconNum = MouseOverIcon(x, y)
	if iconNum < 0 then
		return false
	end

	if up then
		MAX_ICONS = MAX_ICONS + 1
	else
		MAX_ICONS = MAX_ICONS - 1
		if MAX_ICONS < 1 then
			MAX_ICONS = 1
		end
	end
	return true
end

function widget:DrawInMiniMap(sx, sz)
	if not mouseOnUnitID then
		return -1
	end

	local ux, uy, uz = GetUnitPosition(mouseOnUnitID)
	if (not ux or not uy or not uz) then
		return
	end
	local xr = ux / (Game.mapSizeX)
	local yr = 1 - uz / (Game.mapSizeZ)
	glColor(1, 0, 0)
	glRect(xr * sx, yr * sz, (xr * sx) + 5, (yr * sz) + 5)
end

function widget:MousePress(x, y, button)
	local icon = MouseOverIcon(x, y)
	activePress = (icon >= 0)
	return activePress
end

function widget:MouseRelease(x, y, button)
	if not activePress then
		return -1
	end
	activePress = false

	local iconNum = MouseOverIcon(x, y)
	if iconNum < 0 then
		return -1
	end

	local unitID = drawTable[iconNum + 1][2]
	local unitDefID = drawTable[iconNum + 1][1]

	if type(unitID) == 'table' then
		if Clicks[unitDefID] then
			Clicks[unitDefID] = Clicks[unitDefID] + 1
		else
			Clicks[unitDefID] = 1
		end
		unitID = unitID[(Clicks[unitDefID]) % getn(unitID) + 1]
	end

	local alt, ctrl, meta, shift = GetModKeyState()

	if (button == 1) then
		-- left mouse
		SelectUnitArray({ unitID })
	
	elseif (button == 2) then
		-- middle mouse
		SelectUnitArray({ unitID })
		SendCommands( "viewselection" )
	
	end

	return -1
end

function widget:DrawWorld()
	if chobbyInterface then
		return
	end
	if mouseOnUnitID and (not WG['topbar'] or not WG['topbar'].showingQuit()) then
		if widgetHandler:InTweakMode() then
			return -1
		end
		glColor(1, 1, 1, 0.22)
		glUnit(mouseOnUnitID, true)
	end
end

function widget:Shutdown()
	if WG['guishader'] then
		WG['guishader'].DeleteDlist('idlebuilders')
	end
end
