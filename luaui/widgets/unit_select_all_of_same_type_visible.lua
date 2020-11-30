--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unit_smart_select.lua
--  version: 1.36
--  brief:   Selects units as you drag over them and provides selection modifier hotkeys
--  original author: Ryan Hileman (aegis)
--
--  Copyright (C) 2011.
--  Public Domain.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

include('keysym.h.lua')

function widget:GetInfo()
	return {
		name      = "SelectAllUnitsOfSameTypeVisible",
		desc      = "Press cntrl X to select every onscreen with the same type as your selection",
		author    = "aegis",
		date      = "Jan 2, 2011",
		license   = "Public Domain",
		layer     = 0,
		enabled   = true
	}
end

local GetVisibleUnits = Spring.GetVisibleUnits
local GetUnitDefID = Spring.GetUnitDefID
local GetSelectedUnits = Spring.GetSelectedUnits
local spGetKeyState = Spring.GetKeyState
local spGetModKeyState = Spring.GetModKeyState
local SelectUnitArray = Spring.SelectUnitArray

function contains(list, x)
	for _, v in pairs(list) do
		if v == x then return true end
	end
	return false
end

function widget:Update()


	
	
			local keyPressed = spGetKeyState( KEYSYMS.X )
			local alt,ctrl,meta,shift = spGetModKeyState()
		
			if (ctrl and keyPressed) then
				
				local visibleUnits = GetVisibleUnits()
				if #visibleUnits then
					for i=1, #visibleUnits do
					local unitID = visibleUnits[i]
					local visableID = GetUnitDefID(unitID)
					local ud = UnitDefs[visableID]
					end
					
				end
				
				local selectedUnits = GetSelectedUnits()
				local numselected 
				if #selectedUnits == nil then
					numselected = 0
				else
					numselected = #selectedUnits
				end
				
				local numvisible
				if #visibleUnits == nil then
					numvisible = 0
				else
					numvisible = #visibleUnits
					
					
					
					
						
						if  (#selectedUnits > 0) then
						
						SelectionTypes = {}
						for i=1, #selectedUnits do
							local udid = GetUnitDefID(selectedUnits[i])
							SelectionTypes[udid] = 1
						end
						
						-- only select new units identical to those already selected
						tmp = {}
						for i=1, #selectedUnits do
							local uid = selectedUnits[i]
							local udid = GetUnitDefID(uid)
							if (SelectionTypes[udid] ~= nil) then
								tmp[#tmp+1] = uid
							end
						end
						
						tmp2 = {}
						
						for i=1, #tmp do
							local uid = tmp[i]
							local udid = GetUnitDefID(uid)
							--Spring.Echo(tmp)
							--Spring.Echo(visibleUnits)
							if contains(visibleUnits, uid) then
							
								tmp2[#tmp2+1] = uid
							end
								--Spring.Echo(tmp2)

						end
						
					
					
					
					SelectUnitArray(tmp2)
					lastSelection = nil
					referenceSelection = nil
					SelectionTypes = nil
					end
				end
				
				
				
				--Spring.Echo("visibleUnits " .. numvisible)
				--Spring.Echo("selectedUnits " .. numselected)
			--Spring.Echo("ye")
			end
end
