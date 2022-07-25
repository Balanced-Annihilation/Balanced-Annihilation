function widget:GetInfo()
	return {
		name = "Build menu alternate",
		desc = "",
		author = "Floris",
		date = "April 2020",
		license = "GNU GPL, v2 or later",
		layer = 0,
		enabled = true,
		handler = true,
	}
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local stickToBottom = false

local alwaysShow = false

local cfgCellPadding = 0.007
local cfgIconPadding = 0.015 -- space between icons
local cfgIconCornerSize = 0.025
local cfgRadaiconSize = 0.29
local cfgRadariconOffset = 0.027
local cfgPriceFontSize = 0.19
local cfgActiveAreaMargin = 0.05 -- (# * bgpadding) space between the background border and active area

local defaultColls = 5
local dynamicIconsize = false
local minColls = 5
local maxColls = 5

local showOrderDebug = false
local smartOrderUnits = false

local maxPosY = 0.73

local enableShortcuts = false   -- problematic since it overrules use of top row letters from keyboard which some are in use already

local makeFancy = true    -- when using transparant icons this adds highlights so it shows the squared shape of button
local showPrice = false
local showRadarIcon = false
local showShortcuts = false
local showTooltip = false
local showBuildProgress = true

local iconBorderOpacity = 0.1  -- lighten the icon edges

local texDetailMult = 1.25   -- dont go too high, will get pixely
local radartexDetailMult = 2   -- dont go too high, will get pixely

local zoomMult = 1.5
local defaultCellZoom = 0.025 * zoomMult
local rightclickCellZoom = 0.033 * zoomMult
local clickCellZoom = 0.07 * zoomMult
local hoverCellZoom = 0.05 * zoomMult
local clickSelectedCellZoom = 0.125 * zoomMult
local selectedCellZoom = 0.135 * zoomMult


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local buildKeys = {
	113, -- Q
	119, -- W
	101, -- E
	114, -- R
	116, -- T
	121, -- Y
	117, -- U
	105, -- I
	111, -- O
	112, -- P
}

local sound_queue_add = 'LuaUI/Sounds/buildbar_add.wav'
local sound_queue_rem = 'LuaUI/Sounds/buildbar_rem.wav'
--local sound_button = 'LuaUI/Sounds/buildbar_waypoint.wav'

	local fontfile ="LuaUI/Fonts/FreeSansBold.otf"

local vsx, vsy = Spring.GetViewGeometry()

local ordermenuLeft = vsx / 5
local advplayerlistLeft = vsx * 0.8

local ui_opacity = tonumber(Spring.GetConfigFloat("ui_opacity", 0.66) or 0.66)
local ui_scale = tonumber(Spring.GetConfigFloat("ui_scale", 1) or 1)
local glossMult = 1 + (2 - (ui_opacity * 2))    -- increase gloss/highlight so when ui is transparant, you can still make out its boundaries and make it less flat

local isSpec = Spring.GetSpectatingState()
local myTeamID = Spring.GetMyTeamID()
local myPlayerID = Spring.GetMyPlayerID()

local teamList = Spring.GetTeamList()

local buildQueue = {}
local disableInput = isSpec
local backgroundRect = { 0, 0, 0, 0 }
local colls = 5
local rows = 5
local minimapHeight = 0.235
local minimapEnlarged = false
local posY = 0
local posY2 = 0
local posX = 0
local posX2 = 0.2
local width = 0
local height = 0
local selectedBuilders = {}
local selectedBuilderCount = 0
local selectedFactories = {}
local selectedFactoryCount = 0
local cellRects = {}
local cmds = {}
local lastUpdate = os.clock() - 1
local currentPage = 1
local pages = 1
local paginatorRects = {}
local preGamestartPlayer = Spring.GetGameFrame() == 0 and not isSpec

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local spEcho = Spring.Echo
local spIsUnitSelected = Spring.IsUnitSelected
local spGetSelectedUnitsCount = Spring.GetSelectedUnitsCount
local spGetSelectedUnits = Spring.GetSelectedUnits
local spGetActiveCommand = Spring.GetActiveCommand
local spGetActiveCmdDescs = Spring.GetActiveCmdDescs
local spGetCmdDescIndex = Spring.GetCmdDescIndex
local spGetUnitDefID = Spring.GetUnitDefID
local spGetTeamStartPosition = Spring.GetTeamStartPosition
local spGetTeamRulesParam = Spring.GetTeamRulesParam
local spGetGroundHeight = Spring.GetGroundHeight
local spGetMouseState = Spring.GetMouseState
local spTraceScreenRay = Spring.TraceScreenRay
local spGetUnitHealth = Spring.GetUnitHealth
local SelectedUnitsCount = spGetSelectedUnitsCount()
local spGetUnitIsBuilding = Spring.GetUnitIsBuilding

local string_sub = string.sub
local string_gsub = string.gsub
local os_clock = os.clock

local math_floor = math.floor
local math_ceil = math.ceil
local math_max = math.max
local math_min = math.min
local math_tan = math.tan
local math_pi = math.pi
local math_cos = math.cos
local math_sin = math.sin
local math_rad = math.rad
local math_twicePi = math.pi * 2

local GL_QUADS = GL.QUADS
local glShape = gl.Shape
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
local GL_DST_ALPHA = GL.DST_ALPHA
local GL_ONE_MINUS_SRC_COLOR = GL.ONE_MINUS_SRC_COLOR
local glDepthTest = gl.DepthTest

--local glCreateTexture = gl.CreateTexture
--local glActiveTexture = gl.ActiveTexture
--local glCopyToTexture = gl.CopyToTexture
--local glRenderToTexture = gl.RenderToTexture

function table_invert(t)
	local s = {}
	for k, v in pairs(t) do
		s[v] = k
	end
	return s
end

local function convertColor(r, g, b)
	return string.char(255, (r * 255), (g * 255), (b * 255))
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

local unitBuildPic = {}
local unitEnergyCost = {}
local unitMetalCost = {}
local unitGroup = {}
local isBuilder = {}
local isFactory = {}
local unitHumanName = {}
local unitDescriptionLong = {}
local unitTooltip = {}
local unitIconType = {}
local isMex = {}
local unitMaxWeaponRange = {}

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

for unitDefID, unitDef in pairs(UnitDefs) do
	unitHumanName[unitDefID] = unitDef.humanName
	if unitDef.maxWeaponRange > 16 then
		unitMaxWeaponRange[unitDefID] = unitDef.maxWeaponRange
	end
	if unitDef.customParams.description_long then
		unitDescriptionLong[unitDefID] = wrap(unitDef.customParams.description_long, 58)
	end
	unitTooltip[unitDefID] = unitDef.tooltip
	unitIconType[unitDefID] = unitDef.iconType
	unitEnergyCost[unitDefID] = unitDef.energyCost
	unitMetalCost[unitDefID] = unitDef.metalCost
	unitGroup = {}

	unitBuildPic[unitDefID] = unitDef.buildpicname
	if unitBuildPic[unitDefID] == '' then
		unitBuildPic[unitDefID] = lookupUnitBuildPicture(unitDef, {'dds', 'pcx'})
	end

	if unitDef.buildSpeed > 0 and unitDef.buildOptions[1] then
		isBuilder[unitDefID] = unitDef.buildOptions
	end
	if unitDef.isFactory and #unitDef.buildOptions > 0 then
		isFactory[unitDefID] = true
	end
	if unitDef.extractsMetal > 0 then
		isMex[unitDefID] = true
	end
end

local unitOrder = {}
local function addOrderImportance(unitDefID, skip, value)
	if not skip then
		unitOrder[unitDefID] = unitOrder[unitDefID] + value
	end
end

-- order units, add higher value for order importance
local skip = false
for unitDefID, unitDef in pairs(UnitDefs) do
	skip = false
	unitOrder[unitDefID] = 20000000

	-- handle decoy unit like its the regular version
	if unitDef.customParams.decoyfor then
		unitDef = UnitDefNames[unitDef.customParams.decoyfor]
		unitOrder[unitDefID] = unitOrder[unitDefID] - 2
	end

	-- is water unit
	local isWaterUnit = false
	if unitDef.name ~= 'armmex' and unitDef.name ~= 'cormex' and (unitDef.minWaterDepth > 0 or unitDef.modCategories['ship'] or unitDef.modCategories['underwater']) then
		isWaterUnit = true
		unitOrder[unitDefID] = 500000
	end

	-- mobile units
	if not (unitDef.isImmobile or unitDef.isBuilding) then
		addOrderImportance(unitDefID, skip, 15000000)
	end

	-- eco buildings
	if unitDef.isImmobile or unitDef.isBuilding then
		if unitDef.tidalGenerator > 0 then
			addOrderImportance(unitDefID, skip, 12000000)
		elseif unitDef.extractsMetal > 0 then
			addOrderImportance(unitDefID, skip, 14000000)
		elseif unitDef.windGenerator > 0 then
			addOrderImportance(unitDefID, skip, 13000000)
		elseif unitDef.energyMake > 19 and (not unitDef.energyUpkeep or unitDef.energyUpkeep < 10) then
			addOrderImportance(unitDefID, skip, 12000000)
		elseif unitDef.energyUpkeep < -19 then
			addOrderImportance(unitDefID, skip, 12500000)
		end

		-- storage
		if unitDef.energyStorage > 1000 and string.find(string.lower(unitDef.humanName), 'storage') then
			addOrderImportance(unitDefID, skip, 11000000)
		end
		if unitDef.metalStorage > 500 and string.find(string.lower(unitDef.humanName), 'storage') then
			addOrderImportance(unitDefID, skip, 11000000)
		end

		-- converters
		if string.find(string.lower(unitDef.humanName), 'converter') then
			addOrderImportance(unitDefID, skip, 10000000)
		end
	end

	-- nanos
	if unitDef.buildSpeed > 0 and not unitDef.buildOptions[1] then
		addOrderImportance(unitDefID, skip, 3500000)
	end

	if unitDef.buildOptions[1] then
		if unitDef.isBuilding then
			addOrderImportance(unitDefID, skip, 2500000)
		else
			if string.find(string.lower(unitDef.humanName), 'construction') then
				addOrderImportance(unitDefID, skip, 6000000)
			elseif string.find(string.lower(unitDef.tooltip), 'minelayer') or string.find(string.lower(unitDef.tooltip), 'assist') or string.find(string.lower(unitDef.tooltip), 'engineer') then
				addOrderImportance(unitDefID, skip, 4000000)
			else
				addOrderImportance(unitDefID, skip, 5000000)
			end
		end
	end
	-- if unitDef.isImmobile or  unitDef.isBuilding then
	--   if unitDef.floater or unitDef.floatOnWater then
	--     addOrderImportance(unitDefID, skip, 11000000)
	--   elseif unitDef.modCategories['underwater'] or unitDef.modCategories['canbeuw'] or unitDef.modCategories['notland'] then
	--     addOrderImportance(unitDefID, skip, 10000000)
	--   else
	--     addOrderImportance(unitDefID, skip, 12000000)
	--   end
	-- else
	--   if unitDef.modCategories['ship'] then
	--     addOrderImportance(unitDefID, skip, 9000000)
	--   elseif unitDef.modCategories['hover'] then
	--     addOrderImportance(unitDefID, skip, 8000000)
	--   elseif unitDef.modCategories['tank'] then
	--     addOrderImportance(unitDefID, skip, 7000000)
	--   elseif unitDef.modCategories['bot'] then
	--     addOrderImportance(unitDefID, skip, 6000000)
	--   elseif unitDef.isAirUnit then
	--     addOrderImportance(unitDefID, skip, 5000000)
	--   elseif unitDef.modCategories['underwater'] or unitDef.modCategories['canbeuw'] or unitDef.modCategories['notland'] then
	--     addOrderImportance(unitDefID, skip, 8600000)
	--   end
	-- end


	unitOrder[unitDefID] = math_max(1, math_floor(unitOrder[unitDefID]))

	-- make more expensive units of the same kind lower in the list
	unitOrder[unitDefID] = unitOrder[unitDefID] + 1000000
	addOrderImportance(unitDefID, skip, -(unitDef.energyCost / 70))
	addOrderImportance(unitDefID, skip, -unitDef.metalCost)

	unitOrder[unitDefID] = math_max(1, math_floor(unitOrder[unitDefID]))
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
local unitOrderDebug = {}
for unitDefID, unitDef in pairs(UnitDefs) do
	local uDefID = getHighestOrderedUnit()
	unitsOrdered[#unitsOrdered + 1] = uDefID
	unitOrderDebug[uDefID] = unitOrder[uDefID]
	unitOrder[uDefID] = nil
end

if not showOrderDebug then
	unitOrderDebug = nil
end
unitOrder = unitsOrdered
unitsOrdered = nil

--for k, unitDefID in pairs(unitOrder) do
--  Spring.Echo(k..'  '..unitHumanName[unitDefID])
--end


-- load all icons to prevent briefly showing white unit icons (will happen due to the custom texture filtering options)
local function cacheUnitIcons()
	local minC = minColls
	local maxC = maxColls
	if not dynamicIconsize then
		minC = defaultColls
		maxC = defaultColls
	end
	if minC > maxC then
		maxC = minC
	end -- just to be sure

	local activeArea = { backgroundRect[1] + (stickToBottom and bgpadding or 0) + activeAreaMargin, backgroundRect[2] + (stickToBottom and 0 or bgpadding) + activeAreaMargin, backgroundRect[3] - bgpadding - activeAreaMargin, backgroundRect[4] - bgpadding - activeAreaMargin }
	local contentWidth = activeArea[3] - activeArea[1]
	local colls = minC
	local cellSize = math_floor((contentWidth / colls) + 0.33)
	local cellPadding = math_floor(cellSize * cfgCellPadding)
	local cellInnerSize = cellSize - cellPadding - cellPadding
	local newTextureDetail = math_floor(cellInnerSize * (1 + defaultCellZoom) * texDetailMult)
	local newRadariconTextureDetail = math_floor(math_floor((cellInnerSize * cfgRadaiconSize) + 0.5) * radartexDetailMult)
	if not textureDetail or textureDetail ~= newTextureDetail then
		while colls <= maxC do
			-- these are globals so it can be re-used (hover highlight)
			gl.Color(1, 1, 1, 0.001)
			for id, unit in pairs(UnitDefs) do
				-- only caching for defaultCellZoom
				if unitBuildPic[id] then
					gl.Texture(':lr' .. newTextureDetail .. ',' .. newTextureDetail .. ':unitpics/' .. unitBuildPic[id])
					if textureDetail then	-- delete old texture
						gl.DeleteTexture(':lr' .. textureDetail .. ',' .. textureDetail .. ':unitpics/' .. unitBuildPic[id])
					end
				end
				if unitIconType[id] and iconTypesMap[unitIconType[id]] then
					gl.TexRect(-1, -1, 0, 0)
					gl.Texture(':lr' .. newRadariconTextureDetail .. ',' .. newRadariconTextureDetail .. ':' .. iconTypesMap[unitIconType[id]])
					gl.TexRect(-1, -1, 0, 0)
					if radariconTextureDetail then	-- delete old texture
						gl.DeleteTexture(':lr' .. radariconTextureDetail .. ',' .. radariconTextureDetail .. ':' .. iconTypesMap[unitIconType[id]])
					end
				end
				gl.Texture(false)
			end
			gl.Color(1, 1, 1, 1)
			colls = colls + 1
		end
		textureDetail = newTextureDetail
		radariconTextureDetail = newRadariconTextureDetail
	end
end

local function refreshUnitIconCache()
	if dlistCache then
		dlistCache = gl.DeleteList(dlistCache)
	end
	dlistCache = gl.CreateList(function()
		cacheUnitIcons()
	end)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- RectRound(px,py,sx,sy,cs, tl,tr,br,bl, c1,c2): Draw a rectangular shape with cut off edges
--  optional: tl,tr,br,bl  0 = corner, 1 = depending on touching screen border, 2 = always
--  optional: c1,c2 for top-down color gradients
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

	-- bottom left corner
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

	-- bottom right corner
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

	-- top left corner
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

	-- top right corner
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
	--gl.Texture(false)   -- just make sure you do this before calling this function, or uncomment this line
	gl.BeginEnd(GL.QUADS, DrawRectRound, px, py, sx, sy, cs, tl, tr, br, bl, c1, c2)
end


-- cs (corner size) is not implemented yet
local function RectRoundProgress(left, bottom, right, top, cs, progress, color)

	local xcen = (left + right) / 2
	local ycen = (top + bottom) / 2

	local alpha = 360 * (progress)
	local alpha_rad = math_rad(alpha)
	local beta_rad = math_pi / 2 - alpha_rad
	local list = {}
	local listCount = 1
	list[listCount] = { v = { xcen, ycen } }
	listCount = listCount + 1
	list[#list + 1] = { v = { xcen, top } }

	local x, y
	x = (top - ycen) * math_tan(alpha_rad) + xcen
	if alpha < 90 and x < right then
		-- < 25%
		listCount = listCount + 1
		list[listCount] = { v = { x, top } }
	else
		listCount = listCount + 1
		list[listCount] = { v = { right, top } }
		y = (right - xcen) * math_tan(beta_rad) + ycen
		if alpha < 180 and y > bottom then
			-- < 50%
			listCount = listCount + 1
			list[listCount] = { v = { right, y } }
		else
			listCount = listCount + 1
			list[listCount] = { v = { right, bottom } }
			x = (top - ycen) * math_tan(-alpha_rad) + xcen
			if alpha < 270 and x > left then
				-- < 75%
				listCount = listCount + 1
				list[listCount] = { v = { x, bottom } }
			else
				listCount = listCount + 1
				list[listCount] = { v = { left, bottom } }
				y = (right - xcen) * math_tan(-beta_rad) + ycen
				if alpha < 350 and y < top then
					-- < 97%
					listCount = listCount + 1
					list[listCount] = { v = { left, y } }
				else
					listCount = listCount + 1
					list[listCount] = { v = { left, top } }
					x = (top - ycen) * math_tan(alpha_rad) + xcen
					listCount = listCount + 1
					list[listCount] = { v = { x, top } }
				end
			end
		end
	end

	glColor(color[1], color[2], color[3], color[4])
	glShape(GL_TRIANGLE_FAN, list)
	glColor(1, 1, 1, 1)
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
		glColor(color2)
		glVertex(coords[i][1], coords[i][2], coords[i][3])
		glVertex(coords[i2][1], coords[i2][2], coords[i2][3])
		glColor(color1)
		glVertex(coords2[i2][1], coords2[i2][2], coords2[i2][3])
		glVertex(coords2[i][1], coords2[i][2], coords2[i][3])
	end
end
local function RectRoundCircle(x, y, z, radius, cs, centerOffset, color1, color2)
	glBeginEnd(GL.QUADS, DrawRectRoundCircle, x, y, z, radius, cs, centerOffset, color1, color2)
end

local function DrawCircle(x, y, z, radius, sides, color1, color2)
	if not color2 then
		color2 = color1
	end
	local sideAngle = math_twicePi / sides
	glColor(color1)
	glVertex(x, z, y)
	glColor(color2)
	for i = 1, sides + 1 do
		local cx = x + (radius * math_cos(i * sideAngle))
		local cz = z + (radius * math_sin(i * sideAngle))
		glVertex(cx, cz, y)
	end
end

local function doCircle(x, y, z, radius, sides, color1, color2)
	glBeginEnd(GL_TRIANGLE_FAN, DrawCircle, x, 0, z, radius, sides, color1, color2)
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

function IsOnRect(x, y, BLcornerX, BLcornerY, TRcornerX, TRcornerY)
	return x >= BLcornerX and x <= TRcornerX and y >= BLcornerY and y <= TRcornerY
end

function widget:PlayerChanged(playerID)
	isSpec = Spring.GetSpectatingState()
	myTeamID = Spring.GetMyTeamID()
	myPlayerID = Spring.GetMyPlayerID()
end

local function RefreshCommands()
	cmds = {}
	cmdsCount = 0

	if preGamestartPlayer then
		if startDefID then
			-- mimmick output of spGetActiveCmdDescs
			for i, udefid in pairs(UnitDefs[startDefID].buildOptions) do
				cmdsCount = cmdsCount + 1
				cmds[cmdsCount] = {
					id = udefid * -1,
					name = UnitDefs[udefid].name,
					params = {}
				}
			end
		end
	else

		local activeCmdDescs = spGetActiveCmdDescs()
		if smartOrderUnits then
			local cmdUnitdefs = {}
			for index, cmd in pairs(activeCmdDescs) do
				if type(cmd) == "table" then
					if string_sub(cmd.action, 1, 10) == 'buildunit_' then
						-- not cmd.disabled and cmd.type == 20 or
						cmdUnitdefs[cmd.id * -1] = index
					end
				end
			end
			for k, uDefID in pairs(unitOrder) do
				if cmdUnitdefs[uDefID] then
					cmdsCount = cmdsCount + 1
					cmds[cmdsCount] = activeCmdDescs[cmdUnitdefs[uDefID]]
				end
			end
		else
			for index, cmd in pairs(activeCmdDescs) do
				if type(cmd) == "table" then
					if string_sub(cmd.action, 1, 10) == 'buildunit_' then
						-- not cmd.disabled and cmd.type == 20 or
						cmdsCount = cmdsCount + 1
						cmds[cmdsCount] = cmd
					end
				end
			end
		end
	end
end

function widget:ViewResize()
	vsx, vsy = Spring.GetViewGeometry()

	font2 = WG['fonts'].getFont(fontFile, 1.2, 0.22, 1.5)

	if WG['minimap'] then
		minimapEnlarged = WG['minimap'].getEnlarged()
		minimapHeight = WG['minimap'].getHeight()
	end

	local widgetSpaceMargin = math.floor(0.0045 * (vsy / vsx) * vsx * ui_scale) / vsx
	bgpadding = math.ceil(widgetSpaceMargin * 0.66 * vsx)

	activeAreaMargin = math_ceil(bgpadding * cfgActiveAreaMargin)

	
		posY = 0.559
		posY2 = math_floor(0.138 * ui_scale * vsy) / vsy
		posY2 = posY2 + ((widgetSpaceMargin*vsx)/vsy)
		posX = 0
		minColls = 4
		maxColls = 5

		
			
			

		posY = math_floor(posY * vsy) / vsy
		posX = math_floor(posX * vsx) / vsx

		height = (posY - posY2)
		width = 0.184

		width = width / (vsx / vsy) * 1.78        -- make smaller for ultrawide screens
		width = width * ui_scale

		posX2 = math_floor(width * vsx)

		-- make pixel aligned
		width = math_floor(width * vsx) / vsx
		height = math_floor(height * vsy) / vsy


	backgroundRect = { posX, (posY - height) * vsy, posX2, posY * vsy }

	refreshUnitIconCache()
	clear()
	doUpdate = true
end

local function hijacklayout()
	local function dummylayouthandler(xIcons, yIcons, cmdCount, commands)
		--gets called on selection change
		widgetHandler.commands = commands
		widgetHandler.commands.n = cmdCount
		widgetHandler:CommandsChanged() --call widget:CommandsChanged()
		local iconList = { [1337] = 9001 }
		local custom_cmdz = widgetHandler.customCommands
		return "", xIcons, yIcons, {}, custom_cmdz, {}, {}, {}, {}, {}, iconList
	end
	widgetHandler:ConfigLayoutHandler(dummylayouthandler) --override default build/ordermenu layout
	Spring.ForceLayoutUpdate()
end

function widget:Initialize()
	hijacklayout()

	iconTypesMap = {}
	if Script.LuaRules('GetIconTypes') then
		iconTypesMap = Script.LuaRules.GetIconTypes()
	end

	-- Get our starting unit
	if preGamestartPlayer then
		SetBuildFacing()
		if not startDefID or startDefID ~= spGetTeamRulesParam(myTeamID, 'startUnit') then
			startDefID = spGetTeamRulesParam(myTeamID, 'startUnit')
			doUpdate = true
		end
	end

	widget:ViewResize()
	widget:SelectionChanged(spGetSelectedUnits())

	WG['buildmenu'] = {}
	

	refreshUnitIconCache()
end

function clear()
	dlistBuildmenu = gl.DeleteList(dlistBuildmenu)
	dlistBuildmenuBg = gl.DeleteList(dlistBuildmenuBg)
end

function widget:Shutdown()
	if hijackedlayout and not WG['red_buildmenu'] then
		widgetHandler:ConfigLayoutHandler(true)
		Spring.ForceLayoutUpdate()
	end
	clear()
	
	if dlistCache then
		dlistCache = gl.DeleteList(dlistCache)
	end
	WG['buildmenu'] = nil
end

-- update queue number
function widget:UnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders)
	if spIsUnitSelected(factID) then
		doUpdateClock = os_clock() + 0.01
	end
end

local sec = 0
function widget:Update(dt)
	sec = sec + dt
	if sec > 0.33 then
		sec = 0
		if ui_scale ~= Spring.GetConfigFloat("ui_scale", 1) then
			ui_scale = Spring.GetConfigFloat("ui_scale", 1)
			refreshUnitIconCache()
			widget:ViewResize()
			doUpdate = true
		end
		if ui_opacity ~= Spring.GetConfigFloat("ui_opacity", 0.66) then
			ui_opacity = Spring.GetConfigFloat("ui_opacity", 0.66)
			glossMult = 1 + (2 - (ui_opacity * 2))
			clear()
			doUpdate = true
		end
		if WG['minimap'] and minimapEnlarged ~= WG['minimap'].getEnlarged() then
			refreshUnitIconCache()
			widget:ViewResize()
			doUpdate = true
		end



		disableInput = isSpec
		if Spring.IsGodModeEnabled() then
			disableInput = false
		end
	end
end

function drawBuildmenuBg()
	WG['buildmenu'].selectedID = nil

	-- background
	RectRound(backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4], bgpadding * 1.5, (posX > 0 and 1 or 0), 1, 1, 0, { 0.05, 0.05, 0.05, ui_opacity }, { 0, 0, 0, ui_opacity })
	RectRound(backgroundRect[1] + (posX > 0 and bgpadding or 0), backgroundRect[2] + (posY2 > 0 and bgpadding or 0), backgroundRect[3] - bgpadding, backgroundRect[4] - bgpadding, bgpadding, (posX > 0 and 1 or 0), 1, (posY2 > 0 and 1 or 0), 0, { 0.3, 0.3, 0.3, ui_opacity * 0.1 }, { 1, 1, 1, ui_opacity * 0.1 })

	-- gloss
	glBlending(GL_SRC_ALPHA, GL_ONE)
	RectRound(backgroundRect[1]+ (posX > 0 and bgpadding or 0), backgroundRect[4] - bgpadding - ((backgroundRect[4] - backgroundRect[2]) * (stickToBottom and 0.15 or 0.07)), backgroundRect[3] - bgpadding, backgroundRect[4] - bgpadding, bgpadding, (posX > 0 and 1 or 0), 1, 0, 0, { 1, 1, 1, 0.006 * glossMult }, { 1, 1, 1, 0.055 * glossMult })
	RectRound(backgroundRect[1]+ (posX > 0 and bgpadding or 0), backgroundRect[2] + (posY2 > 0 and bgpadding or 0), backgroundRect[3] - bgpadding, backgroundRect[2] + bgpadding + ((backgroundRect[4] - backgroundRect[2]) * 0.045), bgpadding, 0, 0, 1, 0, { 1, 1, 1, 0.025 * glossMult }, { 1, 1, 1, 0 })
	glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
end

local function drawCell(cellRectID, usedZoom, cellColor, progress, highlightColor, edgeAlpha)
	local uDefID = cmds[cellRectID].id * -1

	-- encapsulating cell background
	--RectRound(cellRects[cellRectID][1]+cellPadding, cellRects[cellRectID][2]+cellPadding, cellRects[cellRectID][3]-cellPadding, cellRects[cellRectID][4]-cellPadding, cellSize*0.03, 1,1,1,1, {0.3,0.3,0.3,0.95},{0.22,0.22,0.22,0.95})

	-- unit icon
	glColor(1, 1, 1, 1)
	--local textureDetail = math_floor(cellInnerSize * (1 + usedZoom) * texDetailMult)
	glTexture(':lr' .. textureDetail .. ',' .. textureDetail .. ':unitpics/' .. unitBuildPic[uDefID])
	--glTexRect(cellRects[cellRectID][1]+cellPadding+iconPadding, cellRects[cellRectID][2]+cellPadding+iconPadding, cellRects[cellRectID][3]-cellPadding-iconPadding, cellRects[cellRectID][4]-cellPadding-iconPadding)
	TexRectRound(
		cellRects[cellRectID][1] + cellPadding + iconPadding,
		cellRects[cellRectID][2] + cellPadding + iconPadding,
		cellRects[cellRectID][3] - cellPadding - iconPadding,
		cellRects[cellRectID][4] - cellPadding - iconPadding,
		cornerSize, 2, 2, 2, 2,
		usedZoom
	)

	-- colorize/highlight unit icon
	if cellColor then
		glBlending(GL_DST_ALPHA, GL_ONE_MINUS_SRC_COLOR)
		glColor(cellColor[1], cellColor[2], cellColor[3], cellColor[4])
		glTexture(':lr' .. textureDetail .. ',' .. textureDetail .. ':unitpics/' .. unitBuildPic[uDefID])
		TexRectRound(
			cellRects[cellRectID][1] + cellPadding + iconPadding,
			cellRects[cellRectID][2] + cellPadding + iconPadding,
			cellRects[cellRectID][3] - cellPadding - iconPadding,
			cellRects[cellRectID][4] - cellPadding - iconPadding,
			cornerSize, 2, 2, 2, 2,
			usedZoom
		)
		if cellColor[4] > 0 then
			glBlending(GL_SRC_ALPHA, GL_ONE)
			TexRectRound(
				cellRects[cellRectID][1] + cellPadding + iconPadding,
				cellRects[cellRectID][2] + cellPadding + iconPadding,
				cellRects[cellRectID][3] - cellPadding - iconPadding,
				cellRects[cellRectID][4] - cellPadding - iconPadding,
				cornerSize, 2, 2, 2, 2,
				usedZoom
			)
		end
		glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	end
	glTexture(false)

	-- draw build progress pie on top of texture
	if progress and showBuildProgress then
		RectRoundProgress(cellRects[cellRectID][1] + cellPadding + iconPadding, cellRects[cellRectID][2] + cellPadding + iconPadding, cellRects[cellRectID][3] - cellPadding - iconPadding, cellRects[cellRectID][4] - cellPadding - iconPadding, cellSize * 0.03, progress, { 0.08, 0.08, 0.08, 0.6 })
	end

	-- make fancy
	if makeFancy then
		-- lighten top
		glBlending(GL_SRC_ALPHA, GL_ONE)
		-- glossy half
		--RectRound(cellRects[cellRectID][1]+iconPadding, cellRects[cellRectID][4]-iconPadding-(cellInnerSize*0.5), cellRects[cellRectID][3]-iconPadding, cellRects[cellRectID][4]-iconPadding, cellSize*0.03, 1,1,0,0,{1,1,1,0.1}, {1,1,1,0.18})
		RectRound(cellRects[cellRectID][1] + cellPadding + iconPadding, cellRects[cellRectID][4] - cellPadding - iconPadding - (cellInnerSize * 0.66), cellRects[cellRectID][3] - cellPadding - iconPadding, cellRects[cellRectID][4] - cellPadding - iconPadding, cornerSize, 2, 2, 0, 0, { 1, 1, 1, 0 }, { 1, 1, 1, 0.1 })
		glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

		-- extra darken gradually
		RectRound(cellRects[cellRectID][1] + cellPadding + iconPadding, cellRects[cellRectID][2] + cellPadding + iconPadding, cellRects[cellRectID][3] - cellPadding - iconPadding, cellRects[cellRectID][4] - cellPadding - iconPadding, cornerSize, 0, 0, 2, 2, { 0, 0, 0, 0.1 }, { 0, 0, 0, 0 })
	end

	-- darken price background gradually
	if showPrice or makeFancy then
		RectRound(cellRects[cellRectID][1] + cellPadding + iconPadding, cellRects[cellRectID][2] + cellPadding + iconPadding, cellRects[cellRectID][3] - cellPadding - iconPadding, cellRects[cellRectID][2] + cellPadding + iconPadding + (cellInnerSize * 0.415), cornerSize, 0, 0, 2, 2, { 0, 0, 0, (makeFancy and 0.2 or 0.27) }, { 0, 0, 0, 0 })
	end

	-- lighten cell edges
	if highlightColor then
		local halfSize = (((cellRects[cellRectID][3] - cellPadding - iconPadding)) - (cellRects[cellRectID][1] + cellPadding + iconPadding)) * 0.5
		glBlending(GL_SRC_ALPHA, GL_ONE)
		RectRoundCircle(
			cellRects[cellRectID][1] + cellPadding + iconPadding + halfSize,
			0,
			cellRects[cellRectID][2] + cellPadding + iconPadding + halfSize,
			halfSize, cornerSize, halfSize * 0.5, { highlightColor[1], highlightColor[2], highlightColor[3], 0 }, { highlightColor[1], highlightColor[2], highlightColor[3], highlightColor[4] * 0.75 }
		)
		RectRoundCircle(
			cellRects[cellRectID][1] + cellPadding + iconPadding + halfSize,
			0,
			cellRects[cellRectID][2] + cellPadding + iconPadding + halfSize,
			halfSize, cornerSize, halfSize * 0.82, { highlightColor[1], highlightColor[2], highlightColor[3], 0 }, highlightColor
		)
		glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	end

	-- lighten border
	if iconBorderOpacity > 0 then
		local halfSize = (((cellRects[cellRectID][3] - cellPadding - iconPadding)) - (cellRects[cellRectID][1] + cellPadding + iconPadding)) * 0.5
		glBlending(GL_SRC_ALPHA, GL_ONE)
		RectRoundCircle(
			cellRects[cellRectID][1] + cellPadding + iconPadding + halfSize,
			0,
			cellRects[cellRectID][2] + cellPadding + iconPadding + halfSize,
			halfSize, cornerSize, halfSize - math_max(1, math_floor(halfSize * 0.045)), { 1, 1, 1, edgeAlpha and edgeAlpha or iconBorderOpacity }, { 1, 1, 1, edgeAlpha and edgeAlpha or iconBorderOpacity }
		)
		glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	end

	-- radar icon
	--if showRadarIcon and unitIconType[uDefID] and iconTypesMap[unitIconType[uDefID]] then
	--	glColor(1, 1, 1, 0.9)
	--	glTexture(':lr' .. radariconTextureDetail .. ',' .. radariconTextureDetail .. ':' .. iconTypesMap[unitIconType[uDefID]])
	--	glTexRect(cellRects[cellRectID][3] - radariconOffset - radariconSize, cellRects[cellRectID][2] + radariconOffset, cellRects[cellRectID][3] - radariconOffset, cellRects[cellRectID][2] + radariconOffset + radariconSize)
	--	glTexture(false)
	--end

	-- price
	--if showPrice then
		--doCircle(x, y, z, radius, sides)
		--font2:Print("\255\245\245\245" .. unitMetalCost[uDefID] .. "\n\255\255\255\000" .. unitEnergyCost[uDefID], cellRects[cellRectID][1] + cellPadding + (cellInnerSize * 0.05), cellRects[cellRectID][2] + cellPadding + (priceFontSize * 1.38), priceFontSize, "o")
	--end

	-- debug order value
	if showOrderDebug and smartOrderUnits and unitOrderDebug[uDefID] then
		local text = unitOrderDebug[uDefID]
		font2:Print("\255\175\175\175" .. text, cellRects[cellRectID][1] + cellPadding + (cellInnerSize * 0.05), cellRects[cellRectID][4] - cellPadding - priceFontSize, priceFontSize * 0.82, "o")
	end

	-- shortcuts
	if showShortcuts and enableShortcuts and not disableInput then
		local row = math_ceil(cellRectID / colls)
		local col = cellRectID - ((row - 1) * colls)
		local text = string.upper(string.char(buildKeys[row]) .. ' ' .. string.char(buildKeys[col]))
		font2:Print("\255\175\175\175" .. text, cellRects[cellRectID][1] + cellPadding + (cellInnerSize * 0.05), cellRects[cellRectID][4] - cellPadding - priceFontSize, priceFontSize, "o")
	end

	-- factory queue number
	if cmds[cellRectID].params[1] then
		local pad = math_floor(cellInnerSize * 0.03)
		local textWidth = math_floor(font2:GetTextWidth(cmds[cellRectID].params[1] .. '  ') * cellInnerSize * 0.285)
		local pad2 = 0
		RectRound(cellRects[cellRectID][3] - cellPadding - iconPadding - textWidth - pad2, cellRects[cellRectID][4] - cellPadding - iconPadding - (cellInnerSize * 0.365) - pad2, cellRects[cellRectID][3] - cellPadding - iconPadding, cellRects[cellRectID][4] - cellPadding - iconPadding, cornerSize * 3.3, 0, 0, 0, 1, { 0.15, 0.15, 0.15, 0.95 }, { 0.25, 0.25, 0.25, 0.95 })
		RectRound(cellRects[cellRectID][3] - cellPadding - iconPadding - textWidth - pad2, cellRects[cellRectID][4] - cellPadding - iconPadding - (cellInnerSize * 0.15) - pad2, cellRects[cellRectID][3] - cellPadding - iconPadding, cellRects[cellRectID][4] - cellPadding - iconPadding, 0, 0, 0, 0, 0, { 1, 1, 1, 0 }, { 1, 1, 1, 0.05 })
		RectRound(cellRects[cellRectID][3] - cellPadding - iconPadding - textWidth - pad2 + pad, cellRects[cellRectID][4] - cellPadding - iconPadding - (cellInnerSize * 0.365) - pad2 + pad, cellRects[cellRectID][3] - cellPadding - iconPadding - pad2, cellRects[cellRectID][4] - cellPadding - iconPadding - pad2, cornerSize * 2.6, 0, 0, 0, 1, { 0.7, 0.7, 0.7, 0.1 }, { 1, 1, 1, 0.1 })
		font2:Print("\255\190\255\190" .. cmds[cellRectID].params[1],
			cellRects[cellRectID][1] + cellPadding + (cellInnerSize * 0.94) - pad2,
			cellRects[cellRectID][2] + cellPadding + (cellInnerSize * 0.715) - pad2,
			cellInnerSize * 0.29, "ro"
		)
	end
end

function drawBuildmenu()
	local activeArea = {
		backgroundRect[1] + (stickToBottom and bgpadding or 0) + activeAreaMargin,
		backgroundRect[2] + (stickToBottom and 0 or bgpadding) + activeAreaMargin,
		backgroundRect[3] - bgpadding - activeAreaMargin,
		backgroundRect[4] - bgpadding - activeAreaMargin
	}
	local contentHeight = activeArea[4] - activeArea[2]
	local contentWidth = activeArea[3] - activeArea[1]
	local maxCellSize = contentHeight/2
	-- determine grid size
	if not dynamicIconsize then
		colls = defaultColls
		cellSize = math_min(maxCellSize, math_floor((contentWidth / colls)))
		rows = math_floor(contentHeight / cellSize)
	else
		colls = minColls
		cellSize = math_min(maxCellSize, math_floor((contentWidth / colls)))

		rows = math_floor(contentHeight / cellSize)
		if minColls < maxColls then
			while cmdsCount > rows * colls do
				colls = colls + 1
				cellSize = math_min(maxCellSize, math_floor((contentWidth / colls)))
				rows = math_floor(contentHeight / cellSize)
				if colls == maxColls then
					break
				end
			end
		end
		if stickToBottom then
			if rows > 1 and cmdsCount <= (colls-1) * rows then
				colls = colls - 1
				cellSize = math_min(maxCellSize, math_floor((contentHeight / rows)))
			end
			--cellSize = math_min(contentHeight*0.6, math_floor((contentHeight / rows) + 0.5))
			--colls = math_min(minColls, math_floor(contentWidth / cellSize))
			--if contentWidth / colls < contentWidth / cellSize then
			--	rows = rows + 1
			--	cellSize = math_min(contentHeight*0.6, math_floor((contentHeight / rows) + 0.5))
			--	colls = math_min(minColls, math_floor(contentWidth / cellSize))
			--end
		end
	end

	-- adjust grid size when pages are needed
	local paginatorCellHeight = math_floor(contentHeight - (rows * cellSize))
	if cmdsCount > colls * rows then
		pages = math_ceil(cmdsCount / (colls * rows))
		-- when more than 1 page: reserve bottom row for paginator and calc again
		if pages > 1 then
			pages = math_ceil(cmdsCount / (colls * (rows - 1)))
		end
		if currentPage > pages then
			currentPage = pages
		end

		-- remove a row if there isnt enough room for the paginator UI
		--[[if not stickToBottom then
			if paginatorCellHeight < (0.06 * (1 - ((colls / 4) * 0.25))) * vsy then
				rows = rows - 1
				paginatorCellHeight = math_floor(contentHeight - (rows * cellSize))
			end
		else
			if paginatorCellHeight < (0.06 * (1 - ((rows / 4) * 0.25))) * vsx then
				colls = colls - 1
				paginatorCellHeight = math_floor(contentHeight - (colls * cellSize))
			end
		end]]--
	else
		currentPage = 1
		pages = 1
	end

	-- these are globals so it can be re-used (hover highlight)
	cellPadding = math_floor(cellSize * cfgCellPadding)
	iconPadding = math_max(1, math_floor(cellSize * cfgIconPadding))
	cornerSize = math_floor(cellSize * cfgIconCornerSize)
	cellInnerSize = cellSize - cellPadding - cellPadding
	radariconSize = math_floor((cellInnerSize * cfgRadaiconSize) + 0.5)
	radariconOffset = math_floor(((cellInnerSize * cfgRadariconOffset) + cellPadding + iconPadding) + 0.5)
	priceFontSize = math_floor((cellInnerSize * cfgPriceFontSize) + 0.5)

	cellRects = {}
	local numCellsPerPage = rows * colls
	local cellRectID = numCellsPerPage * (currentPage - 1)
	local maxCellRectID = numCellsPerPage * currentPage
	if maxCellRectID > cmdsCount then
		maxCellRectID = cmdsCount
	end
	font2:Begin()
	local iconCount = 0
	for row = 1, rows do
		if cellRectID >= maxCellRectID then
			break
		end
		for coll = 1, colls do
			if cellRectID >= maxCellRectID then
				break
			end

			iconCount = iconCount + 1
			cellRectID = cellRectID + 1

			local uDefID = cmds[cellRectID].id * -1
			if stickToBottom then
				cellRects[cellRectID] = {
					activeArea[1] + ((coll - 1) * cellSize),
					activeArea[4] - ((row) * cellSize),
					activeArea[1] + (((coll)) * cellSize),
					activeArea[4] - ((row - 1) * cellSize)
				}
			else
				cellRects[cellRectID] = {
					activeArea[3] - ((colls - coll + 1) * cellSize),
					activeArea[4] - ((row) * cellSize),
					activeArea[3] - (((colls - coll)) * cellSize),
					activeArea[4] - ((row - 1) * cellSize)
				}
			end
			local cellIsSelected = (activeCmd and cmds[cellRectID] and activeCmd == cmds[cellRectID].name)
			local usedZoom = cellIsSelected and selectedCellZoom or defaultCellZoom

			if cellIsSelected then
				WG['buildmenu'].selectedID = uDefID
			end

			drawCell(cellRectID, usedZoom, cellIsSelected and { 1, 0.85, 0.2, 0.25 } or nil)
		end
	end

	-- paginator
	if pages == 1 then
		paginatorRects = {}
	else
		local paginatorFontSize = math_max(0.016 * vsy, paginatorCellHeight * 0.2)
		local paginatorCellWidth = math_floor(contentWidth * 0.3)
		local paginatorBorderSize = math_floor(cellSize * ((cfgIconPadding + cfgCellPadding)))

		paginatorRects[1] = { activeArea[1], activeArea[2], activeArea[1] + paginatorCellWidth, activeArea[2] + paginatorCellHeight - cellPadding - activeAreaMargin }
		paginatorRects[2] = { activeArea[3] - paginatorCellWidth, activeArea[2], activeArea[3], activeArea[2] + paginatorCellHeight - cellPadding - activeAreaMargin }

		RectRound(paginatorRects[1][1] + cellPadding, paginatorRects[1][2] + cellPadding, paginatorRects[1][3] - cellPadding, paginatorRects[1][4] - cellPadding, cellSize * 0.03, 2, 2, 2, 2, { 0.28, 0.28, 0.28,  0.8 }, { 0.36, 0.36, 0.36, 0.88 })
		RectRound(paginatorRects[2][1] + cellPadding, paginatorRects[2][2] + cellPadding, paginatorRects[2][3] - cellPadding, paginatorRects[2][4] - cellPadding, cellSize * 0.03, 2, 2, 2, 2, { 0.28, 0.28, 0.28, 0.8 }, { 0.36, 0.36, 0.36,  0.88 })
		RectRound(paginatorRects[1][1] + cellPadding + paginatorBorderSize, paginatorRects[1][2] + cellPadding + paginatorBorderSize, paginatorRects[1][3] - cellPadding - paginatorBorderSize, paginatorRects[1][4] - cellPadding - paginatorBorderSize, cellSize * 0.02, 2, 2, 2, 2, { 0, 0, 0,  0.55 }, { 0, 0, 0,  0.55 })
		RectRound(paginatorRects[2][1] + cellPadding + paginatorBorderSize, paginatorRects[2][2] + cellPadding + paginatorBorderSize, paginatorRects[2][3] - cellPadding - paginatorBorderSize, paginatorRects[2][4] - cellPadding - paginatorBorderSize, cellSize * 0.02, 2, 2, 2, 2, { 0, 0, 0,  0.55 }, { 0, 0, 0,  0.55 })

		-- glossy half
		glBlending(GL_SRC_ALPHA, GL_ONE)
		RectRound(paginatorRects[1][1] + cellPadding, paginatorRects[1][4] - cellPadding - ((paginatorRects[1][4] - paginatorRects[1][2]) * 0.5), paginatorRects[1][3] - cellPadding, paginatorRects[1][4] - cellPadding, cellSize * 0.03, 2, 2, 0, 0, { 1, 1, 1, 0.015 }, { 1, 1, 1, 0.15 })
		RectRound(paginatorRects[2][1] + cellPadding, paginatorRects[2][4] - cellPadding - ((paginatorRects[2][4] - paginatorRects[1][2]) * 0.5), paginatorRects[2][3] - cellPadding, paginatorRects[2][4] - cellPadding, cellSize * 0.03, 2, 2, 0, 0, { 1, 1, 1, 0.015 }, { 1, 1, 1, 0.15 })

		-- glossy bottom
		RectRound(paginatorRects[1][1] + cellPadding, paginatorRects[1][2] + cellPadding, paginatorRects[1][3] - cellPadding, paginatorRects[1][2] + cellPadding + ((paginatorRects[1][4] - paginatorRects[1][2]) * 0.35), cellSize * 0.03, 0, 0, 2, 2, { 1, 1, 1, 0.055 }, { 1, 1, 1, 0 })
		RectRound(paginatorRects[2][1] + cellPadding, paginatorRects[2][2] + cellPadding, paginatorRects[2][3] - cellPadding, paginatorRects[2][2] + cellPadding + ((paginatorRects[2][4] - paginatorRects[1][2]) * 0.35), cellSize * 0.03, 0, 0, 2, 2, { 1, 1, 1, 0.055 }, { 1, 1, 1, 0 })
		glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

		font2:Print("\255\245\245\245" .. currentPage .. "  \\  " .. pages, contentWidth * 0.5, activeArea[2] + (paginatorCellHeight * 0.5) - (paginatorFontSize * 0.25), paginatorFontSize, "co")
	end

	font2:End()
end


local function GetBuildingDimensions(uDefID, facing)
	local bDef = UnitDefs[uDefID]
	if (facing % 2 == 1) then
		return 4 * bDef.zsize, 4 * bDef.xsize
	else
		return 4 * bDef.xsize, 4 * bDef.zsize
	end
end

local function DrawBuilding(buildData, borderColor, buildingAlpha, drawRanges)
	local bDefID, bx, by, bz, facing = buildData[1], buildData[2], buildData[3], buildData[4], buildData[5]
	local bw, bh = GetBuildingDimensions(bDefID, facing)

	gl.DepthTest(false)
	gl.Color(borderColor)

	gl.Shape(GL.LINE_LOOP, { { v = { bx - bw, by, bz - bh } },
							 { v = { bx + bw, by, bz - bh } },
							 { v = { bx + bw, by, bz + bh } },
							 { v = { bx - bw, by, bz + bh } } })

	if drawRanges then

		if isMex[bDefID] then
			gl.Color(1.0, 0.3, 0.3, 0.7)
			gl.DrawGroundCircle(bx, by, bz, Game.extractorRadius, 50)
		end

		local wRange = unitMaxWeaponRange[bDefID]
		if wRange then
			gl.Color(1.0, 0.3, 0.3, 0.7)
			gl.DrawGroundCircle(bx, by, bz, wRange, 40)
		end
	end

	gl.DepthTest(GL.LEQUAL)
	gl.DepthMask(true)
	gl.Color(1.0, 1.0, 1.0, buildingAlpha)

	gl.PushMatrix()
	gl.LoadIdentity()
	gl.Translate(bx, by, bz)
	gl.Rotate(90 * facing, 0, 1, 0)
	gl.UnitShape(bDefID, Spring.GetMyTeamID(), false, false, true)
	gl.PopMatrix()

	gl.Lighting(false)
	gl.DepthTest(false)
	gl.DepthMask(false)
end

local function DrawUnitDef(uDefID, uTeam, ux, uy, uz, scale)
	gl.Color(1, 1, 1, 1)
	gl.DepthTest(GL.LEQUAL)
	gl.DepthMask(true)
	gl.Lighting(true)

	gl.PushMatrix()
	gl.Translate(ux, uy, uz)
	if scale then
		gl.Scale(scale, scale, scale)
	end
	gl.UnitShape(uDefID, uTeam, false, true, true)
	gl.PopMatrix()

	gl.Lighting(false)
	gl.DepthTest(false)
	gl.DepthMask(false)
end

local function DoBuildingsClash(buildData1, buildData2)

	local w1, h1 = GetBuildingDimensions(buildData1[1], buildData1[5])
	local w2, h2 = GetBuildingDimensions(buildData2[1], buildData2[5])

	return math.abs(buildData1[2] - buildData2[2]) < w1 + w2 and
		math.abs(buildData1[4] - buildData2[4]) < h1 + h2
end

function widget:DrawScreen()

if not preGamestartPlayer then
	-- refresh buildmenu if active cmd changed
	prevActiveCmd = activeCmd
	activeCmd = select(4, spGetActiveCommand())
	if activeCmd ~= prevActiveCmd then
		doUpdate = true
	end

	WG['buildmenu'].hoverID = nil
	if not preGamestartPlayer and selectedBuilderCount == 0 and not alwaysShow then
		
	else
		local x, y, b, b2, b3 = spGetMouseState()
		local now = os_clock()
		if doUpdate or (doUpdateClock and now >= doUpdateClock) then
			if doUpdateClock and now >= doUpdateClock then
				doUpdateClock = nil
			end
			lastUpdate = now
			clear()
			RefreshCommands()
			doUpdate = nil
		end

		-- create buildmenu drawlists
	
		if not dlistBuildmenu then
			dlistBuildmenuBg = gl.CreateList(function()
				drawBuildmenuBg()
			end)
			dlistBuildmenu = gl.CreateList(function()
				drawBuildmenu()
			end)
		end

		local hovering = false
		if IsOnRect(x, y, backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4]) then
			Spring.SetMouseCursor('cursornormal')
			hovering = true
		end

		-- draw buildmenu background
		gl.CallList(dlistBuildmenuBg)
		if preGamestartPlayer or selectedBuilderCount ~= 0 then
			-- pre process + 'highlight' under the icons
			local hoveredCellID = nil
			if not WG['topbar'] or not WG['topbar'].showingQuit() then
				if hovering then
					for cellRectID, cellRect in pairs(cellRects) do
						if IsOnRect(x, y, cellRect[1], cellRect[2], cellRect[3], cellRect[4]) then
							hoveredCellID = cellRectID
							local cellIsSelected = (activeCmd and cmds[cellRectID] and activeCmd == cmds[cellRectID].name)
							local uDefID = cmds[cellRectID].id * -1
							WG['buildmenu'].hoverID = uDefID
							gl.Color(1, 1, 1, 1)
							local alt, ctrl, meta, shift = Spring.GetModKeyState()
							--if showTooltip and WG['tooltip'] and not meta then
								-- when meta: unitstats does the tooltip
							--	local text = "\255\215\255\215" .. unitHumanName[uDefID] .. "\n\255\240\240\240" .. unitTooltip[uDefID]
							--	WG['tooltip'].ShowTooltip('buildmenu', text)
						--	end
					
							-- highlight --if b and not disableInput then
							glBlending(GL_SRC_ALPHA, GL_ONE)
							RectRound(cellRects[cellRectID][1] + cellPadding, cellRects[cellRectID][2] + cellPadding, cellRects[cellRectID][3] - cellPadding, cellRects[cellRectID][4] - cellPadding, cellSize * 0.03, 1, 1, 1, 1, { 0, 0, 0, 0.1 * ui_opacity }, { 0, 0, 0, 0.1 * ui_opacity })
							glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
							break
						end
					end
				end
			end

			-- draw buildmenu content
			gl.CallList(dlistBuildmenu)

			-- draw highlight
			local usedZoom
			local cellColor
			if not WG['topbar'] or not WG['topbar'].showingQuit() then
				if IsOnRect(x, y, backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4]) then

					-- paginator buttons
					local paginatorHovered = false
					if paginatorRects[1] and IsOnRect(x, y, paginatorRects[1][1], paginatorRects[1][2], paginatorRects[1][3], paginatorRects[1][4]) then
						paginatorHovered = 1
					end
					
					if paginatorRects[2] and IsOnRect(x, y, paginatorRects[2][1], paginatorRects[2][2], paginatorRects[2][3], paginatorRects[2][4]) then
						paginatorHovered = 2
					end
					if paginatorHovered then
						--if WG['tooltip'] then
							--local text = "\255\240\240\240" .. (paginatorHovered == 1 and "previous page" or "next page")
							--WG['tooltip'].ShowTooltip('buildmenu', text)
						--end
						RectRound(paginatorRects[paginatorHovered][1] + cellPadding, paginatorRects[paginatorHovered][2] + cellPadding, paginatorRects[paginatorHovered][3] - cellPadding, paginatorRects[paginatorHovered][4] - cellPadding, cellSize * 0.03, 2, 2, 2, 2, { 1, 1, 1, 0 }, { 1, 1, 1, (b and 0.35 or 0.15) })
						-- gloss
						RectRound(paginatorRects[paginatorHovered][1] + cellPadding, paginatorRects[paginatorHovered][4] - cellPadding - ((paginatorRects[paginatorHovered][4] - paginatorRects[paginatorHovered][2]) * 0.5), paginatorRects[paginatorHovered][3] - cellPadding, paginatorRects[paginatorHovered][4] - cellPadding, cellSize * 0.03, 2, 2, 0, 0, { 1, 1, 1, 0.015 }, { 1, 1, 1, 0.13 })
						RectRound(paginatorRects[paginatorHovered][1] + cellPadding, paginatorRects[paginatorHovered][2] + cellPadding, paginatorRects[paginatorHovered][3] - cellPadding, paginatorRects[paginatorHovered][2] + cellPadding + ((paginatorRects[paginatorHovered][4] - paginatorRects[paginatorHovered][2]) * 0.33), cellSize * 0.03, 0, 0, 2, 2, { 1, 1, 1, 0.025 }, { 1, 1, 1, 0 })
					end

					-- cells
					if hoveredCellID then
						local cellRectID = hoveredCellID
						local cellIsSelected = (activeCmd and cmds[cellRectID] and activeCmd == cmds[cellRectID].name)
						local uDefID = cmds[cellRectID].id * -1

						-- determine zoom amount and cell color
						usedZoom = hoverCellZoom
						if not cellIsSelected then
							if (b or b2) and cellIsSelected then
								usedZoom = clickSelectedCellZoom
							elseif cellIsSelected then
								usedZoom = selectedCellZoom
							elseif (b or b2) and not disableInput then
								usedZoom = clickCellZoom
							elseif b3 and not disableInput and cmds[cellRectID].params[1] then
								-- has queue
								usedZoom = rightclickCellZoom
							end
							-- determine color
							if (b or b2) and not disableInput then
								cellColor = { 0.3, 0.8, 0.25, 0.2 }
							elseif b3 and not disableInput then
								cellColor = { 1, 0.35, 0.3, 0.2 }
							else
								cellColor = { 0.63, 0.63, 0.63, 0 }
							end
						else
							-- selected cell
							if (b or b2 or b3) then
								usedZoom = clickSelectedCellZoom
							else
								usedZoom = selectedCellZoom
							end
							cellColor = { 1, 0.85, 0.2, 0.25 }
						end
						if not showPrice then
							unsetShowPrice = true
							showPrice = true
						end
						-- re-draw cell with hover zoom (and price shown)
						drawCell(cellRectID, usedZoom, cellColor, nil, { cellColor[1], cellColor[2], cellColor[3], 0.045 + (usedZoom * 0.45) }, 0.15)
						if unsetShowPrice then
							showPrice = false
							unsetShowPrice = nil
						end
						-- gloss highlight
						--glBlending(GL_SRC_ALPHA, GL_ONE)
						--RectRound(cellRects[cellRectID][1]+cellPadding, cellRects[cellRectID][4]-cellPadding-(cellInnerSize*0.5), cellRects[cellRectID][3]-cellPadding, cellRects[cellRectID][4]-cellPadding, cellSize*0.03, 1,1,0,0,{1,1,1,0.0}, {1,1,1,0.09})
						--RectRound(cellRects[cellRectID][1]+cellPadding, cellRects[cellRectID][2]+cellPadding, cellRects[cellRectID][3]-cellPadding, cellRects[cellRectID][2]+cellPadding+(cellInnerSize*0.15), cellSize*0.03, 0,0,1,1,{1,1,1,0.07}, {1,1,1,0})
						--glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
					end
				end
			end

			-- draw builders buildoption progress
			if showBuildProgress then
				local numCellsPerPage = rows * colls
				local cellRectID = numCellsPerPage * (currentPage - 1)
				local maxCellRectID = numCellsPerPage * currentPage
				if maxCellRectID > cmdsCount then
					maxCellRectID = cmdsCount
				end
				-- loop selected builders
				for builderUnitID, _ in pairs(selectedBuilders) do
					local unitBuildID = spGetUnitIsBuilding(builderUnitID)
					if unitBuildID then
						local unitBuildDefID = spGetUnitDefID(unitBuildID)
						if unitBuildDefID then
							-- loop all shown cells
							for cellRectID, cellRect in pairs(cellRects) do
								if cellRectID > maxCellRectID then
									break
								end
								local cellUnitDefID = cmds[cellRectID].id * -1
								if unitBuildDefID == cellUnitDefID then
									local progress = 1 - select(5, spGetUnitHealth(unitBuildID))
									if not usedZoom then
										if cellRectID == hoveredCellID and (b or b2 or b3) then
											usedZoom = clickSelectedCellZoom
										else
											local cellIsSelected = (activeCmd and cmds[cellRectID] and activeCmd == cmds[cellRectID].name)
											usedZoom = cellIsSelected and selectedCellZoom or defaultCellZoom
										end
									end
									if cellColor and cellRectID ~= hoveredCellID then
										cellColor = nil
										usedZoom = cellIsSelected and selectedCellZoom or defaultCellZoom
									end

									if cellRectID == hoveredCellID and not showPrice then
										unsetShowPrice = true
										showPrice = true
									end
									-- re-draw cell with hover zoom (and price shown)
									drawCell(cellRectID, usedZoom, cellColor, progress)
									if cellRectID == hoveredCellID and unsetShowPrice then
										showPrice = false
										unsetShowPrice = nil
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
end

