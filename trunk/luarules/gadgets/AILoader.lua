ion gadget:GetInfo()
   return {
      name = "ShardLua",
      desc = "Shard by AF for Spring Lua",
      author = "eronoobos, based on gadget by raaar, and original AI by AF",
      date = "April 2016",
      license = "whatever",
      layer = 999999,
      enabled = true,
   }
end

-- globals
ShardSpringLua = true -- this is the AI Boot gadget, so we're in Spring Lua
VFS.Include("luarules/gadgets/ai/preload/globals.lua")

-- fake os object
os = shard_include("spring_lua/fakeos")

-- missing math function
function math.mod(number1, number2)
	return number1 % number2
end
math.fmod = math.mod

shard_include("behaviourfactory")
shard_include("unit")
shard_include("module")
shard_include("modules")

-- Shard object
Shard = shard_include("spring_lua/shard")
Shard.AIs = {}
Shard.AIsByTeamID = {}
local AIs = Shard.AIs

-- fake api object
api = shard_include("spring_lua/fakeapi")

-- AI class
shard_include("ai")

-- localization
local spEcho = Spring.Echo
local spGetTeamList = Spring.GetTeamList
local spGetTeamInfo = Spring.GetTeamInfo
local spGetTeamLuaAI = Spring.GetTeamLuaAI
local spAreTeamsAllied = Spring.AreTeamsAllied
local spGetTeamStartPosition = Spring.GetTeamStartPosition
local spGetTeamUnits = Spring.GetTeamUnits
local spGetAllUnits = Spring.GetAllUnits
local spGetUnitTeam = Spring.GetUnitTeam

local function prepareTheAI(thisAI)
	if not thisAI.modules then thisAI:Init() end
	ai = thisAI
	game = thisAI.game
	map = thisAI.map
end

--SYNCED CODE
if (gadgetHandler:IsSyncedCode()) then

