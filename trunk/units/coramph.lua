return {
	coramph = {
		acceleration = 0.090000003576279,
		activatewhenbuilt = true,
		brakerate = 0.1879999935627,
		buildcostenergy = 8935,
		buildcostmetal = 305,
		buildpic = "CORAMPH.DDS",
		buildtime = 9650,
		candgun = true,
		canmove = true,
		category = "KBOT MOBILE WEAPON ALL NOTSHIP NOTAIR NOTHOVER",
		corpse = "HEAP",
		description = "Amphibious Kbot",
		energymake = 0.40000000596046,
		energyuse = 0.40000000596046,
		explodeas = "BIG_UNITEX",
		footprintx = 2,
		footprintz = 2,
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 2100,
		maxslope = 14,
		maxvelocity = 1.8500000238419,
		movementclass = "AKBOT2",
		name = "Gimp",
		nochasecategory = "VTOL",
		objectname = "CORAMPH",
		radardistance = 300,
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 400,
		smoothanim = true,
		sonardistance = 300,
		turnrate = 998,
		upright = true,
		featuredefs = {
			heap = {
				blocking = false,
				category = "heaps",
				damage = 920,
				description = "Gimp Heap",
				energy = 0,
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 114,
				object = "2X2D",
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
			coramph_weapon1 = {
				areaofeffect = 16,
				avoidfriendly = false,
				burnblow = true,
				collidefriendly = false,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASH2",
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				model = "torpedo",
				name = "Torpedo",
				noselfdamage = true,
				predictboost = 0,
				range = 400,
				reloadtime = 8,
				soundhit = "xplodep2",
				soundstart = "torpedo1",
				startvelocity = 75,
				turret = true,
				waterweapon = true,
				weaponacceleration = 5,
				weapontimer = 3,
				weapontype = "TorpedoLauncher",
				weaponvelocity = 100,
				damage = {
					default = 200,
				},
			},
			coramph_weapon2 = {
				areaofeffect = 12,
				beamtime = 0.15000000596046,
				corethickness = 0.20000000298023,
				craterboost = 0,
				cratermult = 0,
				energypershot = 35,
				explosiongenerator = "custom:SMALL_GREEN_LASER_BURN",
				firestarter = 90,
				impactonly = 1,
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				laserflaresize = 10,
				name = "HighEnergyLaser",
				noselfdamage = true,
				range = 300,
				reloadtime = 1.1499999761581,
				rgbcolor = "0 1 0",
				soundhit = "lasrhit1",
				soundstart = "lasrhvy3",
				targetmoveerror = 0.25,
				thickness = 3,
				tolerance = 10000,
				turret = true,
				weapontype = "BeamLaser",
				weaponvelocity = 700,
				damage = {
					bombers = 38,
					default = 150,
					fighters = 38,
					subs = 5,
					vtol = 38,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "CORAMPH_WEAPON2",
				onlytargetcategory = "NOTSUB",
			},
			[3] = {
				def = "CORAMPH_WEAPON1",
				onlytargetcategory = "NOTHOVER",
			},
		},
	},
}
