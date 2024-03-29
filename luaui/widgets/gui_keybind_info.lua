
function widget:GetInfo()
return {
	name    = "Keybind/Mouse Info",
	desc    = "Provides information on the controls",
	author  = "Bluestone",
	date    = "April 2015",
	license = "Mouthwash",
	layer   = -1,
	enabled = true,
}
end

local loadedFontSize = 32
local font = gl.LoadFont(LUAUI_DIRNAME.."Fonts/FreeSansBold.otf", loadedFontSize, 16,2)

local bgcorner = ":n:"..LUAUI_DIRNAME.."Images/bgcorner.png"
local closeButtonTex = ":n:"..LUAUI_DIRNAME.."Images/close.dds"

local bgMargin = 6

local closeButtonSize = 30
local screenHeight = 520-bgMargin-bgMargin
local screenWidth = 1050-bgMargin-bgMargin

local customScale = 1

local spIsGUIHidden = Spring.IsGUIHidden
local showHelp = false

local glColor = gl.Color
local glLineWidth = gl.LineWidth
local glPolygonMode = gl.PolygonMode
local glRect = gl.Rect
local glText = gl.Text
local glShape = gl.Shape
local glGetTextWidth = gl.GetTextWidth
local glGetTextHeight = gl.GetTextHeight

local bgColorMultiplier = 0

local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList

local glPopMatrix = gl.PopMatrix
local glPushMatrix = gl.PushMatrix
local glTranslate = gl.Translate
local glScale = gl.Scale

local GL_FILL = GL.FILL
local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK
local GL_LINE_STRIP = GL.LINE_STRIP

local widgetScale = 1
local vsx, vsy = Spring.GetViewGeometry()

local vsx,vsy = Spring.GetViewGeometry()
local screenX = (vsx*0.5) - (screenWidth/2)
local screenY = (vsy*0.5) + (screenHeight/2)
  
function widget:ViewResize()
  vsx,vsy = Spring.GetViewGeometry()
  screenX = (vsx*0.5) - (screenWidth/2)
  screenY = (vsy*0.5) + (screenHeight/2)
  widgetScale = (0.75 + (vsx*vsy / 7500000)) * customScale
  if keybinds then gl.DeleteList(keybinds) end
  keybinds = gl.CreateList(DrawWindow)
end

local myTeamID = Spring.GetMyTeamID()
local amNewbie = (Spring.GetTeamRulesParam(myTeamID, 'isNewbie') == 1)
local gameStarted = (Spring.GetGameFrame()>0)
function widget:GameStart()
    gameStarted = true
end

-- button
local textSize = 0.75
local textMargin = 0.25
local lineWidth = 0.0625

local posX = 0
local posY = 0
local showOnceMore = false
local buttonGL
local startPosX = posX

local function DrawRectRound(px,py,sx,sy,cs, tl,tr,br,bl)
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
	
	-- bottom left
	if ((py <= 0 or px <= 0)  or (bl ~= nil and bl == 0)) and bl ~= 2   then o = 0.5 else o = offset end
	gl.TexCoord(o,o)
	gl.Vertex(px, py, 0)
	gl.TexCoord(o,1-o)
	gl.Vertex(px+cs, py, 0)
	gl.TexCoord(1-o,1-o)
	gl.Vertex(px+cs, py+cs, 0)
	gl.TexCoord(1-o,o)
	gl.Vertex(px, py+cs, 0)
	-- bottom right
	if ((py <= 0 or sx >= vsx) or (br ~= nil and br == 0)) and br ~= 2   then o = 0.5 else o = offset end
	gl.TexCoord(o,o)
	gl.Vertex(sx, py, 0)
	gl.TexCoord(o,1-o)
	gl.Vertex(sx-cs, py, 0)
	gl.TexCoord(1-o,1-o)
	gl.Vertex(sx-cs, py+cs, 0)
	gl.TexCoord(1-o,o)
	gl.Vertex(sx, py+cs, 0)
	-- top left
	if ((sy >= vsy or px <= 0) or (tl ~= nil and tl == 0)) and tl ~= 2   then o = 0.5 else o = offset end
	gl.TexCoord(o,o)
	gl.Vertex(px, sy, 0)
	gl.TexCoord(o,1-o)
	gl.Vertex(px+cs, sy, 0)
	gl.TexCoord(1-o,1-o)
	gl.Vertex(px+cs, sy-cs, 0)
	gl.TexCoord(1-o,o)
	gl.Vertex(px, sy-cs, 0)
	-- top right
	if ((sy >= vsy or sx >= vsx)  or (tr ~= nil and tr == 0)) and tr ~= 2   then o = 0.5 else o = offset end
	gl.TexCoord(o,o)
	gl.Vertex(sx, sy, 0)
	gl.TexCoord(o,1-o)
	gl.Vertex(sx-cs, sy, 0)
	gl.TexCoord(1-o,1-o)
	gl.Vertex(sx-cs, sy-cs, 0)
	gl.TexCoord(1-o,o)
	gl.Vertex(sx, sy-cs, 0)
