
if addon.InGetInfo then
	return {
		name    = "Main",
		desc    = "displays a simplae loadbar",
		author  = "jK",
		date    = "2012,2013",
		license = "GPL2",
		layer   = 0,
		depend  = {"LoadProgress"},
		enabled = true,
	}
end

------------------------------------------

local showTips = false


local lastLoadMessage = ""

function addon.LoadProgress(message, replaceLastLine)
	lastLoadMessage = message
end

------------------------------------------



local titleColor = "\255\215\255\215"
local contentColor = "\255\255\255\255"


-- Since math.random is not random and always the same, we save a counter to a file and use that.
filename = "LuaUI/Config/randomseed.data"
k = os.time() % 1500
if VFS.FileExists(filename) then
	k = tonumber(VFS.LoadFile(filename))
	if not k then k = 0 end
end
k = k + 1
local file = assert(io.open(filename,'w'), "Unable to save latest randomseed from "..filename)
    file:write(k)
    file:close()
file = nil


local loadedFontSize = 70
local font = gl.LoadFont("FreeSansBold.otf", 70, 22, 1.15)

local lastLoadMessage = ""
local lastProgress = {0, 0}

local progressByLastLine = {
	["Parsing Map Information"] = {0, 20},
	["Loading Weapon Definitions"] = {20, 40},
	["Loading LuaRules"] = {40, 60},
	["Loading LuaUI"] = {60, 80},
	["Finalizing"] = {80, 99}
}
for name,val in pairs(progressByLastLine) do
	progressByLastLine[name] = {val[1]*0.01, val[2]*0.01}
end

function addon.LoadProgress(message, replaceLastLine)
	lastLoadMessage = message
	if message:find("Path") then -- pathing has no rigid messages so cant use the table
		lastProgress = {0.91, 1.0}
	end
	lastProgress = progressByLastLine[message] or lastProgress
end

function addon.DrawLoadScreen()
	local loadProgress = SG.GetLoadProgress()
	if loadProgress == 0 then
		loadProgress = lastProgress[1]
	else
		loadProgress = math.min(math.max(loadProgress, lastProgress[1]), lastProgress[2])
	end

	local vsx, vsy = gl.GetViewSizes()

	-- draw progressbar
	local hbw = 3.5/vsx
	local vbw = 3.5/vsy
	local hsw = 0.4
	local vsw = 0.4
	local yPos =  0.09 --0.054
	local yPosTips = yPos + 0.1245
	local loadvalue = 0.09 + (math.max(0, loadProgress) * 0.819)

	if not showTips then
		yPos = 0.165
		yPosTips = yPos
	end

	--bar bg
	local paddingH = 0.004
	local paddingW = paddingH * (vsy/vsx)
	Spring.Draw.Rectangle(0.09-paddingW, yPos-0.05-paddingH, 0.91+paddingW, yPosTips+paddingH, {color={0.085,0.085,0.085,0.925}, radius=0.007})
	Spring.Draw.Rectangle(0.09-paddingW, yPos-0.05-paddingH, 0.91+paddingW, yPos+paddingH, {color={0,0,0,0.75}, radius=0.007})

    if loadvalue > 0.215 then
	-- loadvalue
	Spring.Draw.Rectangle(0.09, yPos-0.05, loadvalue, yPos, {color={0.4-(loadProgress/7),loadProgress*0.4,0,0.4}, radius=0.0055})

        -- loadvalue gradient
        gl.Texture(false)
	gl.Blending("modulate")
	local c1 = {0,0,0,0.14}
	local c2 = {1-(loadProgress/3)+0.09,loadProgress+0.09,0.08,0.14}
	Spring.Draw.Rectangle(0.09, yPos-0.05, loadvalue, yPos, {colors={c1,c2,c2,c1}})
	gl.Blending("reset")

        -- loadvalue inner glow
	local gc = {1-(loadProgress/3.5)+0.15,loadProgress+0.15,0+0.05}
        gl.Texture(":n:luaui/Images/barglow-center.png")
	Spring.Draw.Rectangle(0.09, yPos-0.05, loadvalue, yPos, {color={gc[1],gc[2],gc[3],0.04}})

        -- loadvalue glow
        local glowSize = 0.06
        gl.Texture(":n:luaui/Images/barglow-center.png")
	Spring.Draw.Rectangle(0.09, yPos-0.05-glowSize, loadvalue, yPos+glowSize, {color={gc[1],gc[2],gc[3],0.1}})

        gl.Texture(":n:luaui/Images/barglow-edge.png")
	Spring.Draw.Rectangle(0.09-(glowSize*1.3), yPos-0.05-glowSize, 0.09, yPos+glowSize, {color={gc[1],gc[2],gc[3],0.1}})
	Spring.Draw.Rectangle(loadvalue+(glowSize*1.3), yPos-0.05-glowSize, loadvalue, yPos+glowSize, {color={gc[1],gc[2],gc[3],0.1}, texcoords="xflip"})
    end

	-- progressbar text
		local barTextSize = vsy * 0.026

		--font:Print(lastLoadMessage, vsx * 0.5, vsy * 0.3, 50, "sc")
		--font:Print(Game.gameName, vsx * 0.5, vsy * 0.95, vsy * 0.07, "sca")
		font:Print(lastLoadMessage, vsx * 0.11, vsy * (yPos-0.017), barTextSize * 0.67, "oa")
		if loadProgress>0 then
			font:Print(("%.0f%%"):format(loadProgress * 99), vsx * 0.5, vsy * (yPos-0.0325), barTextSize, "oc")
		else
			font:Print("Loading...", vsx * 0.5, vsy * (yPos-0.031), barTextSize, "oc")
		end
end


function addon.MousePress(...)
	--Spring.Echo(...)
end


function addon.Shutdown()
	gl.DeleteFont(font)
end
