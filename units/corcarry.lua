return {
	corcarry = {
		acceleration = 0.025,
		activatewhenbuilt = true,
		brakerate = 0.069,
		buildangle = 16384,
		buildcostenergy = 22187,
		buildcostmetal = 1707,
		builder = true,
		buildpic = "CORCARRY.DDS",
		buildtime = 20800,
		canassist = false,
		canattack = false,
		canmove = true,
		canreclaim = false,
		canrepair = false,
		category = "ALL NOTLAND MOBILE NOTSUB SHIP NOWEAPON NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "-1 -7 0",
		collisionvolumescales = "61 61 153",
		collisionvolumetype = "box",
		corpse = "DEAD",
		description = "Aircraft Carrier with Anti-Nuke",
		energymake = 250,
		energystorage = 1500,
		energyuse = 25,
		explodeas = "CRAWL_BLAST",
		floater = true,
		footprintx = 6,
		footprintz = 6,
		icontype = "sea",
		idleautoheal = 15,
		idletime = 600,
		isairbase = true,
		losemitheight = 50,
		mass = 10000,
		maxdamage = 7950,
		maxvelocity = 2.64,
		metalstorage = 1500,
		minwaterdepth = 15,
		movementclass = "DBOAT6",
		name = "Hive",
		nochasecategory = "ALL",
		objectname = "CORCARRY",
		radardistance = 2700,
		radaremitheight = 50,
		seismicsignature = 0,
		selfdestructas = "CRAWL_BLAST",
		sightdistance = 1040,
		sonardistance = 740,
		terraformspeed = 5000,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 1.7424,
		turnrate = 210,
		waterline = 6,
		windgenerator = 0.001,
		workertime = 1000,
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "3.09324645996 4.5947265626e-05 -1.09795379639",
				collisionvolumescales = "76.2124633789 40.5466918945 153.329818726",
				collisionvolumetype = "Box",
				damage = 4770,
				description = "Hive Wreckage",
				energy = 0,
				featuredead = "HEAP",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 1026,
				object = "CORCARRY_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 2016,
				description = "Hive Heap",
				energy = 0,
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 266,
				object = "3X3A",
                collisionvolumescales = "55.0 4.0 55.0",
                collisionvolumetype = "box",
				reclaimable = true,
				resurrectable = 0,
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
				[1] = "shcormov",
			},
			select = {
				[1] = "shcorsel",
			},
		},
		weapondefs = {
			fmd_rocket = {
				areaofeffect = 420,
				avoidfeature = false,
				avoidfriendly = false,
				collidefriendly = false,
				coverage = 2000,
				craterareaofeffect = 420,
				craterboost = 0,
				cratermult = 0,
				energypershot = 7500,
				explosiongenerator = "custom:FLASH4",
				firestarter = 100,
				flighttime = 120,
				impulseboost = 0.123,
				impulsefactor = 0.123,
				interceptor = 1,
				metalpershot = 150,
				model = "fmdmisl",
				name = "Rocket",
				noselfdamage = true,
				range = 72000,
				reloadtime = 2,
				smoketrail = true,
				soundhit = "xplomed4",
				soundhitwet = "splslrg",
				soundhitwetvolume = 0.5,
				soundstart = "Rockhvy1",
				stockpile = true,
				stockpiletime = 90,
				tolerance = 4000,
				tracks = true,
				turnrate = 130000,
				weaponacceleration = 150,
				weapontimer = 5,
				weapontype = "StarburstLauncher",
				weaponvelocity = 6000,
				damage = {
					default = 1500,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "ALL",
				def = "FMD_ROCKET",
			},
		},
	},
}
