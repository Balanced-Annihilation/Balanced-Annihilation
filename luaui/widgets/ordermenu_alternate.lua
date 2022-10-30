function widget:GetInfo()
	return {
		name = "Order menu alternate",
		desc = "",
		author = "Floris",
		date = "April 2020",
		license = "GNU GPL, v2 or later",
		layer = 1,
		enabled = true
	}
end



local cellZoom = 1
local cellClickedZoom = 1.05
local cellHoverZoom = 1.035

local showIcons = false
local colorize = 0
local playSounds = false
local stickToBottom = false
local alwaysShow = false

local posX = 0
local posY = 0.8
local width = 0
local height = 0
local cellMarginOriginal = 0.015
local cellMargin = cellMarginOriginal
local commandInfo = {
	move			= { red = 0.64,	green = 1,		blue = 0.64 },
	stop			= { red = 1,	green = 0.3,	blue = 0.3 },
	attack			= { red = 1,	green = 0.5,	blue = 0.35 },
	areaattack		= { red = 1,	green = 0.35,	blue = 0.15 },
	manualfire		= { red = 1,	green = 0.7,	blue = 0.7 },
	patrol			= { red = 0.73,	green = 0.73,	blue = 1 },
	fight			= { red = 0.9,	green = 0.5,	blue = 1 },
	resurrect		= { red = 1,	green = 0.75,	blue = 1, },
	guard			= { red = 0.33,	green = 0.92,	blue = 1 },
	wait			= { red = 0.7,	green = 0.66,	blue = 0.6 },
	repair			= { red = 1,	green = 0.95,	blue = 0.7 },
	reclaim			= { red = 0.86,	green = 1,		blue = 0.86 },
	restore			= { red = 0.77,	green = 1,		blue = 0.77 },
	capture			= { red = 1,	green = 0.85,	blue = 0.22 },
	settarget		= { red = 1,	green = 0.66,	blue = 0.35 },
	canceltarget	= { red = 0.8,	green = 0.55,	blue = 0.2 },
	areamex			= { red = 0.93,	green = 0.93,	blue = 0.93 },
	upgrademex		= { red = 0.93,	green = 0.93,	blue = 0.93 },
	loadunits		= { red = 0.1,	green = 0.7,	blue = 1 },
	unloadunits		= { red = 0,	green = 0.5,	blue = 1 },
	landatairbase	= { red = 0.4,	green = 0.7,	blue = 0.4 },
	wantcloak		= { red = nil,	green = nil,	blue = nil },
	onoff			= { red = nil,	green = nil,	blue = nil },
}
local isStateCommand = {}

local disabledCommand = {}

local viewSizeX, viewSizeY = Spring.GetViewGeometry()

local fontfile ="LuaUI/Fonts/FreeSansBold.otf"

local barGlowCenterTexture = ":l:LuaUI/Images/barglow-center.png"
local barGlowEdgeTexture   = ":l:LuaUI/Images/barglow-edge.png"


local uiOpacity = tonumber(Spring.GetConfigFloat("ui_opacity", 0.66) or 0.66)
local uiScale = tonumber(Spring.GetConfigFloat("ui_scale", 1) or 1)

local backgroundRect = {}
local activeRect = {}
local cellRects = {}
local cellMarginPx = 0
local cellMarginPx2 = 0
local commands = {}
local rows = 0
local cols = 0
local disableInput = false
local math_isInRect = math.isInRect

local font, backgroundPadding, widgetSpaceMargin, chobbyInterface, displayListOrders, displayListGuiShader
local clickedCell, clickedCellTime, clickedCellDesiredState, cellWidth, cellHeight
local buildmenuBottomPosition = false
local activeCommand, previousActiveCommand, doUpdate, doUpdateClock

local hiddenCommands = {
	[CMD.LOAD_ONTO] = true,
	[CMD.SELFD] = true,
	[CMD.GATHERWAIT] = true,
	[CMD.SQUADWAIT] = true,
	[CMD.DEATHWAIT] = true,
	[CMD.TIMEWAIT] = true,
	[39812] = true, -- raw move
	[34922] = true, -- set unit target
}

