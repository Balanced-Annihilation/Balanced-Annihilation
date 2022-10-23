function widget:GetInfo()
	return {
		name = "Info alternate",
		desc = "",
		author = "Floris",
		date = "April 2020",
		license = "GNU GPL, v2 or later",
		layer = 1,
		enabled = true
	}
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local width = 0
local addonWidth = 0
local height = 0

local zoomMult = 1.5
local defaultCellZoom = 0 * zoomMult
local rightclickCellZoom = 0.065 * zoomMult
local clickCellZoom = 0.065 * zoomMult
local hoverCellZoom = 0.03 * zoomMult

local iconBorderOpacity = 0.1
local showSelectionTotals = true

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


	local fontfile ="LuaUI/Fonts/FreeSansBold.otf"
	local fontfile2 ="LuaUI/Fonts/FreeSansBold.otf"

local vsx, vsy = Spring.GetViewGeometry()

local barGlowCenterTexture = ":l:LuaUI/Images/barglow-center.png"
local barGlowEdgeTexture = ":l:LuaUI/Images/barglow-edge.png"

local hoverType, hoverData = '', ''

local ui_opacity = tonumber(Spring.GetConfigFloat("ui_opacity", 0.66) or 0.66)
local ui_scale = tonumber(Spring.GetConfigFloat("ui_scale", 1) or 1)
local glossMult = 1 + (2 - (ui_opacity * 2))    -- increase gloss/highlight so when ui is transparant, you can still make out its boundaries and make it less flat

local backgroundRect = { 0, 0, 0, 0 }
local currentTooltip = ''
local lastUpdateClock = 0

local hpcolormap = { { 1, 0.0, 0.0, 1 }, { 0.8, 0.60, 0.0, 1 }, { 0.0, 0.75, 0.0, 1 } }

local tooltipTitleColor = '\255\205\255\205'
local tooltipTextColor = '\255\255\255\255'
local tooltipLabelTextColor = '\255\200\200\200'
local tooltipDarkTextColor = '\255\133\133\133'
local tooltipValueColor = '\255\255\245\175'
local tooltipValueWhiteColor = '\255\255\255\255'
local tooltipValueYellowColor = '\255\255\235\175'
local tooltipValueRedColor = '\255\255\180\180'

local selectionHowto = tooltipTextColor .. "Left click" .. tooltipLabelTextColor .. ": Select\n " .. tooltipTextColor .. "   + CTRL" .. tooltipLabelTextColor .. ": Select units of this type on map\n " .. tooltipTextColor .. "   + ALT" .. tooltipLabelTextColor .. ": Select 1 single unit of this unit type\n " .. tooltipTextColor .. "Right click" .. tooltipLabelTextColor .. ": Remove\n " .. tooltipTextColor .. "    + CTRL" .. tooltipLabelTextColor .. ": Remove only 1 unit from that unit type\n " .. tooltipTextColor .. "Middle click" .. tooltipLabelTextColor .. ": Move to center location\n " .. tooltipTextColor .. "    + CTRL" .. tooltipLabelTextColor .. ": Move to center off whole selection"

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local spEcho = Spring.Echo
local spGetCurrentTooltip = Spring.GetCurrentTooltip
local spGetSelectedUnitsCounts = Spring.GetSelectedUnitsCounts
local spGetSelectedUnitsSorted = Spring.GetSelectedUnitsSorted
local spGetSelectedUnitsCount = Spring.GetSelectedUnitsCount
local SelectedUnitsCount = Spring.GetSelectedUnitsCount()
local selectedUnits = Spring.GetSelectedUnits()
local spGetUnitDefID = Spring.GetUnitDefID
local spTraceScreenRay = Spring.TraceScreenRay
local spGetMouseState = Spring.GetMouseState
local spGetModKeyState = Spring.GetModKeyState
local spSelectUnitArray = Spring.SelectUnitArray
local spGetTeamUnitsSorted = Spring.GetTeamUnitsSorted
local spSelectUnitMap = Spring.SelectUnitMap
local spGetUnitHealth = Spring.GetUnitHealth
local spGetUnitResources = Spring.GetUnitResources
local spGetUnitMaxRange = Spring.GetUnitMaxRange
local spGetUnitExperience = Spring.GetUnitExperience
local spGetUnitMetalExtraction = Spring.GetUnitMetalExtraction
local spGetUnitStates = Spring.GetUnitStates
local spGetUnitStockpile = Spring.GetUnitStockpile
local spGetUnitWeaponState = Spring.GetUnitWeaponState
local spGetUnitWeaponDamages = Spring.GetUnitWeaponDamages

local math_floor = math.floor
local math_ceil = math.ceil
local math_min = math.min
local math_max = math.max
local sfind = string.find

local os_clock = os.clock

local isSpec = Spring.GetSpectatingState()
local myTeamID = Spring.GetMyTeamID()

local GL_QUADS = GL.QUADS
local GL_TRIANGLE_FAN = GL.TRIANGLE_FAN
local glBeginEnd = gl.BeginEnd
local glTexture = gl.Texture
local glTexRect = gl.TexRect
local glColor = gl.Color
local glRect = gl.Rect
local glVertex = gl.Vertex
local glBlending = gl.Blending
local GL_SRC_ALPHA = GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local GL_ONE = GL.ONE

