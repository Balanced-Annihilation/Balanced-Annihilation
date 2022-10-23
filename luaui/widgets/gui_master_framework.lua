------------------------------------------------------------------------------------------------------------
-- Metadata
------------------------------------------------------------------------------------------------------------

-- https://github.com/MasterBel2/Master-GUI-Framework

function widget:GetInfo()
	return {
		version = "0.1",
		name = "MasterBel2's GUI Framework",
		desc = "A GUI framework for the SpringRTS Engine",
		author = "MasterBel2",
		date = "October 2020",
		license = "GNU GPL, v2 or later",
		layer = -2,
		enabled = false
	}
end

local count = 0
------------------------------------------------------------------------------------------------------------
-- Global Access
------------------------------------------------------------------------------------------------------------

local framework = {
	debug = false,
	drawDebug = false,
	compatabilityVersion = 14,

	events = { mousePress = "mousePress", mouseWheel = "mouseWheel", mouseOver = "mouseOver" }, -- mouseMove = "mouseMove", mouseRelease = "mouseRelease" (Handled differently to other events – see dragListeners)
	layerRequest = {
		directlyBelow = function(target) return { mode = "below", target = target } end,
		directlyAbove = function(target) return { mode = "above", target = target } end,
		top = function() return { mode = "top" } end,
		bottom = function() return { mode = "bottom" } end,
		anywhere = function() return { mode = "anywhere" } end,
	},

	stats = {},
}

if not WG.MasterFramework then WG.MasterFramework = {} end

WG.MasterFramework[framework.compatabilityVersion] = framework

------------------------------------------------------------------------------------------------------------
-- Internal Access
------------------------------------------------------------------------------------------------------------

local hasCheckedElementBelowMouse = false

local events = framework.events

local elements = {}
local elementOrder = {}

local keyElement
local elementBelowMouse

local activeElement

-- A drag listener must assign itself to the index of the button that was pressed, and must implement the 
-- functions MouseRelease(x, y) and MouseMove(x, y, dx, dy). Listeners will be removed automatically on 
-- mouse release
local dragListeners = {}

-- TODO: Conflicts Per Name!
local conflicts = {}

------------------------------------------------------------------------------------------------------------
-- Debug
------------------------------------------------------------------------------------------------------------

local drawCalls = {}

local function Log(string)
	if framework.debug or framework.drawDebug then
		Spring.Echo("[MasterFramework " .. framework.compatabilityVersion .. "] " .. string)
	end
end


function LogDrawCall(caller)
	if framework.drawDebug then
		drawCalls[caller] = (drawCalls[caller] or 0) + 1
	end
end

-- Logs a formatted error. Provide details as strings, they will be appeneded with the separator " - "
local function Error(...)
	local errorString = "Error in MasterFramework " .. framework.compatabilityVersion

	for i,v in ipairs({...}) do
		errorString = errorString .. " - " .. v
	end

	Spring.Echo(errorString)
end

------------------------------------------------------------------------------------------------------------
-- Other Helpers
------------------------------------------------------------------------------------------------------------

local function nullFunction() end

local function UniqueKey(preferredKey)
	if elements[preferredKey] == nil then
		Log("Creating element with preferred key: " .. preferredKey)
		return preferredKey
	else
		conflicts[preferredKey] = (conflicts[preferredKey] or 0) + 1
		local key = UniqueKey(preferredKey .. "_" .. conflicts[preferredKey])
		Log("Key " .. preferredKey .. " has already been taken! Assigning key " .. key .. " instead.")
		return key
	end
end

------------------------------------------------------------------------------------------------------------
-- Layers
------------------------------------------------------------------------------------------------------------

-- Returns the index of the layer that 
local function WantedLayer(layerRequest)
	if layerRequest.mode == "top" then
		return 1
	elseif layerRequest.mode == "bottom" then
		return #elementOrder + 1
	elseif layerRequest.mode == "below" then
		for i, key in ipairs(elementOrder) do
			if key == layerRequest.target then
				return i + 1
			end
		end
		error("Could not find element \"" .. layerRequest.target .. "\" to place below!")
	elseif layerRequest.mode == "above" then
		for i, key in ipairs(elementOrder) do
			if key == layerRequest.target then
				return i
			end
		end
		error("Could not find element \"" .. layerRequest.target .. "\" to place above!")
	elseif layerRequest.mode == "anywhere" then -- If it doesn't matter, we'll just place just above the elements that are supposed to be below everything else.
		for i, key in ipairs(elementOrder) do
			if elements[key].layerRequest.mode == "bottom" then
				return i
			end
		end
		return #elementOrder + 1
	else
		error("Unrecognised layer mode \"" .. tostring(layerRequest.mode) .. "\"!")
	end
end

local function removeOrderForElement(key)
	for index, elementKey in ipairs(elementOrder) do
		if key == elementKey then
			table.remove(elementOrder, index)
			return
		end
	end
end

function framework:MoveElement(key, layerRequest)
	removeOrderForElement(key)
	table.insert(elementOrder, WantedLayer(layerRequest))
	element.layerRequest = layerRequest
end

------------------------------------------------------------------------------------------------------------
-- Add/Remove Elements
------------------------------------------------------------------------------------------------------------

-- Adds an element to be drawn.
--
-- Parameters:
--  - body: A component as specified in the "Basic Components" section of this file.
function framework:InsertElement(body, preferredKey, layerRequest, deselectAction)
	-- Create element

	local element = { 
		body = body, 
		primaryFrame = nil, 
		tooltips = {}, 
		baseResponders = {}, 
		deselect = deselectAction or function() end
	}

	for _,event in pairs(events) do
		element.baseResponders[event] = { responders = {}, action = nullFunction }
	end

	-- Create key

	local key = UniqueKey(preferredKey)

	element.key = key 
	elements[key] = element

	local wantedLayer = WantedLayer(layerRequest)
	table.insert(elementOrder, wantedLayer, key)
	element.layerRequest = layerRequest

	return key
end

function framework:RemoveElement(key) 
	if key ~= nil then
		Log("Removed " .. key)
		elements[key] = nil
		removeOrderForElement(key)
	else
		Log("Could not remove element: Key is nill!")
	end
end

------------------------------------------------------------------------------------------------------------
-- Includes
------------------------------------------------------------------------------------------------------------

local insert = table.insert
local remove = table.remove

local ceil = math.ceil
local cos = math.cos
local floor = math.floor
local max = math.max
local min = math.min
local pi = math.pi
local sin = math.sin
local sqrt = math.sqrt

-- Set in widget:Initialize
local viewportWidth = 0
local viewportHeight = 0
local viewportDidChange
local relativeScaleFactor = 1
local combinedScaleFactor = 1

local gl_BeginEnd = gl.BeginEnd
local gl_Blending = gl.Blending
local gl_CallList = gl.CallList
local gl_Color = gl.Color
local gl_CreateList = gl.CreateList
local gl_LineWidth = gl.LineWidth
local gl_LoadFont = gl.LoadFont
local gl_DeleteList = gl.DeleteList
local gl_DeleteFont = gl.DeleteFont
local gl_PushMatrix = gl.PushMatrix
local gl_PopMatrix = gl.PopMatrix
local gl_Rect = gl.Rect
local gl_TexCoord = gl.TexCoord
local gl_TexRect = gl.TexRect
local gl_Text = gl.Text
local gl_Texture = gl.Texture
local gl_Translate = gl.Translate
local gl_Vertex = gl.Vertex

