--
-- Created by IntelliJ IDEA.
-- User: Breno Azevedo
-- Date: 30/05/17
-- Time: 03:51
-- This loads after alldefs_post.lua, as defined in defs.lua
--

VFS.Include("gamedata/taptools.lua")
VFS.Include("gamedata/post_save_to_customparams.lua")

local unitDefs = DEFS.unitDefs
local unitDefsData = VFS.Include("gamedata/configs/unitdefs_data.lua")

--Spring.Echo("Saving PostProcessed Table: "..tablelength(unitDefs))

-- Function to generate a table with all existing units' unitdefs, outputs to infolog.txt
-- Eg.: armfatf = { corpse = "DEAD", description = "Enhan...", }
-- PS: This data is usually only generated *once*, when new engine version fields are added
local function UnitDefsToData()
	local allUnits = {}
	local templateFields = unitDefsData.fields	-- This will be copied for each new unit data
	for udefID, udef in pairs(unitDefs) do
		if (istable(udef)) then
			local newUdef = table.deepcopy(templateFields)
			for key,val in pairs(udef) do
				local keyLower = string.lower(key)
				if (templateFields[keyLower] ~= nil) then
					newUdef[keyLower] = val
				else
					Spring.Echo("Warning: UnitDefKey ".. key .." not found in unitdefs_data.fields")
				end
			end
			table.insert(allUnits, {udefID, newUdef})
		end
	end
	Spring.Echo("##All UnitDefs\n")
	local udtstring = table.tosortedstring(allUnits)
	Spring.Echo(udtstring)
end

-- Function to generate a template with default values for all unitdefs_data fields (one-shot usually)
local function PrintUnitDefsTemplate()
	local unitDefTmpt = {}
	for _, udef in pairs(unitDefs) do
		if (istable(udef)) then
			for key,val in pairs(udef) do
				if (unitDefTmpt[key] == nil) then
					defaultval = {}		-- table by default
					if type(val) == "string" then
						defaultval = ""
					elseif type(val) == "boolean" then
						defaultval = false
					elseif type(val) == "number" then
						defaultval = 0
					end
					unitDefTmpt[key] = defaultval
				end
			end
		end
	end
	local udtstring = table.tosortedstring(unitDefTmpt)
	Spring.Echo("##UnitDefs Template\n")
	Spring.Echo(udtstring)
end

-- Outputs all Unit data (defs) to infolog.txt, in CSV format
-- Afterwards, unitdefs_data.lua will be re-generated from the spreadsheet
local function OutputUnitDefs()
	local allUnits = unitDefsData.data
	local text,sep = "", "`"
	Spring.Echo("##CSV Start\n")
	-- CSV Header
	local orderedDefsFields = table.csvkeys(unitDefsData.fields, sep)
	text = "UnitID"..sep..orderedDefsFields.."\n"
	-- CSV Body
	
	--Spring.Echo("##Units Count: "..#allUnits)
	for _,unit in ipairs (allUnits) do
		if (istable(unit)) then
			text = text .. tostring(unit[1]) .. sep		-- UnitDefID
			for _,v in pairsByKeys (unit[2]) do			-- Table with UnitDefs
				text = text .. tostringplus(v) .. sep
			end
			text = text .. "\n"
		end
	end
	Spring.Echo(text)
	Spring.Echo("##CSV End\n")
end

--## Enable each of the post functions below as needed:

--PrintUnitDefsTemplate()
--UnitDefsToData() --<-- Uncomment to create unitdefs_data header
--OutputUnitDefs() --<-- Uncomment to output unitdefs to csv format (at infolog.txt)
