---
--- Created by MaDDoX.
--- DateTime: 20/09/17 15:42
---

local base = piece 'base'
local tip = piece 'tip'

local radians = math.rad

function script.Create()
    Turn (tip, z_axis, radians(90), radians(82.329670) ) --x_axis -90.236264
    Sleep (1096)
    Move ( base , x_axis, 13.800000 , 18.03424 )
end

function script.Activate()
end

function script.Deactivate()
end

--called whenever construction begins.
function script.StartBuilding(heading, pitch)
end

function script.StopBuilding()
end

function script.QueryBuildInfo ( )
    return base
end

-- script.Killed ( number recentDamage, number maxHealth )
function script.Killed(recentDamage, maxHealth)
end
