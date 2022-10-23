--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--	file: gui_musicPlayer.lua
--	brief:	yay music
--	author:	cake
--
--	Copyright (C) 2007.
--	Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name	= "AdvPlayersList Game Info",
		desc	= "Displays current gametime, fps and gamespeed",
		author	= "Floris",
		date	= "april 2017",
		license	= "GNU GPL, v2 or later",
		layer	= -3,
		enabled	= true,	--	loaded by default?
	}
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local fontfile ="LuaUI/Fonts/FreeSansBold.otf"

local ui_opacity =  0.66
local ui_scale = 1
local glossMult = 1 + (2-(ui_opacity))	-- increase gloss/highlight so when ui is transparant, you can still make out its boundaries and make it less flat

local widgetScale = 1
local glPushMatrix   = gl.PushMatrix
local glPopMatrix	   = gl.PopMatrix
local glColor        = gl.Color
local glCreateList   = gl.CreateList
local glDeleteList   = gl.DeleteList
local glCallList     = gl.CallList

local glBlending = gl.Blending
local GL_SRC_ALPHA = GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local GL_ONE = GL.ONE

local drawlist = {}
local advplayerlistPos = {}
local widgetHeight = 22
local top, left, bottom, right = 0,0,0,0

local isSpec = Spring.GetSpectatingState()
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Initialize()
	widget:ViewResize()
	updatePosition()
	WG['displayinfo'] = {}
	WG['displayinfo'].GetPosition = function()
		return {top,left,bottom,right,widgetScale}
	end
	Spring.SendCommands("fps 0")
	Spring.SendCommands("clock 0")
	Spring.SendCommands("speed 0")
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

