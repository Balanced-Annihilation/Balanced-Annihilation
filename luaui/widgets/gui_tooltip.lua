
function widget:GetInfo()
	return {
		name      = "Tooltip",
		desc      = "Shows tooltips",
		author    = "Floris",
		date      = "April 2017",
		license   = "GNU GPL, v2 or later",
		layer     = -9999999999,
		enabled   = true,  --  loaded by default?
	}
end

------------------------------------------------------------------------------------
-- Info
------------------------------------------------------------------------------------
--[[

-- Availible API functions:
WG['tooltip'].AddTooltip(name, area, value, delay, x, y)  -- area: {x1,y1,x2,y2}   value: 'text'   delay(optional): #seconds   x/y(optional): display coordinates
WG['tooltip'].RemoveTooltip(name)

WG['tooltip'].ShowTooltip(name, value, x, y)    -- x/y (optional): display coordinates

You can use 'AddTooltip' to add a screen area that will display a tooltip when you hover over it

Use 'ShowTooltip' to directly show a tooltip, the name you give should be unique, and not one you desined in 'AddTooltip'
(the name will be deleted after use)

]]--
------------------------------------------------------------------------------------
-- Config
------------------------------------------------------------------------------------

local vsx,vsy = Spring.GetViewGeometry()

local defaultDelay = 0.4
local cfgFontSize = 14

local xOffset = 35
local yOffset = -xOffset

local fontfile ="LuaUI/Fonts/FreeSansBold.otf"

local widgetScale = 1
local usedFontSize = cfgFontSize

------------------------------------------------------------------------------------
-- Speedups
------------------------------------------------------------------------------------

local glColor = gl.Color
local glText = gl.Text
local glRect = gl.Rect
local glTranslate = gl.Translate

local spGetModKeyState = Spring.GetModKeyState
local spGetMouseState = Spring.GetMouseState
local spTraceScreenRay = Spring.TraceScreenRay
local spGetTooltip = Spring.GetCurrentTooltip

local math_floor = math.floor
local math_ceil = math.ceil

local vsx, vsy = Spring.GetViewGeometry()
local ui_scale = 1

local tooltips = {}

------------------------------------------------------------------------------------
-- Functions
------------------------------------------------------------------------------------

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

	local offset = 0.15		-- texture offset, because else gaps could show

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

function widget:Initialize()
	widget:ViewResize()
	init()
end

function widget:Shutdown()
	if WG['guishader'] then
        for name, tooltip in pairs(tooltips) do
		    WG['guishader'].DeleteScreenDlist('tooltip_'..name)
        end
	end
	WG['tooltip'] = nil
end

function init()
	widgetScale = (1+((vsy-850)/900)) * (0.95+(ui_scale-1)/2.5)
	usedFontSize = cfgFontSize * widgetScale
	yOffset = -xOffset-usedFontSize

    if WG['tooltip'] == nil then
        WG['tooltip'] = {}
        WG['tooltip'].AddTooltip = function(name, area, value, delay)
			if (value ~= nil and area[1]~=nil and area[2]~=nil and area[3]~=nil and area[4]~=nil) or tooltips[name] ~= nil and tooltips[name].value ~= nil then
                if delay == nil then delay = defaultDelay end
                if tooltips[name] == nil then
					tooltips[name] = {}
				end
				tooltips[name].area = area
				tooltips[name].delay = delay
                if value ~= nil then
                    tooltips[name].value = tostring(value)
                end
            end
        end
        WG['tooltip'].RemoveTooltip = function(name)
            if tooltips[name] ~= nil then
                tooltips[name] = nil
            end
        end
        WG['tooltip'].ShowTooltip = function(name, value, x, y)
            if value ~= nil then
                tooltips[name] = {value=tostring(value) }
                if x ~= nil and y ~= nil then
                    tooltips[name].pos = {x,y}
                end
            end
        end
    end
end

local uiSec = 0
function widget:Update(dt)
	uiSec = uiSec + dt
	if uiSec > 0.5 then
		uiSec = 0
		if ui_scale ~= 1 then
			ui_scale = 1
			widget:ViewResize(vsx,vsy)
		end
	end
end

function widget:ViewResize(x,y)
	vsx,vsy = Spring.GetViewGeometry()

	local fontfile ="LuaUI/Fonts/FreeSansBold.otf"
local vsx,vsy = Spring.GetViewGeometry()
local fontfileScale = (0.7 + (vsx*vsy / 7000000))
local fontfileSize = 44
local fontfileOutlineSize = 8
local fontfileOutlineStrength = 1.3
 font = gl.LoadFont(fontfile, fontfileSize*fontfileScale, fontfileOutlineSize*fontfileScale, fontfileOutlineStrength)

	init()
end


function IsOnRect(x, y, BLcornerX, BLcornerY,TRcornerX,TRcornerY)
	return x >= BLcornerX and x <= TRcornerX and y >= BLcornerY and y <= TRcornerY
end


