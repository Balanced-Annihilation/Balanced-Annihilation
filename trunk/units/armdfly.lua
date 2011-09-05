return {
	armdfly = {
		acceleration = 0.20000000298023,
		brakerate = 6.25,
		buildcostenergy = 6250,
		buildcostmetal = 298,
		buildpic = "ARMDFLY.DDS",
		buildtime = 16022,
		canfly = true,
		canmove = true,
		category = "ALL NOTLAND MOBILE NOTSUB VTOL NOWEAPON NOTSHIP",
		collide = false,
		cruisealt = 150,
		description = "Stealthy Armed Transport",
		energymake = 0.60000002384186,
		energyuse = 0.60000002384186,
		explodeas = "SMALL_UNITEX",
		footprintx = 4,
		footprintz = 4,
		hoverattack = true,
		icontype = "air",
		idleautoheal = 5 ,
		idletime = 1800 ,
		maxdamage = 1050,
		maxslope = 15,
		maxvelocity = 8.0500001907349,
		maxwaterdepth = 0,
		name = "Dragonfly",
		nochasecategory = "VTOL",
		objectname = "ARMDFLY",
		seismicsignature = 0,
		selfdestructas = "SMALL_UNIT",
		sightdistance = 318,
		stealth = true,
		transportcapacity = 30,
		transportsize = 15,
		turnrate = 420,
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			cant = {
				[1] = "cantdo4",
			},
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			ok = {
				[1] = "vtolarmv",
			},
			select = {
				[1] = "vtolarac",
			},
		},
		weapondefs = {
			armdfly_paralyzer = {
				areaofeffect = 32,
				beamtime = 0.5,
				collidefriendly = false,
				craterboost = 0,
				cratermult = 0,
				duration = 0.0099999997764826,
				explosiongenerator = "custom:EMPFLASH20",
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				name = "Paralyzer",
				noselfdamage = true,
				paralyzer = true,
				paralyzetime = 15,
				range = 520,
				reloadtime = 8,
				rgbcolor = "0.9 0.9 0",
				soundhit = "lashit",
				soundstart = "hackshot",
				soundtrigger = true,
				targetmoveerror = 0.30000001192093,
				thickness = 1.25,
				tolerance = 6000,
				turret = false,
				weapontype = "BeamLaser",
				weaponvelocity = 1000,
				damage = {
					default = 22500,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "ARMDFLY_PARALYZER",
			},
		},
	},
}
