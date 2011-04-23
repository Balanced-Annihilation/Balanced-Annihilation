return {
	cordl = {
		acceleration = 0,
		activatewhenbuilt = true,
		badtargetcategory = "NOTSUB",
		bmcode = 0,
		brakerate = 0,
		buildangle = 16384,
		buildcostenergy = 2340,
		buildcostmetal = 280,
		builder = false,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 4,
		buildinggrounddecalsizey = 4,
		buildinggrounddecaltype = "cordl_aoplane.dds",
		buildpic = "CORDL.DDS",
		buildtime = 4280,
		canattack = true,
		canstop = 1,
		category = "ALL NOTLAND WEAPON NOTSUB NOTSHIP NOTAIR",
		corpse = "DEAD",
		defaultmissiontype = "GUARD_NOMOVE",
		description = "Depthcharge Launcher",
		energymake = 0.10000000149012,
		energystorage = 0,
		energyuse = 0.10000000149012,
		explodeas = "SMALL_UNITEX",
		firestandorders = 1,
		footprintx = 2,
		footprintz = 2,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 1075,
		maxslope = 15,
		maxvelocity = 0,
		maxwaterdepth = 0,
		metalstorage = 0,
		name = "Jellyfish",
		noautofire = false,
		objectname = "CORDL",
		seismicsignature = 0,
		selfdestructas = "SMALL_UNIT",
		side = "CORE",
		sightdistance = 611,
		smoothanim = false,
		sonardistance = 525,
		standingfireorder = 2,
		tedclass = "WATER",
		turnrate = 0,
		unitname = "cordl",
		usebuildinggrounddecal = true,
		workertime = 0,
		yardmap = "oooo",
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				damage = 645,
				description = "Jellyfish Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 30,
				hitdensity = 100,
				metal = 182,
				object = "CORDL_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 323,
				description = "Jellyfish Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 73,
				object = "3X3B",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			cloak = "kloak1",
			uncloak = "kloak1un",
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
				[1] = "servmed2",
			},
			select = {
				[1] = "servmed2",
			},
		},
		weapondefs = {
			coax_depthcharge = {
				avoidfriendly = false,
				bouncerebound = 0.60000002384186,
				bounceslip = 0.60000002384186,
				burnblow = true,
				collidefriendly = false,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASH2",
				groundbounce = true,
				guidance = true,
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				lineofsight = true,
				model = "depthcharge",
				name = "DepthCharge",
				noselfdamage = true,
				numbounce = 1,
				propeller = 1,
				range = 580,
				reloadtime = 1.7999999523163,
				rendertype = 1,
				selfprop = true,
				soundhit = "xplodep2",
				soundstart = "torpedo1",
				startvelocity = 250,
				tracks = true,
				turnrate = 18000,
				turret = true,
				waterweapon = true,
				weaponacceleration = 25,
				weapontimer = 6,
				weapontype = "TorpedoLauncher",
				weaponvelocity = 350,
				damage = {
					commanders = 500,
					default = 250,
					dl = 5,
					krogoth = 500,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "NOTSUB",
				def = "COAX_DEPTHCHARGE",
			},
		},
	},
}
