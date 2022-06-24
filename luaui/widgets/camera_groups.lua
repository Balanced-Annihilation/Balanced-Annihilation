function widget:GetInfo()
    return {
        name = "Camera groups",
        desc = "Camera groups",
        author = "Ares",
        license = "GNU GPL, v2 or later",
        layer = 1002,
        enabled = true
    }
end

include("keysym.h.lua")
local GetGroupList = Spring.GetGroupList

local groupNumber = {
    [KEYSYMS.N_1] = 1,
    [KEYSYMS.N_2] = 2,
    [KEYSYMS.N_3] = 3,
    [KEYSYMS.N_4] = 4,
    [KEYSYMS.N_5] = 5,
    [KEYSYMS.N_6] = 6,
    [KEYSYMS.N_7] = 7,
    [KEYSYMS.N_8] = 8,
    [KEYSYMS.N_9] = 9,
    [KEYSYMS.N_0] = 0
}
local GetCameraState = Spring.GetCameraState
local SetCameraTarget = Spring.SetCameraTarget
local selectedUnitsCount = Spring.GetSelectedUnitsCount
local cameraAnchors = {}
local spSetCameraState = Spring.SetCameraState

function widget:KeyPress(key, modifier, isRepeat)
    if (key ~= nil and groupNumber[key]) then
        local group = groupNumber[key]
        local existingGroups = GetGroupList()
        if modifier.ctrl then --set anchor
			if (selectedUnitsCount() == 0) then
				local cameraState = GetCameraState()
				cameraAnchors[group] = Spring.GetCameraState()  --cameraAnchors[group] = {cameraState.px, cameraState.py, cameraState.pz}
			end
        else --recall anchor
            if not existingGroups[group] then  --not exists
				if(cameraAnchors[group]) then
					local cameraAnchor = cameraAnchors[group]
					spSetCameraState(cameraAnchor, 0) -- SetCameraTarget(cameraAnchor[1],cameraAnchor[2], cameraAnchor[3], 0)
				end
            end
        end
    end
end