function widget:GetInfo()
    return {
        name = "fix colors",
        desc = "fix colors",
        author = "Ivan Sirko",
        date = "2020",
        license = "GPL v2",
        layer = -10001,
        enabled = true
    }
end

local myTeamID = Spring.GetMyTeamID()
local spGetSpectatingState	= Spring.GetSpectatingState
local IsSpec = spGetSpectatingState()

function reloadWidgets()
    if widgetHandler.orderList["Ecostats"] ~= 0 then
        widgetHandler:DisableWidget("Ecostats")
        widgetHandler:EnableWidget("Ecostats")
    end
end

function widget:Initialize()
    local allyTeamList = Spring.GetAllyTeamList()
    local numteams = #Spring.GetTeamList() - 1 -- minus gaia
    local numallyteams = #Spring.GetAllyTeamList() - 1 -- minus gaia
    if ((numteams == 2) and (numallyteams == 2)) then
   
	if not IsSpec then
        for _, team in ipairs(Spring.GetTeamList()) do
			if(myTeamID ~= team) then 
            local origColor = Spring.GetTeamOrigColor(team)
				if (origColor <= 0.2) then
						Spring.SetTeamColor(
							team,
							Spring.GetConfigInt("SimpleTeamColorsEnemyR", 250) / 255,
							Spring.GetConfigInt("SimpleTeamColorsEnemyG", 250) / 255,
							Spring.GetConfigInt("SimpleTeamColorsEnemyB", 250) / 255
						)
				end
			end
        end
    end
	end
end

local function ResetOldTeamColors()
    for _, team in ipairs(Spring.GetTeamList()) do
        Spring.SetTeamColor(team, Spring.GetTeamOrigColor(team))
    end
end

function widget:Shutdown()
    ResetOldTeamColors()
end