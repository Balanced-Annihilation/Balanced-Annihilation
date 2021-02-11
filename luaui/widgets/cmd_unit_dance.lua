function widget:GetInfo()
	return {
		name = "Cmd Send Dance",
		desc = "",
		author = "silver",
		version = "",
		date = "2021",
		license = "free",
		layer = 0,
		enabled = true,
	}
end

function widget:TextCommand(msg)
	if msg:sub(1, 6) == "dance2" then
		local selectedUnit = unpack(Spring.GetSelectedUnits())
		msg = "%%2" .. tostring(selectedUnit)
		Spring.SendLuaRulesMsg(msg)
	elseif msg:sub(1, 5) == "dance" then
		local selectedUnit = unpack(Spring.GetSelectedUnits())
		msg = "%%1" .. tostring(selectedUnit)
		Spring.SendLuaRulesMsg(msg)
	elseif msg:sub(1, 3) == "dab" then
		local selectedUnit = unpack(Spring.GetSelectedUnits())
		msg = "%%0" .. tostring(selectedUnit)
		Spring.SendLuaRulesMsg(msg)
	end

	
end