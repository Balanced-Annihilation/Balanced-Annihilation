function gadget:GetInfo()
	return {
		name = "Control Victory",
		desc = "Enables a victory through capture and hold",
		author = "KDR_11k (David Becker), Smoth, Lurker, Forboding Angel",
		date = "2008-03-22 -- Major update July 11th, 2016",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

--[[
-------------------
Before implementing this gadget, read this!!!
This gadget relies on three parts:
• control point config file which is located in luarules/configs/controlpoints/ , and it must have a filename of cv_<mapname>.lua. So, in the case of a map named "Iammas Prime -" with a version of "v01", then the name of my file would be "cv_Iammas Prime - v01.lua".
	PLEASE NOTE: If the map config file is not found and a capture mode is selected, the gadget will generate 7 points in a circle on the map automagically.
• config placed in luarules/configs/ called cv_nonCapturingUnits.lua
• config placed in luarules/configs/ called cv_buildableUnits.lua
• modoptions

The control point config is structured like this (cv_Iammas Prime - v01.lua):

////

return {
	points = {
		[1] = {x = 4608, y = 0, z = 3048},
		[2] = {x = 4265, y = 0, z = 1350},
		[3] = {x = 4950, y = 0, z = 4786},
		[4] = {x = 6641, y = 0, z = 858},
		[5] = {x = 2574, y = 0, z = 5271},
		[6] = {x = 2219, y = 0, z = 498},
		[7] = {x = 6993, y = 0, z = 5616},
	},
}

////

The nonCapturingUnits.lua config file is structured like this:
These are units that are not allowed to capture points.

////

local nonCapturingUnits = {
	"eairengineer",
	"efighter",
	"egunship2",
	"etransport",
	"edrone",
	"ebomber",
}

return nonCapturingUnits

////

The buildableUnits.lua config file is structured like this:
These are units that are allowed to be built within control points.

////

local buildableUnits = {
	"armamex",
	"armmex",
	"armmoho",
	"armuwmex",
	"armuwmme",
	"corexp",
	"cormex",
	"cormexp",
	"cormoho",
	"coruwmex",
	"coruwmme",
}

return buildableUnits

////

Here are all of the modoptions in a neat copy pastable form... Place these modoptions in modoptions.lua in your base game folder:

////
-- Control Victory Options
	{
		key    = 'controlvictoryoptions',
		name   = 'Control Victory Options',
		desc   = 'Allows you to control at a granular level the individual options for Control Point Victory',
		type   = 'section',
	},
	{
		key="scoremode",
		name="Scoring Mode (Control Victory Points)",
		desc="Defines how the game is played",
		type="list",
		def="countdown",
		section="controlvictoryoptions",
		items={
			{key="disabled", name="Disabled", desc="Disable Control Points as a victory condition."},
			{key="countdown", name="Countdown", desc="A Control Point decreases all opponents' scores, zero means defeat."},
			{key="tugofwar", name="Tug of War", desc="A Control Point steals enemy score, zero means defeat."},
			{key="domination", name="Domination", desc="Holding all Control Points will grant 1000 score, first to reach the score limit wins."},
		}
	},
	{
		key    = 'limitscore',
		name   = 'Total Score',
		desc   = 'Total score amount available.',
		type   = 'number',
		section= 'controlvictoryoptions',
		def    = 2750,
		min    = 500,
		max    = 5000,
		step   = 1,  -- quantization is aligned to the def value
		-- (step <= 0) means that there is no quantization
	},
	{
		key    = 'captureradius',
		name   = 'Capture Radius',
		desc   = 'Radius around a point in which to capture it.',
		type   = 'number',
		section= 'controlvictoryoptions',
		def    = 500,
		min    = 100,
		max    = 1000,
		step   = 25,  -- quantization is aligned to the def value
		-- (step <= 0) means that there is no quantization
	},
		{
		key    = 'capturetime',
		name   = 'Capture Time',
		desc   = 'Time to capture a point.',
		type   = 'number',
		section= 'controlvictoryoptions',
		def    = 30,
		min    = 1,
		max    = 60,
		step   = 1,  -- quantization is aligned to the def value
		-- (step <= 0) means that there is no quantization
	},
		{
		key    = 'capturebonus',
		name   = 'Capture Bonus',
		desc   = 'How much faster capture takes place by adding more units.',
		type   = 'number',
		section= 'controlvictoryoptions',
		def    = 0.5,
		min    = 0,
		max    = 10,
		step   = 0.1,  -- quantization is aligned to the def value
		-- (step <= 0) means that there is no quantization
	},
		{
		key    = 'decapspeed',
		name   = 'De-Cap Speed',
		desc   = 'Speed multiplier for neutralizing an enemy point.',
		type   = 'number',
		section= 'controlvictoryoptions',
		def    = 3,
		min    = 0.1,
		max    = 10,
		step   = 0.1,  -- quantization is aligned to the def value
		-- (step <= 0) means that there is no quantization
	},
		{
		key    = 'starttime',
		name   = 'Start Time',
		desc   = 'The time when capturing can start.',
		type   = 'number',
		section= 'controlvictoryoptions',
		def    = 0,
		min    = 0,
		max    = 300,
		step   = 1,  -- quantization is aligned to the def value
		-- (step <= 0) means that there is no quantization
	},
		{
		key    = 'metalperpoint',
		name   = 'Metal given to each player per captured point',
		desc   = 'Each player on an allyteam that has captured a point will receive this amount of resources per point captured per second',
		type   = 'number',
		section= 'controlvictoryoptions',
		def    = 0,
		min    = 0,
		max    = 20,
		step   = 1,  -- quantization is aligned to the def value
		-- (step <= 0) means that there is no quantization
	},
		{
		key    = 'energyperpoint',
		name   = 'Energy given to each player per captured point',
		desc   = 'Each player on an allyteam that has captured a point will receive this amount of resources per point captured per second',
		type   = 'number',
		section= 'controlvictoryoptions',
		def    = 0,
		min    = 0,
		max    = 20,
		step   = 1,  -- quantization is aligned to the def value
		-- (step <= 0) means that there is no quantization
	},
		{
		key    = 'dominationscoretime',
		name   = 'Domination Score Time',
		desc   = 'Time needed holding all points to score in multi domination.',
		type   = 'number',
		section= 'controlvictoryoptions',
		def    = 30,
		min    = 1,
		max    = 60,
		step   = 1,  -- quantization is aligned to the def value
		-- (step <= 0) means that there is no quantization
	},
		{
		key    = 'tugofwarmodifier',
		name   = 'Tug of War Modifier',
		desc   = 'The amount of score transfered between opponents when points are captured is multiplied by this amount.',
		type   = 'number',
		section= 'controlvictoryoptions',
		def    = 2,
		min    = 0,
		max    = 6,
		step   = 1,  -- quantization is aligned to the def value
		-- (step <= 0) means that there is no quantization
	},
-- End Control Victory Options
////


That's all folks!!!
-------------------
]]--

nonCapturingUnits = VFS.Include"LuaRules/Configs/cv_nonCapturingUnits.lua"
buildableUnits = VFS.Include"LuaRules/Configs/cv_buildableUnits.lua"

--local pointMarker = FeatureDefNames.xelnotgawatchtower.id -- Feature marking a point- This doesn't do anything atm

local captureRadius = tonumber(Spring.GetModOptions().captureradius) or 500 -- Radius around a point in which to capture it
local captureTime = tonumber(Spring.GetModOptions().capturetime) or 30 -- Time to capture a point
local captureBonus = tonumber(Spring.GetModOptions().capturebonus) or.5 -- speedup from adding more units
local decapSpeed = tonumber(Spring.GetModOptions().decapspeed) or 3 -- speed multiplier for neutralizing an enemy point
local moveSpeed =.5
local tugofWarModifier = tonumber(Spring.GetModOptions().tugofwarmodifier) or 2 -- Radius around a point in which to capture it

local startTime = tonumber(Spring.GetModOptions().starttime) or 0 -- The time when capturing can start

local dominationScoreTime = tonumber(Spring.GetModOptions().dominationscoretime) or 30 -- Time needed holding all points to score in multi domination

if Spring.GetModOptions().scoremode == "disabled" or Spring.GetModOptions().scoremode == nil then return false end

local limitScore = tonumber(Spring.GetModOptions().limitscore) or 2750

local allyTeamColorSets={}

local scoreModes = {
	disabled = 0, -- none (duh)
	countdown = 1, -- A point decreases all opponents' scores, zero means defeat
	tugofwar = 2, -- A point steals enemy score, zero means defeat
	domination = 3, -- Holding all points will grant 100 score, first to reach the score limit wins
}
local scoreMode = scoreModes[Spring.GetModOptions().scoremode or "countdown"]

Spring.Echo("[ControlVictory] Control Victory Scoring Mode: " .. (Spring.GetModOptions().scoremode or "Countdown"))

local _, _, _, _, _, gaia = Spring.GetTeamInfo(Spring.GetGaiaTeamID())
local mapx, mapz = Game.mapSizeX, Game.mapSizeZ

if (gadgetHandler:IsSyncedCode()) then

	-- SYNCED

	local points = {}
	local score = {}

	local dom = {
		dominator = nil,
		dominationTime = nil,
	}

	local function Loser(team)
		if team == gaia then
			return
		end
		for _, u in ipairs(Spring.GetAllUnits()) do
			if team == Spring.GetUnitAllyTeam(u) then
				Spring.DestroyUnit(u)
			end
		end
	end

	local function Winner(team)
		for _, a in ipairs(Spring.GetAllyTeamList()) do
			if a ~= team and a ~= gaia then
				Loser(a)
			end
		end
	end

	-- functions to be registered as globals

	local function gControlPoints()
		return points or {}
	end

	local function gNonCapturingUnits()
		return nonCapturingUnits or {}
	end

	local function gBuildableUnits()
		return buildableUnits or {}
	end

	local function gCaptureRadius()
		return captureRadius or 0
	end

	-- end global-registered functions

	function gadget:Initialize()
		gadgetHandler:RegisterGlobal('ControlPoints', gControlPoints)
		gadgetHandler:RegisterGlobal('NonCapturingUnits', gNonCapturingUnits)
		gadgetHandler:RegisterGlobal('BuildableUnits', gBuildableUnits)
		gadgetHandler:RegisterGlobal('CaptureRadius', gCaptureRadius)
		for _, a in ipairs(Spring.GetAllyTeamList()) do
			if scoreMode ~= 3 then
				score[a] = limitScore
			else
				score[a] = 0
			end
		end
		score[gaia] = 0
		local configfile, _ = string.gsub(Game.mapName, ".smf$", ".lua")
		configfile = "LuaRules/Configs/ControlPoints/cv_" .. configfile .. ".lua"
		Spring.Echo("[ControlVictory] " .. configfile .. " -This is the name of the control victory configfile-")
		if VFS.FileExists(configfile) then
			local config = VFS.Include(configfile)
			points = config.points
			for _, p in pairs(points) do
				p.capture = 0
			end
			moveSpeed = 0
		else
			--Since no config file is found, we create 7 points spaced out in a circle on the map
			local angle = math.random() * math.pi * 2
			points = {}
			for i=1,6 do
				local angle = angle + i * math.pi * 2/6
				points[i] = {
					x=mapx/2 + mapx * .4 * math.sin(angle),
					y=0,
					z=mapz/2 + mapz * .4 * math.cos(angle),
					--We can make them move around if we want to by uncommenting these lines and the ones below
					--velx=moveSpeed * 10 * -1 * math.cos(angle),
					--velz=moveSpeed * 10 * math.sin(angle),
					owner=nil,
					aggressor=nil,
					capture=0,
				}
			end
			points[7] = {
				x=mapx/2,
				y=0,
				z=mapz/2,
				owner=nil,
				aggressor=nil,
				capture=0,
			}
		end
		_G.points = points
		_G.score = score
		_G.dom = dom
	end

	function gadget:GameFrame(f)
		-- This causes the points to move around, windows screensaver style :-)
