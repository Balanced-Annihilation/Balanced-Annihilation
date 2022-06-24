function widget:GetInfo()
    return {
        name      = "anon_ffa",
        desc      = "",
        author    = "Ivan Sirko",
        date      = "2020",
        license   = "GNU GPL, v2 or later",
        layer     = -100000,
        enabled   = true,
    }
end

if tonumber(Spring.GetModOptions().anon_ffa) ~= 1 or Spring.GetSpectatingState() then return end

local SendCommands = Spring.SendCommands
local GetSpectatingState = Spring.GetSpectatingState
local GetPlayerInfo = Spring.GetPlayerInfo
local GetTeamInfo = Spring.GetTeamInfo
local GetPlayerRoster = Spring.GetPlayerRoster
local GetTeamOrigColor = Spring.GetTeamOrigColor

local CLocalPlayer = Spring.GetMyPlayerID()
local CJustAnotherPlayer = (#Spring.GetPlayerList() ~= 1 and ((CLocalPlayer ~= (0) and (0)) or (1))) or (0)
local CLocalTeam = Spring.GetMyTeamID()
local CGaiaTeam,CGaiaAllyTeam = #Spring.GetTeamList()-1,#Spring.GetAllyTeamList()-1

local function Sub_GetPlayerInfo(player)
    if player == CLocalPlayer then return GetPlayerInfo(player) end
    local name,active,spectator,team,allyTeam,pingTime,cpuUsage,country,rank,customPlayerKeys = GetPlayerInfo(player)
    return "?",active,spectator,((spectator and team) or CGaiaTeam),((spectator and allyTeam) or CGaiaAllyTeam),
        pingTime,cpuUsage,country,rank,customPlayerKeys
end
local function Sub_GetTeamInfo(team)
    if team == CLocalTeam then return GetTeamInfo(team) end
    local team,leader,isDead,isAiTeam,side,allyTeam,incomeMultiplier,customTeamKeys = GetTeamInfo(team)
    --return team,nil,isDead,isAiTeam,nil,allyTeam,nil,customTeamKeys
    return team,CJustAnotherPlayer,isDead,isAiTeam,nil,allyTeam,nil,customTeamKeys
end
local function Sub_GetPlayerRoster(...)
    local roster = GetPlayerRoster(...)
    for i = 1,#roster do local info = roster[i];
        if not info[5] and info[2] ~= CLocalPlayer then info[3],info[4] = CGaiaTeam,CGaiaAllyTeam end
    end
    return roster
end

local function Substitute()
    Spring.GetPlayerInfo = Sub_GetPlayerInfo
    Spring.GetTeamInfo = Sub_GetTeamInfo
    Spring.GetPlayerRoster = Sub_GetPlayerRoster
    Spring.GetTeamOrigColor = Spring.GetTeamColor
    function widget:Update() --(disabling it constantly, as user widgets may enable it via SendCommands/input)
        SendCommands("info 0")
    end
end
local function Restore()
    Spring.GetPlayerInfo = GetPlayerInfo
    Spring.GetTeamInfo = GetTeamInfo
    Spring.GetPlayerRoster = GetPlayerRoster
    Spring.GetTeamOrigColor = GetTeamOrigColor
    widgetHandler:RemoveWidget(widget)
end

Substitute()

function widget:PlayerChanged(player)
    if player == CLocalPlayer and GetSpectatingState() then
        Restore()
    end
end