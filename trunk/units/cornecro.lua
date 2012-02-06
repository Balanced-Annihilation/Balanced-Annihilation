return {
	cornecro = {
		acceleration = 0.20000000298023,
		brakerate = 0.25,
		buildcostenergy = 1400,
		buildcostmetal = 102,
		builddistance = 128,
		builder = true,
		buildpic = "CORNECRO.DDS",
		buildtime = 2400,
		canassist = false,
		canmove = true,
		canresurrect = true,
		category = "KBOT MOBILE ALL NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER",
		corpse = "DEAD",
		description = "Stealthy Rez Kbot",
		energymake = 1.75,
		energyuse = 1.75,
		explodeas = "BIG_UNITEX",
		footprintx = 2,
		footprintz = 2,
		idleautoheal = 5 ,
		idletime = 60 ,
		maxdamage = 200,
		maxslope = 14,
		maxvelocity = 2.5999999046326,
		maxwaterdepth = 22,
		movementclass = "KBOT2",
		name = "Necro",
		objectname = "CORNECRO",
		radardistance = 50,
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 430,
		smoothanim = true,
		stealth = true,
		terraformspeed = 1000,
		turnrate = 1118,
		upright = true,
		workertime = 200,
		featuredefs = {
			dead = {
				blocking = true,
				collisionvolumetype = "Box",
				collisionvolumescales = "33.9485473633 23.5305023193 36.0355987549",
				collisionvolumeoffsets = "0.248977661133 -1.21184884033 0.586555480957",
				category = "corpses",
				damage = 794,
				description = "Necro Wreckage",
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 72,
				object = "CORNECRO_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 794,
				description = "Necro Heap",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 26,
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
				[1] = "necrok2",
			},
			select = {
				[1] = "necrsel2",
			},
		},
	},
}
