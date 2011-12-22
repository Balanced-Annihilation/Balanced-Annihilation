function widget:GetInfo()
    return {
        name = "Attack and Move Notification",
        desc = "v0.31 Notifes when a unit is attacked or a move command failed",
        author = "knorke & very_bad_soldier",
        date = "Dec , 2011",
        license = "GPLv2",
        layer = 1,
        enabled = true
    }
end
----------------------------------------------------------------------------
local alarmInterval                 = 5        --seconds
----------------------------------------------------------------------------                
local spGetLocalTeamID              = Spring.GetLocalTeamID
local spPlaySoundFile               = Spring.PlaySoundFile
local spEcho                        = Spring.Echo
local spGetTimer                    = Spring.GetTimer
local spDiffTimers                  = Spring.DiffTimers
local spIsUnitInView                = Spring.IsUnitInView
local spGetUnitPosition             = Spring.GetUnitPosition
local spSetLastMessagePosition      = Spring.SetLastMessagePosition
local random                        = math.random
----------------------------------------------------------------------------
local lastAlarmTime                 = nil
local localTeamID                   = nil
----------------------------------------------------------------------------

function widget:Initialize()
    setTeamId()    
    lastAlarmTime = spGetTimer()
    math.randomseed( os.time() )
end

function widget:UnitDamaged (unitID, unitDefID, unitTeam, damage, paralyzer, weaponID, attackerID, attackerDefID, attackerTeam)
    if ( localTeamID ~= unitTeam or spIsUnitInView(unitID)) then
        return --ignore other teams and units in view
    end

    local now = spGetTimer()
    if ( spDiffTimers( now, lastAlarmTime ) < alarmInterval ) then
        return
    end
    
    lastAlarmTime = now
    
    local udef = UnitDefs[unitDefID]
    local x,y,z = spGetUnitPosition(unitID)

    spEcho("-> " .. udef.humanName  .." is being attacked!") --print notification
    
    if ( udef.sounds.underattack and (#udef.sounds.underattack > 0) ) then
        id = random(1, #udef.sounds.underattack) --pick a sound from the table by random --(id 138, name warning2, volume 1)
            
        soundFile = udef.sounds.underattack[id].name
        if ( string.find(soundFile, "%.") == nil ) then
            soundFile = soundFile .. ".wav" --append .wav if no extension is found
        end
            
        spPlaySoundFile( "sounds/" .. soundFile, udef.sounds.underattack[id].volume, nil, "ui" )
    end
        
    if (x and y and z) then spSetLastMessagePosition(x,y,z) end
end

--function widget:UnitMoveFailed(unitID, unitDefID, unitTeam)
--    local udef = UnitDefs[unitDefID]
--    spEcho( udef.humanName  .. ": Can't reach destination!" )
--end 

function setTeamId()
    localTeamID = spGetLocalTeamID()    
end

--changing teams, rejoin, becoming spec etc
function widget:PlayerChanged (playerID)
    setTeamId()    
end