local GL_LINE_LOOP = GL.LINE_LOOP
local GL_POLYGON = GL.POLYGON
local GL_QUADS = GL.QUADS

local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local GL_SRC_ALPHA = GL.SRC_ALPHA

local Spring_GetTimer = Spring.GetTimer
local Spring_DiffTimers = Spring.DiffTimers
local Spring_GetTimerMicros = Spring.GetTimer 

local profileName
local startTimer

------------------------------------------------------------------------------------------------------------
-- Caches
------------------------------------------------------------------------------------------------------------

local fonts = {}

------------------------------------------------------------------------------------------------------------
-- Profiling
------------------------------------------------------------------------------------------------------------

local function startProfile(_profileName)
	profileName = _profileName
	startTimer = Spring_GetTimerMicros()
	-- startTimer = Spring_GetTimer()
end
	

local function endProfile()
	-- local time = Spring_DiffTimers(Spring_GetTimer(), startTimer, nil)
	local time = Spring_DiffTimers(Spring_GetTimerMicros(), startTimer, nil, true)
	framework.stats[profileName] = time
	-- Log("Profiled " .. profileName .. ": " .. Spring_DiffTimers(Spring_GetTimer(), startTimer) * 1000 .. " microseconds")
end

------------------------------------------------------------------------------------------------------------
-- Helpers
------------------------------------------------------------------------------------------------------------

local function clear(array)
	for index = 1, #array do
		remove(array)
	end
end

local function round(number)
	return ceil(number - 0.5)
end

------------------------------------------------------------------------------------------------------------
-- Helper Methods
------------------------------------------------------------------------------------------------------------

local function PointIsInRect(x, y, rectX, rectY, rectWidth, rectHeight)
	return x >= rectX and y >= rectY and x <= rectX + rectWidth and y <= rectY + rectHeight
end

framework.PointIsInRect = PointIsInRect

------------------------------------------------------------------------------------------------------------
-- Scaling
-- 
-- Handled on the minor dimension, with a base of 1080p. E.g. on a 3840x1920 display, scale the same as on a
-- 1920x1080 display.
------------------------------------------------------------------------------------------------------------

function framework:Dimension(unscaled)
	return function()
		return floor(unscaled * combinedScaleFactor)
	end
end

local function updateScreenEnvironment(newWidth, newHeight, newScale)
	viewportWidth = newWidth
	viewportHeight = newHeight

	relativeScaleFactor = newScale
	combinedScaleFactor = min(viewportWidth / 1920, viewportHeight / 1080) * relativeScaleFactor
	
	viewportDidChange = 1

	for _, font in pairs(fonts) do
		font:Scale(combinedScaleFactor)
	end

	framework.viewportWidth = viewportWidth
	framework.viewportHeight = viewportHeight
	framework.relativeScaleFactor = relativeScaleFactor
	framework.combinedScaleFactor = combinedScaleFactor
	framework.viewportDidChange = viewportDidChange
end

function framework:SetScale(newScale)
	updateScreenEnvironment(viewportWidth, viewportHeight, newScale)
end

------------------------------------------------------------------------------------------------------------
-- Drawing
------------------------------------------------------------------------------------------------------------

local sinThetaCache = {}
local halfPi = pi/2
local function newSinTheta(cornerRadius)
	local radians = halfPi/cornerRadius
	local sinTheta = {}
	for i = 0, cornerRadius do
		sinTheta[i] = sin(radians * i) * cornerRadius
	end
	sinThetaCache[cornerRadius] = sinTheta
	return sinTheta
end
local x
local function DrawRoundedRect(width, height, cornerRadius, drawFunction, shouldSquareBottomLeft, shouldSquareBottomRight, shouldSquareTopRight, shouldSquareTopLeft, ...)
	LogDrawCall("DrawRoundedRect")

	local centerTopY = height - cornerRadius
	local centerRightX = width - cornerRadius
	
	local sinTheta = sinThetaCache[cornerRadius] or newSinTheta(cornerRadius)
	
	local pastEnd = cornerRadius

	-- Bottom left
	if shouldSquareBottomLeft then
		drawFunction(0, 0, ...)
	else
		for i = 0, cornerRadius do
			drawFunction(cornerRadius - sinTheta[pastEnd-i], cornerRadius - sinTheta[i], ...)
		end
	end

	-- Bottom right
	if shouldSquareBottomRight then
		drawFunction(width, 0, ...)
	else
		for i = 0, cornerRadius do
			drawFunction(centerRightX + sinTheta[i], cornerRadius - sinTheta[pastEnd-i], ...)
		end
	end

	-- Top right
	if shouldSquareTopRight then
		drawFunction(width, height, ...)
	else
		for i = 0, cornerRadius do
			drawFunction(centerRightX + sinTheta[pastEnd-i], centerTopY + sinTheta[i], ...)
		end
	end

	-- Top left
	if shouldSquareTopLeft then
		drawFunction(0, height, ...)
	else
		for i = 0, cornerRadius do
			drawFunction(cornerRadius - sinTheta[i], centerTopY + sinTheta[pastEnd-i], ...)
		end
	end
end

local function DrawRectVertices(width, height, drawFunction)
	LogDrawCall("DrawRectVertices")
	drawFunction(0, 0)
	drawFunction(width, 0)
	drawFunction(width, height)
	drawFunction(0, height)
end


local function DrawRect(drawFunction, x, y, width, height)
	LogDrawCall("DrawRect")
	drawFunction(x, y, x + width, y + height)
end

------------------------------------------------------------------------------------------------------------
-- Decorations
------------------------------------------------------------------------------------------------------------