end
function RectRound(px,py,sx,sy,cs, tl,tr,br,bl)		-- (coordinates work differently than the RectRound func in other widgets)
	gl.Texture(bgcorner)
	gl.BeginEnd(GL.QUADS, DrawRectRound, px,py,sx,sy,cs, tl,tr,br,bl)
	gl.Texture(false)
end


function DrawButton()
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
	RectRound(0,0,4,1.05,0.25, 2,2,0,0)
	local vertices = {
		{v = {0, 1, 0}},
		{v = {0, 0, 0}},
		{v = {1, 0, 0}},
	}
	glShape(GL_LINE_STRIP, vertices)
    glText("Keybinds", textMargin, textMargin, textSize, "no")
end

-- keybind info

include("configs/BA_HotkeyInfo.lua")
local bindColor			= "\255\255\210\070"
local titleColor		= "\255\254\254\254"
local descriptionColor	= "\255\192\190\180"

function DrawTextTable(t,x,y)
    local j = 0
    local height = 0
    local width = 0
    for _,t in pairs(t) do
      if t.blankLine then
        -- nothing here
      elseif t.title then
        -- title line
        local title = t[1] or ""
        local line = " " .. titleColor .. title -- a WTF whitespace is needed here, the colour doesn't show without it...
        gl.Text(line, x+4, y-((13)*j)+5, 14)
		screenWidth = math.max(glGetTextWidth(line)*13,screenWidth)
      else
        -- keybind line
        local bind = string.upper(t[1]) or ""
        local effect = t[2] or ""
        local line = " " .. bindColor .. bind .. "   " .. descriptionColor .. effect
        gl.Text(line, x+14, y-(13)*j, 11)
		width = math.max(glGetTextWidth(line)*11,width)
      end
      height = height + 13
      
	  j = j + 1
    end
    --screenHeight = math.max(screenHeight, height)
    --screenWidth = screenWidth + width
    return x,j
end

function DrawWindow()
    local vsx,vsy = Spring.GetViewGeometry()
    local x = screenX --rightwards
    local y = screenY --upwards
    
	-- background
    gl.Color(0,0,0,0.8)
	RectRound(x-bgMargin,y-screenHeight-bgMargin,x+screenWidth+bgMargin,y+bgMargin,8, 0,1,1,1)
	-- content area
	gl.Color(0.33,0.33,0.33,0.15)
	RectRound(x,y-screenHeight,x+screenWidth,y,8)
	
    gl.Color(1,1,1,1)
	gl.Texture(closeButtonTex)
	gl.TexRect(screenX+screenWidth-closeButtonSize,screenY,screenX+screenWidth,screenY-closeButtonSize)
	gl.Texture(false)
	
	
	-- title background
    local title = "Keybinds"
    local titleFontSize = 18
    gl.Color(0,0,0,0.8)
    titleRect = {x-bgMargin, y+bgMargin, x-bgMargin+(glGetTextWidth(title)*titleFontSize)+27, y+37}
	RectRound(titleRect[1], titleRect[2], titleRect[3], titleRect[4], 8, 1,1,0,0)
	-- title
	font:Begin()
	font:SetTextColor(1,1,1,1)
	font:SetOutlineColor(0,0,0,0.4)
	font:Print(title, x-bgMargin+(titleFontSize*0.75), y+bgMargin+8, titleFontSize, "on")
	font:End()
	
    DrawTextTable(General,x,y-24)
    x = x + 350
    DrawTextTable(Units_I_II,x,y-24)
    x = x + 350
    DrawTextTable(Units_III,x,y-24)
	
    gl.Color(1,1,1,1)
    gl.Text("Binds can be modified in Spring/LuaUI/widgets/cmd_BA_hotkeys.lua or Spring/uikeys.txt", screenX+12, y-screenHeight + 14, 12.5)
