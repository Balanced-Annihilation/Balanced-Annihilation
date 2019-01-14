--[[   Morph Definition File

Morph parameters description
local morphDefs = {		--begining of morphDefs
	unitname = {		--unit being morphed
		into = 'newunitname',		--unit in that will morphing unit morph into
		time = 12,			--time required to complete morph process (in seconds)
		require = 'requnitname',	--unit requnitname must be present in team for morphing to be enabled
		metal = 10,			--required metal for morphing process     note: if you ommit M and/or E costs, morph costs the
		energy = 10,			--required energy for morphing process		difference in costs between unitname and newunitname
		xp = 0.07,			--required experience for morphing process (will be deduced from unit xp after morph, default=0)
		rank = 1,			--required unit rank for morphing to be enabled, if ommited, morph doesn't require rank
		tech = 2,			--required tech level of a team for morphing to be enabled (1,2,3), if ommited, morph doesn't require tech
		cmdname = 'Ascend',		--if ommited will default to "Upgrade"
		texture = 'MyIcon.dds',		--if ommited will default to [newunitname] buildpic, textures should be in "LuaRules/Images/Morph"
		text = 'Description',		--if ommited will default to "Upgrade into a [newunitname]", else it's "Description"
						--you may use "$$unitname" and "$$into" in 'text', both will be replaced with human readable unit names 
	},
}				--end of morphDefs
--]]
--------------------------------------------------------------------------------

-- TODO: Cleanup

local devolution = (-1 > 0)

local metalCost_ecommander = 100
local timeToBuild_ecommander = metalCost_ecommander * 0.25

local metalCost_ecommandercloak = 100
local timeToBuild_ecommandercloak = metalCost_ecommandercloak * 0.25

local metalCost_ecommandershield = 100
local timeToBuild_ecommandershield = metalCost_ecommandershield * 0.25

local metalCost_ecommanderbuild = 100
local timeToBuild_ecommanderbuild = metalCost_ecommanderbuild * 0.25

local metalCost_ecommanderfactory = 100
local timeToBuild_ecommanderfactory = metalCost_ecommanderfactory * 0.25

local metalCost_ecommanderbattle = 100
local timeToBuild_ecommanderbattle = metalCost_ecommanderbattle * 0.25

local metalCost_factory_up1 = 240
local timeToBuild_factory_up1 = metalCost_factory_up1 * 0.25

local metalCost_etech2 = 200
local timeToBuild_etech2 = metalCost_etech2 * 0.25

local metalCost_etech3 = 300
local timeToBuild_etech3 = metalCost_etech3 * 0.25


