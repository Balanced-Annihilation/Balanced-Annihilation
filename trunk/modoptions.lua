--see engineoptions.lua for explanantion
local options={
	{
	   key    = "StartingResources",
	   name   = "Starting Resources",
	   desc   = "Sets storage and amount of resources that players will start with",
	   type   = "section",
	},
    {
       key="ba_modes",
       name="Balanced Annihilation - Game Modes",
       desc="Balanced Annihilation - Game Modes",
       type="section",
    },
    {
       key="ba_options",
       name="Balanced Annihilation - Options",
       desc="Balanced Annihilation - Options",
       type="section",
    },
	{
		key="deathmode",
		name="Game End Mode",
		desc="What it takes to eliminate a team",
		type="list",
		def="com",
		section="ba_modes",
		items={
			{key="neverend", name="None", desc="Teams are never eliminated"},
			{key="com", name="Kill all enemy Commanders", desc="When a team has no Commanders left, it loses"},
			{key="killall", name="Kill everything", desc="Every last unit must be eliminated, no exceptions!"},
		}
	},
    {
        key    = 'mo_armageddontime',
        name   = 'Armageddon time (minutes)',
        desc   = 'At armageddon every immobile unit is destroyed and you fight to the death with what\'s left! (0=off)',
        type   = 'number',
        def    = true,
        section= 'ba_modes',
        def    = 0,
        min    = 0,
        max    = 120,
        step   = 1,
    },
    {
		key    = "mo_noowner",
		name   = "FFA Mode",
		desc   = "Units with no player control are removed/destroyed \nUse FFA spawning mode",
		type   = "bool",
		def    = false,
		section= "ba_modes",
    },
    {
        key    = 'mo_coop',
        name   = 'Cooperative mode',
        desc   = 'Adds extra commanders to id-sharing teams, 1 com per player',
        type   = 'bool',
        def    = false,
        section= 'ba_modes',
    },
    {
      key    = "shareddynamicalliancevictory",
      name   = "Dynamic Ally Victory",
      desc   = "Ingame alliance should count for game over condition.",
      type   = "bool",
	  section= 'ba_modes',
      def    = false,
    },
    {
		key    = "mo_preventcombomb",
		name   = "Prevent Combombs",
		desc   = "Commanders survive DGuns and other commanders explosions",
		type   = "bool",
		def    = false,
		section= "ba_modes",
    },
	{
		key    = "mo_comgate",
		name   = "Commander Gate Effect",
		desc   = "Commanders warp in at gamestart with a shiny teleport effect",
		type   = "bool",
		def    = false,
		section= "ba_options",
    },
	{
		key    = "mo_progmines",
		name   = "Progressive Mining",
		desc   = "New mines take some time to become fully established, death resets progress",
		type   = "bool",
		def    = false,
		section= "ba_ooptions",
    },
	{
		key    = "mo_nowrecks",
		name   = "No Unit Wrecks",
		desc   = "Removes all unit wrecks from the game",
		type   = "bool",
		def    = false,
		section= "ba_options",
    },
    {
		key="mo_transportenemy",
		name="Enemy Transporting",
		desc="Toggle which enemy units you can kidnap with an air transport",
		type="list",
		def="none",
		section="ba_options",
		items={
			{key="notcoms", name="All But Commanders", desc="Only commanders are immune to napping"},
			{key="none", name="Disallow All", desc="No enemy units can be napped"},
		}
	},
	{
       key    = "startmetal",
       name   = "Starting metal",
       desc   = "Determines amount of metal and metal storage that each player will start with",
       type   = "number",
       section= "StartingResources",
       def    = 1000,
       min    = 0,
       max    = 10000,
       step   = 1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
	},
	{
       key    = "startenergy",
       name   = "Starting energy",
       desc   = "Determines amount of energy and energy storage that each player will start with",
       type   = "number",
       section= "StartingResources",
       def    = 1000,
       min    = 0,
       max    = 10000,
       step   = 1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
	},  
    {
		key    = "mo_no_close_spawns",
		name   = "No close spawns",
		desc   = "Prevents players startpoints being placed close together (on large enough maps)",
		type   = "bool",
		def    = true,
		section= "ba_options",
    },
    {
		key    = "mo_newbie_placer",
		name   = "Newbie Placer",
		desc   = "Chooses a startpoint and a random faction for all rank 1 accounts (online only)",
		type   = "bool",
		def    = false,
		section= "ba_options",
    },
    {
		key    = 'LimitDgun',
		name   = 'Limit D-Gun range',
		desc   = "The commander's D-Gun weapon cannot be used near enemy start points",
		type   = 'list',
		def    = false,
		section= "ba_options",
		items={
			{key="off", name="Off", desc="D-Gun works everywhere"},
			{key="startpoints", name="Start Points", desc="D-Gun cannot be used near enemy startpoints"},
			{key="startboxes", name="Start Boxes", desc="D-Gun cannot be used inside enemy startboxes"},
            {key="charge", name="Charge", desc="D-Gun needs to have enough charge before it can fire"},
		}
    },
}
return options