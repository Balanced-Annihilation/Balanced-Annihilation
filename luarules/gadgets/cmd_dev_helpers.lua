function gadget:GetInfo()
  return {
    name      = "Dev Helper Cmds",
    desc      = "provides various luarules commands to help developers, can only be used after /cheat",
    author    = "Bluestone",
    date      = "05/04/2013",
    license   = "Horses",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

if (not gadgetHandler:IsSyncedCode()) then
	return
end

function Load()
	if not Spring.IsCheatingEnabled() then return end

	for _,unitID in pairs(Spring.GetAllUnits()) do
		Spring.SetUnitStockpile(unitID, select(2,Spring.GetUnitStockpile(unitID)) or 0) --no effect if the unit can't stockpile
	end

end

function Dev()
	if not Spring.IsCheatingEnabled() then return end
		Spring.SendCommands("globallos")
		Spring.SendCommands("godmode")
		Spring.SendCommands("give 20 aafus 1")
		Spring.SendCommands("give 20 armmmkr 1")
		Spring.SendCommands("give 20 aafus")
		Spring.SendCommands("give 20 armmmkr")
end

function gadget:HalfHealth()
	if not Spring.IsCheatingEnabled() then return end

    -- reduce all units health to 1/2 of its current value
    for _,unitID in pairs(Spring.GetAllUnits()) do
        Spring.SetUnitHealth(unitID,Spring.GetUnitHealth(unitID)/2)    
    end
end


function gadget:Initialize()
	gadgetHandler:AddChatAction('load', Load, "")
	gadgetHandler:AddChatAction('halfhealth', HalfHealth, "")
		gadgetHandler:AddChatAction('dev', Dev, "")

end


function gadget:Shutdown()
	gadgetHandler:RemoveChatAction('load')
	gadgetHandler:RemoveChatAction('halfhealth')
			gadgetHandler:RemoveChatAction('dev')

end




--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
