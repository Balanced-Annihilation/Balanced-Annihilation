function widget:GetInfo()
	return {
	name      = "Red Console", --version 4.1
	desc      = "Requires Red UI Framework",
	author    = "Regret",
	date      = "29 may 2015",
	license   = "GNU GPL, v2 or later",
	layer     = 1000,
	enabled   = true, --enabled by default
	handler   = true, --can use widgetHandler:x()
	}
end
local NeededFrameworkVersion = 8
local CanvasX,CanvasY = 1280,734 --resolution in which the widget was made (for 1:1 size)
--1272,734 == 1280,768 windowed
local SoundIncomingChat  = 'sounds/beep4.wav'
local SoundIncomingChatVolume = 1.0

local gameOver = false
local lastConnectionAttempt = ''
--todo: dont cut words apart when clipping text 

local spGetTimer = Spring.GetTimer
local spDiffTimers = Spring.DiffTimers
local inittime

local clock = os.clock
local slen = string.len
local ssub = string.sub
local sgsub = string.gsub
local sfind = string.find
local sformat = string.format
local schar = string.char
local mfloor = math.floor
local sbyte = string.byte
local sreverse = string.reverse
local mmax = math.max
local glGetTextWidth = gl.GetTextWidth
local sGetPlayerRoster = Spring.GetPlayerRoster
local sGetTeamColor = Spring.GetTeamColor
local sGetMyAllyTeamID = Spring.GetMyAllyTeamID
local sGetModKeyState = Spring.GetModKeyState
local spPlaySoundFile = Spring.PlaySoundFile
local sGetMyPlayerID = Spring.GetMyPlayerID
local myname = Spring.GetPlayerInfo(sGetMyPlayerID())

local Confignew = {
	console = {
		px = 400,py = 36, --default start position
		sx = 460, --background size
	
		
		fontsize = 11.33,
		
		minlines = 1, --minimal number of lines to display
		maxlines = 6,
		maxlinesScrollmode = 10,
		
		maxage = 30, --max time for a message to be displayed, in seconds
		
		margin = 6, --distance from background border
		
		fadetime = 0.25, --fade effect time, in seconds
		fadedistance = 100, --distance from cursor at which console shows up when empty
		
		filterduplicates = true, --group identical lines, f.e. ( 5x Nickname: blahblah)
		
		--note: transparency for text not supported yet
		cothertext = {1,1,1,1}, --normal chat color
		callytext = {0,1,0,1}, --ally chat
		cspectext = {1,1,0,1}, --spectator chat
		
		cotherallytext = {1,0.5,0.5,1}, --enemy ally messages (seen only when spectating)
		cmisctext = {0.78,0.78,0.78,1}, --everything else
		cgametext = {0.4,1,1,1}, --server (autohost) chat
		
		cbackground = {0,0,0,0.19},
		cborder = {0,0,0,0},
		
		dragbutton = {2,3}, --middle mouse button
		tooltip = {
			background ="",
			--"In CTRL+F11 mode:  Hold \255\255\255\1middle mouse button\255\255\255\255 to drag the console.\n"..
			--"- Press \255\255\255\1CTRL\255\255\255\255 while mouse is above the \nconsole to activate chatlog viewing.\n"..
			--"- Use mousewheel (+hold \255\255\255\1SHIFT\255\255\255\255 for speedup)\n to scroll through the chatlog.",
		},
	},
}


local function IncludeRedUIFrameworkFunctions()
	New = WG.Red.New(widget)
	Copy = WG.Red.Copytable
	SetTooltip = WG.Red.SetTooltip
	GetSetTooltip = WG.Red.GetSetTooltip
	Screen = WG.Red.Screen
	GetWidgetObjects = WG.Red.GetWidgetObjects
end

local function RedUIchecks()
	local color = "\255\255\255\1"
	local passed = true
	if (type(WG.Red)~="table") then
		Spring.Echo(color..widget:GetInfo().name.." requires Red UI Framework.")
		passed = false
	elseif (type(WG.Red.Screen)~="table") then
		Spring.Echo(color..widget:GetInfo().name..">> strange error.")
		passed = false
	elseif (WG.Red.Version < NeededFrameworkVersion) then
		Spring.Echo(color..widget:GetInfo().name..">> update your Red UI Framework.")
		passed = false
	end
	if (not passed) then
		widgetHandler:ToggleWidget(widget:GetInfo().name)
		return false
	end
	IncludeRedUIFrameworkFunctions()
	return true