local hiddenCommandTypes = {
	[CMDTYPE.CUSTOM] = true,
	[CMDTYPE.PREV] = true,
	[CMDTYPE.NEXT] = true,
}

local spGetActiveCommand = Spring.GetActiveCommand
local spGetActiveCmdDescs = Spring.GetActiveCmdDescs

local os_clock = os.clock

local glTexture = gl.Texture
local glTexRect = gl.TexRect
local glColor = gl.Color
local glRect = gl.Rect
local glBlending = gl.Blending
local GL_SRC_ALPHA = GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local GL_ONE = GL.ONE

local math_min = math.min
local math_max = math.max
local math_ceil = math.ceil
local math_floor = math.floor

local RectRound, UiElement, UiButton, elementCorner

local isSpectating = Spring.GetSpectatingState()
local cursorTextures = {}


local function convertColor(r, g, b)
	return string.char(255, (r * 255), (g * 255), (b * 255))
end

local function checkGuiShader(force)
	if WG['guishader'] then
		if force and displayListGuiShader then
			displayListGuiShader = gl.DeleteList(displayListGuiShader)
		end
		if not displayListGuiShader then
			displayListGuiShader = gl.CreateList(function()
				RectRound(backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4], elementCorner * uiScale, ((posX <= 0) and 0 or 1), 1, ((posY-height > 0 or posX <= 0) and 1 or 0), ((posY-height > 0 and posX > 0) and 1 or 0))
			end)
		end
	elseif displayListGuiShader then
		displayListGuiShader = gl.DeleteList(displayListGuiShader)
	end
end

function widget:PlayerChanged(playerID)
	isSpectating = Spring.GetSpectatingState()
end

local function setupCellGrid(force)
  local oldColls = cols
  local oldRows = rows
  local cmdCount = #commands
  local addColl = uiScale < 0.85 and -1 or 0
  local addRow = uiScale < 0.85 and 0 or 0
  if cmdCount <= (5+addColl) * (4+addRow) then
    cols = 5 + addColl
    rows = 4 + addRow
  elseif cmdCount <= (5+addColl) * (4+addRow) then
    cols = 5 + addColl
    rows = 4 + addRow
  elseif cmdCount <= (5+addColl) * (5+addRow) then
    cols = 5 + addColl
    rows = 5 + addRow
  elseif cmdCount <= (5+addColl) * (6+addRow) then
    cols = 5 + addColl
    rows = 6 + addRow
  elseif cmdCount <= (5+addColl) * (6+addRow) then
    cols = 5 + addColl
    rows = 6 + addRow
  elseif cmdCount <= (5+addColl) * (7+addRow) then
    cols = 5 + addColl
    rows = 7 + addRow
  else
    cols = 5 + addColl
    rows = 7 + addRow
  end

	local sizeDivider = ((cols + rows) / 16)
	cellMargin = (cellMarginOriginal / sizeDivider) * uiScale

	if force or oldCols ~= cols or oldRows ~= rows then
		clickedCell = nil
		clickedCellTime = nil
		clickedCellDesiredState = nil
		cellRects = {}
		local i = 0
		cellWidth = math_floor((activeRect[3] - activeRect[1]) / cols)
		cellHeight = math_floor((activeRect[4] - activeRect[2]) / rows)
		local leftOverWidth = ((activeRect[3] - activeRect[1]) - (cellWidth * cols))-1
		local leftOverHeight = ((activeRect[4] - activeRect[2]) - (cellHeight * rows)) -(posY-height <= 0 and 1 or 0)
		cellMarginPx = math_max(1, math_ceil(cellHeight * 0.5 * cellMargin))
		cellMarginPx2 = math_max(0, math_ceil(cellHeight * 0.18 * cellMargin))

		local addedWidth = 0
		local addedHeight = 0
		local addedWidthFloat = 0
		local addedHeightFloat = 0
		local prevAddedWidth = 0
		local prevAddedHeight = 0
		for row = 1, rows do
			prevAddedHeight = addedHeight
			addedHeightFloat = addedHeightFloat + (leftOverHeight / rows)
			addedHeight = math_floor(addedHeightFloat)
			prevAddedWidth = 0
			addedWidthFloat = 0
			for col = 1, cols do
				addedWidthFloat = addedWidthFloat + (leftOverWidth / cols)
				addedWidth = math_floor(addedWidthFloat)
				i = i + 1
				cellRects[i] = {
					math_floor(activeRect[1] + prevAddedWidth + (cellWidth * (col - 1)) + 0.5),
					math_floor(activeRect[4] - addedHeight - (cellHeight * row) + 0.5),
					math_ceil(activeRect[1] + addedWidth + (cellWidth * col) + 0.5),
					math_ceil(activeRect[4] - prevAddedHeight - (cellHeight * (row - 1)) + 0.5)
				}
				prevAddedWidth = addedWidth
			end
		end
	end