-- Colors counterclockwise from bottom left
function framework:Gradient(color1, color2, color3, color4)
	local gradient = {}

	local color2r; local color2g; local color2b; local color2a
	local color3r; local color3g; local color3b; local color3a
	local color4r; local color4g; local color4b; local color4a
	local color1r; local color1g; local color1b; local color1a

	function gradient:SetColors(newColor1, newColor2, newColor3, newColor4)
		color1r = newColor1.r; color1g = newColor1.g; color1b = newColor1.b; color1a = newColor1.a
		color2r = newColor2.r; color2g = newColor2.g; color2b = newColor2.b; color2a = newColor2.a
		color3r = newColor3.r; color3g = newColor3.g; color3b = newColor3.b; color3a = newColor3.a
		color4r = newColor4.r; color4g = newColor4.g; color4b = newColor4.b; color4a = newColor4.a
	end
	gradient:SetColors(color1, color2, color3, color4)

	local function drawRectVertecies(x, y, width, height)
		gl_Color(color1r, color1g, color1b, color1a)
		gl_Vertex(x, y)
		gl_Color(color2r, color2g, color2b, color2a)
		gl_Vertex(x + width, y)
		gl_Color(color3r, color3g, color3b, color3a)
		gl_Vertex(x + width, y + height)
		gl_Color(color4r, color4g, color4b, color4a)
		gl_Vertex(x, y + height)
	end

	local function drawRoundedRectVertex(xOffset, yOffset, x, y, width, height)
		local a = xOffset / width; local b = (width - xOffset) / width; local c = yOffset / height; local d = (height - yOffset) / height
		local mult1 = a * c
		local mult2 = b * c
		local mult3 = b * d
		local mult4 = a * d

		gl_Color(
			color1r * mult1 + color2r * mult2 + color3r * mult3 + color4r * mult4,
			color1g * mult1 + color2g * mult2 + color3g * mult3 + color4g * mult4,
			color1b * mult1 + color2b * mult2 + color3b * mult3 + color4b * mult4,
			color1a * mult1 + color2a * mult2 + color3a * mult3 + color4a * mult4
		)
		gl_Vertex(x + xOffset, y + yOffset)
	end

	function gradient:Draw(rect, x, y, width, height)
		LogDrawCall("Gradient")
		local cornerRadius = rect.cornerRadius() or 0

		if cornerRadius > 0 then
			local beyondLeft = x <= 0
			local belowBottom = y <= 0
			local beyondRight = (x + width) >= viewportWidth
			local beyondTop = (y + height) >= viewportHeight

			gl_BeginEnd(GL_POLYGON, DrawRoundedRect, width, height, cornerRadius, drawRoundedRectVertex, belowBottom or beyondLeft, beyondRight or belowBottom, beyondRight or beyondTop, beyondLeft or beyondTop, x, y, width, height)
		else
			gl_BeginEnd(GL_QUADS, drawRectVertecies, x, y, width, height)
		end
	end
	return gradient
end

-- Colors from left to right
function framework:HorizontalGradient(color1, color2) return framework:Gradient(color1, color2, color2, color1) end
-- Colors from bottom to top
function framework:VerticalGradient(color1, color2) return framework:Gradient(color1, color1, color2, color2) end

local done2
-- Draws a color in a rect.
function framework:Color(r, g, b, a)
	local color = { r = r, g = g, b = b, a = a }

	function color:Set()
		LogDrawCall("Color (Set)")
		gl_Color(self.r, self.g, self.b, self.a)
	end

	local function drawRoundedRectVertex(xOffset, yOffset, x, y)
		gl_Vertex(x + xOffset, y + yOffset)
	end
	
	function color:Draw(rect, x, y, width, height)
		LogDrawCall("Color")
		self:Set()
		local cornerRadius = rect.cornerRadius() or 0

		if cornerRadius > 0 then
			local beyondLeft = x <= 0
			local belowBottom = y <= 0
			local beyondRight = (x + width) >= viewportWidth
			local beyondTop = (y + height) >= viewportHeight

			gl_BeginEnd(GL_POLYGON, DrawRoundedRect, width, height, cornerRadius, drawRoundedRectVertex, 
				belowBottom or beyondLeft, beyondRight or belowBottom, beyondRight or beyondTop, beyondLeft or beyondTop, x, y)
		else
			DrawRect(gl_Rect, x, y, width, height)
		end
		done2 = true
	end

	return color
end

local done

-- Draws a border around an object. NOTE: DOES NOT CURRENTLY WORK PROPERLY
function framework:Stroke(width, color, inside)
	local stroke = { width = width, color = color, inside = inside or false }

	-- Only used for the draw function, so we don't need to worry about this being used by multiple strokes.
	local cachedX 
	local cachedY
	local cachedWidth
	local cachedHeight
	local cachedCornerRadius

	local function strokePixel(xOffset, yOffset)
		gl_Vertex(cachedX + xOffset, cachedY + yOffset)
	end

	function stroke:Draw(rect, x, y, width, height)
		LogDrawCall("Stroke")
		local strokeWidth = self.width

		self.color:Set()
		gl_LineWidth(strokeWidth)
		
		-- Ceil and floor here prevent half-pixels
		local halfStroke = strokeWidth / 2
		-- if inside then
		-- 	cachedX = floor(x + halfStroke)
		-- 	cachedY = floor(y + halfStroke)
		-- 	cachedWidth = ceil(width - strokeWidth)
		-- 	cachedHeight = ceil(height - strokeWidth)
		-- 	cachedCornerRadius = ceil(max(0, (rect.cornerRadius() or 0) - halfStroke))
		-- else
			cachedX = x + halfStroke
			cachedY = y + halfStroke
			cachedWidth = width - strokeWidth
			cachedHeight = height - strokeWidth
			cachedCornerRadius = rect.cornerRadius()
		-- end

		if cachedCornerRadius > 0 then
			gl_BeginEnd(GL_LINE_LOOP, DrawRoundedRect, cachedWidth, cachedHeight, cachedCornerRadius, strokePixel, 
				x <= 0 or y <= 0, x + cachedWidth >= viewportWidth or y <= 0, x + cachedWidth >= viewportWidth or y + cachedHeight >= viewportHeight, x == 0 or y + cachedHeight >= viewportHeight)
		else
			gl_BeginEnd(GL_LINE_LOOP, DrawRectVertices, cachedWidth, cachedHeight, strokePixel)
		end
		done = true
	end

	return stroke
end

-- Draws an image in a rect. The image is immutable, that is you cannot change the file.
function framework:Image(fileName, tintColor)
	local image = { fileName = fileName, tintColor = tintColor or framework.color.white }

	local function drawRoundedRectVertex(xOffset, yOffset, x, y, width, height)
		gl_TexCoord(xOffset / width, 1 - (yOffset / height))
		gl_Vertex(x + xOffset, y + yOffset)
	end

	function image:Draw(rect, x, y, width, height)
		LogDrawCall("Image")
		self.tintColor:Set()
		gl_Texture(self.fileName)
		
		if rect.cornerRadius() > 0 then
			gl_BeginEnd(GL_POLYGON, DrawRoundedRect, width, height, rect.cornerRadius(), drawRoundedRectVertex, false, false, false, false, x, y, width, height)
		else
			DrawRect(gl_TexRect, x, y, width, height)
		end
		gl_Texture(false)
	end

	return image
end

function framework:Blending(srcMode, dstMode, decorations)
	local blending = {}

	function blending:Draw(...)
		gl_Blending(srcMode, dstMode)
		for i=1, #decorations do
			decorations[i]:Draw(...)
		end
		gl_Blending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	end

	return blending
end

------------------------------------------------------------------------------------------------------------
-- Basic Components
------------------------------------------------------------------------------------------------------------

local nextID = 0
function framework:PrimaryFrame(body)
	local primaryFrame = {}

	local cachedX, cachedY
	local width, height

	local _body

	function primaryFrame:SetBody()
		_body = framework:TextGroup(body)
	end

	primaryFrame:SetBody(body)

	function primaryFrame:Geometry()
		return cachedX, cachedY, width, height
	end

	function primaryFrame:CachedPosition()
		return cachedX, cachedY
	end

	function primaryFrame:Size()
		if (not width) or (not height) then
			return self:Layout(viewportWidth, viewportHeight)
		else
			return width, height
		end
	end

	function primaryFrame:Layout(availableWidth, availableHeight)
		width, height = _body:Layout(availableWidth, availableHeight)
		return width, height
	end

	function primaryFrame:Draw(x, y)
		_body:Draw(x, y)
		activeElement.primaryFrame = self
		cachedX = x
		cachedY = y
	end

	return primaryFrame