function lines(str)
	local t = {}
	local function helper(line)
		t[#t + 1] = line
		return ""
	end
	helper((str:gsub("(.-)\r?\n", helper)))
	return t
end

function wrap(str, limit)
	limit = limit or 72
	local here = 1
	local buf = ""
	local t = {}
	str:gsub("(%s*)()(%S+)()",
		function(sp, st, word, fi)
			if fi - here > limit then
				--# Break the line
				here = st
				t[#t + 1] = buf
				buf = word
			else
				buf = buf .. sp .. word  --# Append
			end
		end)
	--# Tack on any leftovers
	if (buf ~= "") then
		t[#t + 1] = buf
	end
	return t
end

function round(value, numDecimalPlaces)
	if value then
		return string.format("%0." .. numDecimalPlaces .. "f", math.round(value, numDecimalPlaces))
	else
		return 0
	end
end

local function convertColor(r, g, b)
	return string.char(255, (r * 255), (g * 255), (b * 255))
end

local function lookupUnitBuildPicture(unitDef, extensions)
	for _, extension in ipairs(extensions) do
		filename = unitDef.name .. "." .. extension
		if VFS.FileExists('unitpics/' .. filename) then
			spEcho("Found unit build picture " .. filename)
			return filename
		end
	end
	spEcho("Failed to find unit build picture for " .. unitDef.name)
	return ''
end

local unitDefInfo = {}
for unitDefID, unitDef in pairs(UnitDefs) do
	unitDefInfo[unitDefID] = {}

	if unitDef.isAirUnit then
		unitDefInfo[unitDefID].airUnit = true
	end

	if unitDef.isImmobile or unitDef.isBuilding then
		if not unitDef.cantBeTransported then
			unitDefInfo[unitDefID].transportable = true
		end
	end

	unitDefInfo[unitDefID].humanName = unitDef.humanName
	if unitDef.maxWeaponRange > 16 then
		unitDefInfo[unitDefID].maxWeaponRange = unitDef.maxWeaponRange
	end
	if unitDef.speed > 0 then
		unitDefInfo[unitDefID].speed = round(unitDef.speed, 0)
	end
	if unitDef.rSpeed > 0 then
		unitDefInfo[unitDefID].reverseSpeed = round(unitDef.rSpeed, 0)
	end
	if unitDef.stealth then
		unitDefInfo[unitDefID].stealth = true
	end
	if unitDef.isTransport then
		unitDefInfo[unitDefID].transport = { unitDef.transportMass, unitDef.transportSize, unitDef.transportCapacity }
	end
	if unitDef.customParams.paralyzemultiplier then
		unitDefInfo[unitDefID].paralyzeMult = tonumber(unitDef.customParams.paralyzemultiplier)
	end
	--if unitDef.wreckName then
	--	if FeatureDefNames[unitDef.wreckName] then
	--		unitDefInfo[unitDefID].unitWreckMetal = FeatureDefNames[unitDef.wreckName].metal
	--		if FeatureDefNames[unitDef.wreckName].deathFeatureID and FeatureDefs[FeatureDefNames[unitDef.wreckName].deathFeatureID] then
	--			unitDefInfo[unitDefID].unitHeapMetal = FeatureDefs[FeatureDefNames[unitDef.wreckName].deathFeatureID].metal
	--		end
	--	end
	--end
	unitDefInfo[unitDefID].armorType = Game.armorTypes[unitDef.armorType or 0] or '???'

	if unitDef.losRadius > 0 then
		unitDefInfo[unitDefID].losRadius = unitDef.losRadius
	end
	if unitDef.airLosRadius > 0 then
		unitDefInfo[unitDefID].airLosRadius = unitDef.airLosRadius
	end
	if unitDef.radarRadius > 0 then
		unitDefInfo[unitDefID].radarRadius = unitDef.radarRadius
	end
	if unitDef.sonarRadius > 0 then
		unitDefInfo[unitDefID].sonarRadius = unitDef.sonarRadius
	end
	if unitDef.jammerRadius > 0 then
		unitDefInfo[unitDefID].jammerRadius = unitDef.jammerRadius
	end
	if unitDef.sonarJamRadius > 0 then
		unitDefInfo[unitDefID].sonarJamRadius = unitDef.sonarJamRadius
	end
	if unitDef.seismicRadius > 0 then
		unitDefInfo[unitDefID].seismicRadius = unitDef.seismicRadius
	end

	if unitDef.customParams.energyconv_capacity and unitDef.customParams.energyconv_efficiency then
		unitDefInfo[unitDefID].metalmaker = { tonumber(unitDef.customParams.energyconv_capacity), tonumber(unitDef.customParams.energyconv_efficiency) }
	end

	unitDefInfo[unitDefID].tooltip = unitDef.tooltip
	unitDefInfo[unitDefID].iconType = unitDef.iconType
	unitDefInfo[unitDefID].energyCost = unitDef.energyCost
	unitDefInfo[unitDefID].metalCost = unitDef.metalCost
	unitDefInfo[unitDefID].health = unitDef.health
	unitDefInfo[unitDefID].buildTime = unitDef.buildTime

	unitDefInfo[unitDefID].buildPic = unitDef.buildpicname
	if unitDefInfo[unitDefID].buildPic == '' then
		unitDefInfo[unitDefID].buildPic = lookupUnitBuildPicture(unitDef, {'dds', 'pcx'})
	end

	if unitDef.canStockpile then
		unitDefInfo[unitDefID].canStockpile = true
	end
	if unitDef.buildSpeed > 0 then
		unitDefInfo[unitDefID].buildSpeed = unitDef.buildSpeed
	end
	if unitDef.buildOptions[1] then
		unitDefInfo[unitDefID].buildOptions = unitDef.buildOptions
	end
	if unitDef.extractsMetal > 0 then
		unitDefInfo[unitDefID].mex = true
	end
	local totalDps = 0
	for i = 1, #unitDef.weapons do
		if not unitDefInfo[unitDefID].weapons then
			unitDefInfo[unitDefID].weapons = {}
			unitDefInfo[unitDefID].dps = 0
			unitDefInfo[unitDefID].reloadTime = 0
			unitDefInfo[unitDefID].mainWeapon = i
		end
		unitDefInfo[unitDefID].weapons[i] = unitDef.weapons[i].weaponDef
		local weaponDef = WeaponDefs[unitDef.weapons[i].weaponDef]
		if weaponDef.damages then
			-- get highest damage category
			local maxDmg = 0
			local reloadTime = 0
			for _, v in pairs(weaponDef.damages) do
				if v > maxDmg then
					maxDmg = v
					reloadTime = weaponDef.reload
				end
			end
			local dps = math_floor(maxDmg * weaponDef.salvoSize / weaponDef.reload)
			if dps > unitDefInfo[unitDefID].dps then
				--unitDefInfo[unitDefID].dps = dps
				unitDefInfo[unitDefID].reloadTime = reloadTime	-- only main weapon is relevant
				unitDefInfo[unitDefID].mainWeapon = i
			end
			totalDps = totalDps + dps
			unitDefInfo[unitDefID].dps = totalDps
		end
		if unitDef.weapons[i].onlyTargets['vtol'] ~= nil then
			unitDefInfo[unitDefID].isAaUnit = true
		end
		if weaponDef.energyCost > 0 and (not unitDefInfo[unitDefID].energyPerShot or weaponDef.energyCost > unitDefInfo[unitDefID].energyPerShot) then
			unitDefInfo[unitDefID].energyPerShot = weaponDef.energyCost
		end
		if weaponDef.metalCost > 0 and (not unitDefInfo[unitDefID].metalPerShot or weaponDef.metalCost > unitDefInfo[unitDefID].metalPerShot) then
			unitDefInfo[unitDefID].metalPerShot = weaponDef.metalCost
		end
	end
end


-- order units, add higher value for order importance
local unitOrder = {}
for unitDefID, unitDef in pairs(UnitDefs) do
	unitOrder[unitDefID] = 0
	if unitDef.buildSpeed > 0 then
		unitOrder[unitDefID] = unitOrder[unitDefID] + (unitDef.buildSpeed * 10000)
	end
	if unitDef.buildOptions[1] then
		if unitDef.isBuilding then
			unitOrder[unitDefID] = unitOrder[unitDefID] + 200000000
		else
			unitOrder[unitDefID] = unitOrder[unitDefID] + 150000000
		end
		if unitDef.modCategories['notland'] or unitDef.modCategories['underwater'] then
			unitOrder[unitDefID] = unitOrder[unitDefID] - 25000000
		end
	end
	if unitDef.isImmobile or unitDef.isBuilding then
		if unitDef.floatOnWater then
			unitOrder[unitDefID] = unitOrder[unitDefID] + 11000000
		elseif unitDef.modCategories['underwater'] or unitDef.modCategories['canbeuw'] or unitDef.modCategories['notland'] then
			unitOrder[unitDefID] = unitOrder[unitDefID] + 10000000
		else
			unitOrder[unitDefID] = unitOrder[unitDefID] + 12000000
		end
	else
		if unitDef.modCategories['ship'] then
			unitOrder[unitDefID] = unitOrder[unitDefID] + 9000000
		elseif unitDef.modCategories['hover'] then
			unitOrder[unitDefID] = unitOrder[unitDefID] + 8000000
		elseif unitDef.modCategories['tank'] then
			unitOrder[unitDefID] = unitOrder[unitDefID] + 7000000
		elseif unitDef.modCategories['bot'] then
			unitOrder[unitDefID] = unitOrder[unitDefID] + 6000000
		elseif unitDef.isAirUnit then
			unitOrder[unitDefID] = unitOrder[unitDefID] + 5000000
		elseif unitDef.modCategories['underwater'] or unitDef.modCategories['canbeuw'] or unitDef.modCategories['notland'] then
			unitOrder[unitDefID] = unitOrder[unitDefID] + 8600000
		end
	end
	if unitDef.energyCost then
		unitOrder[unitDefID] = unitOrder[unitDefID] + (unitDef.energyCost / 70)
	end
	if unitDef.metalCost then
		unitOrder[unitDefID] = unitOrder[unitDefID] + unitDef.metalCost
	end
	if unitDefInfo[unitDefID].dps then
		unitOrder[unitDefID] = unitOrder[unitDefID] + unitDefInfo[unitDefID].dps
	end
	unitOrder[unitDefID] = math_floor(unitOrder[unitDefID])
end

local function getHighestOrderedUnit()
	local highest = { 0, 0 }
	for unitDefID, orderValue in pairs(unitOrder) do
		if orderValue > highest[2] then
			highest = { unitDefID, orderValue }
		end
	end
	return highest[1]
end

local unitsOrdered = {}
for unitDefID, unitDef in pairs(UnitDefs) do
	local uDefID = getHighestOrderedUnit()
	unitsOrdered[#unitsOrdered + 1] = uDefID
	unitOrder[uDefID] = nil
end

unitOrder = unitsOrdered
unitsOrdered = nil

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- load all icons to prevent briefly showing white unit icons (will happen due to the custom texture filtering options)
local function cacheUnitIcons()
	for id, unit in pairs(UnitDefs) do
		-- delete old cached icon when iconsize changed
		if prevUnitIconSize and prevUnitIconSize ~= unitIconSize then
			gl.DeleteTexture(':lr'..prevUnitIconSize..','..prevUnitIconSize..':unitpics/' .. unitDefInfo[id].buildPic)
			gl.DeleteTexture(':lr'..prevUnitIconSize2..','..prevUnitIconSize2..':unitpics/' .. unitDefInfo[id].buildPic)
		end
		if prevRadarIconSize and prevRadarIconSize ~= radarIconSize then
			if iconTypesMap[unitDefInfo[id].iconType] then
				gl.DeleteTexture(':lr' .. (prevRadarIconSize * 2) .. ',' .. (prevRadarIconSize * 2) .. ':' .. iconTypesMap[unitDefInfo[id].iconType])
			end
		end

		gl.Texture(':lr'..unitIconSize2..','..unitIconSize2..':unitpics/' .. unitDefInfo[id].buildPic)
		gl.TexRect(-1, -1, 0, 0)
		gl.Texture(':lr'..unitIconSize..','..unitIconSize..':unitpics/' .. unitDefInfo[id].buildPic)
		gl.TexRect(-1, -1, 0, 0)
		if iconTypesMap[unitDefInfo[id].iconType] then
			gl.Texture(':lr' .. (radarIconSize * 2) .. ',' .. (radarIconSize * 2) .. ':' .. iconTypesMap[unitDefInfo[id].iconType])
			gl.TexRect(-1, -1, 0, 0)
		end
		gl.Texture(false)
	end
	prevRadarIconSize = radarIconSize
	prevUnitIconSize = unitIconSize
	prevUnitIconSize2 = unitIconSize2
end

local function refreshUnitIconCache()
	if dlistCache then
		dlistCache = gl.DeleteList(dlistCache)
	end
	dlistCache = gl.CreateList(function()
		cacheUnitIcons()
	end)
end



function widget:PlayerChanged(playerID)
	isSpec = Spring.GetSpectatingState()
	myTeamID = Spring.GetMyTeamID()
end

function widget:ViewResize()
	ViewResizeUpdate = true

	vsx, vsy = Spring.GetViewGeometry()

	width = 0.184
	height = 0.14 * ui_scale
	width = width / (vsx / vsy) * 1.78        -- make smaller for ultrawide screens
	width = width * ui_scale
	-- make pixel aligned
	height = math_floor(height * vsy) / vsy
	width = math_floor(width * vsx) / vsx

	local widgetSpaceMargin = math_floor(0.0045 * vsy * ui_scale) / vsy
	bgpadding = math_ceil(widgetSpaceMargin * 0.66 * vsy)

	backgroundRect = { 0, 0, (width - addonWidth) * vsx, height * vsy }

	doUpdate = true
	clear()

	radarIconSize = math_floor((height * vsy * 0.17) + 0.5)
	unitIconSize = math_floor((height * vsy * 0.7) + 0.5)
	unitIconSize2 = math_floor((height * vsy * 0.35) + 0.5)
	if radarIconSize > 128 then
		radarIconSize = 128
	end
	if unitIconSize > 256 then
		unitIconSize = 256
	end
	if unitIconSize2 > 256 then
		unitIconSize2 = 256
	end


	font, loadedFontSize = WG['fonts'].getFont(fontfile)
	font2 = WG['fonts'].getFont(fontfile2)
end

function GetColor(colormap, slider)
	local coln = #colormap
	if (slider >= 1) then
		local col = colormap[coln]
		return col[1], col[2], col[3], col[4]
	end
	if (slider < 0) then
		slider = 0
	elseif (slider > 1) then
		slider = 1
	end
	local posn = 1 + (coln - 1) * slider
	local iposn = math_floor(posn)
	local aa = posn - iposn
	local ia = 1 - aa

	local col1, col2 = colormap[iposn], colormap[iposn + 1]

	return col1[1] * ia + col2[1] * aa, col1[2] * ia + col2[2] * aa,
	col1[3] * ia + col2[3] * aa, col1[4] * ia + col2[4] * aa
end

function widget:Initialize()
	widget:ViewResize()

	WG['info'] = {}
	WG['info'].displayUnitID = function(unitID)
		cfgDisplayUnitID = unitID
	end
	WG['info'].clearDisplayUnitID = function()
		cfgDisplayUnitID = nil
	end
	WG['info'].getPosition = function()
		return width, height
	end
	iconTypesMap = {}
	if Script.LuaRules('GetIconTypes') then
		iconTypesMap = Script.LuaRules.GetIconTypes()
	end
	Spring.SetDrawSelectionInfo(false)    -- disables springs default display of selected units count
	Spring.SendCommands("tooltip 0")

	if WG['rankicons'] then
		rankTextures = WG['rankicons'].getRankTextures()
	end

	bfcolormap = {}
	for hp = 0, 100 do
		bfcolormap[hp] = { GetColor(hpcolormap, hp * 0.01) }
	end

	refreshUnitIconCache()
end

function clear()
	dlistInfo = gl.DeleteList(dlistInfo)
end

function widget:Shutdown()
	Spring.SetDrawSelectionInfo(true) --disables springs default display of selected units count
	Spring.SendCommands("tooltip 1")
	clear()
	
end

local uiOpacitySec = 0
local sec = 0
function widget:Update(dt)
	uiOpacitySec = uiOpacitySec + dt
	if uiOpacitySec > 0.5 then
		uiOpacitySec = 0
		if WG['buildpower'] then
			addonWidth, _ = WG['buildpower'].getSize()
			if not addonWidth then
				addonWidth = 0
			end
			widget:ViewResize()
		elseif addonWidth > 0 then
			addonWidth = 0
			widget:ViewResize()
		end
		if ui_scale ~= Spring.GetConfigFloat("ui_scale", 1) then
			ui_scale = Spring.GetConfigFloat("ui_scale", 1)
			widget:ViewResize()
			refreshUnitIconCache()
		end
		if ui_opacity ~= Spring.GetConfigFloat("ui_opacity", 0.66) then
			ui_opacity = Spring.GetConfigFloat("ui_opacity", 0.66)
			glossMult = 1 + (2 - (ui_opacity * 2))
			doUpdate = true
		end
		if not rankTextures and WG['rankicons'] then
			rankTextures = WG['rankicons'].getRankTextures()
		end
	end

	sec = sec + dt
	if sec > 0.05 then
		sec = 0
		checkChanges()
	end
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

local function DrawRectRoundCircle(x, y, z, radius, cs, centerOffset, color1, color2)
	if not color2 then
		color2 = color1
	end
	--centerOffset = 0
	local coords = {
		{ x - radius + cs, z + radius, y }, -- top left
		{ x + radius - cs, z + radius, y }, -- top right
		{ x + radius, z + radius - cs, y }, -- right top
		{ x + radius, z - radius + cs, y }, -- right bottom
		{ x + radius - cs, z - radius, y }, -- bottom right
		{ x - radius + cs, z - radius, y }, -- bottom left
		{ x - radius, z - radius + cs, y }, -- left bottom
		{ x - radius, z + radius - cs, y }, -- left top
	}
	local cs2 = cs * (centerOffset / radius)
	local coords2 = {
		{ x - centerOffset + cs2, z + centerOffset, y }, -- top left
		{ x + centerOffset - cs2, z + centerOffset, y }, -- top right
		{ x + centerOffset, z + centerOffset - cs2, y }, -- right top
		{ x + centerOffset, z - centerOffset + cs2, y }, -- right bottom
		{ x + centerOffset - cs2, z - centerOffset, y }, -- bottom right
		{ x - centerOffset + cs2, z - centerOffset, y }, -- bottom left
		{ x - centerOffset, z - centerOffset + cs2, y }, -- left bottom
		{ x - centerOffset, z + centerOffset - cs2, y }, -- left top
	}
	for i = 1, 8 do
		local i2 = (i >= 8 and 1 or i + 1)
		gl.Color(color2)
		gl.Vertex(coords[i][1], coords[i][2], coords[i][3])
		gl.Vertex(coords[i2][1], coords[i2][2], coords[i2][3])
		gl.Color(color1)
		gl.Vertex(coords2[i2][1], coords2[i2][2], coords2[i2][3])
		gl.Vertex(coords2[i][1], coords2[i][2], coords2[i][3])
	end
end
local function RectRoundCircle(x, y, z, radius, cs, centerOffset, color1, color2)
	gl.BeginEnd(GL_QUADS, DrawRectRoundCircle, x, y, z, radius, cs, centerOffset, color1, color2)
end

function IsOnRect(x, y, BLcornerX, BLcornerY, TRcornerX, TRcornerY)
	return x >= BLcornerX and x <= TRcornerX and y >= BLcornerY and y <= TRcornerY
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

local function DrawTexRectRound(px, py, sx, sy, cs, tl, tr, br, bl, offset)
	local csyMult = 1 / ((sy - py) / cs)

	local function drawTexCoordVertex(x, y)
		local yc = 1 - ((y - py) / (sy - py))
		local xc = (offset * 0.5) + ((x - px) / (sx - px)) + (-offset * ((x - px) / (sx - px)))
		yc = 1 - (offset * 0.5) - ((y - py) / (sy - py)) + (offset * ((y - py) / (sy - py)))
		gl.TexCoord(xc, yc)
		gl.Vertex(x, y, 0)
	end

	-- mid section
	drawTexCoordVertex(px + cs, py)
	drawTexCoordVertex(sx - cs, py)
	drawTexCoordVertex(sx - cs, sy)
	drawTexCoordVertex(px + cs, sy)

	-- left side
	drawTexCoordVertex(px, py + cs)
	drawTexCoordVertex(px + cs, py + cs)
	drawTexCoordVertex(px + cs, sy - cs)
	drawTexCoordVertex(px, sy - cs)

	-- right side
	drawTexCoordVertex(sx, py + cs)
	drawTexCoordVertex(sx - cs, py + cs)
	drawTexCoordVertex(sx - cs, sy - cs)
	drawTexCoordVertex(sx, sy - cs)

	-- bottom left
	if ((py <= 0 or px <= 0) or (bl ~= nil and bl == 0)) and bl ~= 2 then
		drawTexCoordVertex(px, py)
	else
		drawTexCoordVertex(px + cs, py)
	end
	drawTexCoordVertex(px + cs, py)
	drawTexCoordVertex(px + cs, py + cs)
	drawTexCoordVertex(px, py + cs)
	-- bottom right
	if ((py <= 0 or sx >= vsx) or (br ~= nil and br == 0)) and br ~= 2 then
		drawTexCoordVertex(sx, py)
	else
		drawTexCoordVertex(sx - cs, py)
	end
	drawTexCoordVertex(sx - cs, py)
	drawTexCoordVertex(sx - cs, py + cs)
	drawTexCoordVertex(sx, py + cs)
	-- top left
	if ((sy >= vsy or px <= 0) or (tl ~= nil and tl == 0)) and tl ~= 2 then
		drawTexCoordVertex(px, sy)
	else
		drawTexCoordVertex(px + cs, sy)
	end
	drawTexCoordVertex(px + cs, sy)
	drawTexCoordVertex(px + cs, sy - cs)
	drawTexCoordVertex(px, sy - cs)
	-- top right
	if ((sy >= vsy or sx >= vsx) or (tr ~= nil and tr == 0)) and tr ~= 2 then
		drawTexCoordVertex(sx, sy)
	else
		drawTexCoordVertex(sx - cs, sy)
	end
	drawTexCoordVertex(sx - cs, sy)
	drawTexCoordVertex(sx - cs, sy - cs)
	drawTexCoordVertex(sx, sy - cs)
end
function TexRectRound(px, py, sx, sy, cs, tl, tr, br, bl, zoom)
	gl.BeginEnd(GL.QUADS, DrawTexRectRound, px, py, sx, sy, cs, tl, tr, br, bl, zoom)
end

local function drawSelectionCell(cellID, uDefID, usedZoom, highlightColor)
	if not usedZoom then
		usedZoom = defaultCellZoom
	end

	glColor(1, 1, 1, 1)
	glTexture(texSetting .. "unitpics/" .. unitDefInfo[uDefID].buildPic)
	--glTexRect(cellRect[cellID][1]+cellPadding, cellRect[cellID][2]+cellPadding, cellRect[cellID][3]-cellPadding, cellRect[cellID][4]-cellPadding)
	--DrawRect(cellRect[cellID][1]+cellPadding, cellRect[cellID][2]+cellPadding, cellRect[cellID][3]-cellPadding, cellRect[cellID][4]-cellPadding,0.06)
	TexRectRound(cellRect[cellID][1] + cellPadding, cellRect[cellID][2] + cellPadding, cellRect[cellID][3], cellRect[cellID][4], cornerSize, 1, 1, 1, 1, usedZoom)
	glTexture(false)
	-- darkening bottom
	RectRound(cellRect[cellID][1] + cellPadding, cellRect[cellID][2] + cellPadding, cellRect[cellID][3], cellRect[cellID][4], cornerSize, 0, 0, 1, 1, { 0, 0, 0, 0.1 }, { 0, 0, 0, 0 })
	-- gloss
	glBlending(GL_SRC_ALPHA, GL_ONE)
	RectRound(cellRect[cellID][1] + cellPadding, cellRect[cellID][4] - ((cellRect[cellID][4] - cellRect[cellID][2]) * 0.77), cellRect[cellID][3], cellRect[cellID][4], cornerSize, 1, 1, 0, 0, { 1, 1, 1, 0 }, { 1, 1, 1, 0.08 })
	RectRound(cellRect[cellID][1] + cellPadding, cellRect[cellID][4] - ((cellRect[cellID][4] - cellRect[cellID][2]) * 0.14), cellRect[cellID][3], cellRect[cellID][4], cornerSize, 1, 1, 0, 0, { 1, 1, 1, 0 }, { 1, 1, 1, 0.05 })
	RectRound(cellRect[cellID][1] + cellPadding, cellRect[cellID][2] + cellPadding, cellRect[cellID][3], cellRect[cellID][2] + cellPadding + ((cellRect[cellID][4] - cellRect[cellID][2]) * 0.14), cornerSize, 0, 0, 1, 1, { 1, 1, 1, 0.08 }, { 1, 1, 1, 0 })
	glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

	-- lighten cell edges
	if highlightColor then
		local halfSize = (((cellRect[cellID][3] - cellPadding)) - (cellRect[cellID][1])) * 0.5
		glBlending(GL_SRC_ALPHA, GL_ONE)
		RectRoundCircle(
			cellRect[cellID][1] + cellPadding + halfSize,
			0,
			cellRect[cellID][2] + cellPadding + halfSize,
			halfSize, cornerSize, halfSize * 0.5, { highlightColor[1], highlightColor[2], highlightColor[3], 0 }, { highlightColor[1], highlightColor[2], highlightColor[3], highlightColor[4] * 0.75 }
		)
		RectRoundCircle(
			cellRect[cellID][1] + cellPadding + halfSize,
			0,
			cellRect[cellID][2] + cellPadding + halfSize,
			halfSize, cornerSize, halfSize * 0.82, { highlightColor[1], highlightColor[2], highlightColor[3], 0 }, highlightColor
		)
		glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	end

	-- lighten border
	if iconBorderOpacity > 0 then
		local halfSize = (((cellRect[cellID][3] - cellPadding)) - (cellRect[cellID][1])) * 0.5
		glBlending(GL_SRC_ALPHA, GL_ONE)
		RectRoundCircle(
			cellRect[cellID][1] + cellPadding + halfSize,
			0,
			cellRect[cellID][2] + cellPadding + halfSize,
			halfSize, cornerSize, halfSize - math_max(1, cellPadding), { 1, 1, 1, iconBorderOpacity }, { 1, 1, 1, iconBorderOpacity }
		)
		glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	end

	-- unitcount
	if selUnitsCounts[uDefID] > 1 then
		local fontSize = math_min(gridHeight * 0.19, cellsize * 0.6) * (1 - ((1 + string.len(selUnitsCounts[uDefID])) * 0.066))
		font2:Begin()
		font2:Print(selUnitsCounts[uDefID], cellRect[cellID][3] - cellPadding - (fontSize * 0.09), cellRect[cellID][2] + (fontSize * 0.3), fontSize, "ro")
		font2:End()
	end
end

local function getSelectionTotals(cells)
	local descriptionColor = '\255\240\240\240'
	local metalColor = '\255\245\245\245'
	local energyColor = '\255\255\255\000'
	local healthColor = '\255\100\255\100'

	local labelColor = '\255\205\205\205'
	local valueColor = '\255\255\255\255'
	local valuePlusColor = '\255\180\255\180'
	local valueMinColor = '\255\255\180\180'

	local statsIndent = ''
	local stats = ''

	-- description
	if cellHovered then
		local text, numLines = font:WrapText(unitDefInfo[selectionCells[cellHovered]].tooltip, (backgroundRect[3] - backgroundRect[1]) * (loadedFontSize / 16))
		stats = stats .. statsIndent .. tooltipTextColor .. text .. '\n\n'
	end

	-- loop all unitdefs/cells (but not individual unitID's)
	local totalMetalValue = 0
	local totalEnergyValue = 0
	local totalDpsValue = 0
	for _, unitDefID in pairs(cells) do
		-- metal cost
		if unitDefInfo[unitDefID].metalCost then
			totalMetalValue = totalMetalValue + (unitDefInfo[unitDefID].metalCost * selUnitsCounts[unitDefID])
		end
		-- energy cost
		if unitDefInfo[unitDefID].energyCost then
			totalEnergyValue = totalEnergyValue + (unitDefInfo[unitDefID].energyCost * selUnitsCounts[unitDefID])
		end
		-- DPS
		if unitDefInfo[unitDefID].dps then
			totalDpsValue = totalDpsValue + (unitDefInfo[unitDefID].dps * selUnitsCounts[unitDefID])
		end
	end

	-- loop all unitID's
	local totalMaxHealthValue = 0
	local totalHealth = 0
	local totalMetalMake, totalMetalUse, totalEnergyMake, totalEnergyUse = 0, 0, 0, 0
	for _, unitID in pairs(cellHovered and selUnitsSorted[selectionCells[cellHovered]] or selectedUnits) do
		-- resources
		local metalMake, metalUse, energyMake, energyUse = spGetUnitResources(unitID)
		if metalMake then
			totalMetalMake = totalMetalMake + metalMake
			totalMetalUse = totalMetalUse + metalUse
			totalEnergyMake = totalEnergyMake + energyMake
			totalEnergyUse = totalEnergyUse + energyUse
		end
		-- health
		local health, maxHealth, _, _, buildProgress = spGetUnitHealth(unitID)
		if health and maxHealth then
			totalMaxHealthValue = totalMaxHealthValue + maxHealth
			totalHealth = totalHealth + health
		end
	end

	-- resources
	stats = stats .. statsIndent .. tooltipLabelTextColor .. "M: " .. (totalMetalMake > 0 and valuePlusColor .. '+' .. (totalMetalMake < 10 and round(totalMetalMake, 1) or round(totalMetalMake, 0)) .. ' ' or '... ') .. (totalMetalUse > 0 and valueMinColor .. '-' .. (totalMetalUse < 10 and round(totalMetalUse, 1) or round(totalMetalUse, 0)) or tooltipLabelTextColor .. '... ')
	stats = stats .. '\n' .. statsIndent
	stats = stats .. tooltipLabelTextColor .. "E: " .. (totalEnergyMake > 0 and valuePlusColor .. '+' .. (totalEnergyMake < 10 and round(totalEnergyMake, 1) or round(totalEnergyMake, 0)) .. ' ' or '... ') .. (totalEnergyUse > 0 and valueMinColor .. '-' .. (totalEnergyUse < 10 and round(totalEnergyUse, 1) or round(totalEnergyUse, 0)) or tooltipLabelTextColor .. '... ')

	-- metal cost
	if totalMetalValue > 0 then
		stats = stats .. '\n' .. statsIndent .. tooltipLabelTextColor .. "Cost M: " .. tooltipValueWhiteColor .. totalMetalValue .. "   "
	end
	stats = stats .. '\n' .. statsIndent

	-- energy cost
	if totalEnergyValue > 0 then
		stats = stats .. tooltipLabelTextColor .. "Cost E: " .. tooltipValueYellowColor .. totalEnergyValue .. "   "
	end

	-- health
	totalMaxHealthValue = math_floor(totalMaxHealthValue)
	if totalMaxHealthValue > 0 then
		totalHealth = math_floor(totalHealth)
		local percentage = math_floor((totalHealth / totalMaxHealthValue) * 100)
		stats = stats .. '\n' .. statsIndent .. tooltipLabelTextColor .. "Health: " .. tooltipValueColor .. percentage .. "%"
		stats = stats .. "\n" .. tooltipDarkTextColor .. " (" ..tooltipLabelTextColor .. totalHealth .. tooltipDarkTextColor .. ' of ' .. tooltipLabelTextColor .. totalMaxHealthValue .. tooltipDarkTextColor .. ")"
	end

	-- DPS
	if totalDpsValue > 0 then
		stats = stats .. '\n' .. statsIndent .. tooltipLabelTextColor .. "DPS: " .. tooltipValueRedColor .. totalDpsValue .. "   "
	end

	if stats ~= '' then
		stats = '\n' .. stats
		if not cellHovered then
			stats = '\n' .. stats
		end
	end

	return stats
end

local sGetSelectedUnitsCount = Spring.GetSelectedUnitsCount

local function drawUnitInfo()
	local fontSize = (height * vsy * 0.123) * (0.95 - ((1 - ui_scale) * 0.5))

	local iconSize = math.floor(fontSize * 4.35)
	local iconPadding = math.floor(fontSize * 0.32)

	glColor(1, 1, 1, 1)
	if unitDefInfo[displayUnitDefID].buildPic then
		local iconX = backgroundRect[1] + iconPadding
		local iconY =  backgroundRect[4] - iconPadding - bgpadding

		glTexture(":lr"..unitIconSize..","..unitIconSize..":unitpics/" .. unitDefInfo[displayUnitDefID].buildPic)
		TexRectRound(iconX, iconY - iconSize, iconX + iconSize, iconY, bgpadding * 0.6, 1, 1, 1, 1, 0.03)
		glTexture(false)
		-- darkening bottom
		RectRound(iconX, iconY - iconSize, iconX + iconSize, iconY, bgpadding * 0.6, 0, 0, 1, 1, { 0, 0, 0, 0.15 }, { 0, 0, 0, 0 })
		-- gloss
		glBlending(GL_SRC_ALPHA, GL_ONE)
		RectRound(iconX, iconY - (iconSize*0.35), iconX + iconSize, iconY, bgpadding * 0.6, 1, 1, 0, 0, { 1, 1, 1, 0 }, { 1, 1, 1, 0.1 })
		RectRound(iconX, iconY - iconSize, iconX + iconSize, iconY-(iconSize*0.2), bgpadding * 0.6, 0, 0, 1, 1, { 1, 1, 1, 0.05 }, { 1, 1, 1, 0 })

		local halfSize = iconSize * 0.5
		RectRoundCircle(
				iconX + halfSize,
				0,
				iconY - halfSize,
				halfSize, bgpadding * 0.6, halfSize - math_max(1, bgpadding* 0.5), { 1, 1, 1, iconBorderOpacity }, { 1, 1, 1, iconBorderOpacity }
		)
		glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
		
		--if WG['buildmenu'] and (WG['buildmenu'].hoverID) then
		if WG['buildmenu'] and (WG['buildmenu'].hoverID) then
			local padding = (halfSize + halfSize) * 0.045
			local size = fontSize * 0.85
			
			
		
			
			font:Print("\255\245\245\245" .. unitDefInfo[displayUnitDefID].metalCost .. "\n\255\255\255\000" .. unitDefInfo[displayUnitDefID].energyCost .. "\n\255\001\255\255" .. unitDefInfo[displayUnitDefID].buildTime, iconX + padding, iconY  - halfSize- (halfSize*0.6) + padding + (size * 1.07), size, "o") --- halfSize
		end
	end
	iconSize = iconSize + iconPadding

	local dps, metalExtraction, stockpile, maxRange, exp, metalMake, metalUse, energyMake, energyUse
	local text, unitDescriptionLines = font:WrapText(unitDefInfo[displayUnitDefID].tooltip, (contentWidth - iconSize) * (loadedFontSize / fontSize))



	if displayUnitID then
		exp = spGetUnitExperience(displayUnitID)
		if exp and exp > 0.009 and WG['rankicons'] and rankTextures then
			local rankIconSize = math_floor((height * vsy * 0.19) )
			local rankIconMarginX = math_floor((height * vsy * 0.015) + 0.5) *5
			local rankIconMarginY = math_floor((height * vsy * 0.18) + 0.5) /5
			if displayUnitID then
				local rank = WG['rankicons'].getRank(displayUnitDefID, exp)
				if rankTextures[rank] then
					glColor(1, 1, 1, 1)
					glTexture(':lr' .. (rankIconSize * 2) .. ',' .. (rankIconSize * 2) .. ':' .. rankTextures[rank])
					glTexRect(backgroundRect[3] - rankIconMarginX - rankIconSize, backgroundRect[4] - rankIconMarginY - rankIconSize, backgroundRect[3] - rankIconMarginX, backgroundRect[4] - rankIconMarginY)
					glTexture(false)
					glColor(1, 1, 1, 1)
				end
			end
		end
	end

	-- unitID
	--if displayUnitID then
	--  local radarIconSpace = (radarIconMargin+radarIconSize)
	--  font:Begin()
	--  font:Print('\255\200\200\200#'..displayUnitID, backgroundRect[3]-radarIconMargin-radarIconSpace, backgroundRect[4]+(fontSize*0.6)-radarIconSpace, fontSize*0.8, "ro")
	--  font:End()
	--end


	local unitNameColor = '\255\205\255\205'
	if SelectedUnitsCount > 0 then
		if not displayMode == 'unitdef' or (WG['buildmenu'] and (WG['buildmenu'].selectedID and (not WG['buildmenu'].hoverID or (WG['buildmenu'].selectedID == WG['buildmenu'].hoverID)))) then
			unitNameColor = '\255\125\255\125'
		end
	end
	local descriptionColor = '\255\240\240\240'
	local metalColor = '\255\245\245\245'
	local energyColor = '\255\255\255\000'
	local healthColor = '\255\100\255\100'

	local labelColor = '\255\205\205\205'
	local valueColor = '\255\255\255\255'
	local valuePlusColor = '\255\180\255\180'
	local valueMinColor = '\255\255\180\180'

	-- custom unit info background
	local width = contentWidth * 0.81
	local height = (backgroundRect[4] - backgroundRect[2]) * (unitDescriptionLines > 1 and 0.495 or 0.6)

	-- unit tooltip
	font:Begin()
	font:Print(descriptionColor .. text, backgroundRect[3] - width + bgpadding, backgroundRect[4] - contentPadding - (fontSize * 2.17), fontSize * 0.98, "o")
	font:End()

	-- unit name
	font2:Begin()
	--font2:End()
	local nameLength = string.len(unitDefInfo[displayUnitDefID].humanName)
	if(nameLength>24) then
		font2:Print(unitNameColor .. unitDefInfo[displayUnitDefID].humanName, backgroundRect[3] - width + bgpadding, backgroundRect[4] - contentPadding - (fontSize * 0.89), fontSize * 0.95, "o")

	else
		font2:Print(unitNameColor .. unitDefInfo[displayUnitDefID].humanName, backgroundRect[3] - width + bgpadding, backgroundRect[4] - contentPadding - (fontSize * 0.89), fontSize * 1.12, "o")

	end
	  --width = 0.184
	
	-- custom unit info area
	customInfoArea = { math_floor(backgroundRect[3] - width - bgpadding), math_floor(backgroundRect[2]), math_floor(backgroundRect[3] - bgpadding), math_floor(backgroundRect[2] + height) }

	--if not displayMode == 'unitdef' or not unitDefInfo[displayUnitDefID].buildOptions or (not (WG['buildmenu'] and WG['buildmenu'].hoverID)) then
		RectRound(customInfoArea[1], customInfoArea[2], customInfoArea[3], customInfoArea[4], bgpadding, 1, 0, 0, 0, { 0.8, 0.8, 0.8, 0.06 }, { 0.8, 0.8, 0.8, 0.14 })
	--end

	local contentPaddingLeft = contentPadding * 0.75
	local texPosY = backgroundRect[4] - iconSize - (contentPadding * 0.64)
	local texSize = fontSize * 0.6

	local leftSideHeight = (backgroundRect[4] - backgroundRect[2]) * 0.47
	local posY1 = math_floor(backgroundRect[2] + leftSideHeight) - contentPadding - ((math_floor(backgroundRect[2] + leftSideHeight) - math_floor(backgroundRect[2])) * 0.1)
	local posY2 = math_floor(backgroundRect[2] + leftSideHeight) - contentPadding - ((math_floor(backgroundRect[2] + leftSideHeight) - math_floor(backgroundRect[2])) * 0.38)
	local posY3 = math_floor(backgroundRect[2] + leftSideHeight) - contentPadding - ((math_floor(backgroundRect[2] + leftSideHeight) - math_floor(backgroundRect[2])) * 0.67)

	local valueY1 = ''
	local valueY2 = ''
	local valueY3 = ''
	local health, maxHealth, _, _, buildProgress
	--[[if displayUnitID then
		local metalMake, metalUse, energyMake, energyUse = spGetUnitResources(displayUnitID)
		if metalMake then
			valueY1 = (metalMake > 0 and valuePlusColor .. '+' .. (metalMake < 10 and round(metalMake, 1) or round(metalMake, 0)) .. ' ' or '') .. (metalUse > 0 and valueMinColor .. '-' .. (metalUse < 10 and round(metalUse, 1) or round(metalUse, 0)) or '')
			valueY2 = (energyMake > 0 and valuePlusColor .. '+' .. (energyMake < 10 and round(energyMake, 1) or round(energyMake, 0)) .. ' ' or '') .. (energyUse > 0 and valueMinColor .. '-' .. (energyUse < 10 and round(energyUse, 1) or round(energyUse, 0)) or '')
			valueY3 = ''
		end

		-- display health value/bar
		health, maxHealth, _, _, buildProgress = spGetUnitHealth(displayUnitID)
		if health then
			local healthBarWidth = (backgroundRect[3] - backgroundRect[1]) * 0.15
			local healthBarHeight = healthBarWidth * 0.1
			local healthBarMargin = healthBarHeight * 0.7
			local healthBarPadding = healthBarHeight * 0.15
			local healthValueWidth = (healthBarWidth - healthBarPadding) * (health / maxHealth)
			local color = bfcolormap[math_min(math_max(math_floor((health / maxHealth) * 100), 0), 100)]
			valueY3 = convertColor(color[1], color[2], color[3]) .. math_floor(health)
		end
	else 
	end]]--
	
		--if WG['buildmenu'].hoverID then
		--valueY1 = unitNameColor .. unitDefInfo[displayUnitDefID].metalCost
		--valueY2 = unitNameColor .. unitDefInfo[displayUnitDefID].energyCost
		--valueY3 = unitNameColor .. unitDefInfo[displayUnitDefID].health
		--else 
	--end
	
	if(unitDefInfo[displayUnitDefID].dps) then
		if(unitDefInfo[displayUnitDefID].dps>99999) then
			valueY1 = unitNameColor .. '99999'
		else
			valueY1 = unitNameColor .. unitDefInfo[displayUnitDefID].dps
		end
	end
	
	if(unitDefInfo[displayUnitDefID].maxWeaponRange) then
		valueY2 = unitNameColor .. unitDefInfo[displayUnitDefID].maxWeaponRange
	end
	
	if(unitDefInfo[displayUnitDefID].speed) then
		valueY3 = unitNameColor .. unitDefInfo[displayUnitDefID].speed
	end
	
	
	
	

	glColor(1, 1, 1, 1)
	local texDetailSize = math_floor(texSize * 4)
	if valueY1 ~= '' then
		glTexture(":lr" .. texDetailSize .. "," .. texDetailSize .. ":LuaUI/Images/info_damage.png")
		glTexRect(backgroundRect[1] + contentPaddingLeft - (texSize * 0.6), posY1 - texSize, backgroundRect[1] + contentPaddingLeft + (texSize * 1.4), posY1 + texSize)
	end
	if valueY2 ~= '' then
		glTexture(":lr" .. texDetailSize .. "," .. texDetailSize .. ":LuaUI/Images/info_range.png")
		glTexRect(backgroundRect[1] + contentPaddingLeft - (texSize * 0.6), posY2 - texSize, backgroundRect[1] + contentPaddingLeft + (texSize * 1.4), posY2 + texSize)
	end
	if valueY3 ~= '' then
		glTexture(":lr" .. texDetailSize .. "," .. texDetailSize .. ":LuaUI/Images/info_speed.png")
		glTexRect(backgroundRect[1] + contentPaddingLeft - (texSize * 0.6), posY3 - texSize, backgroundRect[1] + contentPaddingLeft + (texSize * 1.4), posY3 + texSize)
	end
	glTexture(false)

	-- metal
	local fontSize2 = fontSize * 0.87
	local contentPaddingLeft = contentPaddingLeft + texSize + (contentPadding * 0.5)
	font2:Print(valueY1, backgroundRect[1] + contentPaddingLeft, posY1 - (fontSize2 * 0.31), fontSize2, "o")
	-- energy
	font2:Print(valueY2, backgroundRect[1] + contentPaddingLeft, posY2 - (fontSize2 * 0.31), fontSize2, "o")
	-- health
	font2:Print(valueY3, backgroundRect[1] + contentPaddingLeft, posY3 - (fontSize2 * 0.31), fontSize2, "o")
	font2:End()

	-- draw unit buildoption icons
	--if displayMode == 'unitdef' and unitDefInfo[displayUnitDefID].buildOptions then
		
	--else
		-- unit/unitdef info (without buildoptions)


		contentPadding = contentPadding * 0.95
		local contentPaddingLeft = customInfoArea[1] + contentPadding

		local text = ''
		local separator = ''
		local infoFontsize = fontSize --*0.94 --fontSize * 0.86
		-- to determine what to show in what order
		local function addTextInfo(label, value)
			text = text .. labelColor .. separator .. string.upper(label:sub(1, 1)) .. label:sub(2)  .. valueColor .. (value and (label ~= '' and ' ' or '')..value or '')
			separator = ',   '
		end



		local text, _ = font:WrapText(text, ((backgroundRect[3] - bgpadding - bgpadding - bgpadding) - (backgroundRect[1] + contentPaddingLeft)) * (loadedFontSize / infoFontsize))

		-- prune number of lines
		local lines = lines(text)
		text = ''
		for i, line in pairs(lines) do
			text = text .. line
			-- only 4 fully fit, but showing 5, so the top part of text shows and indicates there is more to see somehow
			if i == 5 then
				break
			end
			text = text .. '\n'
		end
		lines = nil

		--local caption
		
		local unitcount = sGetSelectedUnitsCount()
			if (unitcount ~= 0) then
				caption = "Selected units: "..unitcount.."\n"
			else
				caption = ""--"\n"
			end
		
		

		
		lines = {}
					for s in spGetCurrentTooltip():gmatch("[^\r\n]+") do
						table.insert(lines, s)
					end
		
		--width = 0.2125  --width = 0.184
		
		local editedline = lines[3]
		if lines[3] and (sfind(lines[3],'Range')) then
			editedline = lines[3]:match("^[^R]+")
		end
		
	

		if lines[2] and editedline and lines[4] then
		local myString = lines[4]
		
		myString = string.gsub(myString, "Metal", "M")
		 myString = string.gsub(myString,"Energy", "E")
		
		
		words = lines[2].."\n"..editedline .."\n"..myString.."\n"
		end

		-- display unit(def) info text
		
		if displayMode == 'unit' then
		
		font:Begin()
				font:Print(caption .. words, customInfoArea[3] - width + (bgpadding*2.4), customInfoArea[4] - contentPadding - (infoFontsize * 0.55), infoFontsize, "o") --.. caption

		--font:Print(text, customInfoArea[3] - width + (bgpadding*2.4), customInfoArea[4] - contentPadding - (infoFontsize * 0.55), infoFontsize, "o")
		font:End()
		end

	--end
end

local function pruneLines()

end

local function drawEngineTooltip()
	--local labelColor = '\255\205\205\205'
	--local valueColor = '\255\255\255\255'

	-- display default plaintext engine tooltip
	local fontSize = (height * vsy * 0.12) * (0.95 - ((1 - ui_scale) * 0.5))
	local text, numLines = font:WrapText(currentTooltip, contentWidth * (loadedFontSize / fontSize))
	font:Begin()
	font:Print(text, backgroundRect[1] + contentPadding, backgroundRect[4] - contentPadding - (fontSize * 0.8), fontSize, "o")
	font:End()
end

local function drawInfo()
	-- background
	RectRound(backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4], bgpadding * 1.5, (WG['buildpower'] and 0 or 1), 1, 1, 0, { 0.05, 0.05, 0.05, ui_opacity }, { 0, 0, 0, ui_opacity })
	RectRound(backgroundRect[1] , backgroundRect[2] + ( 0), backgroundRect[3] - bgpadding, backgroundRect[4] - bgpadding, bgpadding, (WG['buildpower'] and 0 or 1), 1, 0, 1, { 0.3, 0.3, 0.3, ui_opacity * 0.1 }, { 1, 1, 1, ui_opacity * 0.1 })

	-- gloss
	glBlending(GL_SRC_ALPHA, GL_ONE)
	RectRound(backgroundRect[1], backgroundRect[4] - bgpadding - ((backgroundRect[4] - backgroundRect[2]) * (stickToBottom and 0.15 or 0.07)), backgroundRect[3] - bgpadding, backgroundRect[4] - bgpadding, bgpadding, (WG['buildpower'] and 0 or 1), 1, 0, 0, { 1, 1, 1, 0.006 * glossMult }, { 1, 1, 1, 0.055 * glossMult })
	RectRound(backgroundRect[1], backgroundRect[2] + (0), backgroundRect[3] - bgpadding, backgroundRect[2] + bgpadding + ((backgroundRect[4] - backgroundRect[2]) * 0.045), bgpadding, 0, 0, 1, 0, { 1, 1, 1, 0.025 * glossMult }, { 1, 1, 1, 0 })
	glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

	contentPadding = (height * vsy * 0.075) * (0.95 - ((1 - ui_scale) * 0.5))
	contentWidth = backgroundRect[3] - backgroundRect[1] - contentPadding - contentPadding

	if displayMode ~= 'text' and displayUnitDefID then
		drawUnitInfo()
	else
		drawEngineTooltip()
	end
end



local function LeftMouseButton(unitDefID, unitTable)
	local alt, ctrl, meta, shift = spGetModKeyState()
	local acted = false
	if not ctrl then
		-- select units of icon type
		if alt or meta then
			acted = true
			spSelectUnitArray({ unitTable[1] })  -- only 1
		else
			acted = true
			spSelectUnitArray(unitTable)
		end
	else
		-- select all units of the icon type
		local sorted = spGetTeamUnitsSorted(myTeamID)
		local units = sorted[unitDefID]
		if units then
			acted = true
			spSelectUnitArray(units, shift)
		end
	end

end

local function MiddleMouseButton(unitDefID, unitTable)
	local alt, ctrl, meta, shift = spGetModKeyState()
	-- center the view
	if ctrl then
		-- center the view on the entire selection
		Spring.SendCommands( "viewselection" )
	else
		-- center the view on this type on unit
		spSelectUnitArray(unitTable)
		Spring.SendCommands( "viewselection" )
		spSelectUnitArray(selectedUnits)
	end
end

local function RightMouseButton(unitDefID, unitTable)
	local alt, ctrl, meta, shift = spGetModKeyState()
	-- remove selected units of icon type
	local map = {}
	for i = 1, #selectedUnits do
		map[selectedUnits[i]] = true
	end
	for _, uid in ipairs(unitTable) do
		map[uid] = nil
		if ctrl then
			break
		end -- only remove 1 unit
	end
	spSelectUnitMap(map)
end

function widget:MousePress(x, y, button)
	if Spring.IsGUIHidden() then
		return
	end
	if IsOnRect(x, y, backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4]) then
		return true
	end
end

function widget:MouseRelease(x, y, button)
	if Spring.IsGUIHidden() then
		return
	end
	if displayMode and displayMode == 'selection' and customInfoArea and IsOnRect(x, y, customInfoArea[1], customInfoArea[2], customInfoArea[3], customInfoArea[4]) then
		if selectionCells and selectionCells[1] and cellRect then
			for cellID, unitDefID in pairs(selectionCells) do
				if cellRect[cellID] and IsOnRect(x, y, cellRect[cellID][1], cellRect[cellID][2], cellRect[cellID][3], cellRect[cellID][4]) then
					-- apply selection
					--if b then
					--  local alt, ctrl, meta, shift = spGetModKeyState()
					--  -- select all units of the icon type
					--  local sorted = spGetTeamUnitsSorted(myTeamID)
					--  local units = sorted[unitDefID]
					--  local acted = false
					--  if units then
					--    acted = true
					--    spSelectUnitArray(units, shift)
					--  end
					--  if acted then
					--  end
					--end


					local unitTable = nil
					local index = 0
					for udid, uTable in pairs(selUnitsSorted) do
						if udid == unitDefID then
							unitTable = uTable
							break
						end
						index = index + 1
					end
					if unitTable == nil then
						return -1
					end

					if button == 1 then
						LeftMouseButton(unitDefID, unitTable)
					elseif button == 2 then
						MiddleMouseButton(unitDefID, unitTable)
					elseif button == 3 then
						RightMouseButton(unitDefID, unitTable)
					end
					return -1
				end
			end
		end
	end

	if WG['smartselect'] and not WG['smartselect'].updateSelection then
		return
	end
	if (not activePress) then
		return -1
	end
	activePress = false
	local icon = MouseOverIcon(x, y)

	local units = spGetSelectedUnitsSorted()
	if (units.n ~= unitTypes) then
		return -1  -- discard this click
	end
	units.n = nil

	local unitDefID = -1
	local unitTable = nil
	local index = 0
	for udid, uTable in pairs(units) do
		if (index == icon) then
			unitDefID = udid
			unitTable = uTable
			break
		end
		index = index + 1
	end
	if (unitTable == nil) then
		return -1
	end

	local alt, ctrl, meta, shift = spGetModKeyState()

	if (button == 1) then
		LeftMouseButton(unitDefID, unitTable)
	elseif (button == 2) then
		MiddleMouseButton(unitDefID, unitTable)
	elseif (button == 3) then
		RightMouseButton(unitDefID, unitTable)
	end

	return -1
end

function widget:DrawScreen()


	if ViewResizeUpdate then
		ViewResizeUpdate = nil
		refreshUnitIconCache()
	end
	local x, y, b, b2, b3 = spGetMouseState()

	if doUpdate or (doUpdateClock and os_clock() >= doUpdateClock) then
		doUpdateClock = nil
		clear()
		doUpdate = nil
		lastUpdateClock = os_clock()
	end

	if not dlistInfo then
		dlistInfo = gl.CreateList(function()
			drawInfo()
		end)
	end
	gl.CallList(dlistInfo)



	-- widget hovered
	if IsOnRect(x, y, backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4]) then

		Spring.SetMouseCursor('cursornormal')

		if displayMode == 'unit' then

			if WG['unitstats'] and WG['unitstats'].showUnit then
				WG['unitstats'].showUnit(displayUnitID)
			end
		end
	end
end

function checkChanges()
	local x, y, b, b2, b3 = spGetMouseState()
	lastType = hoverType
	lastHoverData = hoverData
	hoverType, hoverData = spTraceScreenRay(x, y)
	
	prevDisplayMode = displayMode
	prevDisplayUnitDefID = displayUnitDefID
	prevDisplayUnitID = displayUnitID

	-- determine what mode to display
	displayMode = 'text'
	displayUnitID = nil
	displayUnitDefID = nil

	-- buildmenu unitdef
	if WG['buildmenu'] and (WG['buildmenu'].hoverID or WG['buildmenu'].selectedID) then
		displayMode = 'unitdef'
		displayUnitDefID = WG['buildmenu'].hoverID or WG['buildmenu'].selectedID

	elseif cfgDisplayUnitID and Spring.ValidUnitID(cfgDisplayUnitID) then
		displayMode = 'unit'
		displayUnitID = cfgDisplayUnitID
		displayUnitDefID = spGetUnitDefID(displayUnitID)
		if lastUpdateClock + 0.6 < os_clock() then
			-- unit stats could have changed meanwhile
			doUpdate = true
		end

		-- hovered unit
	elseif not IsOnRect(x, y, backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4]) and hoverType and hoverType == 'unit'  then
		-- add small hover delay against eplilepsy
		displayMode = 'unit'
		displayUnitID = hoverData
		displayUnitDefID = spGetUnitDefID(displayUnitID)
		if lastUpdateClock + 0.6 < os_clock() then
			-- unit stats could have changed meanwhile
			doUpdate = true
		end

		-- hovered feature
	elseif not IsOnRect(x, y, backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4]) and hoverType and hoverType == 'feature'  then
		-- add small hover delay against eplilepsy
		--displayMode = 'feature'
		--displayFeatureID = hoverData
		--displayFeatureDefID = spGetUnitDefID(displayUnitID)
		local newTooltip = spGetCurrentTooltip()
		if newTooltip ~= currentTooltip then
			currentTooltip = newTooltip
			doUpdate = true
		end

		-- selected unit
	elseif SelectedUnitsCount >= 1 then
		displayMode = 'unit'
		displayUnitID = selectedUnits[1]
		displayUnitDefID = spGetUnitDefID(selectedUnits[1])
		if lastUpdateClock + 0.6 < os_clock() then
			-- unit stats could have changed meanwhile
			doUpdate = true
		end

		-- selection
	--elseif SelectedUnitsCount > 1 then
	--	displayMode = 'selection'

		-- tooltip text
	else
		local newTooltip = spGetCurrentTooltip()
		if newTooltip ~= currentTooltip then
			currentTooltip = newTooltip
			doUpdate = true
		end
	end

	-- display changed
	if prevDisplayMode ~= displayMode or prevDisplayUnitDefID ~= displayUnitDefID or prevDisplayUnitID ~= displayUnitID then
		doUpdate = true
	end
end

function widget:SelectionChanged(sel)
	if SelectedUnitsCount ~= 0 and spGetSelectedUnitsCount() == 0 then
		doUpdate = true
		SelectedUnitsCount = 0
		selectedUnits = {}
	end
	if spGetSelectedUnitsCount() > 0 then
		SelectedUnitsCount = spGetSelectedUnitsCount()
		selectedUnits = sel
		if not doUpdateClock then
			doUpdateClock = os_clock() + 0.05  -- delay to save some performance
		end
	end
end
