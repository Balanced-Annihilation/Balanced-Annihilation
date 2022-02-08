local versionNumber = "0.5"

function widget:GetInfo()
  return {
    name      = "SmoothCam",
    desc      = "[v" .. string.format("%s", versionNumber ) .. "] Moves camera smoothly",
    author    = "very_bad_soldier",
    date      = "August, 8, 2010",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
	handler   = true,
    enabled   = true
  }
end


--------------------------------------------------------------------------------
----------------------------Configuration---------------------------------------
local camSpeed   = 0.27
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local spGetCameraState   	= Spring.GetCameraState
local spSetCameraState   	= Spring.SetCameraState
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function widget:Update(dt)
	if( not panning) then
  local cs = spGetCameraState()
  spSetCameraState(cs, camSpeed)
  end
end

function widget:KeyPress(key, modifier, isRepeat)
    if modifier.ctrl then --set anchor
		panning = true
    else
		panning = false
	end
end

--function widget:Initialize()
-- Spring.SendCommands("CamTimeFactor 2")
--Spring.SendCommands("CamTimeExponent 8")
--end

--function widget:Initialize()
-- Spring.SendCommands("CamTimeFactor 3.7")
--Spring.SendCommands("CamTimeExponent 14.8")
--end

--function widget:Shutdown()
--	Spring.SendCommands("CamTimeFactor 1")
--  Spring.SendCommands("CamTimeExponent 4")
--end