end


function widget:DrawScreen()
    if spIsGUIHidden() then return end
    if amNewbie and not gameStarted then return end
    
    -- draw the button
    --if not buttonGL then
    --    buttonGL = gl.CreateList(DrawButton)
    --end
    
    --glLineWidth(lineWidth)
	
    --glPushMatrix()
    --    glTranslate(posX*vsx, posY*vsy, 0)
     ---   glScale(17*widgetScale, 17*widgetScale, 1)
	--	glColor(0, 0, 0, (0.3*bgColorMultiplier))
     --   glCallList(buttonGL)
    --glPopMatrix()

    glColor(1, 1, 1, 1)
    glLineWidth(1)
    
    -- draw the help
    if not keybinds then
        keybinds = gl.CreateList(DrawWindow)
    end
    
    if show or showOnceMore then
		glPushMatrix()
			glTranslate(-(vsx * (widgetScale-1))/2, -(vsy * (widgetScale-1))/2, 0)
			glScale(widgetScale, widgetScale, 1)
			glCallList(keybinds)
		glPopMatrix()
		
		showOnceMore = false
   
	end
end

function IsOnRect(x, y, BLcornerX, BLcornerY,TRcornerX,TRcornerY)
	
	-- check if the mouse is in a rectangle
	return x >= BLcornerX and x <= TRcornerX
	                      and y >= BLcornerY
	                      and y <= TRcornerY
end


function widget:MousePress(x, y, button)
	return mouseEvent(x, y, button, false)
end

function widget:MouseRelease(x, y, button)
	return mouseEvent(x, y, button, true)
end

function mouseEvent(x, y, button, release)
	if spIsGUIHidden() then return false end
    if amNewbie and not gameStarted then return end
    
    if show then 
			-- on window
			local rectX1 = ((screenX-bgMargin) * widgetScale) - ((vsx * (widgetScale-1))/2)
			local rectY1 = ((screenY+bgMargin) * widgetScale) - ((vsy * (widgetScale-1))/2)
			local rectX2 = ((screenX+screenWidth+bgMargin) * widgetScale) - ((vsx * (widgetScale-1))/2)
			local rectY2 = ((screenY-screenHeight-bgMargin) * widgetScale) - ((vsy * (widgetScale-1))/2)
			if IsOnRect(x, y, rectX1, rectY2, rectX2, rectY1) then
				
				-- on close button
				rectX1 = rectX2 - ((closeButtonSize+bgMargin+bgMargin) * widgetScale)
				rectY2 = rectY1 - ((closeButtonSize+bgMargin+bgMargin) * widgetScale)
				if IsOnRect(x, y, rectX1, rectY2, rectX2, rectY1) then
					if release then
						showOnceMore = true		-- show once more because the  lags behind, though this will not fully fix it
						show = not show
					end
					return true
				end
				return true
			elseif titleRect == nil or not IsOnRect(x, y, (titleRect[1] * widgetScale) - ((vsx * (widgetScale-1))/2), (titleRect[2] * widgetScale) - ((vsy * (widgetScale-1))/2), (titleRect[3] * widgetScale) - ((vsx * (widgetScale-1))/2), (titleRect[4] * widgetScale) - ((vsy * (widgetScale-1))/2)) then
				if release then
					showOnceMore = show		-- show once more because the  lags behind, though this will not fully fix it
					show = not show
				end
				return true
			end
	    else
			
			--tx = (x - posX*vsx)/(17*widgetScale)
			--ty = (y - posY*vsy)/(17*widgetScale)
			--if tx < 0 or tx > 4 or ty < 0 or ty > 1.05 then return false end
			--if release then
			--	showOnceMore = show		-- show once more because the  lags behind, though this will not fully fix it
			--	show = not show
			--end
			--return true
    end
end

function widget:Initialize()

	WG['keybinds'] = {}
	WG['keybinds'].toggle = function(state)
		if state ~= nil then
			show = state
		else
			show = not show
		end
	end
	WG['keybinds'].isvisible = function()
		return show
	end
	widget:ViewResize()
end

function widget:Shutdown()
    if buttonGL then
        glDeleteList(buttonGL)
        buttonGL = nil
    end
    if keybinds then
        glDeleteList(keybinds)
        keybinds = nil
    end
end