function widget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdOpts, cmdParams, cmdTag)
	if isFactory[unitDefID] and cmdID < 0 then
		-- filter away non build cmd's
		if doUpdateClock == nil then
			doUpdateClock = os_clock() + 0.01
		end
	end
end

function widget:SelectionChanged(sel)
	if SelectedUnitsCount ~= spGetSelectedUnitsCount() then
		SelectedUnitsCount = spGetSelectedUnitsCount()
	end
	selectedBuilders = {}
	selectedBuilderCount = 0
	selectedFactories = {}
	selectedFactoryCount = 0
	if SelectedUnitsCount > 0 then
		for _, unitID in pairs(sel) do
			if isFactory[spGetUnitDefID(unitID)] then
				selectedFactories[unitID] = true
				selectedFactoryCount = selectedFactoryCount + 1
			end
			if isBuilder[spGetUnitDefID(unitID)] then
				selectedBuilders[unitID] = true
				selectedBuilderCount = selectedBuilderCount + 1
				doUpdate = true
			end
		end
	end
end

local function GetUnitCanCompleteQueue(uID)

	local uDefID = Spring.GetUnitDefID(uID)
	if uDefID == startDefID then
		return true
	end

	-- What can this unit build ?
	local uCanBuild = {}
	local uBuilds = UnitDefs[uDefID].buildOptions
	for i = 1, #uBuilds do
		uCanBuild[uBuilds[i]] = true
	end

	-- Can it build everything that was queued ?
	for i = 1, #buildQueue do
		if not uCanBuild[buildQueue[i][1]] then
			return false
		end
	end

	return true
