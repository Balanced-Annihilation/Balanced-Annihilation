return {
	commander_blast = {
		areaofeffect = 720,
		craterboost = 6,
		cratermult = 3,
		edgeeffectiveness = 0.25,
		explosiongenerator = "custom:BLANK", -- COMMANDER_EXPLOSION is called from gadget unit_commmander_blast
		impulseboost = 3,
		impulsefactor = 3,
		name = "Matter/AntimatterExplosion",
		range = 380,
		reloadtime = 3.5999999046326,
		soundhit = "newboom",
		soundstart = "largegun",
		turret = 1,
		weaponvelocity = 250,
		damage = {
			default = 50000,
		},
		 weaponType = "Cannon",

        customparams = {
            expl_light_color = "1 0.6 0.2",
			light_color = "1 0.6 0.2",
            expl_light_mult = 1.1,
            expl_light_radius_mult = 1.1,
            expl_light_life_mult = 1.14,
            expl_light_heat_radius_mult = 1.2,
        },
	},
}