end

local function refreshCommands()
	local stateCommands = {}
	local otherCommands = {}
	local stateCommandsCount = 0
	local otherCommandsCount = 0
	for index, command in pairs(spGetActiveCmdDescs()) do
		if type(command) == "table" and not disabledCommand[command.name] then
			if command.type == CMDTYPE.ICON_MODE then
				isStateCommand[command.id] = true
			end
			if not hiddenCommands[command.id] and not hiddenCommandTypes[command.type] and command.action ~= nil and not command.disabled then
				if command.type == CMDTYPE.ICON_BUILDING or (string.sub(command.action, 1, 10) == 'buildunit_') then
					-- intentionally empty, no action to take
				elseif isStateCommand[command.id] then
					stateCommandsCount = stateCommandsCount + 1
					stateCommands[stateCommandsCount] = command
				else
					otherCommandsCount = otherCommandsCount + 1
					otherCommands[otherCommandsCount] = command
				end
			end
		end
	end
	commands = {}
	for i = 1, stateCommandsCount do
		commands[i] = stateCommands[i]
	end
	for i = 1, otherCommandsCount do
		commands[i + stateCommandsCount] = otherCommands[i]
	end

	setupCellGrid(false)
end

function widget:ViewResize()
	viewSizeX, viewSizeY = Spring.GetViewGeometry()

  width = 0.184
  height = 0.18

	width = width / (viewSizeX / viewSizeY) * 1.78        -- make smaller for ultrawide screens
	width = width * uiScale

	-- make pixel aligned
	width = math.floor(width * viewSizeX) / viewSizeX
	height = math.floor(height * viewSizeY) / viewSizeY


	font = WG['fonts'].getFont(fontFile)

	--[[local fontfileOutlineSize = 7
	local fontfileOutlineStrength = 1.1
	local fontfileSize = 40
	local vsx,vsy = Spring.GetViewGeometry()
	  local newFontfileScale = (0.5 + (vsx*vsy / 5700000))
	  if fontfileScale ~= newFontfileScale then
		fontfileScale = newFontfileScale
		gl.DeleteFont(font)
		font = gl.LoadFont(fontfile, fontfileSize*fontfileScale, fontfileOutlineSize*fontfileScale, fontfileOutlineStrength)
		loadedFontSize = fontfileSize*fontfileScale
	  end]]--
	
	elementCorner = WG.FlowUI.elementCorner
	backgroundPadding = WG.FlowUI.elementPadding

	RectRound = WG.FlowUI.Draw.RectRound
	UiElement = WG.FlowUI.Draw.Element
	UiButton = WG.FlowUI.Draw.Button
	elementCorner = WG.FlowUI.elementCorner

	widgetSpaceMargin = WG.FlowUI.elementMargin

	if WG['minimap'] then
		minimapHeight = WG['minimap'].getHeight()
	end
	if stickToBottom then
		posY = height
		posX = width + (widgetSpaceMargin/viewSizeX)
	else

			posX = 0
			posY = 0.741
	end

	backgroundRect = { posX * viewSizeX, (posY - height) * viewSizeY, (posX + width) * viewSizeX, posY * viewSizeY }
	local activeBgpadding = math_floor((backgroundPadding * 1.4) + 0.3)
	activeRect = {
		(posX * viewSizeX) + (posX > 0 and activeBgpadding or math.ceil(backgroundPadding * 0.6)),
		((posY - height) * viewSizeY) + (posY-height > 0 and math_floor(activeBgpadding) or math_floor(activeBgpadding / 3)),
		((posX + width) * viewSizeX) - activeBgpadding,
		(posY * viewSizeY) - activeBgpadding
	}
	displayListOrders = gl.DeleteList(displayListOrders)

	checkGuiShader(true)
	setupCellGrid(true)
	doUpdate = true
