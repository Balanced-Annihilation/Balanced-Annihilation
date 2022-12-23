function widget:GetInfo()
  return {
    name      = "Select n Center!",
    desc      = "Selects and centers the Commander at the start of the game.",
    author    = "quantum and Evil4Zerggin",
    date      = "19 April 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 5,
    enabled   = true,
  }
end

function widget:GameStart()
    local unitArray = Spring.GetTeamUnits(Spring.GetMyTeamID())
    if unitArray[1] then
        Spring.SelectUnitArray({unitArray[1]})
        local x, y, z = Spring.GetUnitPosition(unitArray[1])
        Spring.SetCameraTarget(x, y, z)
    end
    widgetHandler:RemoveWidget(self)
end
