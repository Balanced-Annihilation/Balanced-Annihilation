return {
	corfrt = {
		acceleration = 0,
		airsightdistance = 750,
		brakerate = 0,
		buildangle = 16384,
		buildcostenergy = 1054,
		buildcostmetal = 72,
		buildpic = "CORFRT.DDS",
		buildtime = 2357,
		category = "ALL NOTLAND WEAPON NOTSUB NOTSHIP NOTAIR",
		corpse = "DEAD",
		description = "Floating Anti-air Tower",
		energyuse = 0.10000000149012,
		explodeas = "BIG_UNITEX",
		footprintx = 4,
		footprintz = 4,
		icontype = "building",
		idleautoheal = 2.9000000953674,
		idletime = 900,
		maxdamage = 290,
		minwaterdepth = 2,
		name = "Stinger",
		nochasecategory = "ALL",
		objectname = "CORFRT",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 468,
		waterline = 4,
		yardmap = "wwwwwwwwwwwwwwww",
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				damage = 174,
				description = "Stinger Wreckage",
				energy = 0,
				footprintx = 4,
				footprintz = 4,
				height = 20,
				hitdensity = 100,
				metal = 47,
				object = "CORFRT_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
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
				[1] = "kbcormov",
			},
			select = {
				[1] = "kbcorsel",
			},
		},
		weapondefs = {
			armrl_missile = {
				areaofeffect = 48,
				canattackground = false,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASH2",
				firestarter = 70,
				flighttime = 3,
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				metalpershot = 0,
				model = "missile",
				name = "Missiles",
				noselfdamage = true,
				range = 765,
				reloadtime = 1.7000000476837,
				smoketrail = true,
				soundhit = "xplomed2",
				soundstart = "rockhvy2",
				startvelocity = 400,
				texture2 = "armsmoketrail",
				toairweapon = true,
				tolerance = 10000,
				tracks = true,
				turnrate = 63000,
				turret = true,
				weaponacceleration = 150,
				weapontimer = 5,
				weapontype = "MissileLauncher",
				weaponvelocity = 750,
				damage = {
					default = 113,
					hgunships = 84,
					l1subs = 5,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "NOWEAPON",
				def = "ARMRL_MISSILE",
			},
		},
	},
}
