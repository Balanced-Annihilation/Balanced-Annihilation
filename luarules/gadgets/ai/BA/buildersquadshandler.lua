BuilderSquadsHandler = class(Module)

local TechLevel = {
	armcv = 1,
	armca = 1,
	armck = 1,
	armacv = 3,
	armack = 2,
	armaca = 2,
	armch = 1,
	armbeaver = 1,
	corcv = 1,
	corca = 1,
	corck = 1,
	coracv = 3,
	coraca = 2,
	corack = 2,
	corch = 1,
	cormuskrat = 1,
}

local EcoBuilders = {
	{
	armcv = true,
	armca = true,
	armck = true,
	armacv = true,
	armack = true,
	armaca = true,
	armch = true,
	armbeaver = true,
	corcv = true,
	corca = true,
	corck = true,
	coracv = true,
	coraca = true,
	corack = true,
	corch = true,
	cormuskrat = true,
	},
	{
	armacv = true,
	armack = true,
	armaca = true,
	coracv = true,
	coraca = true,
	corack = true,
	},
	{
	armacv = true,
	coracv = true,
	},
}

local ExpBuilders = {
	{
	armcv = true,
	armca = true,
	armck = true,
	armacv = true,
	armack = true,
	armaca = true,
	armch = true,
	armbeaver = true,
	corcv = true,
	corca = true,
	corck = true,
	coracv = true,
	coraca = true,
	corack = true,
	corch = true,
	cormuskrat = true,
	},
	{
	armacv = true,
	armack = true,
	armaca = true,
	coracv = true,
	coraca = true,
	corack = true,
	},
	{
	armacv = true,
	coracv = true,
	},
}

local UtilBuilders = {
	armcv = true,
	armca = true,
	armck = true,
	armacv = true,
	armack = true,
	armaca = true,
	armch = true,
	armbeaver = true,
	corcv = true,
	corca = true,
	corck = true,
	coracv = true,
	coraca = true,
	corack = true,
	corch = true,
	cormuskrat = true,
	armfark = true,
	corfast = true,
	armconsul = true,
}
local MilLeaders = {
	armlab = true,
	armalab = true,
	armvp = true,
	armavp = true,
	armap = true,
	armaap = true,
	armshltx = true,
	corlab = true,
	coralab = true,
	corvp = true,
	coravp = true,
	corap = true,
	coraap = true,
	corgant = true,
}

local Commander = {
	armcom = true,
	corcom = true,
}

local function squadtable(domain)
	local maxallowedbp
	if domain == "military" then
		maxallowedbp = 2000
	elseif domain == "economy" then
		maxallowedbp = 1500
	elseif domain == "expand" then
		maxallowedbp = 400
	elseif domain == "util" then
		maxallowedbp = 600
	else
		maxallowedbp = 300
	end
	local stable = {
		leader = {},
		helper = {},
		wtdbprate = 1,
		curbp = 0,
		maxbp = 0,
		maxallowedbp = maxallowedbp,
		}
	return stable
end

function BuilderSquadsHandler:Name()
	return "BuilderSquadsHandler"
end

function BuilderSquadsHandler:internalName()
	return "buildersquadshandler"
end

function BuilderSquadsHandler:WatchTechLevel()
	local maxtechlevel = 1
	for defName, techlevel in pairs (TechLevel) do
		if Spring.GetTeamUnitDefCount(self.ai.id, UnitDefNames[defName].id) > 0 then
			maxtechlevel = math.max(maxtechlevel, techlevel)
		end
	end
	self.currentTechLevel = maxtechlevel
end

function BuilderSquadsHandler:Init()
	self.squads = {
		military = {}, -- [i] = {leader = {[i] = {tqb = tqb, unit = unit}}, helper = {[i] = {tqb = tqb, unit = unit}}, hasPendingRequest, wtdbprate, curbp, maxbp, maxallowedbp}
		economy = {},
		expand = {},
		util = {},
		commander = {},
	}
	self.requests = {} -- [i] = {domain  = domain, role = role, [squadn = squadn]}
	self.idle = {} -- [i] = tqb
	self.states = {} -- [unitID] = {state = state, [params = params]}
	self.coeff = {economy = 0.2, military = 0.2, expand = 0.2, util = 0.2, commander = 0.2}
	self:AddRequest(nil, "commander", "leader")
	self:AddRequest(nil, "military", "leader")
	self:AddRequest(nil, "expand", "leader")
	self:AddRequest(nil, "economy", "leader")
	self:AddRequest(nil, "util", "leader")
	self:AddRequest(nil, "expand", "leader")
	self:AddRequest(nil, "expand", "leader")
	self:AddRequest(nil, "economy", "leader")
	self:AddRequest(nil, "util", "leader")
	self.currentTechLevel = 1
	-- self:AddRequest(nil, "util", "leader")
