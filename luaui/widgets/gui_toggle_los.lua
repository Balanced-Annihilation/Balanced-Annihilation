function widget:GetInfo()
	return {
		name		= "toggle los button",
		desc		= "toggles specfullview, located next to advplayerlist",
		author		= "Floris",
		date		= "24 july 2016",
		license		= "GNU GPL, v2 or later",
		layer		= -3,
		enabled		= true,
		hidden		= true,
	}
end

local iconTexture = ":n:"..LUAUI_DIRNAME.."Images/mapmarksfx/eye.png"
local iconSize = 16

local glTranslate				= gl.Translate
local glPushMatrix          	= gl.PushMatrix
local glPopMatrix				= gl.PopMatrix

local glCreateList				= gl.CreateList
local glDeleteList				= gl.DeleteList
local glCallList				= gl.CallList

local drawlist = {}
local xPos = 0
local yPos = 0

local mouseover = false

local usedImgSize = iconSize

local isSpec = Spring.GetSpectatingState()
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

local function RectQuad(px,py,sx,sy)
	local o = 0.008		-- texture offset, because else grey line might show at the edges
	gl.TexCoord(o,1-o)
	gl.Vertex(px, py, 0)
	gl.TexCoord(1-o,1-o)
	gl.Vertex(sx, py, 0)
	gl.TexCoord(1-o,o)
	gl.Vertex(sx, sy, 0)
	gl.TexCoord(o,o)
	gl.Vertex(px, sy, 0)
end

function DrawRect(px,py,sx,sy)
	gl.BeginEnd(GL.QUADS, RectQuad, px,py,sx,sy)
end

local function createList(size)
	if drawlist[1] ~= nil then
		glDeleteList(drawlist[1])
	end
	drawlist[1] = glCreateList( function()
		gl.Texture(iconTexture)
		DrawRect(-usedImgSize, 0, 0, usedImgSize)
		gl.Texture(false)
	end)
end

local advplayerlistPos = {}
function updatePosition(force)
	if WG['advplayerlist_api'] ~= nil then
		local prevPos = advplayerlistPos
		advplayerlistPos = WG['advplayerlist_api'].GetPosition()		-- returns {top,left,bottom,right,widgetScale}
		usedImgSize = iconSize * advplayerlistPos[5]
		xPos = advplayerlistPos[2] - (5.3*advplayerlistPos[5])
		yPos = advplayerlistPos[3]
		if advplayerlistPos[3] < 0 then
			yPos = 0
		end
		yPos = yPos + (4*advplayerlistPos[5])
		yPos = yPos + usedImgSize + usedImgSize/4
		if (prevPos[1] == nil or prevPos[1] ~= advplayerlistPos[1] or prevPos[2] ~= advplayerlistPos[2] or prevPos[5] ~= advplayerlistPos[5]) or force then
			createList(usedImgSize)
		end
	end
end

function widget:Initialize()
	WG.togglelos = {}
	updatePosition(true)
end

function widget:Shutdown()
	if drawlist[1] ~= nil then
		glDeleteList(drawlist[1])
	end
	WG.togglelos = nil
end

local sec = 0
function widget:Update(dt)
	sec = sec + dt
	if sec > 0.5 then
		sec = 0
		updatePosition()
	end
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

function widget:DrawScreen()

	if drawlist[1] ~= nil and isSpec then
		local mx,my = Spring.GetMouseState()
		glPushMatrix()
			glTranslate(xPos, yPos, 0)
				if isInBox(mx, my, {xPos-usedImgSize, yPos, xPos, yPos+usedImgSize}) then
					--Spring.SetMouseCursor('cursornormal')
					gl.Color(1,1,1,1)
				else
					gl.Color(1,1,1,0.66)
				end
			glCallList(drawlist[1])
		glPopMatrix()
	end
end

function isInBox(mx, my, box)
    return mx > box[1] and my > box[2] and mx < box[3] and my < box[4]
end

function widget:MousePress(mx, my, mb)
	if mb == 1 and isInBox(mx, my, {xPos-usedImgSize, yPos, xPos, yPos+usedImgSize}) then
		return true
	end
end

function widget:MouseRelease(mx, my, mb)
	if mb == 1 and isInBox(mx, my, {xPos-usedImgSize, yPos, xPos, yPos+usedImgSize}) then
		Spring.SendCommands("specfullview")
		Spring.SendCommands("togglelos")
		updatePosition(true)
	end
end