end



function widget:Initialize()
	widget:ViewResize()
	widget:SelectionChanged()

	WG['ordermenu'] = {}
	WG['ordermenu'].getPosition = function()
		return posX, posY, width, height
	end
	WG['ordermenu'].setBottomPosition = function(value)
		stickToBottom = value
		widget:ViewResize()
	end
	WG['ordermenu'].getAlwaysShow = function()
		return alwaysShow
	end
	WG['ordermenu'].setAlwaysShow = function(value)
		alwaysShow = value
		widget:ViewResize()
	end
	WG['ordermenu'].getBottomPosition = function()
		return stickToBottom
	end
	WG['ordermenu'].getDisabledCmd = function(cmd)
		return disabledCommand[cmd]
	end
	WG['ordermenu'].setDisabledCmd = function(params)
		if params[2] then
			disabledCommand[params[1]] = true
		else
			disabledCommand[params[1]] = nil
		end
	end
	WG['ordermenu'].getColorize = function()
		return colorize
	end
	WG['ordermenu'].setColorize = function(value)
		doUpdate = true
		colorize = value
		if colorize > 1 then
			colorize = 1
		end
	end
end

function widget:Shutdown()
	if WG['guishader'] and displayListGuiShader then
		WG['guishader'].DeleteDlist('ordermenu')
		displayListGuiShader = nil
	end
	displayListOrders = gl.DeleteList(displayListOrders)
	WG['ordermenu'] = nil
end

local buildmenuBottomPos = false
local sec = 0
function widget:Update(dt)
	sec = sec + dt
	if sec > 0.5 then
		sec = 0
		checkGuiShader()

		if WG['buildmenu'] and WG['buildmenu'].getBottomPosition then
			local prevbuildmenuBottomPos = buildmenuBottomPos
			buildmenuBottomPos = WG['buildmenu'].getBottomPosition()
			if buildmenuBottomPos ~= prevbuildmenuBottomPos then
				widget:ViewResize()
			end
		end
		if uiScale ~= Spring.GetConfigFloat("ui_scale", 1) then
			uiScale = Spring.GetConfigFloat("ui_scale", 1)
			widget:ViewResize()
			setupCellGrid(true)
			doUpdate = true
		end
		if uiOpacity ~= Spring.GetConfigFloat("ui_opacity", 0.66) then
			uiOpacity = Spring.GetConfigFloat("ui_opacity", 0.66)
			doUpdate = true
		end

		if WG['minimap'] and minimapHeight ~= WG['minimap'].getHeight() then
			widget:ViewResize()
			setupCellGrid(true)
			doUpdate = true
		end

		disableInput = isSpectating
		if Spring.IsGodModeEnabled() then
			disableInput = false
		end
	end
end

local function RectQuad(px, py, sx, sy, offset)
	gl.TexCoord(offset, 1 - offset)
	gl.Vertex(px, py, 0)
	gl.TexCoord(1 - offset, 1 - offset)
	gl.Vertex(sx, py, 0)
	gl.TexCoord(1 - offset, offset)
	gl.Vertex(sx, sy, 0)
	gl.TexCoord(offset, offset)
	gl.Vertex(px, sy, 0)
end
function DrawRect(px, py, sx, sy, zoom)
	gl.BeginEnd(GL.QUADS, RectQuad, px, py, sx, sy, zoom)
end