end

-- A component of fixed size.
function framework:Rect(width, height, cornerRadius, decorations)
	local rect = { cornerRadius = cornerRadius or framework:Dimension(0), decorations = decorations or {} }

	function rect:SetSize(newWidth, newHeight)
		width = newWidth
		height = newHeight
	end

	function rect:Draw(x, y)
		LogDrawCall("Rect")
		local decorations = self.decorations
		for i = 1, #decorations do
			decorations[i]:Draw(self, x, y, width(), height())
		end
	end

	function rect:Layout() 
		return width(), height() 
	end

	return rect
end

------------------------------------------------------------------------------------------------------------
-- Text
------------------------------------------------------------------------------------------------------------

-- TODO: Fonts, text, & Scaling!

framework.color = {
	white = framework:Color(1, 1, 1, 1),
	red = framework:Color(1, 0, 0, 1),
	green = framework:Color(0, 1, 0, 1),
	blue = framework:Color(0, 1, 0, 1),
	black = framework:Color(0, 0, 0, 1)
}

function framework:Font(fileName, size, outlineWidth, outlineWeight)
	local key = fileName.."s"..(size or "default").."o"..(outlineWidth or "default").."os"..(outlineWeight or "default")
	local font = fonts[key]

	LogDrawCall("Font (Load)")

	if font == nil then
		font = {
			key = key,
			fileName = fileName,
			size = size,
			outlineWidth = outlineWidth,
			outlineWeight = outlineWeight
		}

		function font:Scale(newScale)
			if self.glFont then gl_DeleteFont(self.glFont) end
			self.glFont = gl_LoadFont(fileName, round(size * newScale), round((outlineWidth or 0) * newScale), outlineWeight)
			self.scale = newScale
		end

		font:Scale(combinedScaleFactor)

		fonts[key] = font
	end

	return font
end

framework.defaultFont = framework:Font("FreeSansBold.otf", 12)

local activeTextGroup
function framework:TextGroup(body)
	local textGroup = {}
	local elements = {}

	function textGroup:SetBody(newBody)
		body = newBody
	end

	function textGroup:AddElement(newElement)
		local fontKey = newElement._readOnly_font.key
		local fontGroup = elements[fontKey] or {}
		insert(fontGroup, newElement)
		elements[fontKey] = fontGroup
	end

	function textGroup:Layout(availableWidth, availableHeight)
		return body:Layout(availableWidth, availableHeight)
	end

	function textGroup:Draw(...)
		for fontKey, textElements in pairs(elements) do
			if #textElements == 0 then
				elements[fontKey] = nil
			else
				clear(textElements)
			end
		end
		
		local previousTextGroup = activeTextGroup
		activeTextGroup = self
		body:Draw(...)
		activeTextgroup = previousTextGroup

		for _, textElements in pairs(elements) do
			local textElement = textElements[1]
			if not textElement then break end

			local glFont = textElement._readOnly_font.glFont
			glFont:Begin()
			for index = 1, #textElements do
				textElements[index]:DrawForReal(glFont)
			end
			glFont:End()
		end
	end

	return textGroup
end

-- Auto-sizing text
-- FIXME: Text currently has an issue where it'll jump up and down. Not sure why this is happening. A pixel rounding issue maybe.
function framework:Text(string, color, constantWidth, constantHeight, font, watch)
	font = font or framework.defaultFont
	local text = {
		color = color or framework.color.white, 
		constantWidth = constantWidth, constantHeight = constantHeight,
		type = "Text"
	}

	local fontScale
	local fontSize
	local width, height, descender, ascender

	local prevDescender, prevHeight = 0, 0

	local function layout(font)
		width = text.constantWidth or font.glFont:GetTextWidth(string) * fontSize * fontScale
		if text.constantHeight then
			height = text.constantHeight
		else
			local unscaledHeight, unscaledDescender, lines = font.glFont:GetTextHeight(string)
			-- height = unscaledHeight * fontSize * fontScale
			-- height = unscaledHeight * fontSize * fontScale -- height doesn't include the ascender, which will lead to weird layout things
			descender = unscaledDescender * fontSize * fontScale
			-- ascender = fontSize * fontScale - (height - descender)
			height = lines * fontSize * fontScale

			-- Spring.Echo("String: " .. string .. ", prevHeight: " .. prevHeight .. ", height: " .. height .. ", prevDescender: " .. prevDescender .. ", descender: " .. descender .. ", fontSize: " .. fontSize .. ", fontScale: " .. fontScale)

			
			-- if watch and (height ~= prevHeight or descender ~= prevDescender) then
			-- 	Spring.Echo("Height changed! String: " .. string .. ", prevHeight: " .. prevHeight .. ", height: " .. height .. ", prevDescender: " .. prevDescender .. ", descender: " .. descender .. ", fontSize: " .. fontSize .. ", fontScale: " .. fontScale)
			-- 	prevHeight = height
			-- 	prevDescender = descender
			-- end

			-- Spring.Echo("height: " .. unscaledHeight .. ", descender: " .. unscaledDescender)
		end
	end

	function text:SetFont(newFont)
		local font = newFont or framework.defaultFont
		fontSize = font.size
		fontScale = font.scale
		self._readOnly_font = font -- So TextGroup can group drawing by font
		layout(font)
	end

	function text:SetString(newString)
		if string ~= newString then
			string = newString
			layout(font)
			return true
		end
	end

	text:SetFont(font)
	text:SetString(string)

	local cachedX, cachedY

	function text:Layout(availableHeight, availableWidth)
		if fontScale ~= font.scale then
			fontScale = font.scale
			layout(font)
		end
		-- return width, height - descender + ascender
		return width, height
	end

	function text:Draw(x, y)
		cachedX = x
		cachedY = y

		LogDrawCall("Text (Grouped)")
		activeTextGroup:AddElement(self)
	end

	function text:DrawForReal(glFont)
		local color = self.color
		glFont:SetTextColor(color.r, color.g, color.b, color.a)

		-- height - 1 is because it appeared to be drawing 1 pixel too high - for the default font, at least. I haven't checked with any other font size yet.
		-- I don't know what to do about text that's supposed to be centred vertically in a cell, because this method of drawing means the descender pushes the text up a bunch.
		glFont:Print(string, cachedX, cachedY + height - 1, fontSize * fontScale, "ao")
	end

	return text
end

function framework:DeleteFont(font)
	LogDrawCall("Font (Delete)")
	fonts[font.key] = nil
	gl_DeleteFont(font.glFont)
end

------------------------------------------------------------------------------------------------------------
-- User Interaction
------------------------------------------------------------------------------------------------------------

-- NOTE: Rasterizers are compatible with Responders IF AND ONLY IF the rasterizer DOES NOT APPLY TRANSLATION