function gadget:Initialize()

	local numberOfmFAITeams = 0
	local teamList = spGetTeamList()

	for i=1,#teamList do
		local id = teamList[i]
		local _,_,_,isAI,side,allyId = spGetTeamInfo(id)
        
		--spEcho("Player " .. teamList[i] .. " is " .. side .. " AI=" .. tostring(isAI))

		---- adding AI
		if (isAI) then
			local aiInfo = spGetTeamLuaAI(id)
			if (string.sub(aiInfo,1,8) == "ShardLua") then
				numberOfmFAITeams = numberOfmFAITeams + 1
				spEcho("Player " .. teamList[i] .. " is " .. aiInfo)
				-- add AI object
				thisAI = AI()
				thisAI.id = id
				thisAI.allyId = allyId
				-- thisAI:Init()
				AIs[#AIs+1] = thisAI
				Shard.AIsByTeamID[id] = thisAI
			else
				spEcho("Player " .. teamList[i] .. " is another type of lua AI!")
			end
		end
	end

	-- add allied teams for each AI
	for _,thisAI in ipairs(AIs) do
		alliedTeamIds = {}
		enemyTeamIds = {}
		for i=1,#teamList do
			if (spAreTeamsAllied(thisAI.id,teamList[i])) then
				alliedTeamIds[teamList[i]] = true
			else
				enemyTeamIds[teamList[i]] = true
			end
		end
		-- spEcho("AI "..thisAI.id.." : allies="..#alliedTeamIds.." enemies="..#enemyTeamIds)
		thisAI.alliedTeamIds = alliedTeamIds
		thisAI.enemyTeamIds = enemyTeamIds
	end

	-- catch up to started game
	local frame = Spring.GetGameFrame()
	if frame > 0 then
		self:GameStart()
		-- catch up to current units
		for _,uId in ipairs(spGetAllUnits()) do
			self:UnitCreated(uId, Spring.GetUnitDefID(uId), Spring.GetUnitTeam(uId))
			self:UnitFinished(uId, Spring.GetUnitDefID(uId), Spring.GetUnitTeam(uId))
		end
	end
end

function gadget:GameStart() 
    -- Initialise AIs
    for _,thisAI in ipairs(AIs) do
        local _,_,_,isAI,side = spGetTeamInfo(thisAI.id)
		thisAI.side = side
		local x,y,z = spGetTeamStartPosition(thisAI.id)
		thisAI.startPos = {x,y,z}
		if not thisAI.modules then thisAI:Init() end
    end
end


function gadget:GameFrame(n) 

	-- for each AI...
    for _,thisAI in ipairs(AIs) do
        
        -- update sets of unit ids : own, friendlies, enemies
		thisAI.ownUnitIds = {}
        thisAI.friendlyUnitIds = {}
        thisAI.alliedUnitIds = {}
        thisAI.enemyUnitIds = {}

        for _,uId in ipairs(spGetAllUnits()) do
        	if (spGetUnitTeam(uId) == thisAI.id) then
        		thisAI.ownUnitIds[uId] = true
        		thisAI.friendlyUnitIds[uId] = true
        	elseif (thisAI.alliedTeamIds[spGetUnitTeam(uId)] or spGetUnitTeam(uId) == thisAI.id) then
        		thisAI.alliedUnitIds[uId] = true
        		thisAI.friendlyUnitIds[uId] = true
        	else
        		thisAI.enemyUnitIds[uId] = true
        	end
        end 
	
		-- run AI game frame update handlers
		prepareTheAI(thisAI)
		thisAI:Update()
    end
end


function gadget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOpts, cmdTag)
	if cmdID < 0 then
		local bdef = UnitDefs[unitDefID]
		local udef = UnitDefs[-cmdID]
		-- Spring.Echo(bdef.name, unitID, "received command to build", udef.name)
	end
end

function gadget:UnitCreated(unitId, unitDefId, teamId, builderId) 
	local udef = UnitDefs[unitDefId]
	-- Spring.Echo(udef.name, unitId, "created")
	-- for each AI...
	local unit = Shard:shardify_unit(unitId)
    for _,thisAI in ipairs(AIs) do
    	if Spring.GetUnitTeam(unitId) == thisAI.id then
	    	prepareTheAI(thisAI)
	    	thisAI:UnitCreated(unit)
	    end
		-- thisAI:UnitCreated(unitId, unitDefId, teamId, builderId)
	end
end

function gadget:UnitDestroyed(unitId, unitDefId, teamId, attackerId, attackerDefId, attackerTeamId) 
	-- for each AI...
	local unit = Shard:shardify_unit(unitId)
	if unit then
		for _,thisAI in ipairs(AIs) do
			prepareTheAI(thisAI)
			thisAI:UnitDead(unit)
			-- thisAI:UnitDestroyed(unitId, unitDefId, teamId, attackerId, attackerDefId, attackerTeamId)
		end
		Shard:unshardify_unit(self.engineUnit)
	end
end


function gadget:UnitDamaged(unitId, unitDefId, unitTeamId, damage, paralyzer, weaponDefId, projectileId, attackerId, attackerDefId, attackerTeamId)
	-- for each AI...
	local unit = Shard:shardify_unit(unitId)
	if unit then
		local attackerUnit = Shard:shardify_unit(attackerId)
		local damageObj = Shard:shardify_damage(damage, weaponDefId, paralyzer)
	    for _,thisAI in ipairs(AIs) do
	    	prepareTheAI(thisAI)
	    	thisAI:UnitDamaged(unit, attackerUnit, damageObj)
			-- thisAI:UnitDamaged(unitId, unitDefId, unitTeamId, attackerId, attackerDefId, attackerTeamId)
		end	
	end
end

function gadget:UnitIdle(unitId, unitDefId, teamId) 
	-- for each AI...
	local unit = Shard:shardify_unit(unitId)
	if unit then
	    for _,thisAI in ipairs(AIs) do
	    	prepareTheAI(thisAI)
	    	thisAI:UnitIdle(unit)
			-- thisAI:UnitIdle(unitId, unitDefId, teamId)
		end
	end
end


function gadget:UnitFinished(unitId, unitDefId, teamId) 
	-- for each AI...
	local unit = Shard:shardify_unit(unitId)
	if unit then
	    for _,thisAI in ipairs(AIs) do
			-- thisAI:UnitFinished(unitId, unitDefId, teamId)
			prepareTheAI(thisAI)
			thisAI:UnitBuilt(unit)
		end
	end
end

function gadget:UnitTaken(unitId, unitDefId, teamId, newTeamId) 
	local unit = Shard:shardify_unit(unitId)
	if unit then
	    for _,thisAI in ipairs(AIs) do
	    	prepareTheAI(thisAI)
			-- thisAI:UnitTaken(unitId, unitDefId, teamId, newTeamId)
			-- thisAI:UnitDead(unit)
		end
	end
end

function gadget:UnitGiven(unitId, unitDefId, teamId, oldTeamId) 
	local unit = Shard:shardify_unit(unitId)
	if unit then
	    for _,thisAI in ipairs(AIs) do
	    	prepareTheAI(thisAI)
			-- thisAI:UnitCreated(unitId, unitDefId, teamId, oldTeamId)
			thisAI:UnitCreated(unit)
		end
	end
end

function gadget:FeatureDestroyed(featureID)
	Shard:unshardify_feature(featureID)
end

function gadget:GameID(gameID)
	if Shard then
		Shard.gameID = gameID
		local rseed = 0
		local unpacked = VFS.UnpackU8(gameID, 1, string.len(gameID))
		for i, part in ipairs(unpacked) do
			-- local mult = 256 ^ (#unpacked-i)
			-- rseed = rseed + (part*mult)
			rseed = rseed + part
		end
		-- Spring.Echo("randomseed", rseed)
		Shard.randomseed = rseed
	end
end

--UNSYNCED CODE
else

local function sdAddRectangle(_, x1, z1, x2, z2, r, g, b, a, label, filled, teamID, channel)
	if (Script.LuaUI('ShardDrawAddRectangle')) then
		Script.LuaUI.ShardDrawAddRectangle(x1, z1, x2, z2, {r, g, b, a}, label, filled, teamID, channel)
	end
end

local function sdEraseRectangle(_, x1, z1, x2, z2, r, g, b, a, label, filled, teamID, channel)
	if (Script.LuaUI('ShardDrawEraseRectangle')) then
		Script.LuaUI.ShardDrawEraseRectangle(x1, z1, x2, z2, {r, g, b, a}, label, filled, teamID, channel)
	end
end

local function sdAddCircle(_, x, z, radius, r, g, b, a, label, filled, teamID, channel)
	if (Script.LuaUI('ShardDrawAddCircle')) then
		Script.LuaUI.ShardDrawAddCircle(x, z, radius, {r, g, b, a}, label, filled, teamID, channel)
	end
end

local function sdEraseCircle(_, x, z, radius, r, g, b, a, label, filled, teamID, channel)
	if (Script.LuaUI('ShardDrawEraseCircle')) then
		Script.LuaUI.ShardDrawEraseCircle(x, z, radius, {r, g, b, a}, label, filled, teamID, channel)
	end
end

local function sdAddLine(_, x1, z1, x2, z2, r, g, b, a, label, arrow, teamID, channel)
	if (Script.LuaUI('ShardDrawAddLine')) then
		Script.LuaUI.ShardDrawAddLine(x1, z1, x2, z2, {r, g, b, a}, label, arrow, teamID, channel)
	end
end

local function sdEraseLine(_, x1, z1, x2, z2, r, g, b, a, label, arrow, teamID, channel)
	if (Script.LuaUI('ShardDrawEraseLine')) then
		Script.LuaUI.ShardDrawEraseLine(x1, z1, x2, z2, {r, g, b, a}, label, arrow, teamID, channel)
	end
end

local function sdAddPoint(_, x, z, r, g, b, a, label, teamID, channel)
	if (Script.LuaUI('ShardDrawAddPoint')) then
		Script.LuaUI.ShardDrawAddPoint(x, z, {r, g, b, a}, label, teamID, channel)
	end
end

local function sdErasePoint(_, x, z, r, g, b, a, label, teamID, channel)
	if (Script.LuaUI('ShardDrawErasePoint')) then
		Script.LuaUI.ShardDrawErasePoint(x, z, {r, g, b, a}, label, teamID, channel)
	end
end

local function sdAddUnit(_, unitID, r, g, b, a, label, teamID, channel)
	if (Script.LuaUI('ShardDrawAddUnit')) then
		Script.LuaUI.ShardDrawAddUnit(unitID, {r, g, b, a}, label, teamID, channel)
	end
end

local function sdEraseUnit(_, unitID, r, g, b, a, label, teamID, channel)
	if (Script.LuaUI('ShardDrawEraseUnit')) then
		Script.LuaUI.ShardDrawEraseUnit(unitID, {r, g, b, a}, label, teamID, channel)
	end
end

local function sdClearShapes(_, teamID, channel)
	if (Script.LuaUI('ShardDrawClearShapes')) then
		Script.LuaUI.ShardDrawClearShapes(teamID, channel)
	end
end

local function sdDisplay(_, onOff)
	if (Script.LuaUI('ShardDrawDisplay')) then
		Script.LuaUI.ShardDrawDisplay(onOff)
	end
end

function gadget:Initialize()
	gadgetHandler:AddSyncAction('ShardDrawAddRectangle', sdAddRectangle)
	gadgetHandler:AddSyncAction('ShardDrawEraseRectangle', sdEraseRectangle)
	gadgetHandler:AddSyncAction('ShardDrawAddCircle', sdAddCircle)
	gadgetHandler:AddSyncAction('ShardDrawEraseCircle', sdEraseCircle)
	gadgetHandler:AddSyncAction('ShardDrawAddLine', sdAddLine)
	gadgetHandler:AddSyncAction('ShardDrawEraseLine', sdEraseLine)
	gadgetHandler:AddSyncAction('ShardDrawAddPoint', sdAddPoint)
	gadgetHandler:AddSyncAction('ShardDrawErasePoint', sdErasePoint)
	gadgetHandler:AddSyncAction('ShardDrawAddUnit', sdAddUnit)
	gadgetHandler:AddSyncAction('ShardDrawEraseUnit', sdEraseUnit)
	gadgetHandler:AddSyncAction('ShardDrawClearShapes', sdClearShapes)
	gadgetHandler:AddSyncAction('ShardDrawDisplay', sdDisplay)
end

end