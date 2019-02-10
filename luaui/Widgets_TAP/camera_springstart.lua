function widget:GetInfo()
	return {
		name = "Camera Start Setup",
		desc = "Sets camera to Spring after load, centers on commander on start",
		author = "MaDDoX",
		date = "12/03/2017",
		license = "LGPL",
		layer = 100,
		enabled = true,
	}
end

local camAngle = 2.52  --2.677 is the default, more = vertical top/down

--local spGetAllUnits		= Spring.GetAllUnits
local initialized = false
local spGetMyTeamID		= Spring.GetMyTeamID
local spGetTeamUnits	= Spring.GetTeamUnits
local spGetCameraState = Spring.GetCameraState
local spSetCameraState = Spring.SetCameraState
local spGetPlayerInfo = Spring.GetPlayerInfo
local myPlayerID = Spring.GetMyPlayerID()
local spGetGameFrame = Spring.GetGameFrame
local spGetUnitPosition = Spring.GetUnitPosition
local spSetCameraTarget = Spring.SetCameraTarget

function widget:Initialize()
	local camState = spGetCameraState()
	camState.mode = 2
	spSetCameraState(camState,0)
            --"luaui enablewidget Spy move/reclaim defaults"
    local _, _, spec = spGetPlayerInfo(myPlayerID)
    -- Only enable MMB-hold scroll-lock if it's in spec mode
    if not spec then
        Spring.SendCommands("/set MouseDragScrollThreshold -1")
    else
        Spring.SendCommands("/set MouseDragScrollThreshold 0.3")
    end
end

function widget:GameFrame(n)
	local _, _, spec = spGetPlayerInfo(myPlayerID)
	if spec or initialized then
		widgetHandler:RemoveWidget()
		return
	end
    local myUnits = spGetTeamUnits(spGetMyTeamID())
	if #myUnits > 0 then
		local commID = myUnits[1]
		local x, y, z = spGetUnitPosition(commID)
        local camState = spGetCameraState()
        --Spring.Echo("Cam State params: ")
        --for index,value in pairs(camState) do
        --    Spring.Echo(index,value)
        --end
        camState.mode = 2
        camState.rx = camAngle
        spSetCameraState(camState,0)
		spSetCameraTarget(x, y, z)
		--local camState = Spring.GetCameraState()
		--camState.py = y-500
		--Spring.SetCameraState(camState,0)
		--Spring.SetCameraOffset (0, 0, -200)
	end
    initialized = true
    --Spring.Echo("Initialized")
end