--[[   for _,p in pairs(points) do
    if p.velx then
         p.velx = p.velx / moveSpeed + .03 * (0.5 - math.random())
         p.velz = p.velz / moveSpeed + .03 * (0.5 - math.random())
         local vel = (p.velx^2 + p.velz^2)^0.5
         local velmult = math.max(1 - .1^(math.max(1, math.min(3, math.log(vel / moveSpeed)))), (vel * 1^.01)^.99 / vel) * moveSpeed
         p.velx = p.velx * velmult
         p.velz = p.velz * velmult
         if p.x + p.velx < captureRadius or p.x + p.velx > mapx - captureRadius then p.velx = -1 * p.velx end
         if p.z + p.velz < captureRadius or p.z + p.velz > mapz - captureRadius then p.velz = -1 * p.velz end
         p.x = p.x + p.velx
         p.x = p.x + p.velx
         p.z = p.z + p.velz
         p.z = p.z + p.velz
      end
   end ]]--

		if f % 30 <.1 and f / 1800 > startTime then
			local owned = {}
			for _, allyTeamID in ipairs(Spring.GetAllyTeamList()) do
				owned[allyTeamID] = 0
			end
			for _, capturePoint in pairs(points) do
				local aggressor = nil
				local owner = capturePoint.owner
				local count = 0
				for _, u in ipairs(Spring.GetUnitsInCylinder(capturePoint.x, capturePoint.z, captureRadius)) do
					local validUnit = true
					for _, i in ipairs (nonCapturingUnits) do
						if UnitDefs[Spring.GetUnitDefID(u)].name == i then
							validUnit = false
						end
					end
					if validUnit then
						local unitOwner = Spring.GetUnitAllyTeam(u)
						--Spring.Echo(unitOwner)
						if owner then
							if owner == unitOwner then
								count = 0
								break
							else
								count = count + 1
							end
						else
							if aggressor then
								if aggressor == unitOwner then
									count = count + 1
								else
									aggressor = nil
									break
								end
							else
								aggressor = unitOwner
								count = count + 1
							end
						end
					end
				end
				if owner and count > 0 then
					capturePoint.aggressor = nil
					capturePoint.capture = capturePoint.capture + (1 + captureBonus * (count - 1)) * decapSpeed
				elseif aggressor then
					--Spring.Echo("capturePoint.aggressor", capturePoint.aggressor)
					if capturePoint.aggressor == aggressor then
						capturePoint.capture = capturePoint.capture + 1 + captureBonus * (count - 1)
					else
						capturePoint.aggressor = aggressor
						capturePoint.capture = 1 + captureBonus * (count - 1)
					end
				end
				if capturePoint.capture > captureTime then
					capturePoint.owner = capturePoint.aggressor
					capturePoint.capture = 0
				end
				if capturePoint.owner then
					--Spring.Echo(capturePoint.owner)
					owned[capturePoint.owner] = owned[capturePoint.owner] + 1
				end
			end

			-- resources granted to each play on an allyteam that captures a point
			for _, allyTeamID in ipairs(Spring.GetAllyTeamList()) do
				local ateams = Spring.GetTeamList(allyTeamID)
				for i = 1, #ateams do
					local metalPerPoint = Spring.GetModOptions().metalperpoint
					local energyPerPoint = Spring.GetModOptions().energyperpoint
					if Spring.GetModOptions().metalperpoint == nil then
						metalPerPoint = 0
					end
					if Spring.GetModOptions().energyPerPoint == nil then
						energyPerPoint = 0
					end
					Spring.AddTeamResource(ateams[i], "metal", owned[allyTeamID] * metalPerPoint) -- adjust the 5
					Spring.AddTeamResource(ateams[i], "energy", owned[allyTeamID] * energyPerPoint) -- adjust the 5
				end
			end

			if scoreMode == 1 then -- Countdown
				for owner, count in pairs(owned) do
					for _, allyTeamID in ipairs(Spring.GetAllyTeamList()) do
						if allyTeamID ~= owner and score[allyTeamID] > 0 then
							score[allyTeamID] = score[allyTeamID] - count
						end
					end
				end
				for allyTeamID, teamScore in pairs(score) do
					-- Spring.Echo("Team "..allyTeamID..": "..teamScores)
					if teamScore <= 0 then
						Loser(allyTeamID)
					end
				end
			elseif scoreMode == 2 then -- Tug of War
				for owner, count in pairs(owned) do
					for _, a in ipairs(Spring.GetAllyTeamList()) do
						if a ~= owner and score[a] > 0 then
							score[a] = score[a] - count * tugofWarModifier
							score[owner] = score[owner] + count * tugofWarModifier
						end
					end
				end
				for allyTeamID, teamScore in pairs(score) do
					--Spring.Echo("Team "..allyTeamID..": "..teamScore)
					if teamScore <= 0 then
						Loser(allyTeamID)
					end
				end
			elseif scoreMode == 3 then -- Domination
				local prevDominator = dom.dominator
				dom.dominator = nil
				for owner, count in pairs(owned) do
					if count == #points then
						dom.dominator = owner
						if prevDominator ~= owner or not dom.dominationTime then
							dom.dominationTime = f + 30 * dominationScoreTime
						end
						break
					end
				end
				if dom.dominator then
					if dom.dominationTime <= f then
						for _, capturePoint in pairs(points) do
							capturePoint.owner = nil
							capturePoint.capture = 0
						end
						score[dom.dominator] = score[dom.dominator] + 1000
						if score[dom.dominator] >= limitScore then
							Winner(dom.dominator)
						end
					end
				end
			end
		end
	end