-- In order to receive enter and actions, the responder must return true to hover actions.
function framework:MouseOverResponder(rect, hoverAction, enterAction, leaveAction)

	local responder = self:Responder(rect, events.mouseOver, hoverAction)

	responder.MouseEnter = enterAction
	responder.MouseLeave = leaveAction

	return responder
end

function framework:MouseOverChangeResponder(rect, changeAction)
	return self:MouseOverResponder(
		rect, 
		function() return true end,
		function() 
			changeAction(true)
		end,
		function() 
			changeAction(false) 
		end
	)
end

function framework:MousePressResponder(rect, downAction, moveAction, releaseAction)
	local responder = self:Responder(rect, events.mousePress, nil)

	responder.downAction = downAction
	responder.moveAction = moveAction
	responder.releaseAction = releaseAction

	function responder:action(x, y, button)
		responder.button = button
		dragListeners[button] = responder
		return responder:downAction(x, y, button)
	end

	function responder:MouseMove(x, y, dx, dy)
		self:moveAction(x, y, dx, dy)
	end
	
	function responder:MouseRelease(x, y)
		-- The call site will remove as a drag listener
		self:releaseAction(x, y)
	end

	return responder
end

local responderID = 0
local activeResponders = {}
for _, event in pairs(events) do
	activeResponders[event] = {}
end

function framework:Responder(rect, event, action)
	local responder = { rect = rect, action = action, responders = {}, id = responderID }
	responderID = responderID + 1

	local width, height
	local cachedX, cachedY

	function responder:Size() return width, height end
	function responder:CachedPosition() return cachedX, cachedY end
	function responder:Geometry() return cachedX, cachedY, width, height end

	function responder:Layout(...)
		width, height = self.rect:Layout(...)
		return width, height
	end

	function responder:Draw(x, y)
		LogDrawCall("Responder")

		-- Parent keeps track of the order of responders, and use that to decide who gets the interactions first
		local previousActiveResponder = activeResponders[event]
		insert(previousActiveResponder.responders, 1, self)
		self.parent = previousActiveResponder

		activeResponders[event] = self
		clear(self.responders)
		self.rect:Draw(x, y)
		activeResponders[event] = previousActiveResponder
		
		cachedX = x
		cachedY = y
	end

	
	return responder
end

local tooltipID = 0
local activeTooltip
function framework:Tooltip(rect, description)
	local tooltip = { rect = rect, description = description, tooltips = {} }
	local id = tooltipID -- like for responder, this is immutable so doesn't need to be stored in the table
	tooltipID = tooltipID + 1

	local width, height
	local cachedX, cachedY

	function tooltip:Size()
		return width, height
	end

	function tooltip:CachedPosition()
		return cachedX, cachedY
	end

	function tooltip:Geometry()
		return cachedX, cachedY, width, height
	end

	function tooltip:Layout(...)
		width, height = self.rect:Layout(...)
		return width, height
	end
	
	function tooltip:Draw(x, y)
		LogDrawCall("Tooltip")
		local previousActiveTooltip = activeTooltip
		local parent = self.parent
		if previousActiveTooltip ~= parent then
			if parent then
				parent.tooltips[id] = nil
			end
			previousActiveTooltip.tooltips[id] = self
			self.parent = previousActiveTooltip
		end
		activeTooltip = self

		self.rect:Draw(x, y)
		activeTooltip = previousActiveTooltip
		
		cachedX = x
		cachedY = y
	end
	return tooltip
end

------------------------------------------------------------------------------------------------------------
-- Positioning
------------------------------------------------------------------------------------------------------------

-- An interface element that caches the size and position of its body, without impacting layout or drawing.
function framework:GeometryTarget(body)
    local geometryTarget = {}
    local width, height, cachedX, cachedY
    function geometryTarget:Layout(...)
        width, height = body:Layout(...)
        return width, height
    end
    function geometryTarget:Draw(x, y)
        cachedX = x
        cachedY = y
        body:Draw(x, y)
    end
    function geometryTarget:CachedPosition()
        return cachedX or 0, cachedY or 0
    end
    function geometryTarget:Size()
        if (not height) or (not width) then
            return self:Layout(0, 0) -- we need a value, so get one.
        end
        return width, height
    end

    return geometryTarget
end

framework.xAnchor = { left = 0, center = 0.5, right = 1 }
framework.yAnchor = { bottom = 0, center = 0.5, top = 1 }

-- Positions a rect relative to another rect, with no impact on the layout of the original rect.
function framework:RectAnchor(rectToAnchorTo, anchoredRect, xAnchor, yAnchor)
	local rectAnchor = { rectToAnchorTo = rectToAnchorTo, anchoredRect = anchoredRect, xAnchor = xAnchor, yAnchor = yAnchor, type = "RectAnchor" }

	local rectToAnchorToWidth,rectToAnchorToHeight,anchoredRectWidth,anchoredRectHeight

	function rectAnchor:Layout(availableWidth, availableHeight)
		anchoredRectWidth, anchoredRectHeight = self.anchoredRect:Layout(availableWidth, availableHeight)
		rectToAnchorToWidth, rectToAnchorToHeight = self.rectToAnchorTo:Layout(availableWidth, availableHeight)
		return rectToAnchorToWidth, rectToAnchorToHeight
	end

	function rectAnchor:Draw(x, y)
		LogDrawCall("RectAnchor")
		local rectToAnchorTo = self.rectToAnchorTo
		local anchoredRect = self.anchoredRect
		rectToAnchorTo:Draw(x, y)
		anchoredRect:Draw(x + floor((rectToAnchorToWidth - anchoredRectWidth) * self.xAnchor), y + floor((rectToAnchorToHeight - anchoredRectHeight) * self.yAnchor))
	end
	return rectAnchor
end

function framework:ConstantOffsetAnchor(rectToAnchorTo, anchoredRect, xOffset, yOffset)
	local anchor = { rectToAnchorTo = rectToAnchorTo, anchoredRect = anchoredRect, xOffset = xOffset, yOffset = yOffset }

	function anchor:Layout(availableWidth, availableHeight)
		rectToAnchorToWidth, rectToAnchorToHeight = self.rectToAnchorTo:Layout(availableWidth, availableHeight)
		anchoredRectWidth, anchoredRectHeight = self.anchoredRect:Layout(availableWidth, availableHeight)
		return rectToAnchorToWidth, rectToAnchorToHeight
	end

	function anchor:Draw(x, y)
		LogDrawCall("ConstantOffsetAnchor")
        self.rectToAnchorTo:Draw(x, y)
        self.anchoredRect:Draw(x + self.xOffset, y + self.yOffset)
	end
	return anchor
end