local function drawCell(cell, zoom)
	if not zoom then
		zoom = 1
	end

	local cmd = commands[cell]
	if cmd then
		local leftMargin = cellMarginPx
		local rightMargin = cellMarginPx2
		local topMargin = cellMarginPx
		local bottomMargin = cellMarginPx2

		if cell % cols == 1 then
			leftMargin = cellMarginPx2
		end
		if cell % cols == 0 then
			rightMargin = cellMarginPx2
		end
		if cols/cell >= 1  then
			topMargin = math_floor(((cellMarginPx + cellMarginPx2) / 2) + 0.5)
		end

		local cellInnerWidth = math_floor(((cellRects[cell][3] - rightMargin) - (cellRects[cell][1] + leftMargin)) + 0.5)
		local cellInnerHeight = math_floor(((cellRects[cell][4] - topMargin) - (cellRects[cell][2] + bottomMargin)) + 0.5)

		local padding = math_max(1, math_floor(backgroundPadding * 0.45))

		local isActiveCmd = (activeCommand == cmd.name)
		-- order button background
		local color1, color2
		if isActiveCmd then
			zoom = cellClickedZoom
			color1 = {0,0,0,0.95}
			color2 = {0.9,0,0,0.95}
		else
			if WG['guishader'] then
				color1 = (cmd.type == 5) and {0.1,0.1,0.1,1} or {0.1,0.1,0.1,1}				color1[4] = math_max(0, math_min(0.35, (uiOpacity-0.3)))
				color2 = {0.4,0.4,0.4,0.95}
			else
				color1 = {0,0,0,0.85}
				color1[4] = math_max(0, math_min(0.4, (uiOpacity-0.3)))
				color2 = {0,0,0,0.75}
			end
			if color1[4] > 0.06 then
				-- white bg (outline)
				RectRound(cellRects[cell][1] + leftMargin, cellRects[cell][2] + bottomMargin, cellRects[cell][3] - rightMargin, cellRects[cell][4] - topMargin, cellWidth * 0.021, 2, 2, 2, 2, color1, color2)
				-- darken inside
				color1 = {0,0,0, color1[4]*0.85}
				color2 = {0,0,0, color2[4]*0.85}
				RectRound(cellRects[cell][1] + leftMargin + padding, cellRects[cell][2] + bottomMargin + padding, cellRects[cell][3] - rightMargin - padding, cellRects[cell][4] - topMargin - padding, padding, 2, 2, 2, 2, color1, color2)
			end
			color1 = { 0, 0, 0, math_max(0.55, math_min(0.95, uiOpacity)) }	-- bottom
			color2 = { 0, 0, 0, math_max(0.55, math_min(0.95, uiOpacity)) }	-- top
		end

		UiButton(cellRects[cell][1] + leftMargin + padding, cellRects[cell][2] + bottomMargin + padding, cellRects[cell][3] - rightMargin - padding, cellRects[cell][4] - topMargin - padding, 1,1,1,1, 1,1,1,1, nil, color1, color2, padding)

		-- text
		if not showIcons or not cursorTextures[cmd.cursor] then
			local text
			-- First element of params represents selected state index, but Spring engine implementation returns a value 2 less than the actual index
			local stateOffset = 2

			if isStateCommand[cmd.id] then
				local currentStateIndex = cmd.params[1]
				local commandState = cmd.params[currentStateIndex + stateOffset]
				if commandState then
					text = commandState
				else
					text = '?'
				end
			else
				if cmd.action == 'stockpile' then
					-- Stockpile command name gets mutated to reflect the current status, so can just pass it in
					text  = cmd.action .. " ".. cmd.name 
				else
					text = cmd.name 
					if(cmd.name == "ManualFire") then
						text = "D-gun"
					end
				end
			end

			local fontSize = cellInnerWidth / font:GetTextWidth('  '..text..' ') * math_min(1, (cellInnerHeight/(rows*6)))
			  if fontSize > cellInnerWidth / 6.3 then
				fontSize = cellInnerWidth / 6.3
				 if(#text < 8) then
				fontSize = fontSize * 1.5
				end
			  end
			local fontHeight = font:GetTextHeight(text)*fontSize
			  local fontHeightOffset = fontHeight*0.34
			  if cmd.type == 5 then  -- state cmds (fire at will, etc)
				fontHeightOffset = fontHeight*0.22
			  end
			  if colorize > 0 and cmdColor[cmd.name] then
				local part = (1/colorize)
				local grey = (0.93*(part-1))
				font:SetTextColor((grey + cmdColor[cmd.name][1]) / part, (grey + cmdColor[cmd.name][2]) / part, (grey + cmdColor[cmd.name][3]) / part, 1)
			  else
				font:SetTextColor(0.91, 0.91, 0.91, 1)
			  end
			  font:Print(text, cellRects[cell][1] + ((cellRects[cell][3]-cellRects[cell][1])/2), (cellRects[cell][2] - ((cellRects[cell][2]-cellRects[cell][4])/2) - fontHeightOffset), fontSize, "con")
			end

		-- state lights
		if isStateCommand[cmd.id] then
			local statecount = #cmd.params - 1 --number of states for the cmd
			local curstate = cmd.params[1] + 1
			local desiredState = nil
			if clickedCellDesiredState and cell == clickedCell then
				desiredState = clickedCellDesiredState + 1
			end
			if curstate == desiredState then
				clickedCellDesiredState = nil
				desiredState = nil
			end
			local padding2 = padding
			local stateWidth = (cellInnerWidth / statecount) - padding2 - padding2
			local stateHeight = math_floor(cellInnerHeight * 0.14)
			local stateMargin = math_floor((stateWidth * 0.075) + 0.5) + padding2 + padding2
			local glowSize = math_floor(stateHeight * 8)
			local r, g, b, a = 0, 0, 0, 0
			for i = 1, statecount do
				if i == curstate or i == desiredState then
					if i == 1 then
						r, g, b, a = 1, 0.1, 0.1, (i == desiredState and 0.33 or 0.8)
					elseif i == 2 then
						if statecount == 2 then
							r, g, b, a = 0.1, 1, 0.1, (i == desiredState and 0.22 or 0.8)
						else
							r, g, b, a = 1, 1, 0.1, (i == desiredState and 0.22 or 0.8)
						end
					else
						r, g, b, a = 0.1, 1, 0.1, (i == desiredState and 0.26 or 0.8)
					end
				else
					r, g, b, a = 0, 0, 0, 0.36  -- default off state
				end
				glColor(r, g, b, a)
				local x1 = math_floor(cellRects[cell][1] + leftMargin + padding + padding2 + (stateWidth * (i - 1)) + (i == 1 and 0 or stateMargin))
				local y1 = math_floor(cellRects[cell][2] + bottomMargin + padding + padding2)
				local x2 = math_ceil(cellRects[cell][3] - rightMargin - padding - padding2 - (stateWidth * (statecount - i)) - (i == statecount and 0 or stateMargin))
				local y2 = math_ceil(cellRects[cell][2] + bottomMargin + stateHeight + padding2)
				-- fancy fitting rectrounds
				if rows < 6 then
					RectRound(x1, y1, x2, y2, stateHeight * 0.33,
						(i == 1 and 0 or 2), (i == statecount and 0 or 2), (i == statecount and 2 or 0), (i == 1 and 2 or 0))
				else
					glRect(x1, y1, x2, y2)
				end
				-- fancy active state glow
				if rows < 6 and i == curstate then
					glBlending(GL_SRC_ALPHA, GL_ONE)
					glColor(r, g, b, 0.09)
					glTexture(barGlowCenterTexture)
					DrawRect(x1, y1 - glowSize, x2, y2 + glowSize, 0.008)
					glTexture(barGlowEdgeTexture)
					DrawRect(x1 - (glowSize * 2), y1 - glowSize, x1, y2 + glowSize, 0.008)
					DrawRect(x2 + (glowSize * 2), y1 - glowSize, x2, y2 + glowSize, 0.008)
					glTexture(false)
					glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
				end
			end
		end
	end
end

local function drawOrders()
	-- just making sure blending mode is correct
	glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

	UiElement(backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4], ((posX <= 0) and 0 or 1), 1, ((posY-height > 0 or posX <= 0) and 1 or 0), ((posY-height > 0 and posX > 0) and 1 or 0))

	if #commands > 0 then
		font:Begin()
		for cell = 1, #commands do
			drawCell(cell, cellZoom)
		end
		font:End()
	end