-- Allow units listed in the buildableUnits config to be built in control points

	local allowedBuildableUnits = {}
	for i = 1, #buildableUnits do
		if UnitDefNames[buildableUnits[i]] then
			allowedBuildableUnits[UnitDefNames[buildableUnits[i]].id] = true
		end
	end

	function gadget:AllowUnitCreation(unit, builder, team, x, y, z) -- TODO: fix for comshare
		if allowedBuildableUnits[unit] then
			return true
		end
		for _, p in pairs(points) do
			if x and math.sqrt((x - p.x) * (x - p.x) + (z - p.z) * (z - p.z)) < captureRadius then
				Spring.SendMessageToPlayer(team, "This unit is not allowed to be built in Control Points")
				return false
			end
		end
		return true
	end

	function gadget:GameOver()
		gadgetHandler:RemoveCallIn("GameFrame")
	end

else -- UNSYNCED

	local font
	local shaderCircle
	local shaderCircleViewLocation
	local shaderCircleProjLocation

	-- The geometry shader can only output 128 vertices. This limits the circle resolution.
	local maxPieces = 42

	local OPTIONS = {
		circlePieces = math.min(math.floor(captureRadius / 20), maxPieces),
		rotationSpeed = 0.5,
	}

	local teamList
	local capturePoints = {}

	local prevTimer = Spring.GetTimer()
	local currentRotationAngle = 0

	local ringThickness = 3.5
	local capturePieParts = math.min(4 + math.floor(captureRadius / 8), maxPieces)

	local outerRingDistance = 4.5
	local outerRingScale = (captureRadius - (ringThickness) - outerRingDistance) / captureRadius

	-----------------------------------------------------------------------------------------
	-- creates initial team listing
	-----------------------------------------------------------------------------------------
	local function CreateTeamList()
		local result = {}
		for _, allyTeamID in ipairs(Spring.GetAllyTeamList()) do
			if not result[allyTeamID] then
				result[allyTeamID] = {}
			end

			for _, teamID in pairs(Spring.GetTeamList(allyTeamID))do
				local playerList = Spring.GetPlayerList(teamID, true)
				if result[allyTeamID][teamID] == nil then
					result[allyTeamID][teamID] = {}
				end

				local r, g, b = Spring.GetTeamColor(teamID)
				result[allyTeamID]["color"] = {r, g, b, 1}

				local name
				for _, playerID in pairs(Spring.GetPlayerList(teamID)) do
					name = Spring.GetPlayerInfo(playerID) .. "'s Team (" .. teamID .. ")"
					if name then break end
				end
				if not name then
					aiName = Spring.GetTeamLuaAI(teamID)
					if aiName then
						if aiName == "" then
							aiName = "Evil Machine"
						end
						name = aiName
					end
				end
				if not name then
					name = "Team " .. teamID
				end
				result[allyTeamID]["name"] = name
			end
		end
		return result
	end

	local function CreateShaders()
		shaderCircle = gl.CreateShader({
			vertex = [[
				//VERTEX SHADER
				#version 400

				layout(location = 0) in vec3 inPosition;
				layout(location = 1) in float inRadius;
				layout(location = 2) in float inPieces;
				layout(location = 3) in float inDrawPieces;
				layout(location = 4) in vec4 inInnerColor;
				layout(location = 5) in vec4 inOuterColor;
				layout(location = 6) in float inDirection;

				out VertexData {
					float radius;
					float pieces;
					float drawPieces;
					vec4 innerColor;
					vec4 outerColor;
					float direction;
				} outData;

				void main() {
					gl_Position = vec4(inPosition, 1.0f);
					outData.radius = inRadius;
					outData.pieces = inPieces;
					outData.drawPieces = inDrawPieces;
					outData.innerColor = inInnerColor;
					outData.outerColor = inOuterColor;
					outData.direction = inDirection;
				}
			]],

			geometry = [[
				//GEOMETRY SHADER
				#version 400

				#define pi 3.14159265358979

				uniform mat4 viewMatrix;
				uniform mat4 projMatrix;

				layout (points) in;
				layout (triangle_strip, max_vertices = 128) out;

				in VertexData {
					float radius;
					float pieces;
					float drawPieces;
					vec4 innerColor;
					vec4 outerColor;
					float direction;
				} inData[1];

				out VertexData {
					vec4 color;
				} outData;

				void main() {
					vec4 center = projMatrix * viewMatrix * gl_in[0].gl_Position;

					float radstep = (pi * 2 / inData[0].pieces);
					float a;

					for (int i=0; i<inData[0].drawPieces; ++i) {
						outData.color = inData[0].innerColor;
						gl_Position = center;
						EmitVertex();

						outData.color = inData[0].outerColor;
						a = inData[0].direction * i * radstep;
						gl_Position = projMatrix * viewMatrix * (gl_in[0].gl_Position + vec4(inData[0].radius * sin(a), 0, inData[0].radius * cos(a), 0.0f));
						EmitVertex();

						a = inData[0].direction * (i + 1) * radstep;
						gl_Position = projMatrix * viewMatrix * (gl_in[0].gl_Position + vec4(inData[0].radius * sin(a), 0, inData[0].radius * cos(a), 0.0f));
						EmitVertex();

						EndPrimitive();
					}
				}
			]],

			fragment = [[
				//FRAGMENT SHADER
				#version 400

				in VertexData {
					vec4 color;
				} inData;

				layout(location = 0) out vec4 outColor;

				void main() {
					outColor = inData.color;
				}
			]],
		})

		if shaderCircle == nil then
			Spring.Echo("Circle shader log: ".. gl.GetShaderLog())
		end

		shaderCircleViewLocation = gl.GetUniformLocation(shaderCircle, "viewMatrix")
		shaderCircleProjLocation = gl.GetUniformLocation(shaderCircle, "projMatrix")
	end

	function gadget:Initialize()
		font = gl.LoadFont("LuaUI/Fonts/FreeSansBold.otf", 18, 3, 5.0)
		CreateShaders()
		teamList = CreateTeamList()
	end

	function gadget:GameFrame()
		for i, capturePoint in spairs(SYNCED.points) do
			if capturePoints[i] == nil then
				capturePoints[i] = {}
				capturePoints[i].color = {1,1,1}
				capturePoints[i].aggressorColor = {1,1,1}
				capturePoints[i].x = capturePoint.x
				capturePoints[i].y = Spring.GetGroundHeight(capturePoint.x, capturePoint.z) + 25
				capturePoints[i].z = capturePoint.z
			end
			if capturePoint.owner and capturePoint.owner ~= Spring.GetGaiaTeamID() then
				capturePoints[i].color[1],capturePoints[i].color[2],capturePoints[i].color[3] = Spring.GetTeamColor(Spring.GetTeamList(capturePoint.owner)[1])
			else
				capturePoints[i].color = {1,1,1}
			end
			if capturePoint.aggressor and capturePoint.aggressor ~= Spring.GetGaiaTeamID() then
				capturePoints[i].aggressorColor[1],capturePoints[i].aggressorColor[2],capturePoints[i].aggressorColor[3] = Spring.GetTeamColor(Spring.GetTeamList(capturePoint.aggressor)[1])
			else
				capturePoints[i].aggressorColor = {1,1,1}
			end
			capturePoints[i].capture = capturePoint.capture
		end
	end

	local function DrawPoints(minimap)
		gl.DepthTest(false)

		gl.UseShader(shaderCircle)

		if minimap then
			gl.UniformMatrix(shaderCircleViewLocation, "mmview")
			gl.UniformMatrix(shaderCircleProjLocation, "mmproj")
		else
			gl.UniformMatrix(shaderCircleViewLocation, "view")
			gl.UniformMatrix(shaderCircleProjLocation, "projection")
		end

		local capturedAlpha = 0.22
		local capturingAlpha = 0.33
		if minimap then
			capturedAlpha = 0.4
			capturingAlpha = 0.6
		end

		for _, point in pairs(capturePoints) do
			-- owner circle backgroundcolor
			Spring.Draw.Vertices(1, {point.x, point.y, point.z}, {captureRadius - ringThickness / 2}, {OPTIONS.circlePieces}, {OPTIONS.circlePieces}, {0, 0, 0, 0}, {point.color[1], point.color[2], point.color[3], capturedAlpha}, {1})

			-- captured percentage
			if point.capture > 0 then
				local direction = 1
				if point.aggressorColor[1]..'_'..point.aggressorColor[2]..'_'..point.aggressorColor[3] == '1_1_1' then
					direction = -1
				end
				local piesize = math.floor(((point.capture/captureTime) / (1/capturePieParts))+0.5)
				Spring.Draw.Vertices(1, {point.x, point.y, point.z}, {captureRadius}, {capturePieParts}, {piesize}, {0, 0, 0, 0}, {point.aggressorColor[1], point.aggressorColor[2], point.aggressorColor[3], capturingAlpha}, {direction})
			end

		end

		gl.UseShader(0)

		if not minimap then
			-- animate rotation
			if OPTIONS.rotationSpeed > 0 then
				clockDifference = Spring.DiffTimers(Spring.GetTimer(), prevTimer)
				prevTimer = Spring.GetTimer()

				currentRotationAngle = currentRotationAngle + OPTIONS.rotationSpeed * clockDifference * 0.2
				if currentRotationAngle > 360 then
				   currentRotationAngle = currentRotationAngle - 360
				end
			end

			-- outer ring
			local radius = captureRadius + outerRingDistance
			local detail = OPTIONS.circlePieces * 2
			detail = detail + detail % 2
			local radstep = math.pi * 2 / detail
			local c = {{1,1,1,0.4}, {0,0,0,0.4}}

			for _, point in pairs(capturePoints) do
				local vertices = {}
				local colors = {}
				
				for i = 0, detail do
					local a = i * radstep + currentRotationAngle
					vertices[i+1] = {point.x + radius * math.sin(a), point.y, point.z + radius * math.cos(a)}
					colors[i+1] = c[i%2+1]
				end
				Spring.Draw.Lines(vertices, {width=ringThickness, colors=colors})
			end
		end

		gl.DepthTest(true)
	end

	function gadget:DrawInMiniMap()
		DrawPoints(true)
	end

	function gadget:DrawWorldPreUnit()
		DrawPoints(false) -- Todo: use DrawWorldPreUnit make it so that it colorizes the map/ground
	end

	function gadget:DrawScreen(vsx, vsy)
		local frame = Spring.GetGameFrame()
		if frame / 1800 > startTime then
			local n = 1
			local dominator = SYNCED.dom.dominator
			local dominationTime = SYNCED.dom.dominationTime
			local allyCounter = 0

			--Make it look Pretty
			local scoreMode = Spring.GetModOptions().scoremode or "Countdown"
			if scoreMode == "countdown" then scoreMode = "Countdown" end
			if scoreMode == "tugofwar" then scoreMode = "Tug of War" end
			if scoreMode == "domination" then scoreMode = "Domination" end
			font:Print("Scoring Mode: " .. scoreMode, vsx - 280, vsy * .58 - 38 * -0.75, 18, "lo")

			-- for all the scores with a team.
			for allyTeamID, allyScore in spairs(SYNCED.score) do
				if allyTeamID ~= gaia then
					local teamName = teamList[allyTeamID]["name"]
					local color = teamList[allyTeamID]["color"]

					if #Spring.GetTeamList(allyTeamID) == 0 then
						color = {0.5, 0.5, 0.5, 1}
					end

					font:SetTextColor(color)
					font:Print(teamName, vsx - 280, vsy * .58 - 38 * allyCounter, 16, "lo")

					if allyTeamID == dominator and dominationTime > Spring.GetGameFrame() then
						font:Print(teamName .. " will score a domination in " ..  math.floor((dominationTime - Spring.GetGameFrame()) / 30) .. " seconds!", vsx *.5, vsy *.7, 24, "oc")
					end

					font:SetTextColor(1, 1, 1, 1)
					font:Print("Score: " .. allyScore, vsx - 250, vsy * .5625 - 38 * allyCounter, 16, "lo")

					allyCounter = allyCounter + 1
				end
			end

		else
			font:Print("Capturing points begins in:", vsx - 280, vsy *.58, 18, "lo")
			local timeleft = startTime * 60 - frame / 30
			timeleft = timeleft - timeleft % 1
			font:Print(timeleft .. " seconds", vsx - 280, vsy *.58 - 25, 18, "lo")
		end
	end

end