function framework:MarginAroundRect(rect, left, top, right, bottom, decorations, cornerRadius, shouldRasterize)
	local margin = { rect = rect, decorations = decorations or {}, cornerRadius = cornerRadius or framework:Dimension(0), 
		shouldInvalidateRasterizer = true, type = "MarginAroundRect"
	}

	local rasterizableRect
	local rasterizer

	local width, height

	local function getWidth() return width end
	local function getHeight() return height end

	if shouldRasterize then
		rasterizableRect = framework:Rect(getWidth, getHeight, cornerRadius, decorations)
		rasterizer = framework:Rasterizer(rasterizableRect)

		function margin:Draw(x, y)
			if self.shouldInvalidateRasterizer or viewportDidChange then
				rasterizableRect.cornerRadius = self.cornerRadius
				rasterizableRect.decorations = self.decorations
				rasterizer.invalidated = self.shouldInvalidateRasterizer
				self.shouldInvalidateRasterizer = false
			end
			rasterizer:Draw(x, y)

			self.rect:Draw(x + left(), y + bottom())
		end
	else
		function margin:Draw(x, y)
			local decorations = self.decorations
			for i = 1, #decorations do
				decorations[i]:Draw(self, x, y, width, height)
			end
	
			self.rect:Draw(x + left(), y + bottom())
		end
	end
	
	function margin:Layout(availableWidth, availableHeight)
		local horizontal = left() + right() -- May be more performant to do left right top bottom – not sure though
		local vertical = top() + bottom()

		local rectWidth, rectHeight = self.rect:Layout(availableWidth - horizontal, availableHeight - vertical)
		width = rectWidth + horizontal
		height = rectHeight + vertical
		return width, height
	end

	return margin
end

function framework:FrameOfReference(xAnchor, yAnchor, body)
	local frame = { xAnchor = xAnchor, yAnchor = yAnchor, body = body, type = "FrameOfReference" }

	local width, height
	local rectWidth, rectHeight

	function frame:Layout(availableWidth, availableHeight)
		rectWidth, rectHeight = self.body:Layout(availableWidth, availableHeight)
		width = availableWidth
		height = availableHeight

		return availableWidth, availableHeight
	end

	function frame:Draw(x, y)
        LogDrawCall("FrameOfReference")
		self.body:Draw(x + floor((width - rectWidth) * self.xAnchor), y + floor((height - rectHeight) * self.yAnchor))
	end

	return frame
end

------------------------------------------------------------------------------------------------------------
-- Grouping
------------------------------------------------------------------------------------------------------------

local function debugDescription(table, name, indentation)
    indentation = indentation or 0
    Spring.Echo(string.rep("| ", indentation) .. "Table: " .. tostring(name))
    for key, value in pairs(table) do
        if type(value) == "table" then
            debugDescription(value, key, indentation + 1)
        else
            Spring.Echo(string.rep("| ", indentation + 1) .. tostring(key) .. ": " .. tostring(value))
        end
    end
end

function framework:VerticalStack(contents, spacing, xAnchor)
	local verticalStack = { members = contents, xAnchor = xAnchor, spacing = spacing, type = "VerticalStack" }

	local maxWidth

	function verticalStack:Layout(availableWidth, availableHeight)

		local members = self.members
		local memberCount = #members
		
		if memberCount == 0 then
			return 0, 0
		end

		local elapsedDistance = 0
	 	maxWidth = 0
		local spacing = self.spacing()
		
		for i = 1, memberCount do
			local member = members[memberCount - (i - 1)]
			local memberWidth, memberHeight = member:Layout(availableWidth, availableHeight - elapsedDistance)
			member.vStackCachedY = elapsedDistance
			member.vStackCachedWidth = memberWidth
			elapsedDistance = elapsedDistance + memberHeight + spacing
			maxWidth = max(maxWidth, memberWidth)
		end

		return maxWidth, elapsedDistance - spacing
	end

	function verticalStack:Draw(x, y)
		local members = self.members
		local xAnchor = self.xAnchor

		for i = 1, #members do 
			local member = members[i]
			member:Draw(x + floor((maxWidth - member.vStackCachedWidth) * xAnchor), y + member.vStackCachedY)
		end
	end

	return verticalStack
end

function framework:StackInPlace(contents, xAnchor, yAnchor)
	local stackInPlace = { members = contents, xAnchor = xAnchor, yAnchor = yAnchor, type = "StackInPlace" }

	local maxWidth
	local maxHeight

	function stackInPlace:Layout(availableWidth, availableHeight)

		maxWidth = 0
		maxHeight = 0

		local members = self.members
		local memberCount = #members

		for i = 1, memberCount do 
			local member = members[i]
			local memberWidth, memberHeight = member:Layout(availableWidth, availableHeight)

			maxWidth = max(maxWidth, memberWidth)
			maxHeight = max(maxHeight, memberHeight)

			member.stackInPlaceCachedWidth = memberWidth
			member.stackInPlaceCachedHeight = memberHeight
		end

		return maxWidth, maxHeight
	end

	function stackInPlace:Draw(x, y)
		local members = self.members
		local xAnchor = self.xAnchor
		local yAnchor = self.yAnchor

		for i = 1, #members do
			local member = members[i]
			member:Draw(x + floor((maxWidth - member.stackInPlaceCachedWidth) * xAnchor), y + floor((maxHeight - member.stackInPlaceCachedHeight) * yAnchor))
		end
	end
	return stackInPlace
end

function framework:HorizontalStack(_members, spacing, yAnchor)
	local horizontalStack = { members = _members, yAnchor = yAnchor or 0.5, spacing = spacing, type = "HorizontalStack" }

	-- for _, member in pairs(members) do
	-- 	if member ~= nil then
	-- 		insert(horizontalStack.members, member)
	-- 	end
	-- end

	local maxHeight

	function horizontalStack:Layout(availableWidth, availableHeight)

		local members = self.members
		local memberCount = #members

		if memberCount == 0 then
			return 0, 0
		end

		local elapsedDistance = 0
		maxHeight = 0

		local spacing = self.spacing()

		for i = 1, memberCount do
			local member = members[i]
			local memberWidth, memberHeight = member:Layout(availableWidth - elapsedDistance, availableHeight)
			member.hStackCachedX = elapsedDistance
			member.hStackCachedHeight = memberHeight
			elapsedDistance = elapsedDistance + memberWidth + spacing
			maxHeight = max(memberHeight, maxHeight)
		end
		
		return elapsedDistance - spacing, maxHeight
	end

	function horizontalStack:Draw(x, y)
		local members = self.members
		local yAnchor = self.yAnchor

		for i = 1, #members do
			local member = members[i]
			member:Draw(x + member.hStackCachedX, y + floor((maxHeight - member.hStackCachedHeight) * yAnchor))
		end
	end
	
	return horizontalStack
end

------------------------------------------------------------------------------------------------------------
-- Performance
------------------------------------------------------------------------------------------------------------

-- NOTE: Translation is NOT COMPATIBLE WITH RESPONDERS
local emptyTable = {}
local recalculatingRasterizer = false