end

local clickCountDown = 2
function widget:DrawScreen()
	if chobbyInterface then
		return
	end
	clickCountDown = clickCountDown - 1
	if clickCountDown == 0 then
		doUpdate = true
	end
	previousActiveCommand = activeCommand
	activeCommand = select(4, spGetActiveCommand())
	if activeCommand ~= previousActiveCommand then
		doUpdate = true
	end

	local x, y, b = Spring.GetMouseState()
	local cellHovered
	if not WG['topbar'] or not WG['topbar'].showingQuit() then
		if math_isInRect(x, y, backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4]) then
			Spring.SetMouseCursor('cursornormal')
			for cell = 1, #cellRects do
				if commands[cell] then
					if math_isInRect(x, y, cellRects[cell][1], cellRects[cell][2], cellRects[cell][3], cellRects[cell][4]) then
						local cmd = commands[cell]

						cellHovered = cell
					end
				else
					break
				end
			end
		end
	end

	-- make all cmd's fit in the grid
	local now = os_clock()
	if clickedCellDesiredState and not doUpdateClock then	-- make sure state changes get updated
		doUpdateClock = now + 0.1
	end
	if doUpdate or (doUpdateClock and now >= doUpdateClock) then
		if doUpdateClock and now >= doUpdateClock then
			doUpdateClock = nil
			doUpdate = true
		end
		doUpdateClock = nil
		refreshCommands()
	end

	if #commands == 0 and (not alwaysShow or Spring.GetGameFrame() == 0) then	-- dont show pregame because factions interface is shown
		if displayListGuiShader and WG['guishader'] then
			WG['guishader'].RemoveDlist('ordermenu')
		end
	else
		if displayListGuiShader and WG['guishader'] then
			WG['guishader'].InsertDlist(displayListGuiShader, 'ordermenu')
		end
		if doUpdate then
			displayListOrders = gl.DeleteList(displayListOrders)
		end
		if not displayListOrders then
			displayListOrders = gl.CreateList(function()
				drawOrders()
			end)
		end

		gl.CallList(displayListOrders)

		if #commands >0 then
			-- draw highlight on top of button
			if not WG['topbar'] or not WG['topbar'].showingQuit() then
				if commands and cellHovered then
					local cell = cellHovered
					if cellRects[cell] and cellRects[cell][4] then
						drawCell(cell, cellHoverZoom)

						local colorMult = 1
						if commands[cell] and activeCommand == commands[cell].name then
							colorMult = 0.4
						end

						local leftMargin = cellMarginPx
						local rightMargin = cellMarginPx2
						local topMargin = cellMarginPx
						local bottomMargin = cellMarginPx2

						if cell % cols == 1 then
							leftMargin = cellMarginPx2
						end
						if cell % cols == 0 then
							rightMargin = cellMarginPx2
						end
						if cols/cell >= 1  then
							topMargin = math_floor(((cellMarginPx + cellMarginPx2) / 2) + 0.5)
						end

						-- gloss highlight
						local pad = math_max(1, math_floor(backgroundPadding * 0.52))
						local pad2 = pad
						glBlending(GL_SRC_ALPHA, GL_ONE)
						RectRound(cellRects[cell][1] + leftMargin + pad + pad2, cellRects[cell][4] - topMargin - backgroundPadding - pad - pad2 - ((cellRects[cell][4] - cellRects[cell][2]) * 0.42), cellRects[cell][3] - rightMargin - pad - pad2, (cellRects[cell][4] - topMargin - pad - pad2), cellMargin * 0.025, 2, 2, 0, 0, { 1, 1, 1, 0.035 * colorMult }, { 1, 1, 1, (disableInput and 0.11 * colorMult or 0.24 * colorMult) })
						RectRound(cellRects[cell][1] + leftMargin + pad + pad2, cellRects[cell][2] + bottomMargin + pad + pad2, cellRects[cell][3] - rightMargin - pad - pad2, (cellRects[cell][2] - bottomMargin - pad - pad2) + ((cellRects[cell][4] - cellRects[cell][2]) * 0.5), cellMargin * 0.025, 0, 0, 2, 2, { 1, 1, 1, (disableInput and 0.035 * colorMult or 0.075 * colorMult) }, { 1, 1, 1, 0 })
						glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
					end
				end
			end

			-- clicked cell effect
			if clickedCellTime and commands[clickedCell] then
				local cell = clickedCell
				if cellRects[cell] and cellRects[cell][4] then
					local isActiveCmd = (commands[cell].name == activeCommand)
					local duration = 0.33
					if isActiveCmd then
						duration = 0.45
					elseif isStateCommand[commands[clickedCell].id] then
						duration = 0.6
					end
					local alpha = 0.33 - ((now - clickedCellTime) / duration)
					if alpha > 0 then
						if isActiveCmd then
							glColor(0, 0, 0, alpha)
						else
							glBlending(GL_SRC_ALPHA, GL_ONE)
							glColor(1, 1, 1, alpha)
						end

						local leftMargin = cellMarginPx
						local rightMargin = cellMarginPx2
						local topMargin = cellMarginPx
						local bottomMargin = cellMarginPx2

						if cell % cols == 1 then
							leftMargin = cellMarginPx2
						end
						if cell % cols == 0 then
							rightMargin = cellMarginPx2
						end
						if cols/cell >= 1  then
							topMargin = math_floor(((cellMarginPx + cellMarginPx2) / 2) + 0.5)
						end

						-- gloss highlight
						local pad = math_max(1, math_floor(backgroundPadding * 0.52))
						RectRound(cellRects[cell][1] + leftMargin + pad, cellRects[cell][2] + bottomMargin + pad, cellRects[cell][3] - rightMargin - pad, cellRects[cell][4] - topMargin - pad, pad, 2, 2, 2, 2)
					else
						clickedCellTime = nil
					end
					glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
				end
			end
		end
	end
	doUpdate = nil
