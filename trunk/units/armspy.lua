return {
	armspy = {
		acceleration = 0.24,
		activatewhenbuilt = true,
		brakerate = 0.6,
		buildcostenergy = 8219,
		buildcostmetal = 128,
		builder = true,
		buildpic = "ARMSPY.DDS",
		buildtime = 17631,
		canassist = false,
		canguard = false,
		canmove = true,
		canrepair = false,
		canrestore = false,
		category = "KBOT MOBILE ALL NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER SURFACE",
		cloakcost = 50,
		cloakcostmoving = 100,
		collisionvolumeoffsets = "0 0 0",
		collisionvolumescales = "19 24 26",
		collisionvolumetype = "box",
		corpse = "DEAD",
		description = "Radar-Invisible Spy Kbot",
		energymake = 5,
		energyuse = 5,
		footprintx = 2,
		footprintz = 2,
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 270,
		maxslope = 32,
		maxvelocity = 2.18,
		maxwaterdepth = 112,
		mincloakdistance = 75,
		movementclass = "KBOT2",
		name = "Infiltrator",
		objectname = "ARMSPY",
		onoffable = true,
		seismicsignature = 2,
		selfdestructas = "SPYBOMBX",
		selfdestructcountdown = 1,
		sightdistance = 550,
		sonarstealth = true,
		stealth = true,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 1.4388,
		turnrate = 1375,
		upright = true,
		workertime = 50,
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "-0.497138977051 -0.20779847168 -1.07509613037",
				collisionvolumescales = "31.7495880127 18.5738830566 32.936630249",
				collisionvolumetype = "Box",
				damage = 162,
				description = "Infiltrator Wreckage",
				energy = 0,
				featuredead = "HEAP",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 83,
				object = "ARMSPY_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 81,
				description = "Infiltrator Heap",
				energy = 0,
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 33,
				object = "2X2D",
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
				[1] = "kbarmmov",
			},
			select = {
				[1] = "kbarmsel",
			},
		},
	},
}