function framework:Rasterizer(providedBody)
	local rasterizer = { invalidated = true, type = "Rasterizer" }

	local textGroup = framework:TextGroup(providedBody)
	
	-- debug
	local framesCalculatedInARow = 0

	-- Caching
	local activeResponderCache = {}
	local drawList
	local _body = textGroup
	local width, height

	for _, event in pairs(events) do
		activeResponderCache[event] = { responders = {} }
	end

	function rasterizer:SetBody(newBody)
		textGroup:SetBody(newBody)
		invalidated = true
	end

	function rasterizer:Layout(availableWidth, availableHeight)
		if self.invalidated or not drawList or viewportDidChange then
			width, height = _body:Layout(availableWidth, availableHeight)
		end
		return width, height 
	end

	local function draw(body, ...)
		body:Draw(...)
	end

	function rasterizer:Draw(x, y)
		LogDrawCall("Rasterizer")
		if recalculatingRasterizer or framework.drawDebug then
			-- Display lists cannot be nested, so we'll skip using one while we're creating one.
			_body:Draw(x, y)
			return
		elseif self.invalidated or not drawList or viewportDidChange then
			-- Log("Recalculating rasterizer " .. self._readOnly_elementID)
			recalculatingRasterizer = true
			if framesCalculatedInARow > 0 then
				Log("Recalculated " .. (self.name or "unnamed") .. " " .. framesCalculatedInARow .. " frame(s) in a row")
			end
			LogDrawCall("Rasterizer (Recompile)")

			-- Cache responders that won't be drawn
			for _, event in pairs(events) do
				-- activeResponderCache[event].responders = {}
				clear(activeResponderCache[event].responders)
			end

			local previousResponders = activeResponders
			activeResponders = activeResponderCache

			gl_DeleteList(drawList)
			drawList = gl_CreateList(draw, _body, x, y)

			-- Reset  things
			activeResponders = previousResponders
			
			self.invalidated = false
			recalculatingRasterizer = false
			framesCalculatedInARow = framesCalculatedInARow + 1
		else
			framesCalculatedInARow = 0
		end

		for _, event in pairs(events) do
			local parentResponder = activeResponders[event]
			local childrenOfParentResponder = parentResponder.responders
			
			local cachedResponders = activeResponderCache[event].responders

			for index = 1, #cachedResponders do
				local cachedResponder = cachedResponders[index]
				insert(childrenOfParentResponder, cachedResponder)
				cachedResponder.parent = parentResponder
			end
		end

		gl_CallList(drawList)
	end

	return rasterizer
end


function clear(array)
	for index = 1, #array do
		remove(array)
	end
end
------------------------------------------------------------------------------------------------------------
-- System events
------------------------------------------------------------------------------------------------------------

function widget:Initialize()
	local viewSizeX, viewSizeY = Spring.GetViewGeometry()
	
	updateScreenEnvironment(viewSizeX, viewSizeY, relativeScaleFactor)
end

function widget:DrawScreen()
	-- startProfile("DrawScreen")
	hasCheckedElementBelowMouse = false
	elementBelowMouse = nil
	local index = #elementOrder
	while 0 < index do
		local key = elementOrder[index]
		index = index - 1
		local element = elements[key]
		activeElement = element
		activeTooltip = element
		activeResponders = element.baseResponders
		for _,responder in pairs(activeResponders) do
			clear(responder.responders)
		end
		local elementBody = element.body
		-- startProfile("Layout")
		-- for i = 0,500 do
		startProfile(key..":Layout()")
		local success, _error = pcall(elementBody.Layout, elementBody, viewportWidth, viewportHeight)
		if not success then
			Error("widget:DrawScreen", "Element: " .. key, "elementBody:Layout", _error)
			framework:RemoveElement(key)
		end
		endProfile()
		-- end
		-- endProfile()
		-- startProfile("Draw")
		-- for i = 0,500 do
		startProfile(key..":Draw()")
		local success, _error = pcall(elementBody.Draw, elementBody, 0, 0)
		if not success then
			Error("widget:DrawScreen", "Element: " .. key, "elementBody:Draw", _error)
			framework:RemoveElement(key)
		end
		endProfile()
				
		-- end
		-- endProfile()
	end
	viewportDidChange = false
	if drawDebug then
		Log("####")
		for caller, callCount in pairs(drawCalls) do
			Log(caller .. ": " .. callCount)
		end
		drawCalls = {}
	end
	-- endProfile()
end

function widget:ViewResize(viewSizeX, viewSizeY)
	if viewportWidth ~= viewSizeX or viewportHeight ~= viewSizeY then
		updateScreenEnvironment(viewSizeX, viewSizeY, relativeScaleFactor)
	end
end

------------------------------------------------------------------------------------------------------------
-- Tooltips
------------------------------------------------------------------------------------------------------------

local function FindTooltip(x, y, tooltips)
	for key,tooltip in pairs(tooltips) do
		local success, tooltipX, tooltipY, tooltipWidth, tooltipHeight = pcall(tooltip.Geometry, tooltip)
		if not success then
			-- tooltipX stores the error message in case of failure
			Error("FindTooltip", "tooltip:Geometry", "Element: " .. key, tooltipX) 
			break
		end
		if not tooltipX and tooltipY and tooltipWidth and tooltipHeight then
			Error("FindTooltip", "Element: " .. key, "Tooltip:Geometry is incomplete: " .. (tooltipX or "nil") .. ", " .. (tooltipY or "nil") .. ", " .. (tooltipWidth or "nil") .. ", " .. (tooltipHeight or "nil"))
			break
		end

		if PointIsInRect(x, y, tooltipX, tooltipY, tooltipWidth, tooltipHeight) then
			local child = FindTooltip(x, y, tooltip.tooltips)
			return child or tooltip
		end
	end
	return nil
end

function widget:GetTooltip(x, y)
	-- IsAbove is called before GetTooltip, so we can use the element found by that.
	local tooltip = FindTooltip(x, y, elementBelowMouse.tooltips)
	if not tooltip then return nil end

	return tooltip.description
	
end
function widget:TweakGetTooltip(x, y)
end

------------------------------------------------------------------------------------------------------------
-- Keyboard Events
------------------------------------------------------------------------------------------------------------

function widget:KeyPress(key, mods, isRepeat, label, unicode) end
function widget:KeyRelease(key, mods, label, unicode) end

------------------------------------------------------------------------------------------------------------
-- Mouse Events
------------------------------------------------------------------------------------------------------------

-- Finds the topmost element whose PrimaryFrame contains the given point.
local function CheckElementUnderMouse(x, y)
	if not hasCheckedElementBelowMouse then
		for _, key in ipairs(elementOrder) do
			local element = elements[key]
			local primaryFrame = element.primaryFrame
			if primaryFrame ~= nil then -- Check for pre-initialised elements.
				local success, frameX, frameY, frameWidth, frameHeight = pcall(primaryFrame.Geometry, primaryFrame)
				if not success then
					-- frameX contains the error if this fails
					Error("CheckUnderMouse", "Element: " .. key, "PrimaryFrame:Geometry", frameX)
					break
				end
				if not (frameX and frameY and frameWidth and frameHeight) then
					Error("CheckUnderMouse", "Element: " .. key, "PrimaryFrame:Geometry is incomplete: " .. (frameX or "nil") .. ", " .. (frameY or "nil") .. ", " .. (frameWidth or "nil") .. ", " .. (frameHeight or "nil"))
					break
				end
				if PointIsInRect(x, y, frameX, frameY, frameWidth, frameHeight) then
					elementBelowMouse = element
					return true
				end
			end
		end
	end

	return elementBelowMouse ~= nil
