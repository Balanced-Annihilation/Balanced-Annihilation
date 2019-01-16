--------------------------------------------------------------------------------
-- Default Engine Weapon Definitions Post-processing
--------------------------------------------------------------------------------
-- TAPrime stores weapondefs in the unitdef files, except for standalone/shared
-- weapons, individually defined in the /weapons folder
--
-- Here we load those defs into the WeaponDefs table
-- Then we call alldefs_post.lua, in which post processing of WeaponDefs should
-- actually take place. So basically, DONT TOUCH this!
--------------------------------------------------------------------------------

VFS.Include("gamedata/taptools.lua")
-- see alldefs.lua for documentation
-- load the games _Post functions for defs, and find out if saving to custom params is wanted
VFS.Include("gamedata/alldefs_post.lua")
-- load functionality for saving to custom params
VFS.Include("gamedata/post_save_to_customparams.lua")


--local function isbool(x)   return (type(x) == 'boolean') end
--local function istable(x)  return (type(x) == 'table')   end
--local function isnumber(x) return (type(x) == 'number')  end
--local function isstring(x) return (type(x) == 'string')  end
--
--local function tobool(val)
--  local t = type(val)
--  if (t == 'nil') then
--    return false
--  elseif (t == 'boolean') then
--    return val
--  elseif (t == 'number') then
--    return (val ~= 0)
--  elseif (t == 'string') then
--    return ((val ~= '0') and (val ~= 'false'))
--  end
--  return false
--end

--------------------------------------------------------------------------------

local function ExtractWeaponDefs(udName, ud)

  local wds = ud.weapondefs
  if (not istable(wds)) then
    return
  end

  -- add this unitDef's weaponDefs
  for wdName, wd in pairs(wds) do
    if (isstring(wdName) and istable(wd)) then
      local fullName = udName .. '_' .. wdName
      WeaponDefs[fullName] = wd
        
      WeaponDef_Post(fullName, wd, udName)

      if SaveDefsToCustomParams then
        MarkDefOmittedInCustomParams("WeaponDefs", fullName, wd)
      end
    end
  end

  -- convert the weapon names
  local weapons = ud.weapons
  if (istable(weapons)) then
    for i = 1, 32 do
      local w = weapons[i]
      if (istable(w)) then
        if (isstring(w.def)) then
          local ldef = string.lower(w.def)
          local fullName = udName .. '_' .. ldef
          local wd = WeaponDefs[fullName]
          if (istable(wd)) then
            w.name = fullName
          end
        end
        w.def = nil
      end
    end
  end

  -- convert the death explosions
  if (isstring(ud.explodeas)) then
    local fullName = udName .. '_' .. ud.explodeas
    if (WeaponDefs[fullName]) then
      ud.explodeas = fullName
    end
  end
  if (isstring(ud.selfdestructas)) then
    local fullName = udName .. '_' .. ud.selfdestructas
    if (WeaponDefs[fullName]) then
      ud.selfdestructas = fullName
    end
  end  
end

local function PrintWeaponDamageTypes()
  Spring.Echo('-+-+-+-+-+-+-+-+-+-+-+')
  Spring.Echo(' Weapon Damage Types: ')
  Spring.Echo('-+-+-+-+-+-+-+-+-+-+-+')
  local text = '\n'
  for unitName, damageTypes in pairs(WeaponDamageTypes) do
    text = text .. unitName .. ' = { '
    for weaponName, damageType in pairs(damageTypes) do
      text = text .. '["'..weaponName .. '"] = "' .. damageType ..'", '
    end
    text = text .. '},\n'
  end
  
  Spring.Echo(text)
end

--------------------------------------------------------------------------------


-- handle standalone weapondefs
for name,wd in pairs(WeaponDefs) do
    WeaponDef_Post(name,wd)
    
    if SaveDefsToCustomParams then
        SaveDefToCustomParams("WeaponDefs", name, wd)
    end
end

-- extract weapondefs from the unitdefs
local UnitDefs = DEFS.unitDefs
for udName,ud in pairs(UnitDefs) do
  if (isstring(udName) and istable(ud)) then
    ExtractWeaponDefs(udName, ud)
  end
end

--PrintWeaponDamageTypes()

-- apply mod options that need _post 
ModOptions_Post(UnitDefs, WeaponDefs)