function lines(str)
  local t = {}
  local function helper(line) t[#t+1]=line return "" end
  helper((str:gsub("(.-)\r?\n", helper)))
  return t
end


function drawTooltip(name, x, y)
	--Spring.Echo('Showing tooltip:  '..name)

	local paddingH = math_floor(9.5 * widgetScale)
	local paddingW = math_floor(paddingH * 1.42)
	local posX = math_floor(x + paddingW)
	local posY = math_floor(y + paddingH)

	local fontSize = math_floor(usedFontSize)
	local maxWidth = 0
	local maxHeight = 0
	local lineHeight = fontSize + (fontSize/4.5)
	local lines = lines(tooltips[name].value)

	-- get text dimentions
	for i, line in ipairs(lines) do
		maxWidth = math_ceil(math.max(maxWidth, (font:GetTextWidth(line)*fontSize)))
		maxHeight = math_ceil(maxHeight + lineHeight)
	end
	-- adjust position when needed
	if posX+maxWidth+paddingW+paddingW > vsx then
		posX = math_floor(posX - maxWidth - paddingW - paddingW - (xOffset*widgetScale*2))
	end
	if posX - paddingW < 0 then
		posX = 0 + paddingW
	end
	if posY + paddingH > vsy then
		posY = (posY - (posY - vsy)) - paddingH
	end
	if posY-maxHeight-paddingH-paddingH < 0 then
		posY = 0 + maxHeight + paddingH + paddingH
	end

	-- draw background
	local cornersize = 0
	--glColor(0.45,0.45,0.45,(WG['guishader'] and 0.66 or 0.8))
	RectRound(posX-paddingW+cornersize, posY-maxHeight-paddingH+cornersize, posX+maxWidth+paddingW-cornersize, posY+paddingH-cornersize, 3.3*widgetScale, 2,2,2,2, {0.44,0.44,0.44,(WG['guishader'] and 0.67 or 0.94)}, {0.66,0.66,0.66 ,(WG['guishader'] and 0.67 or 0.94)})
	if WG['guishader'] then
		WG['guishader'].InsertScreenDlist( gl.CreateList( function()
			RectRound(posX-paddingW+cornersize, posY-maxHeight-paddingH+cornersize, posX+maxWidth+paddingW-cornersize, posY+paddingH-cornersize, 3.3*widgetScale)
		end), 'tooltip_'..name)
	end
	cornersize = math_floor(2.4*widgetScale)
	--glColor(0,0,0,(WG['guishader'] and 0.22 or 0.26))
	RectRound(posX-paddingW+cornersize,
		posY-maxHeight-paddingH+cornersize,
		posX+maxWidth+paddingW-cornersize,
		posY+paddingH-cornersize-0.06,
		2.2*widgetScale,
		2,2,2,2, {0,0,0,(WG['guishader'] and 0.5 or 0.55)}, {0.15,0.15,0.15,(WG['guishader'] and 0.5 or 0.55)})

	-- draw text
	maxHeight = math_floor(-fontSize*0.93)
	glTranslate(posX, posY, 0)
	font:Begin()
	--font:SetTextColor(0.95,0.95,0.95,1)
	--font:SetOutlineColor(0.3,0.3,0.3,0.3)
	for i, line in ipairs(lines) do
		font:Print('\255\244\244\244'..line, 0, maxHeight, fontSize, "o")
		maxHeight = maxHeight - lineHeight
	end
	font:End()
	glTranslate(-posX, -posY, 0)
end

local cleanupGuishaderAreas = {}
function widget:RecvLuaMsg(msg, playerID)
	if msg:sub(1,18) == 'LobbyOverlayActive' then
		chobbyInterface = (msg:sub(1,19) == 'LobbyOverlayActive1')
	end
end

function widget:DrawScreen()
	if chobbyInterface then return end
	if (WG['topbar'] and WG['topbar'].showingQuit()) then
		return
	end
	local x, y = spGetMouseState()
	local now = os.clock()

	if WG['guishader'] then
		for name, _ in pairs(cleanupGuishaderAreas) do
			WG['guishader'].DeleteScreenDlist(name)
			cleanupGuishaderAreas[name] = nil
		end
	end
	for name, tooltip in pairs(tooltips) do
		if tooltip.area == nil or (tooltip.area[4]~= nil and IsOnRect(x, y, tooltip.area[1], tooltip.area[2], tooltip.area[3], tooltip.area[4])) then
			if tooltip.area == nil then
                if tooltip.pos ~= nil then
				    drawTooltip(name, tooltip.pos[1], tooltip.pos[2])
                else
                    drawTooltip(name, x + (xOffset*widgetScale), y + (yOffset*widgetScale))
                end
				tooltips[name] = nil
				cleanupGuishaderAreas['tooltip_'..name] = true
			else
				if tooltip.displayTime == nil then
					tooltip.displayTime = now + tooltip.delay
				elseif tooltip.displayTime <= now then
                    if tooltip.pos ~= nil then
                        drawTooltip(name, tooltip.pos[1], tooltip.pos[2])
                    else
                        drawTooltip(name, x + (xOffset*widgetScale), y + (yOffset*widgetScale))
                    end
				end
			end
		else
			if tooltip.displayTime ~= nil then
				tooltip.displayTime = nil
				if WG['guishader'] then
					WG['guishader'].DeleteScreenDlist('tooltip_'..name)
				end
			end
		end
	end
end


