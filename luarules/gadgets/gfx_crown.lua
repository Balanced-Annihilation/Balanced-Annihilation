function gadget:GetInfo()
  return {
    name      = "Commander Crowns",
    desc      = "Spawns Crown for commanders",
    author    = "Doo",
    date      = "April 2018",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = false  --  loaded by default?
  }
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if gadgetHandler:IsSyncedCode() then

    VFS.Include('luarules/configs/champions.lua')

    function gadget:UnitCreated(unitID, unitDefID, unitTeam)
        if UnitDefNames["armcom"].id == unitDefID or UnitDefNames["corcom"].id == unitDefID then
            --show crown if victor of a tourney
            local _, leader = Spring.GetTeamInfo(unitTeam)
            local leader = Spring.GetPlayerInfo(leader)
            if crown[leader] then
                    Spring.CallCOBScript(unitID, "showcrown", 0)
            end
        end
    end

end	