end

function widget:MousePress(x, y, button)
	if Spring.IsGUIHidden() then
		return
	end
	if math_isInRect(x, y, backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4]) then
		if #commands > 0 then
			if not disableInput then
				for cell = 1, #cellRects do
					local cmd = commands[cell]
					if cmd then
						if math_isInRect(x, y, cellRects[cell][1], cellRects[cell][2], cellRects[cell][3], cellRects[cell][4]) then
							clickCountDown = 2
							clickedCell = cell
							clickedCellTime = os_clock()

							-- remember desired state: only works for a single cell at a time, because there is no way to re-identify a cell when the selection changes
							if isStateCommand[cmd.id] then
								if button == 1 then
									clickedCellDesiredState = cmd.params[1] + 1
									if clickedCellDesiredState >= #cmd.params - 1 then
										clickedCellDesiredState = 0
									end
								else
									clickedCellDesiredState = cmd.params[1] - 1
									if clickedCellDesiredState < 0 then
										clickedCellDesiredState = #cmd.params - 1
									end
								end
								doUpdate = true
							end


							if cmd.id and Spring.GetCmdDescIndex(cmd.id) then
								Spring.SetActiveCommand(Spring.GetCmdDescIndex(cmd.id), button, true, false, Spring.GetModKeyState())
							end
							break
						end
					else
						break
					end
				end
			end
			return true
		elseif alwaysShow and Spring.GetGameFrame() > 0 then
			return true
		end
	end
end

function widget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdOpts, cmdParams, cmdTag)
	if isStateCommand[cmdID] then
		if not hiddenCommands[cmdID] and doUpdateClock == nil then
			doUpdateClock = os_clock() + 0.01
		end
	end
end

function widget:SelectionChanged(sel)
	clickCountDown = 2
	clickedCellDesiredState = nil
end