end

function widget:GameFrame(n)

	-- handle the pregame build queue
	preGamestartPlayer = false
end

function SetBuildFacing()
	local wx, wy, _, _ = Spring.GetScreenGeometry()
	local _, pos = spTraceScreenRay(wx / 2, wy / 2, true)
	if not pos then
		return
	end
	local x = pos[1]
	local z = pos[3]

	if math.abs(Game.mapSizeX - 2 * x) > math.abs(Game.mapSizeZ - 2 * z) then
		if 2 * x > Game.mapSizeX then
			facing = 3
		else
			facing = 1
		end
	else
		if 2 * z > Game.mapSizeZ then
			facing = 2
		else
			facing = 0
		end
	end
	Spring.SetBuildFacing(facing)
end

local function setPreGamestartDefID(uDefID)
	selBuildQueueDefID = uDefID
	if isMex[uDefID] then
		if Spring.GetMapDrawMode() ~= "metal" then
			Spring.SendCommands("ShowMetalMap")
		end
	elseif Spring.GetMapDrawMode() == "metal" then
		Spring.SendCommands("ShowStandard")
	end
end

function widget:KeyPress(key, mods, isRepeat)
	if Spring.IsGUIHidden() then
		return
	end
	-- add buildfacing shortcuts (facing commands are only handled by spring if we have a building selected, which isn't possible pre-game)
	if preGamestartPlayer and selBuildQueueDefID then
		if key == 91 then
			-- [
			local facing = Spring.GetBuildFacing()
			facing = facing + 1
			if facing > 3 then
				facing = 0
			end
			Spring.SetBuildFacing(facing)
		end
		if key == 93 then
			-- ]
			local facing = Spring.GetBuildFacing()
			facing = facing - 1
			if facing < 0 then
				facing = 3
			end
			Spring.SetBuildFacing(facing)
		end
		if key == 27 then
			-- ESC
			setPreGamestartDefID()
		end
	end

	-- unit icon shortcuts
	if not disableInput and enableShortcuts and cmdsCount > 0 then
		if rowPressedClock and rowPressedClock < (os_clock() + 3) then
			rowPressed = nil
			rowPressedClock = nil
		end
		for k, buildKey in pairs(buildKeys) do
			if buildKey == key then
				if not rowPressed then
					rowPressed = k
					rowPressedClock = os_clock()
					return true
				else
					local cellRectID = k + ((rowPressed - 1) * colls)
					if cmds[cellRectID] and cmds[cellRectID].id then
						Spring.SetActiveCommand(spGetCmdDescIndex(cmds[cellRectID].id), 1, true, false, Spring.GetModKeyState())
					end
					rowPressed = nil
					rowPressedClock = nil
					return true
				end
				break
			end
		end
		rowPressed = nil
	end
end

function widget:MousePress(x, y, button)
	if Spring.IsGUIHidden() then
		return
	end
	if WG['topbar'] and WG['topbar'].showingQuit() then
		return
	end

	if IsOnRect(x, y, backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4]) then
		if selectedBuilderCount > 0 or (preGamestartPlayer and startDefID) then
			local paginatorHovered = false
			if paginatorRects[1] and IsOnRect(x, y, paginatorRects[1][1], paginatorRects[1][2], paginatorRects[1][3], paginatorRects[1][4]) then
				currentPage = currentPage - 1
				if currentPage < 1 then
					currentPage = pages
				end
				doUpdate = true
			end
			if paginatorRects[2] and IsOnRect(x, y, paginatorRects[2][1], paginatorRects[2][2], paginatorRects[2][3], paginatorRects[2][4]) then
				currentPage = currentPage + 1
				if currentPage > pages then
					currentPage = 1
				end
				doUpdate = true
			end
			if not disableInput then
				for cellRectID, cellRect in pairs(cellRects) do
					if cmds[cellRectID].id and unitHumanName[-cmds[cellRectID].id] and IsOnRect(x, y, cellRect[1], cellRect[2], cellRect[3], cellRect[4]) then
						if button ~= 3 then
							--Spring.PlaySoundFile(sound_queue_add, 0.75, 'ui')
							if preGamestartPlayer then
								setPreGamestartDefID(cmds[cellRectID].id * -1)
							elseif spGetCmdDescIndex(cmds[cellRectID].id) then
								Spring.SetActiveCommand(spGetCmdDescIndex(cmds[cellRectID].id), 1, true, false, Spring.GetModKeyState())
							end
						else
							if cmds[cellRectID].params[1] then
								-- has queue
								--Spring.PlaySoundFile(sound_queue_rem, 0.75, 'ui')
							end
							if preGamestartPlayer then
								setPreGamestartDefID(cmds[cellRectID].id * -1)
							elseif spGetCmdDescIndex(cmds[cellRectID].id) then
								Spring.SetActiveCommand(spGetCmdDescIndex(cmds[cellRectID].id), 3, false, true, Spring.GetModKeyState())
							end
						end
						doUpdateClock = os_clock() + 0.01
						return true
					end
				end
			end
			return true
		elseif alwaysShow then
			return true
		end

	elseif preGamestartPlayer then

		if selBuildQueueDefID then
			if button == 1 then

				local mx, my, button = spGetMouseState()
				local _, pos = spTraceScreenRay(mx, my, true)
				if not pos then
					return
				end
				local bx, by, bz = Spring.Pos2BuildPos(selBuildQueueDefID, pos[1], pos[2], pos[3])
				local buildFacing = Spring.GetBuildFacing()

				if Spring.TestBuildOrder(selBuildQueueDefID, bx, by, bz, buildFacing) ~= 0 then

					local buildData = { selBuildQueueDefID, bx, by, bz, buildFacing }
					local _, _, meta, shift = Spring.GetModKeyState()
					if meta then
						table.insert(buildQueue, 1, buildData)

					elseif shift then

						local anyClashes = false
						for i = #buildQueue, 1, -1 do
							if DoBuildingsClash(buildData, buildQueue[i]) then
								anyClashes = true
								table.remove(buildQueue, i)
							end
						end

						if not anyClashes then
							buildQueue[#buildQueue + 1] = buildData
						end
					else
						buildQueue = { buildData }
					end

					if not shift then
						setPreGamestartDefID(nil)
					end
				end

				return true

			elseif button == 3 then
				setPreGamestartDefID(nil)
				return true
			end
		end
	end
end



