return {
	corsktl = {
		acceleration = 0.12,
		brakerate = 0.564,
		buildcostenergy = 26371,
		buildcostmetal = 540,
		buildpic = "CORSKTL.DDS",
		buildtime = 16975,
		canmove = true,
		cantbetransported = true,
		category = "KBOT MOBILE WEAPON ALL KAMIKAZE NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE",
		cloakcost = 150,
		cloakcostmoving = 400,
		collisionvolumeoffsets = "0.5 4 0",
		collisionvolumescales = "19 17 19",
		collisionvolumetype = "box",
		description = "Advanced Amphibious Crawling Bomb",
		energymake = 0.2,
		energyuse = 0.2,
		explodeas = "CRAWL_BLAST",
		firestate = 2,
		footprintx = 2,
		footprintz = 2,
		idleautoheal = 5,
		idletime = 1800,
		mass = 300000000,
		maxdamage = 320,
		maxslope = 255,
		maxvelocity = 2.8,
		maxwaterdepth = 30,
		mincloakdistance = 60,
		movementclass = "AKBOTBOMB2",
		name = "Skuttle",
		nochasecategory = "VTOL",
		objectname = "CORSKTL",
		seismicsignature = 4,
		selfdestructas = "CORMINE6",
		selfdestructcountdown = 0,
		sightdistance = 260,
		turninplace = 0,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 1.155,
		turnrate = 1122,
		upright = true,
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
				[1] = "servsml6",
			},
			select = {
				[1] = "servsml6",
			},
		},
		weapondefs = {
			crawl_detonator = {
				areaofeffect = 5,
				avoidfeature = false,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0,
				explosiongenerator = "",
				firesubmersed = true,
				gravityaffected = "true",
				impulseboost = 0,
				impulsefactor = 0,
				name = "Mine Detonator",
				range = 1,
				reloadtime = 0.1,
				soundhitwet = "splshbig",
				soundhitwetvolume = 0.5,
				weapontype = "Cannon",
				weaponvelocity = 1000,
				damage = {
					crawlingbombs = 1000,
					default = 0,
				},
			},
			crawl_dummy = {
				areaofeffect = 0,
				avoidfeature = false,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0,
				explosiongenerator = "",
				firesubmersed = true,
				impulseboost = 0,
				impulsefactor = 0,
				name = "Crawlingbomb Dummy Weapon",
				range = 80,
				reloadtime = 0.1,
				soundhitwet = "sizzle",
				soundhitwetvolume = 0.5,
				tolerance = 100000,
				weapontype = "Melee",
				weaponvelocity = 100000,
				avoidground = false,
				waterweapon = true,
				damage = {
					default = 0,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "CRAWL_DUMMY",
				onlytargetcategory = "SURFACE",
			},
			[2] = {
				def = "CRAWL_DETONATOR",
				onlytargetcategory = "NOTSUB",
			},
		},
	},
}
