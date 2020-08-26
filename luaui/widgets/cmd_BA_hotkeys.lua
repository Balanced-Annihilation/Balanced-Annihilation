function widget:GetInfo()
	return {
		name = "BA Hotkeys",
		desc =  "z mex mm, x enrgy, c turret, v nano rad jam, b aa, n anti sheild" ,
		author = "Beherith",
		date = "23 march 2012",
		license = "GNU LGPL, v2.1 or later",
		layer = 1,
		enabled = true,
        handler = true,
	}
end
local minWind               = Game.windMin
local maxWind               = Game.windMax
local avgWind = math.floor((maxWind + minWind) / 2)

-- table of stuff that we unbind on load
local unbinds={
    "bind any+c controlunit",
    "bind c controlunit",
    "bind any+x  buildspacing dec",
    "bind x  buildspacing dec",
    "bindaction buildspacing dec",
    "bind any+z buildspacing inc",
    "bind z buildspacing inc",
    "bindaction buildspacing inc",

    "bind , prevmenu",
    "bind . nextmenu",
	
	

}

-- table of stuff that we bind on load
local binds = {}
function MakeBindsTable (swapYZ)
    -- handle swapping YZ, its very awkward to have them the 'wrong' way around on AZERTY keyboards
    if swapYZ==nil then swapYZ=false end
    local Y = swapYZ and "z" or "y"
    local Z = swapYZ and "y" or "z"
    
    local _binds = {
        -- building hotkeys
		
		--Z X C V B
			--Z = mex and mm
			--X = e
			--C = turrets
			--V = nano radar jammar 
			--B = aa
			--N = anti/sheild 
			
		--Z = mex and mm
		
		--t2 mex
		"bind "..Z.."  buildunit_armmoho",
        "bind shift+"..Z.."  buildunit_armmoho",
        "bind "..Z.."  buildunit_cormoho",
        "bind shift+"..Z.."  buildunit_cormoho",
		--t2 uw
		"bind "..Z.."  buildunit_coruwmme",
        "bind shift+"..Z.."  buildunit_coruwmme",
        "bind "..Z.."  buildunit_armuwmme",
        "bind shift+"..Z.."  buildunit_armuwmme",
		--t2 mm
		"bind "..Z.." buildunit_cormmkr",
        "bind shift+"..Z.." buildunit_cormmkr",
        "bind "..Z.." buildunit_armmmkr",
		"bind shift+"..Z.." buildunit_armmmkr",
		--t2 mm w
		"bind "..Z.." buildunit_armuwmmm",
        "bind shift+"..Z.." buildunit_armuwmmm",
        "bind "..Z.." buildunit_coruwmmm",
        "bind shift+"..Z.." buildunit_coruwmmm",
		--t1 mex
		"bind "..Z.."  buildunit_armmex",
        "bind shift+"..Z.."  buildunit_armmex",
        "bind "..Z.."  buildunit_cormex",
        "bind shift+"..Z.."  buildunit_cormex",
        --t1 uw
        "bind "..Z.."  buildunit_coruwmex",
        "bind shift+"..Z.."  buildunit_coruwmex",
        "bind "..Z.."  buildunit_armuwmex",
        "bind shift+"..Z.."  buildunit_armuwmex",
		--t1 mm
        "bind "..Z.."  buildunit_armmakr",
        "bind shift+"..Z.."  buildunit_armmakr",
        "bind "..Z.."  buildunit_cormakr",
        "bind shift+"..Z.."  buildunit_cormakr",
		--t1 wmm
        "bind "..Z.."  buildunit_armfmkr",
        "bind shift+"..Z.."  buildunit_armfmkr",
        "bind "..Z.."  buildunit_corfmkr",
        "bind shift+"..Z.."  buildunit_corfmkr",
		
		--mex exploiters
		"bind "..Z.." buildunit_armamex",
        "bind shift+"..Z.." buildunit_armamex",
        "bind "..Z.." buildunit_corexp",
        "bind shift+"..Z.." buildunit_corexp",
		 "bind "..Z.." buildunit_cormexp",
        "bind shift+"..Z.." buildunit_cormexp",
		
		--X = e
		
		--afus
		"bind x buildunit_aafus",
        "bind shift+x buildunit_aafus",
		"bind x buildunit_cafus",
        "bind shift+x buildunit_cafus",
		--fus
		"bind x buildunit_armfus",
        "bind shift+x buildunit_armfus",
        "bind x buildunit_corfus",
        "bind shift+x buildunit_corfus",
		--fus w
		"bind x buildunit_armuwfus",
        "bind shift+x buildunit_armuwfus",
        "bind x buildunit_coruwfus",
        "bind shift+x buildunit_coruwfus",
	}	
		
		
		
		local _binds2
		if (avgWind > 7) then
		--wind
		_binds2 = {
		"bind x buildunit_armwin",
        "bind shift+x buildunit_armwin",
		"bind x buildunit_corwin",
        "bind shift+x buildunit_corwin",
		--adv solar
        "bind x buildunit_armadvsol",
        "bind shift+x buildunit_armadvsol",
        "bind x buildunit_coradvsol",
        "bind shift+x buildunit_coradvsol",
		--solar
		"bind x buildunit_armsolar",
        "bind shift+x buildunit_armsolar",
        "bind x buildunit_corsolar",
        "bind shift+x buildunit_corsolar",
		}
		else
		_binds2 = {
		--solar
		"bind x buildunit_armsolar",
        "bind shift+x buildunit_armsolar",
        "bind x buildunit_corsolar",
        "bind shift+x buildunit_corsolar",
		--adv solar
        "bind x buildunit_armadvsol",
        "bind shift+x buildunit_armadvsol",
        "bind x buildunit_coradvsol",
        "bind shift+x buildunit_coradvsol",
		--wind
		"bind x buildunit_armwin",
        "bind shift+x buildunit_armwin",
		"bind x buildunit_corwin",
        "bind shift+x buildunit_corwin",
		}
		end
		
		
		local _binds3 =  {
		--tidal
        "bind x buildunit_armtide",
        "bind shift+x buildunit_armtide",
        "bind x buildunit_cortide",
        "bind shift+x buildunit_cortide",
		
		--C = turrets  
		
		
		
		--float mine
		"bind c buildunit_corfmine3",
        "bind shift+c buildunit_corfmine3",
		"bind c buildunit_armfmine3",
        "bind shift+c buildunit_armfmine3",
		--h mine
		"bind c buildunit_cormine3",
        "bind shift+c buildunit_cormine3",
		"bind c buildunit_armmine3",
        "bind shift+c buildunit_armmine3",
		--m mine
		"bind c buildunit_cormine2",
        "bind shift+c buildunit_cormine2",
		"bind c buildunit_armmine2",
        "bind shift+c buildunit_armmine2",

		
		--t2 turret
		"bind c buildunit_armpb",
        "bind shift+c buildunit_armpb",
		"bind c buildunit_corvipe",
        "bind shift+c buildunit_corvipe",
		--doom anni
		"bind c buildunit_cordoom",
        "bind shift+c buildunit_cordoom",
		"bind c buildunit_armanni",
        "bind shift+c buildunit_armanni",
		--llt
		"bind c buildunit_armllt",
		"bind shift+c buildunit_armllt",
		"bind c buildunit_corllt",
        "bind shift+c buildunit_corllt",
		--hllt
		"bind c buildunit_hllt",
		"bind shift+c buildunit_hllt",
		"bind c buildunit_tawf001",
        "bind shift+c buildunit_tawf001",
		--claw maw
		"bind c buildunit_armclaw",
		"bind shift+c buildunit_armclaw",
		"bind c buildunit_cormaw",
        "bind shift+c buildunit_cormaw",	
		
		
				
		
		--V = nano radar jammar 
		
		--nano
		"bind v buildunit_armnanotc",
        "bind shift+v buildunit_armnanotc",
		"bind v buildunit_cornanotc",
        "bind shift+v buildunit_cornanotc",	
		--t2 jam
		"bind v buildunit_corshroud",
        "bind shift+v buildunit_corshroud",
        "bind v buildunit_armveil",
        "bind shift+v buildunit_armveil",
		--t2 rad
		"bind v buildunit_armarad",
        "bind shift+v buildunit_armarad",
        "bind v buildunit_corarad",
        "bind shift+v buildunit_corarad",
		--rad
		"bind v buildunit_armrad",
        "bind shift+v buildunit_armrad",
        "bind v buildunit_corrad",
        "bind shift+v buildunit_corrad",
		--rad w
        "bind v buildunit_armfrad",
        "bind shift+v buildunit_armfrad",
        "bind v buildunit_corfrad",
        "bind shift+v buildunit_corfrad",
		
		--B = aa
		
		--flak
		"bind b buildunit_armflak",
        "bind shift+b buildunit_armflak",
		"bind b buildunit_corflak",
        "bind shift+b buildunit_corflak",
		--flak w
		"bind b buildunit_corenaa",
        "bind shift+b buildunit_corenaa",
		"bind b buildunit_armfflak",
        "bind shift+b buildunit_armfflak",
		--pako sucks only sam
		"bind b buildunit_madsam",
        "bind shift+b buildunit_madsam",
		--merc scream
		"bind b buildunit_mercury",
        "bind shift+b buildunit_mercury",
		"bind b buildunit_screamer",
        "bind shift+b buildunit_screamer",
		--t1 aa
        "bind b buildunit_corrl",
        "bind shift+b buildunit_corrl",
        "bind b buildunit_armrl",
        "bind shift+b buildunit_armrl",
		--aa w
		"bind b buildunit_armfrt",
        "bind shift+b buildunit_armfrt",
        "bind b buildunit_corfrt",
        "bind shift+b buildunit_corfrt",
		
		--N = anti/sheild 
		--anti
		"bind n buildunit_corfmd",
        "bind shift+n buildunit_corfmd",
        "bind n buildunit_armamd",
        "bind shift+n buildunit_armamd",
		--sheild
		"bind n buildunit_corgate",
        "bind shift+n buildunit_corgate",
        "bind n buildunit_armgate",
        "bind shift+n buildunit_armgate",
 
        -- build spacing
        "bind any+b buildspacing inc",
        "bind any+n buildspacing dec",    
        
        -- numpad movement
        "bind numpad2 moveback",
        "bind numpad6 moveright",
        "bind numpad4 moveleft",
        "bind numpad8 moveforward",
        "bind numpad9 moveup",
        "bind numpad3 movedown",
        "bind numpad1 movefast",
        
        -- set target
        "bind q settarget",
        "bind j canceltarget",
        
        "bind * drawinmap", --some keyboards don't have ` or \
        "bind ,	buildfacing inc", --because some keyboards don't have [ and ] ke"..Y.."s
        "bind .	buildfacing dec",
        "bind o buildfacing inc", --apparently some keyboards don't have , and . either...
        
        "bind ,	buildfacing inc", --because some keyboards don't have [ and ] ke"..Y.."s
        "bind .	buildfacing dec",
        "bind o buildfacing inc", --apparently some keyboards don't have , and . either...
		}
   
    
	binds = table.merge(_binds,_binds2)
	binds = table.merge(binds,_binds3)
end

function LoadBindings()
	for k,v in ipairs(unbinds) do
		Spring.SendCommands("un"..v)
	end
    

		MakeBindsTable(WG.swapYZbinds)   

    
	for k,v in ipairs(binds) do
		Spring.SendCommands(v)
	end
end

function UnloadBindings()
	for k,v in ipairs(binds) do
		Spring.SendCommands("un"..v)
	end

	for k,v in ipairs(unbinds) do
		Spring.SendCommands(v)
	end
end

function table.merge(t1, t2)
   for k,v in ipairs(t2) do
      table.insert(t1, v)
   end 
 
   return t1
end

function ReloadBindings()
    UnloadBindings()
    LoadBindings()
end

function widget:Initialize()
    MakeBindsTable(WG.swapYZbinds)    
    LoadBindings()
    
    WG.Reload_BA_Hotkeys = ReloadBindings
end

function widget:Shutdown()
    UnloadBindings()
    WG.Reload_BA_Hotkeys = nil

    if widgetHandler.orderList and (widgetHandler.orderList["BA Hotkeys -- swap YZ"] or 0) > 0 then
        widgetHandler:DisableWidget("BA Hotkeys -- swap YZ")
    end
end