end

-- Attempts to call an action on a responder, then recursively calls Event on the parent (if one exists) in the case of failure. 
local function Event(responder, ...)
	local success, result = pcall(responder.action, responder, ...)
	if not success then
		-- in case of failure, result stores the error message
		Error("Event", "responder:action", result)
		return nil
	elseif result then
		return responder
	else
		local parent = responder.parent
		if parent ~= nil then
			return Event(parent, ...)
		end
	end
end

-- Calls an action on the top-most responder containing the specified point, failingover to its parent responder. Returns the responder that calls the action.
local function SearchDownResponderTree(responder, x, y, ...)
	for _,childResponder in pairs(responder.responders) do
		local success, responderX, responderY, responderWidth, responderHeight = pcall(childResponder.Geometry, childResponder)
		if not success then
			-- responderX contains the error if this fails
			Error("Element: " .. key, "childResponder:Geometry", responderX)
			break
		end
		if not (responderX and responderY and responderWidth and responderHeight) then
			Error("Element: " .. key, "childResponder:Geometry is incomplete: " .. (responderX or "nil") .. ", " .. (responderY or "nil") .. ", " .. (responderWidth or "nil") .. ", " .. (responderHeight or "nil"))
			break
		end

		if PointIsInRect(x, y, responderX, responderY, responderWidth, responderHeight) then
			local favouredResponder = SearchDownResponderTree(childResponder, x, y, ...)
			if favouredResponder then
				return favouredResponder
			else
				return Event(childResponder, x, y, ...)
			end
		end
	end
	return nil
end

-- Calls the base responder for a given event on the current element below mouse. 
local function FindResponder(event, x, y, ...)
	return SearchDownResponderTree(elementBelowMouse.baseResponders[event], x, y, ...)
end

-- Normal mode

-- Alias for performance reasons; do not modify
local mousePressEvent = events.mousePress
function widget:MousePress(x, y, button)
	if not CheckElementUnderMouse(x, y) then
		for _, key in ipairs(elementOrder) do
			local element = elements[key]
			local success, errorMessage = pcall(element.deselect)
			if not success then
				Error("widget:MousePress", "Element: " .. key, "element.deslect", errorMessage)
			end
		end
		return false
	end
	return FindResponder(mousePressEvent, x, y, button)
end

function widget:MouseMove(x, y, dx, dy, button)
	local dragListener = dragListeners[button]
	if dragListener ~= nil then
		local success, errorMessage = pcall(dragListener.MouseMove, dragListener, x, y, dx, dy)
		if not success then
			Error("widget:MouseMove", "dragListener:MouseMove", errorMessage)
		end
	end
end

function widget:MouseRelease(x, y, button)
	local dragListener = dragListeners[button]
	if dragListener then
		local success, errorMessage = pcall(dragListener.MouseRelease, dragListener, x, y)
		if not success then
			Error("widget:MouseRelease", "dragListener:MouseRelease", errorMessage)
		end
		dragListeners[button] = nil
	end
	return false
end

local mouseWheelEvent = events.mouseWheel
function widget:MouseWheel(up, value)
	if elementBelowMouse then
		local frame = elementBelowMouse.primaryFrame
		return FindResponder(mouseWheelEvent, frame.cachedX, frame.cachedY)
	else
		return false
	end
end

local watcherID = 0
-- Tracks which responders the mouse cursor is above along the entire responder chain, and notifies them
-- when the cursor enters and leaves their bounds.
function framework:IsAboveWatcher()
	local object = { id = watcherID }
	local lastResponderBelow

	watcherID = watcherID + 1

	local nestedWatcher

	-- Updates the last responder below, and the nested watcher.
	function object:Update(responderUnderMouse, x, y)

		if lastResponderBelow then
			if (not responderUnderMouse) or (responderUnderMouse.id ~= lastResponderBelow.id) then
				local success, errorMessage = pcall(lastResponderBelow.MouseLeave, lastResponderBelow)
				if not success then
					Error("IsAboveWatcher:Update", "lastResponderBelow:MouseLeave", errorMessage)
				end
				nestedWatcher:Reset()
				nestedWatcher = nil
			end
		end

		if responderUnderMouse then
			if (not lastResponderBelow) or (lastResponderBelow.id ~= responderUnderMouse.id) then
				local success, errorMessage = pcall(responderUnderMouse.MouseEnter, responderUnderMouse)
				if not success then
					Error("IsAboveWatcher:Update", "responderUnderMouse:MouseEnter", errorMessage)
				end
				nestedWatcher = framework:IsAboveWatcher()
			end
			nestedWatcher:Bubble(responderUnderMouse, x, y)
		end

		lastResponderBelow = responderUnderMouse
	end

	-- Recursively searches for another responder that might handle the event, and triggers the events.
	function object:Bubble(responder, x, y)
		if responder and responder.parent then
			local responderUnderMouse = Event(responder.parent, x, y)
			self:Update(responderUnderMouse, x, y)
		else
			self:Reset()
		end
	end

	-- Locates the most deeply nested responder, and begins watching it.
	function object:Search(responder, x, y)
		self:Update(SearchDownResponderTree(responder, x, y), x, y)
	end

	-- Informs the watcher there is no responder to watch.
	function object:Reset()
		if lastResponderBelow then
			local success, errorMessage = pcall(lastResponderBelow.MouseLeave, lastResponderBelow)
			if not success then
				Error("IsAboveWatcher:Reset", "lastResponderBelow:MouseLeave", errorMessage)
			end
		end
		self:Update(nil, nil, nil)
	end

	return object
end

local isAboveThing = framework:IsAboveWatcher()

local mouseOverEvent = events.mouseOver
local isAbove
local isAboveChecked = false
function widget:IsAbove(x, y)
	if isAboveChecked then return end
	-- startProfile("IsAbove")
	local isAbove
	-- for i=0,1000 do
		isAbove = CheckElementUnderMouse(x, y)
		if isAbove then
			isAboveThing:Search(elementBelowMouse.baseResponders[mouseOverEvent], x, y)
		else
			isAboveThing:Reset()
		end
	-- end
	-- endProfile()
	isAboveChecked = true
	return isAbove
end
function widget:Update()
	-- widget:IsAbove seems to be called multiple times a frame. To mitigate this, we'll call it once per function we *know* is called once per frame - in this case, Update().
	-- (It might be slightly more optimal (re performance) to call it in DrawScreen, but putting it in Update allows us to keep it right here where it's easy to read.)
	isAboveChecked = false
end

-- Tweak mode 

function widget:TweakMousePress(x, y, button) end
function widget:TweakMouseMove(x, y, dx, dy, button) end
function widget:TweakMouseRelease(x, y, button) end
function widget:TweakMouseWheel(up, value) end
function widget:TweakIsAbove(x, y) return widget:IsAbove(x, y) end

------------------------------------------------------------------------------------------------------------
-- Joystick events
------------------------------------------------------------------------------------------------------------

-- function widget:JoyAxis(axis,value) end
-- function widget:JoyHat(hat, value) end
-- function widget:JoyButtonDown(button, state) end
-- function widget:JoyButtonUp(button, state) end