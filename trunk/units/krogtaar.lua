return {
	krogtaar = {
		acceleration = 0.14399999380112,
		brakerate = 0.23800000548363,
		buildcostenergy = 50499,
		buildcostmetal = 6784,
		buildpic = "krogtaar.DDS",
		buildtime = 101125,
		canmove = true,
		category = "KBOT WEAPON ALL NOTSUB NOTAIR NOTHOVER SURFACE",
		corpse = "dead",
		description = "Heavy Weapons Mech",
		energymake = 3,
		energyuse = 3,
		explodeas = "CRAWL_BLAST",
		footprintx = 4,
		footprintz = 4,
		idleautoheal = 35,
		idletime = 1200,
		mass = 999999995904,
		maxdamage = 70000,
		maxslope = 17,
		maxvelocity = 1.3300000429153,
		maxwaterdepth = 13,
		movementclass = "HKBOT4",
		name = "KrogTaar",
		nochasecategory = "VTOL",
		objectname = "krogtaar",
		radardistance = 0,
		selfdestructas = "CRAWL_BLAST",
		selfdestructcountdown = 10,
		sightdistance = 390,
		turnrate = 1058,
		upright = true,
		featuredefs = {
			dead = {
				blocking = true,
				category = "cor_corpses",
				collisionvolumeoffsets = "0.543556213379 0.108607275391 -1.27166748047",
				collisionvolumescales = "67.5281219482 32.0374145508 71.4806213379",
				collisionvolumetype = "Box",
				damage = 15700,
				description = "Wreckage",
				featuredead = "heap",
				featurereclamate = "smudge01",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 5990,
				object = "krogtaar_dead",
				reclaimable = true,
				seqnamereclamate = "tree1reclamate",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 6960,
				description = "Wreckage",
				featurereclamate = "smudge01",
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 4472,
				object = "3x3a",
				reclaimable = true,
				seqnamereclamate = "tree1reclamate",
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
			cor_taar_rc = {
				accuracy = 200,
				areaofeffect = 64,
				burnblow = true,
				cegtag = "krogtaarblaster",
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASHKROGTAAR",
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				intensity = 4,
				model = "bomb2",
				name = "KrogTaarBlaster",
				noselfdamage = true,
				range = 465,
				reloadtime = 0.40000000596046,
				rgbcolor = "0 0 0",
				size = 1,
				soundhit = "xplomed3",
				soundstart = "Mavgun2",
				sprayangle = 200,
				tolerance = 10000,
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 400,
				damage = {
					default = 344,
					subs = 5,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "NOWEAPON",
				def = "COR_TAAR_RC",
				onlytargetcategory = "NOTSUB",
			},
		},
	},
}
