-- BA does not use unitdefs_post, see alldefs_post.lua 
-- basically, DONT TOUCH this! 


-- see alldefs.lua for documentation
-- load the games _Post functions for defs, and find out if saving to custom params is wanted
VFS.Include("gamedata/alldefs_post.lua")
-- load functionality for saving to custom params
VFS.Include("gamedata/post_save_to_customparams.lua")

-- handle unitdefs and the weapons they contain
for name,ud in pairs(UnitDefs) do
  UnitDef_Post(name,ud)
  if ud.weapondefs then
	for wname,wd in pairs(ud.weapondefs) do
	  WeaponDef_Post(wname,wd)
	end
  end 
  
  --ud.acceleration = 0.75
  --ud.turnrate = 800
  
  if SaveDefsToCustomParams then
      SaveDefToCustomParams("UnitDefs", name, ud)    
  end
end

local function disableunits(unitlist)
  for name, ud in pairs(UnitDefs) do
    if (ud.buildoptions) then
      for _, toremovename in ipairs(unitlist) do
        for index, unitname in pairs(ud.buildoptions) do
          if (unitname == toremovename) then
	    Spring.Echo("Unit removed :-  " .. toremovename)
            table.remove(ud.buildoptions, index)
          end
        end
      end
    end
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
----Disable superunits
--------------------------------------------------------------------------------
if (tonumber(Spring.GetModOptions().allow_buzz) == 0) then
  disableunits({
	"corbuzz", "armvulc"
  })
end