end

local function AutoResizeObjects() --autoresize v2
	if (LastAutoResizeX==nil) then
		LastAutoResizeX = CanvasX
		LastAutoResizeY = CanvasY
	end
	local lx,ly = LastAutoResizeX,LastAutoResizeY
	local vsx,vsy = Screen.vsx,Screen.vsy
	if ((lx ~= vsx) or (ly ~= vsy)) then
		local objects = GetWidgetObjects(widget)
		local scale = vsx/lx
		local skippedobjects = {}
		for i=1,#objects do
			local o = objects[i]
			local adjust = 0
			if ((o.movableslaves) and (#o.movableslaves > 0)) then
				adjust = (o.px*scale+o.sx*scale)-vsx
				if (((o.px+o.sx)-lx) == 0) then
					o._moveduetoresize = true
				end
			end
			if (o.px) then o.px = o.px * scale end
			if (o.py) then o.py = o.py * scale end
			if (o.sx) then o.sx = o.sx * scale end
			if (o.sy) then o.sy = o.sy * scale end
			if (o.fontsize) then o.fontsize = o.fontsize * scale end
			if (adjust > 0) then
				o._moveduetoresize = true
				o.px = o.px - adjust
				for j=1,#o.movableslaves do
					local s = o.movableslaves[j]
					s.px = s.px - adjust/scale
				end
			elseif ((adjust < 0) and o._moveduetoresize) then
				o._moveduetoresize = nil
				o.px = o.px - adjust
				for j=1,#o.movableslaves do
					local s = o.movableslaves[j]
					s.px = s.px - adjust/scale
				end
			end
		end
		LastAutoResizeX,LastAutoResizeY = vsx,vsy
	end
end


local function createconsole(r)
	local vars = {}
	
	local lines = {"text",
		px=r.px+r.margin,py=r.py+r.margin,
		fontsize=r.fontsize,
		caption="",
		options="o", --black outline
	}
	
	local activationarea = {"area",
		px=r.px-r.fadedistance,py=r.py-r.fadedistance,
		sx=r.sx+r.fadedistance*2,sy=0,
		
		mousewheel=function(up,mx,my,self)
			if (vars.browsinghistory) then
				local alt,ctrl,meta,shift = Spring.GetModKeyState()
				local step = 1
				if (shift) then
					step = 5
				end
				if (vars.historyoffset == nil) then
					vars.historyoffset = 0
				end
				if (up) then
					vars.historyoffset = vars.historyoffset + step
					vars._forceupdate = true
				else
					vars.historyoffset = vars.historyoffset - step
					vars._forceupdate = true
				end
				if (vars.historyoffset > (#vars.consolehistory - r.maxlines)) then
					vars.historyoffset = #vars.consolehistory - r.maxlines
				elseif (vars.historyoffset < 0) then
					vars.historyoffset = 0
				end
			end
		end,
	}

	local background = {"rectanglerounded",
		px=r.px,py=r.py,
		sx=r.sx,sy=r.maxlines*r.fontsize+r.margin*2,
		color=r.cbackground,
		border=r.cborder,
		movable=r.dragbutton,
		
		obeyscreenedge = true,
		--overrideclick = {2},
		
		movableslaves={lines,activationarea},
		
		effects = {
			fadein_at_activation = r.fadetime,
			fadeout_at_deactivation = r.fadetime,
		},
	}
	
	activationarea.onupdate=function(self)
		local fadedistance = (self.sx-background.sx)/2
		self.sy = background.sy+fadedistance*2
		self.px = background.px-fadedistance
		self.py = background.py-fadedistance
		
		if (not self._mousenotover ) then
		
		
			local alt,ctrl,meta,shift = Spring.GetModKeyState()
			if(ctrl) then	
			background.active = nil --activate
			if (vars._empty) then
				background.sy = (r.minlines*lines.fontsize + (lines.px-background.px)*2)
			end
			if (ctrl and not vars.browsinghistory) then
				if (vars._skipagecheck == nil) then
					vars._forceupdate = true
					vars.nextupdate = -1
					vars.browsinghistory = true
					vars.historyoffset = 0
					
					self.overridewheel = true
				end
				vars._skipagecheck = true
				vars._usecounters = false
			end
		else
			if (vars._skipagecheck ~= nil) then
				vars._forceupdate = true
				vars.browsinghistory = nil
				vars.historyoffset = 0
				
				self.overridewheel = nil
				vars._skipagecheck = nil
				vars._usecounters = nil
			end
		end
		end
		
		self._mousenotover = nil
	end
	activationarea.mousenotover=function(mx,my,self)
		self._mousenotover = true
		if (vars._empty) then
			background.active = false
		end
	end
	
	New(activationarea)
	New(background)
	New(lines)
	
	local counters = {}
	for i=1,r.maxlines do
		local b = New(lines)
		b.onupdate = function(self)
			self.px = background.px - self.getwidth() - (lines.px-background.px)
		end
		b._count = 0
		b.active = false
		b.py = b.py+(i-1)*r.fontsize
		counters[#counters+1] = b
		table.insert(background.movableslaves,b)
	end
	
	--tooltip
	background.mouseover = function(mx,my,self) SetTooltip(r.tooltip.background) end
	
	background.active = nil
	
	return {
		["background"] = background,
		["lines"] = lines,
		["counters"] = counters,
		["vars"] = vars
	}
end

local function lineColour(prevline) -- search prevline and find the final instance of a colour code

	local prevlineReverse = sreverse(prevline)
	local newlinecolour = ""
	
	local colourCodePosReverse = sfind(prevlineReverse, "\255") --search string from back to front

	if colourCodePosReverse then
		for i = 0,2 do
			if ssub(prevlineReverse, colourCodePosReverse + 3 - i, colourCodePosReverse + 3 - i) == "\255" then
				colourCodePosReverse = colourCodePosReverse + 3 - i
				break
			end
		end

		local colourCodePos = slen(prevline) - colourCodePosReverse + 1 	
		if slen(ssub(prevline, colourCodePos)) >= 4 then
			newlinecolour = ssub(prevline, colourCodePos, colourCodePos+3)
		end
	end	

	return newlinecolour
end

local function clipLine(line,fontsize,maxwidth)
	local clipped = {}
		
	local firstclip = line:len()
	local firstpass = true
	while (1) do --loops over lines
		local linelen = slen(line)
		local i=1
		while (1) do -- loop through potential positions where we might need to clip
			if (glGetTextWidth(ssub(line,1,i+1))*fontsize > maxwidth) then
				local test = line
				local newlinecolour = ""
				
				-- set colour of new clipped line
				if firstpass == nil then
					newlinecolour = lineColour(clipped[#clipped])
				end
				
				local newline = newlinecolour .. ssub(test,1,i)
				
				clipped[#clipped+1] = newline
				line = ssub(line,i+1)
	
				if (firstpass) then
					firstclip = i
					firstpass = nil
				end
				
				break
			end
			i=i+1
			if (i > linelen) then
				break
			end
		end
		
		-- check if we need to clip again
		local width = glGetTextWidth(line)*fontsize
		if (width <= maxwidth) then
			break
		end
	end
	
	-- put remainder of line into final clipped line
	local newlinecolour = ""
	if #clipped > 0 then 
		newlinecolour = lineColour(clipped[#clipped])
	end
	clipped[#clipped+1] = newlinecolour .. line
	
	return clipped,firstclip
end

local function clipHistory(g,oneline)
	local history = g.vars.consolehistory
	local maxsize = g.background.sx - (g.lines.px-g.background.px)
	
	local fontsize = g.lines.fontsize
	
	if (oneline and #history > 0) then
		local line = history[#history] or {}
		local lines,firstclip = clipLine(line[1],fontsize,maxsize)	
		line[1] = ssub(line[1],1,firstclip)
		for i=1,#lines do
			if (i>1) then
				history[#history+1] = {line[4]..lines[i],line[2],line[3],line[4],line[5]}
			end
		end
	else
		local clippedhistory = {}
		for i=1,#history do
			local line = history[i]
			local lines,firstclip = clipLine(line[1],fontsize,maxsize)
			lines[1] = ssub(line[1],1,firstclip)
			for i=1,#lines do
				if (i>1) then
					clippedhistory[#clippedhistory+1] = {line[4]..lines[i],line[2],line[3],line[4],line[5]}
				else
					clippedhistory[#clippedhistory+1] = {lines[i],line[2],line[3],line[4],line[5]}
				end
			end
		end
		g.vars.consolehistory = clippedhistory
	end
end

local function convertColor(r,g,b)

if tonumber(Spring.GetModOptions().anon_ffa) == 1 then --is fa

				return schar(255, (90), (255), (90))

			else
				return schar(255, (r*255), (g*255), (b*255))

			end

end

local function convertColorSpec(r,g,b)
	return schar(255, (r*255), (g*255), (b*255))
end


local pauseelapsed = false
local function processLine(line,g,cfg,newlinecolor)
	if (g.vars.browsinghistory) then
		if (g.vars.historyoffset == nil) then
			g.vars.historyoffset = 0
		end
		g.vars.historyoffset = g.vars.historyoffset + 1
	end
	
	g.vars.nextupdate = 0

	local roster = sGetPlayerRoster()

	
	local names = {}
	for i=1,#roster do
		names[roster[i][1]] = {roster[i][4],roster[i][5],roster[i][3],roster[i][2]}
	end
	
	local name = ""
	local text = ""
	local linetype = 0 --other
	
	local ignoreThisMessage = false
	

	
	if (not newlinecolor) then
		if (names[ssub(line,2,(sfind(line,"> ") or 1)-1)] ~= nil) then
			linetype = 1 --playermessage
			name = ssub(line,2,sfind(line,"> ")-1)
			text = ssub(line,slen(name)+4)
		elseif (names[ssub(line,2,(sfind(line,"] ") or 1)-1)] ~= nil) then
			linetype = 2 --spectatormessage
			name = ssub(line,2,sfind(line,"] ")-1)
			text = ssub(line,slen(name)+4)
		elseif (names[ssub(line,2,(sfind(line,"(replay)") or 3)-3)] ~= nil) then
			linetype = 2 --spectatormessage
			name = ssub(line,2,sfind(line,"(replay)")-3)
			text = ssub(line,slen(name)+13)
		elseif (names[ssub(line,1,(sfind(line," added point: ") or 1)-1)] ~= nil) then
			linetype = 3 --playerpoint
			name = ssub(line,1,sfind(line," added point: ")-1)
			text = ssub(line,slen(name.." added point: ")+1)
		elseif (ssub(line,1,1) == ">") then
			linetype = 4 --gamemessage
			text = ssub(line,3)
            if ssub(line,1,3) == "> <" then --player speaking in battleroom
                local i = sfind(ssub(line,4,slen(line)), ">")
                name = ssub(line,4,i+2)
            end
		end		
    end
	
	
		
if sfind(line,"style camera") then --	if sfind(line," Connection established") then
	  ignoreThisMessage = true

	  if sfind(line," FPS") then
	  	
		widgetHandler:DisableWidget("SmoothCam")
		widgetHandler:DisableWidget("Top Bar")
		widgetHandler:DisableWidget("Order menu alternative")
		widgetHandler:DisableWidget("Build menu alternative")
		if (not Spring.IsGUIHidden()) then
			Spring.SendCommands("ResBar")
		end
	  else
		value = Spring.GetConfigInt("smoothcam", 1)

		if (value == 1) then
			widgetHandler:EnableWidget("SmoothCam")
		end
		widgetHandler:EnableWidget("Top Bar")
		widgetHandler:EnableWidget("Order menu alternative")
		widgetHandler:EnableWidget("Build menu alternative")
		if (Spring.IsGUIHidden()) then
			Spring.SendCommands("ResBar")
		end
	end
elseif sfind(line,"rror:") then --	if sfind(line,"Error:") then
	  ignoreThisMessage = true
	elseif sfind(line,"r::P") then --	smooth camera
	  ignoreThisMessage = true
	elseif sfind(line,"rver=") then --	if sfind(line,"server=") then
	  ignoreThisMessage = true
	elseif sfind(line,"^Set \"shadows\" config(-)parameter to ") then
		ignoreThisMessage = true
	elseif sfind(line,"ceback:") then --	if sfind(line,"stack traceback:") then
	  ignoreThisMessage = true
	elseif sfind(line,"^Connection att") then --	if sfind(line,"^Connection attempt from ") then
		name = ssub(line,25)
		lastConnectionAttempt = name
	  ignoreThisMessage = true
	
	elseif sfind(line," Connection est") then --	if sfind(line," Connection established") then
		name = lastConnectionAttempt
	  ignoreThisMessage = true
	elseif sfind(line," ct password") then --	if sfind(line," Connection established") then
		name = lastConnectionAttempt
	  ignoreThisMessage = true
	
	elseif sfind(line,"ient=") then-- if sfind(line,"client=") then
	  ignoreThisMessage = true
	
	elseif sfind(line,"cTeamA") then 	--if sfind(line,"SpecTeamAction") then
	  ignoreThisMessage = true
	
	elseif sfind(line,"t_select") then --	if sfind(line,"smart_select") then
	  ignoreThisMessage = true
	
	
	elseif sfind(line,"mpt rej") then --	Connection attempt rejected from ::ffff:186.227.58.214: Unpack failure (type)
	  ignoreThisMessage = true
	
	
	elseif sfind(line,"bled!") then --	model shaders is enabled!
	  ignoreThisMessage = true
	
	
	elseif sfind(line,"%.lua") then --	Removed: widget.lua disbaled
	  ignoreThisMessage = true
	
	
	--if sfind(line,"->") then 
	--	name = lastConnectionAttempt
	--  ignoreThisMessage = true
	--
	
	elseif sfind(line,"-> User is n") then  -- "Spectator " normal quit remove spectator quit spam
	  ignoreThisMessage = true
	
	elseif sfind(line,"cmdcolors.tmp") then --
	  ignoreThisMessage = true
	elseif sfind(line,"normal quit") then  -- "Spectator " normal quit remove spectator quit spam
	  ignoreThisMessage = true
	elseif sfind(line,"water rend") then  -- "Spectator " normal quit remove spectator quit spam
	  ignoreThisMessage = true
	
	elseif sfind(line,"n attempt fr") then -- Reconnection attempt from/ reconnection attemp reestablish??
	  ignoreThisMessage = true
	elseif sfind(line,"shed (id") then -- connection restablished
	  ignoreThisMessage = true
	elseif sfind(line,"not authorized") then -- User name not authorized to connect
	  ignoreThisMessage = true
	elseif sfind(line,"rlap redu") then --
	  ignoreThisMessage = true

	elseif sfind(line,"not reconnect") then  -- User can not reconnect
	  ignoreThisMessage = true
	elseif ((tonumber(Spring.GetConfigInt("ProfanityFilter",1) or 1) == 1) ) then --filter rude words
		local line2 = string.lower(line)
	   if sfind(line2,"cunt") or sfind(line2," fuc")or sfind(line2,"nigg")or sfind(line2,"tard")or sfind(line2,"bitch") or sfind(line2,"shit")or sfind(line2,"fag")or sfind(line2,"autis")or sfind(line2,"rape")or sfind(line2,"dick")or sfind(line2,"penis")or sfind(line2,"pussy")or sfind(line2,"porn")or sfind(line2,"sex")or sfind(line2,"gay")or sfind(line2,"homo")or sfind(line2,"cancer") then
				ignoreThisMessage = true
		end
   end
	
	
	if linetype==0 then
		--filter out some engine messages; 
		--2 lines (instead of 4) appears when player connects
		if sfind(line,'-> Version') or sfind(line,'ClientReadNet') or sfind(line,'Address') then
			ignoreThisMessage = true
		end

        if sfind(line,"Wrong network version") then
            local n,_ = sfind(line,"Message")
            if n ~= nil then
				line = ssub(line,1,n-3) --shorten so as these messages don't get clipped and can be detected as duplicates
			end
        end

		
		if gameOver then
			if sfind(line,'left the game') then
				ignoreThisMessage = true
			end
		end
	end
	

	--ignore messages from muted--
	if WG.ignoredPlayers and WG.ignoredPlayers[name] then 
		ignoreThisMessage = true 
		--Spring.Echo ("blocked message by " .. name)
	end
	
	local MyAllyTeamID = sGetMyAllyTeamID()
	local textcolor = nil
	
    local playSound = false
	if (linetype==1) then --playermessage
		local c = cfg.cothertext
		local misccolor = convertColor(c[1],c[2],c[3])
		if (sfind(text,"Allies: ") == 1) then
			text = ssub(text,9)
			if (names[name][1] == MyAllyTeamID) then
				c = cfg.callytext
			else
				c = cfg.cotherallytext
			end
		elseif (sfind(text,"Spectators: ") == 1) then
			text = ssub(text,13)
			c = cfg.cspectext
		end
		
		textcolor = convertColorSpec(c[1],c[2],c[3])
		local r,g,b,a = sGetTeamColor(names[name][3])
		local namecolor = convertColor(r,g,b)
		
		line = namecolor..name..misccolor..": "..textcolor..text
        
        playSound = true
		
	elseif (linetype==2) then --spectatormessage
		local c = cfg.cothertext
		local misccolor = convertColorSpec(c[1],c[2],c[3])
		if (sfind(text,"Allies: ") == 1) then
			text = ssub(text,9)
			c = cfg.cspectext
		elseif (sfind(text,"Spectators: ") == 1) then
			text = ssub(text,13)
			c = cfg.cspectext
		end
		textcolor = convertColorSpec(c[1],c[2],c[3])
		c = cfg.cspectext
		local namecolor = convertColorSpec(c[1],c[2],c[3])
		
		line = namecolor.."(s) "..name..misccolor..": "..textcolor..text
		
        playSound = true
        
	elseif (linetype==3) then --playerpoint
		local c = cfg.cspectext
		local namecolor = convertColor(c[1],c[2],c[3])
		
		local spectator = true
		if (names[name] ~= nil) then
			spectator = names[name][2]
		end
		if (spectator) then
            name = "(s) "..name
		else
            local r,g,b,a = sGetTeamColor(names[name][3])
            namecolor =  convertColor(r,g,b)
		end
		
		c = cfg.cotherallytext
		if (spectator) then
			c = cfg.cspectext
		elseif (names[name][1] == MyAllyTeamID) then
			c = cfg.callytext
		end
		textcolor = convertColorSpec(c[1],c[2],c[3])
		c = cfg.cothertext
		local misccolor = convertColorSpec(c[1],c[2],c[3])
		
		line = namecolor..name..misccolor.." * "..textcolor..text
		
	elseif (linetype==4) then --gamemessage
		local c = cfg.cgametext
		textcolor = convertColorSpec(c[1],c[2],c[3])
		
		line = textcolor.."> "..text
	else --every other message
	
		if (pauseelapsed or (Spring.GetGameSeconds() >0) or (spDiffTimers(spGetTimer(),inittime) > 13)) then
		pauseelapsed = true
		else
		ignoreThisMessage = true
		end
		
		local c = cfg.cmisctext
		textcolor = convertColorSpec(c[1],c[2],c[3])
		line = textcolor..line
	end
	
	if (g.vars.consolehistory == nil) then
		g.vars.consolehistory = {}
	end
	local history = g.vars.consolehistory	


	if (not ignoreThisMessage) then		--mute--
		local lineID = #history+1	
		history[#history+1] = {line,clock(),lineID,textcolor,linetype}
        
		if tonumber(Spring.GetConfigInt("chatsound",1) or 1) == 1 then
        if ( playSound ) then
            spPlaySoundFile( SoundIncomingChat, SoundIncomingChatVolume, nil, "ui" )
        end
		end
	end

	return history[#history]
end


local function updateconsole(g,cfg)
	local forceupdate = g.vars._forceupdate
	local justforcedupdate = g.vars._justforcedupdate
	
	if (forceupdate and (not justforcedupdate)) then
		g.vars._justforcedupdate = true
		g.vars._forceupdate = nil
	else
		g.vars._justforcedupdate = nil
		g.vars._forceupdate = nil
		
		if (g.vars.nextupdate == nil) then
			g.vars.nextupdate = 0
		end
		if ((g.vars.nextupdate < 0) or (clock() < g.vars.nextupdate)) then
			return
		end
	end
	
	local skipagecheck = g.vars._skipagecheck
	local usecounters = g.vars._usecounters
	
	local maxlines = cfg.maxlines
	
	local historyoffset = 0
	if (g.vars.browsinghistory) then
		if (g.vars.historyoffset == nil) then
			g.vars.historyoffset = 0
		end
		historyoffset = g.vars.historyoffset
		maxlines = cfg.maxlinesScrollmode
	end
	
	if (usecounters == nil) then
		usecounters = cfg.filterduplicates
	end

	
	local counters = {}
	for i=1,maxlines do
		counters[i] = 1
		if g.counters[i] == nil then
			g.counters[i] = {}
		end
		g.counters[i].active = false
		g.counters[i].caption = ""
	end
	
	local maxage = cfg.maxage
	local display = ""
	local count = 0
	local i=0
	local lastID = 0
	local lastLine = ""
	
	local history = g.vars.consolehistory or {}

	while (count < maxlines) do
		if (history[#history-i-historyoffset]) then
			local line = history[#history-i-historyoffset]
			if (skipagecheck or ((clock()-line[2]) <= maxage)) then
				if (count == 0) then
					count = count + 1
					display = line[1]
				else
					if (usecounters and (lastID > 0) and (lastID~=line[3]) and (line[1] == lastLine)) then
						counters[count] = counters[count] + 1
					else
						count = count + 1
						display = line[1].."\n"..display
					end
				end
				
				lastLine = line[1]
				lastID = line[3]
				
				if (skipagecheck) then
					g.vars.nextupdate = -1
				else
					g.vars.nextupdate = line[2]+maxage
				end
			else
				break
			end
			i=i+1
		else
			break
		end
	end
	
	if (usecounters) then
		for i=1,#counters do
			if (counters[i] ~= 1) then
				local counter = count-i+1
				g.counters[counter].active = nil
				g.counters[counter].caption = counters[i].."x"
			end
		end
	end
	
	if (count == 0) then
		g.vars.nextupdate = -1 --no update until new console line
		g.background.active = false
		g.lines.active = false
		g.vars._empty = true
		g.background.sy = cfg.minlines*g.lines.fontsize + (g.lines.px-g.background.px)*2
	else
		g.background.active = nil --activate
		g.lines.active = nil --activate
		g.vars._empty = nil
		g.background.sy = count*g.lines.fontsize + (g.lines.px-g.background.px)*2
	end
	
	g.lines.caption = display
	g.lines.sx = 100
end

function widget:Initialize()

	inittime = spGetTimer()
	PassedStartupCheck = RedUIchecks()
	if (not PassedStartupCheck) then return end
	
	console = createconsole(Confignew.console)
	Spring.SendCommands("console 0")
	Spring.SendCommands("inputtextgeo 0.26 0.73 0.02 0.028")
	AutoResizeObjects()

end

function widget:ViewResize(newX,newY)
	AutoResizeObjects()
end

function widget:GameOver()
	gameOver = true
end

function widget:Shutdown()
	Spring.SendCommands("console 1")
end

function widget:AddConsoleLine(lines,priority)
		--if Spring.GetConfigString("showchat", "1") == "1" then
		--if (pauseelapsed or (Spring.GetGameSeconds() >0) or (spDiffTimers(spGetTimer(),inittime) > 10)) then
		--	local textcolor

				
		--	if(not pauseelapsed) then
		--		textcolor = processLine(" ", console, Confignew.console, textcolor)[4]
		--		pauseelapsed = true
		--	end
		
			local textcolor
			lines = lines:match('^\[f=[0-9]+\] (.*)$') or lines
			for line in lines:gmatch("[^\n]+") do
				local result = processLine(line, console, Confignew.console, textcolor)
				if result then
					textcolor = result[4]
				end
			end
			clipHistory(console,true)
		--end
		
		--end
end

function widget:Update()
	updateconsole(console,Confignew.console)
	AutoResizeObjects()
end

--save/load stuff
--currently only position
function widget:GetConfignewData() --save Confignew
	if (PassedStartupCheck) then
		local vsx = Screen.vsx
		local unscale = CanvasX/vsx --needed due to autoresize, stores unresized variables
		Confignew.console.px = console.background.px * unscale
		Confignew.console.py = console.background.py * unscale
		return {Confignew=Confignew}
	end
end
function widget:SetConfignewData(data) --load Confignew
	if (data.Confignew ~= nil) then
		Confignew.console.px = data.Confignew.console.px
		Confignew.console.py = data.Confignew.console.py
	end
end