local morphDefs = {
----------------------------------------------------------
---- Commanders
----------------------------------------------------------

--	ecommander = 	{
--		{
--			into = 'ecommandercloak',
--			time = timeToBuild_ecommandercloak,
--			cmdname = [[Cloaking Overseer]],
--			metal = metalCost_ecommandercloak,
--			text = 'Morph to Cloaking Overseer: Gains a large cloaking field which also cloaks the Overseer.',
--		},
--	},

----------------------------------------------------------
---- Resources
----------------------------------------------------------

--	armmex = 	{
--		{
--			into = 'armmoho',
--			--time = timeToBuild_ecommandercloak,
--			cmdname = [[Moho Mine]],
--			--metal = metalCost_ecommandercloak,
--			text = 'Morph to Moho Mine: Superior metal extraction speed.',
--		},
--	},

--------------------------------------------------------------
---- Kbots
--------------------------------------------------------------

--    armpw = 	{
--        {
--            into = 'armwar',
--            --time = 600,
--            cmdname = [[Warrior]],
--            require = 'armtech',
--            --metal = 250, --temp
--            --energy = 2000,
--            text = 'Morph to Warrior: Stalwart armor class.',
--        },
--    },

--------------------------------------------------------------
---- Tech Structures
--------------------------------------------------------------

--    armtech = {
--        {
--            into = 'armtech2',
--            time = 20,
--            cmdname = [[Level 2]],
--            metal = 100, --temp
--            energy = 100, --temp
--            text = 'Upgrade to Tech Center Level 2',
--        },
--    },
--
--    armtech2 = {
--        {
--            into = 'armtech3',
--            time = 20,
--            cmdname = [[Level 3]],
--            metal = 100, --temp
--            energy = 100, --temp
--            text = 'Upgrade to Tech Center Level 3',
--        },
--    },
--
--    armtech3 = {
--        {
--            into = 'armtech4',
--            time = 20,
--            cmdname = [[Level 4]],
--            metal = 100, --temp
--            energy = 100, --temp
--            text = 'Upgrade to Tech Center Level 4',
--        },
--    },
    
--    armoutpost = {
--        {
--            into = 'armoutpost2',
--            time = 10,
--            cmdname = [[Level 2]],
--            metal = 100, --temp
--            energy = 100, --temp
--            text = 'Upgrade to Outpost Level 2',
--        },
--    },
--
--    armoutpost2 = {
--        {
--            into = 'armoutpost3',
--            time = 10,
--            cmdname = [[Level 3]],
--            metal = 100, --temp
--            energy = 100, --temp
--            text = 'Upgrade to Outpost Level 3',
--        },
--    },
--
--    armoutpost3 = {
--        {
--            into = 'armoutpost4',
--            time = 10,
--            cmdname = [[Level 4]],
--            metal = 100, --temp
--            energy = 100, --temp
--            text = 'Upgrade to Outpost Level 4',
--        },
--    },
    
    ----------------------------------------------------------
---- Factories
----------------------------------------------------------
--	ebasefactory = 	{
--		{
--			into = 'ebasefactory_up1',
--			time = timeToBuild_factory_up1,
--			cmdname = [[Upgrade]],
--			metal = metalCost_factory_up1,
--			text = [[+20% damage/hp buff, +15% faster reload, -5% speed]],
--		},
--	},
--	ebasefactory_up1 = 	{
--		{
--			into = 'ebasefactory_up2',
--			time = timeToBuild_factory_up1,
--			cmdname = [[Upgrade]],
--			metal = metalCost_factory_up1,
--			text = [[+15% damage/hp buff, +15% faster reload, -5% speed]],
--		},
--	},

----------------------------------------------------------
---- Kbots
----------------------------------------------------------
	
--	ehbotpeewee = 	{
--		{
--			into = 'ehbotpeewee_turret',
--			time = 12.5,
--			cmdname = [[Deploy]],
--			metal = 50,
--			text = 'Morph into a stationary turret that gains 4x health.',
--		},
--	},
--
--	ehbotpeewee_up1 = 	{
--		{
--			into = 'ehbotpeewee_turret_up1',
--			time = 12.5,
--			cmdname = [[Deploy]],
--			metal = 50,
--			text = 'Morph into a stationary turret that gains 4x health.',
--		},
--	},
	
----------------------------------------------------------
---- Tech Facility
----------------------------------------------------------
	
--	etech1 = 	{
--		{
--			into = 'etech2',
--			time = timeToBuild_etech2,
--			cmdname = [[Tech 2
--Upgrade]],
--			metal = metalCost_etech2,
--			text = 'Morph into a Tech Level 2 Facility.',
--		},
--	},

----------------------------------------------------------
---- End of Data
----------------------------------------------------------
}

--
-- Here's an example of why active configuration
-- scripts are better then static TDF files...
--

--
-- devolution, babe  (useful for testing)
--
if (devolution) then
  local devoDefs = {}
  for src,data in pairs(morphDefs) do
    devoDefs[data.into] = { into = src, time = 10, metal = 1, energy = 1 }
  end
  for src,data in pairs(devoDefs) do
    morphDefs[src] = data
  end
end


return morphDefs

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
