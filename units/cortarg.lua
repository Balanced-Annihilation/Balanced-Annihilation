return {
	cortarg = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 4096,
		buildcostenergy = 7529,
		buildcostmetal = 799,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 6,
		buildinggrounddecalsizey = 6,
		buildinggrounddecaltype = "cortarg_aoplane.dds",
		buildpic = "CORTARG.DDS",
		buildtime = 10898,
		category = "ALL NOTLAND NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER SURFACE",
		corpse = "DEAD",
		description = "Enhanced Radar Targeting, more facilities enhance accuracy",
		energyuse = 100,
		explodeas = "LARGE_BUILDINGEX",
		footprintx = 5,
		footprintz = 4,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		istargetingupgrade = true,
		maxdamage = 1800,
		maxslope = 10,
		maxwaterdepth = 0,
		name = "Targeting Facility",
		objectname = "CORTARG",
		onoffable = true,
		seismicsignature = 0,
		selfdestructas = "LARGE_BUILDING",
		sightdistance = 273,
		usebuildinggrounddecal = false,
		yardmap = "oooooooooooooooooooo",
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0.625 -3.66210937486e-06 -0.246391296387",
				collisionvolumescales = "62.75 20.2424926758 64.4927825928",
				collisionvolumetype = "Box",
				damage = 1080,
				description = "Targeting Facility Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 5,
				footprintz = 4,
				height = 20,
				hitdensity = 100,
				metal = 487,
				object = "CORTARG_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 540,
				description = "Targeting Facility Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 5,
				footprintz = 4,
				height = 4,
				hitdensity = 100,
				metal = 195,
				object = "4X4D",
                collisionvolumescales = "85.0 14.0 85.0",
                collisionvolumetype = "box",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sounds = {
			activate = "targon2",
			canceldestruct = "cancel2",
			deactivate = "targoff2",
			underattack = "warning1",
			working = "targsel2",
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			select = {
				[1] = "targsel2",
			},
		},
	},
}