end

function BuilderSquadsHandler:SetState(tqb, unit, state, params, unitID)
	if state and state == "squad" and params and params.role and (params.role == "leader" or params.role == "helper") then
		tqb:Activate()
	else
		tqb:Deactivate()
	end
	if state == "dead" then
		self.states[unitID] = nil
		return
	end
	self.states[unit.id] = {state = state, params = params}
end

function BuilderSquadsHandler:GetState(tqb, unit)
	return self.states[tqb.unit:Internal().id]
end

function BuilderSquadsHandler:CheckIfExistingNewSquadRequest(techlevel, domain, role)
	for k = 1, #self.requests do
		if self.requests[k] and self.requests[k].domain == domain and self.requests[k].role == role then
			return true
		end
	end
	return false
end

function BuilderSquadsHandler:AddRequest(techlevel, domain, role, squadn)
	self.requests[#self.requests + 1] = { domain = domain, role = role, squadn = squadn}
	return true
end

function BuilderSquadsHandler:RemoveRequest(i)
	if self.requests[i] and self.requests[i].domain and self.requests[i].squadn then
		if self.squads[self.requests[i].domain][self.requests[i].squadn].hasPendingRequest == true then
			self.squads[self.requests[i].domain][self.requests[i].squadn].hasPendingRequest = false
		end
	end
	for k = i, #self.requests - 1 do
		self.requests[k] = self.requests[k+1]
	end
	self.requests[#self.requests] = nil
	return true
end

function BuilderSquadsHandler:CreateSquad(domain)
	local i = 1
	while self.squads[domain][i] ~= nil do
		i = i + 1
	end
	self.squads[domain][i] = squadtable(domain)
	return i
end

function BuilderSquadsHandler:RemoveSquad(domain, i)
	local curSquad = self.squads[domain][i]
	if curSquad then
		for k,v in pairs (curSquad.helper) do
			self:RegisterIdleRecruit(v.tqb, v.unit)
		end
		for k,v in pairs (curSquad.leader) do
			self:RegisterIdleRecruit(v.tqb, v.unit)
		end
		for k,v in pairs(self.requests) do
			if v.squadn == i then
				self:RemoveRequest(k)
				break
			end
		end
		self.squads[domain][i] = {helper = {}, leader = {}}
	end
	self:AddRequest(_,domain, "leader") -- request for replacement squad
end

function BuilderSquadsHandler:ProcessUnit(unit)
	local defs = UnitDefs[UnitDefNames[unit:Name()].id]
	local canBuild = defs.buildSpeed > 0
	local canAssist = defs.canAssist and defs.canMove and (defs.speed > 0)
	local canBuildEco = EcoBuilders[self.currentTechLevel][defs.name] == true
	local canBuildMil = MilLeaders[defs.name] == true
	local canBuildUtil = UtilBuilders[defs.name] == true
	local canBuildExp = ExpBuilders[self.currentTechLevel][defs.name] == true
	local militaryhelper = defs.name == "armnanotc" or defs.name == "cornanotc"
	local militaryleader = canBuildMil
	local utilhelper = false
	local utilleader = canBuildUtil
	local economyhelper = canAssist
	local economyleader = canBuildEco
	local expandhelper = canAssist
	local expandleader = canBuildExp
	local commanderhelper = false
	local commanderleader = defs.name == "armcom" or defs.name == "corcom"	
	local canBe = {
		military = {helper = militaryhelper, leader = militaryleader},
		commander = {helper = commanderhelper, leader = commanderleader},
		util = {helper = utilhelper, leader = utilleader},
		economy = {helper = economyhelper, leader = economyleader},
		expand = {helper = expandhelper, leader = expandleader},
	}
	return defs.name, canBe
end

function BuilderSquadsHandler:AddRecruit(tqb)
	local unit = tqb.unit:Internal()
	self:RemoveIdleRecruit(tqb, unit)
	local unitName, canBe = self:ProcessUnit(unit)
	for i = 1, #self.requests do
		local req = self.requests[i]
		if req.role == "leader" then
			if canBe[req.domain][req.role] == true then
				req.squadn = self:CreateSquad(req.domain)
				self:AssignToSquad(tqb, unit, req.domain, req.role, req.squadn)
				self:RemoveRequest(i)
				return true
			end
		elseif canBe[req.domain][req.role] == true then
			self:AssignToSquad(tqb, unit, req.domain, req.role, req.squadn)
			self:RemoveRequest(i)
			return true
		end
	end
	self:RegisterIdleRecruit(tqb, unit)
end

function BuilderSquadsHandler:RemoveRecruit(tqb)
	local unit = tqb.unit:Internal()
	local state = self:GetState(tqb, unit)
	if state.state == "squad" then
		self:RemoveFromSquad(tqb, unit, state.params.domain, state.params.role, state.params.squadn)
	elseif state.state == "idle" then
		self:RemoveIdleRecruit(tqb, unit)
	end
	self:SetState(tqb, unit, "dead",_, tqb.unit:Internal().id)
	tqb:Deactivate()
	tqb.unit = nil
end

function BuilderSquadsHandler:RegisterIdleRecruit(tqb, unit)
	local i = 1
	while self.idle[i] ~= nil do
		i = i + 1
	end
	self.idle[i] = tqb
	self:SetState(tqb, unit, "idle")
end

function BuilderSquadsHandler:RemoveIdleRecruit(tqb, unit)
	local offset = 0
	for i = 1, #self.idle do
		if (not self.idle[i]) or (not self.idle[i].unit) or self.idle[i].unit:Internal().id == tqb.unit:Internal().id then
			offset = offset + 1
		end
		self.idle[i] = self.idle[i+offset]
	end
end

function BuilderSquadsHandler:AssignToSquad(tqb, unit, domain, role, squadn)
	local squadrole = self.squads[domain][squadn][role]
	self.squads[domain][squadn][role][#self.squads[domain][squadn][role] + 1] = {tqb = tqb, unit = unit}
	self:SetState(tqb, unit, "squad", {domain = domain, role = role, squadn = squadn})
end

function BuilderSquadsHandler:RemoveFromSquad(tqb, unit, domain, role, squadn)
	local squadrole = self.squads[domain][squadn][role]
	local offset = 0
	if role == "leader" then
		self:RemoveSquad(domain,i)
	else
		for i = 1, #squadrole do
			if squadrole[i].unit == unit then
				offset = offset + 1
			end
			if i + offset <= #squadrole then
				self.squads[domain][squadn][role][i] = self.squads[domain][squadn][role][i+offset]
			end
		end
	end
end

function BuilderSquadsHandler:AllowedExpense(res)
	local storedPart = (math.max(0,(res.c - res.s*0.1))) -- Can expend 90% of storage
	local producedPart = res.i
	return storedPart + producedPart
end

function BuilderSquadsHandler:Update()
	if not (Spring.GetGameFrame()%60 == 0) then
		return
	end
	Spring.Echo("//////////////////////"..self.ai.id)
	self:WatchTechLevel()
	local curResources = {energy = self.ai.aimodehandler.resources["energy"], metal = self.ai.aimodehandler.resources["metal"]}
	local m = curResources.metal
	local e = curResources.energy
	local ame = self:AllowedExpense(m)
	local aee = self:AllowedExpense(e)
	self.resourcesManagement = {
	military = {e = self.coeff.military * aee, m = self.coeff.military * ame},
	economy = {e = self.coeff.economy * aee, m = self.coeff.economy * ame},
	expand = {e = self.coeff.expand * aee, m = self.coeff.expand * ame},
	util = {e = self.coeff.util * aee, m = self.coeff.util * ame},
	commander = {e = self.coeff.commander * aee, m = self.coeff.commander * ame},
	}
	for i, v in pairs(self.idle) do -- Try to assign idle recruits to a squad
		if self.idle[i] and self.idle[i].unit then
			self:AddRecruit(self.idle[i])
		end
	end
		Spring.Echo("//////////////Requests")
	for k,v in pairs(self.requests) do -- requests that are not completed after checking all idles will probably need to be sent to task queues
		Spring.Echo(v.domain, v.role, v.squadn, v.sentToTaskQueues, v.queued)	
		if v.sentToTaskQueues ~= true then
			v.sentToTaskQueues = true
		end
	end
	for domain, squads in pairs(self.squads) do
		local nSquads = 0
			for k, v in pairs(squads) do
				nSquads = nSquads + 1
			end
		for k, v in pairs(squads) do
			self:SquadUpdate(domain, k, 1/nSquads)
		end
	end
		Spring.Echo("/////////////////Active Squads")
	for domain, squads in pairs(self.squads) do
		for k, v in pairs(squads) do
			Spring.Echo(domain,k,v)
			if (not v.leader[1]) and (not v.helper[1]) then
				self.squads[domain][k] = nil
			end
		end
	end
end

function BuilderSquadsHandler:SquadUpdate(domain, i, coeff)
	local allocatedToThisSquad = { m = self.resourcesManagement[domain].m * coeff, e = self.resourcesManagement[domain].e * coeff}
	local curUsedBPTot = 0
	local curUsedMetalTot = 0
	local curUsedEnergyTot = 0
	local theoricMaxBPTot = 0
	local wantedBPrate = self.squads[domain][i].wtdbprate or 1
	for k,v in pairs(self.squads[domain][i].helper) do
		local unit = v.unit
		local unitID = unit.id
		local defs = UnitDefs[UnitDefNames[unit:Name()].id]
		local theoricMaxBP = defs.buildSpeed
		local _,curUsedMetal,_,curUsedEnergy = Spring.GetUnitResources(unitID)
		local curUsedBP = (Spring.GetUnitCurrentBuildPower(unitID) or 0) * defs.buildSpeed
		curUsedBPTot = curUsedBPTot + curUsedBP
		curUsedEnergyTot = curUsedEnergyTot + (curUsedEnergy or 0 )
		curUsedMetalTot = curUsedMetalTot + (curUsedMetal or 0)
		theoricMaxBPTot = theoricMaxBPTot + theoricMaxBP
	end
	for k,v in pairs(self.squads[domain][i].leader) do
		local unit = v.unit
		local unitID = unit.id
		local defs = UnitDefs[UnitDefNames[unit:Name()].id]
		if domain ~= "util" and TechLevel[unit:Name()] and TechLevel[unit:Name()] < self.currentTechLevel then
			self:RemoveSquad(domain, i)
			return
		end
		local theoricMaxBP = defs.buildSpeed
		local _,curUsedMetal,_,curUsedEnergy = Spring.GetUnitResources(unitID)
		local curUsedBP = (Spring.GetUnitCurrentBuildPower(unitID) or 0) * defs.buildSpeed
		curUsedBPTot = curUsedBPTot + curUsedBP
		curUsedEnergyTot = curUsedEnergyTot + (curUsedEnergy or 0)
		curUsedMetalTot = curUsedMetalTot + (curUsedMetal or 0)
		theoricMaxBPTot = theoricMaxBPTot + theoricMaxBP
	end
	local curBPrate = curUsedBPTot / theoricMaxBPTot
	if curUsedMetalTot < allocatedToThisSquad.m and curUsedEnergyTot < allocatedToThisSquad.e then
		if curBPrate == 1.0  and domain ~= "commander" then
			if theoricMaxBPTot < self.squads[domain][i].maxallowedbp then
				if self.squads[domain][i].hasPendingRequest ~= true then
					self:AddRequest(_, domain, "helper", i)
					self.squads[domain][i].hasPendingRequest = true
				end
			elseif self:CheckIfExistingNewSquadRequest(_,domain, "leader") ~= true then
				self:AddRequest(_, domain, "leader")
			end
		else
			wantedBPrate = math.min(1.0, wantedBPrate + 0.1)
		end
	else
		wantedBPrate = math.max(0.01, wantedBPrate - 0.1)
	end
	for k,v in pairs(self.squads[domain][i].helper) do
		local unit = v.unit
		local unitID = unit.id
		local defs = UnitDefs[UnitDefNames[unit:Name()].id]
		Spring.SetUnitBuildSpeed(unitID, defs.buildSpeed * wantedBPrate)
	end
	for k,v in pairs(self.squads[domain][i].leader) do
		local unit = v.unit
		local unitID = unit.id
		local defs = UnitDefs[UnitDefNames[unit:Name()].id]
		Spring.SetUnitBuildSpeed(unitID, defs.buildSpeed * wantedBPrate)
	end
	self.squads[domain][i].wtdbprate = wantedBPrate
	self.squads[domain][i].curbp = curUsedBPTot
	self.squads[domain][i].maxbp = theoricMaxBPTot
end

function BuilderSquadsHandler:ScoreUnit(unit)
end