local gameMaxUnits = math.min(Spring.GetModOptions().maxunits, math.floor(32000 / #Spring.GetTeamList()))

local function updateValues()

	local textsize = 11*widgetScale
	local textYPadding = 8*widgetScale
	local textXPadding = 10*widgetScale

	if drawlist[2] ~= nil then
		glDeleteList(drawlist[2])
	end
	drawlist[2] = glCreateList( function()
		local _,gamespeed,_ = Spring.GetGameSpeed()
		gamespeed = string.format("%.2f", gamespeed)
		local fps = Spring.GetFPS()
		local titleColor = '\255\180\180\180'
		local valueColor = '\255\180\180\180'
		local gameframe = Spring.GetGameFrame()
		local minutes = math.floor((gameframe / 30 / 60))
		local seconds = math.floor((gameframe - ((minutes*60)*30)) / 30)
		if seconds == 0 then
			seconds = '00'
		elseif seconds < 10 then
			seconds = '0'..seconds
		end
		local time = minutes..':'..seconds

        font:Begin()
		font:Print(valueColor..time, left+textXPadding, bottom+(0.3*widgetHeight*widgetScale), textsize, 'no')
		local extraSpacing = 0
		if minutes > 99 then
			extraSpacing = 1.34
		elseif minutes > 9 then
			extraSpacing = 0.7
		end
		local myTeamId = Spring.GetMyTeamID()
		local totalUnits = gameMaxUnits - Spring.GetTeamUnitCount(myTeamId)
		
		local fpsDigits = math.floor(math.log10(fps)+1)
		if(not isSpec) then
		if(fpsDigits >= 3) then
			if(totalUnits<101)then
				font:Print(titleColor..' x'..valueColor..gamespeed..titleColor..'      fps '..valueColor..fps..'      unit '..valueColor.."\255\255\001\001"..totalUnits.."\255\255\001\001", left+textXPadding+(textsize*(3.2+extraSpacing)), bottom+(0.3*widgetHeight*widgetScale), textsize, 'no')
			else
				font:Print(titleColor..' x'..valueColor..gamespeed..titleColor..'      fps '..valueColor..fps, left+textXPadding+(textsize*(3.2+extraSpacing)), bottom+(0.3*widgetHeight*widgetScale), textsize, 'no')
			end
		else
			if(totalUnits<101)then
				font:Print(titleColor..' x'..valueColor..gamespeed..titleColor..'      fps '..valueColor..fps..'        unit '..valueColor.."\255\255\001\001"..totalUnits.."\255\255\001\001", left+textXPadding+(textsize*(3.2+extraSpacing)), bottom+(0.3*widgetHeight*widgetScale), textsize, 'no')
			else
				font:Print(titleColor..' x'..valueColor..gamespeed..titleColor..'      fps '..valueColor..fps, left+textXPadding+(textsize*(3.2+extraSpacing)), bottom+(0.3*widgetHeight*widgetScale), textsize, 'no')
			end
		end
		else
				font:Print(titleColor..' x'..valueColor..gamespeed..titleColor..'      fps '..valueColor..fps, left+textXPadding+(textsize*(3.2+extraSpacing)), bottom+(0.3*widgetHeight*widgetScale), textsize, 'no')
		end
		font:End()
    end)
end

function widget:GameStart()
	myPlayerID = Spring.GetMyPlayerID()
	if Spring.GetSpectatingState() then
		isSpec = true
	else
		isSpec = false
	end
end

function widget:PlayerChanged(playerID)
	if Spring.GetGameFrame() > 0 then
		if playerID == myPlayerID then
			if Spring.GetSpectatingState() then
				isSpec = true
			end
		end
	end
end

local function createList()
	if drawlist[3] ~= nil then
		glDeleteList(drawlist[3])
	end
	
	if drawlist[1] ~= nil then
		glDeleteList(drawlist[1])
	end
	drawlist[1] = glCreateList( function()
		--glColor(0, 0, 0, ui_opacity)
		RectRound(left, bottom, right, top, bgpadding*1.6, ui_opacity,0,0,0, {0,0,0,ui_opacity}, {0,0,0,ui_opacity}, {0,0,0,ui_opacity})

		local borderPadding = bgpadding
		local borderPaddingRight = borderPadding
		if right >= vsx-0.2 then
			borderPaddingRight = 0
		end
		local borderPaddingLeft = borderPadding
		if left <= 0.2 then
			borderPaddingLeft = 0
		end
		glColor(0,0,0,ui_opacity)
		--RectRound(left+borderPaddingLeft, bottom, right-borderPaddingRight, top-borderPadding, bgpadding, 1,1,1,1, {0.3,0.3,0.3,ui_opacity*0.1}, {1,1,1,ui_opacity*0.1})

		-- gloss
		--glBlending(GL_SRC_ALPHA, GL_ONE)
		--RectRound(left+borderPaddingLeft, top-borderPadding-((top-bottom)*0.35), right-borderPaddingRight, top-borderPadding, bgpadding, 1,1,0,0, {1,1,1,0.01*glossMult}, {1,1,1,0.055*glossMult})
		--RectRound(left+borderPaddingLeft, bottom, right-borderPaddingRight, bottom+((top-bottom)*0.35), bgpadding, 0,0,1,1, {1,1,1,0.025*glossMult},{1,1,1,0})
		--glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	end)
	updateValues()
end


function widget:Shutdown()
	
	for i=1,#drawlist do
		glDeleteList(drawlist[i])
	end
	Spring.SendCommands("fps 1")
	Spring.SendCommands("clock 1")
	Spring.SendCommands("speed 1")
	WG['displayinfo'] = nil
end


local passedTime = 0
local passedTime2 = 0
local uiOpacitySec = 0.5
function widget:Update(dt)

	uiOpacitySec = uiOpacitySec + dt
	if uiOpacitySec > 0.5 then
		uiOpacitySec = 0
		if ui_scale ~= 1 then
			ui_scale =1
			widget:ViewResize()
		end
		uiOpacitySec = 0
		if ui_opacity ~= 0.66 then
			ui_opacity = 0.66
			glossMult = 1 + (2-(ui_opacity*2))
			createList()
		end
	end
	passedTime = passedTime + dt
	passedTime2 = passedTime2 + dt
	if passedTime > 0.1 then
		passedTime = passedTime - 0.1
		updatePosition()
	end
	if passedTime2 > 1 then
		updateValues()
		passedTime2 = passedTime2 - 1
	end
end


function updatePosition(force)
	if (WG['advplayerlist_api'] ~= nil) then
		local prevPos = advplayerlistPos
		if WG['unittotals'] ~= nil then
			advplayerlistPos = WG['unittotals'].GetPosition()		-- returns {top,left,bottom,right,widgetScale}
		else
			advplayerlistPos = WG['advplayerlist_api'].GetPosition()		-- returns {top,left,bottom,right,widgetScale}
		end
		if advplayerlistPos[5] ~= nil then
			left = advplayerlistPos[2]
			bottom = advplayerlistPos[1]
			right = advplayerlistPos[4]
			top = math.ceil(advplayerlistPos[1]+(widgetHeight*advplayerlistPos[5]))
			widgetScale = advplayerlistPos[5]
			if (prevPos[1] == nil or prevPos[1] ~= advplayerlistPos[1] or prevPos[2] ~= advplayerlistPos[2] or prevPos[5] ~= advplayerlistPos[5]) or force then
				createList()
			end
		end
	end
end

function widget:ViewResize(newX,newY)
	local prevVsx, prevVsy = vsx, vsy
	vsx, vsy = Spring.GetViewGeometry()

	local fontfile ="LuaUI/Fonts/FreeSansBold.otf"
local vsx,vsy = Spring.GetViewGeometry()
local fontfileScale = (0.7 + (vsx*vsy / 7000000))
local fontfileSize = 44
local fontfileOutlineSize = 8
local fontfileOutlineStrength = 1.3
 font = gl.LoadFont(fontfile, fontfileSize*fontfileScale, fontfileOutlineSize*fontfileScale, fontfileOutlineStrength)

	local widgetSpaceMargin = math.floor(0.0045 * vsy * ui_scale) / vsy
	bgpadding = math.ceil(widgetSpaceMargin * 0.66 * vsy)

	if prevVsy ~= vsx or prevVsy ~= vsy then
		updateValues()
	end
end



function widget:DrawScreen()

	if drawlist[1] ~= nil then
		glPushMatrix()
			glCallList(drawlist[1])
			glCallList(drawlist[2])
		glPopMatrix()
	end
end
