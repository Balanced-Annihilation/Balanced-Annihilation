return {
	corcom = {
		acceleration = 0.18000000715256,
		activatewhenbuilt = true,
		autoheal = 5,
		brakerate = 0.375,
		buildcostenergy = 25000,
		buildcostmetal = 2500,
		builddistance = 128,
		builder = true,
		buildpic = "CORCOM.DDS",
		buildtime = 75000,
		cancapture = true,
		candgun = true,
		canmove = true,
		capturespeed = 900,
		category = "ALL WEAPON COMMANDER NOTSUB NOTSHIP NOTAIR",
		cloakcost = 100,
		cloakcostmoving = 1000,
		collisionvolumeoffsets = "0 -1 0",
		collisionvolumescales = "36 44 26",
		collisionvolumetest = 1,
		collisionvolumetype = "Ell",
		commander = true,
		corpse = "DEAD",
		description = "Commander",
		energymake = 25,
		energystorage = 1000,
		explodeas = "COMMANDER_BLAST",
		footprintx = 2,
		footprintz = 2,
		hidedamage = true,
		icontype = "corcommander",
		idleautoheal = 5,
		idletime = 1800,
		mass = 5000,
		maxdamage = 3000,
		maxslope = 20,
		maxvelocity = 1.25,
		maxwaterdepth = 35,
		metalmake = 1.5,
		metalstorage = 1000,
		mincloakdistance = 50,
		movementclass = "AKBOT2",
		name = "Commander",
		nochasecategory = "ALL",
		objectname = "CORCOM",
		radardistance = 700,
		reclaimable = false,
		seismicsignature = 0,
		selfdestructas = "COMMANDER_BLAST",
		selfdestructcountdown = 5,
		showplayername = true,
		sightdistance = 450,
		smoothanim = true,
		sonardistance = 300,
		terraformspeed = 900,
		transportbyenemy = false,
		turnrate = 1133,
		upright = true,
		workertime = 300,
		buildoptions = {
			[1] = "corsolar",
			[2] = "cortide",
			[3] = "corwin",
			[4] = "cormstor",
			[5] = "corestor",
			[6] = "coruwms",
			[7] = "coruwes",
			[8] = "cormex",
			[9] = "coruwmex",
			[10] = "cormakr",
			[11] = "corfmkr",
			[12] = "corlab",
			[13] = "corvp",
			[14] = "corap",
			[15] = "corsy",
			[16] = "coreyes",
			[17] = "corrad",
			[18] = "corsonar",
			[19] = "cordrag",
			[20] = "corfdrag",
			[21] = "corllt",
			[22] = "cortl",
			[23] = "corrl",
			[24] = "corfrt",
			[25] = "cordl",
		},
		customparams = {
			paralyzemultiplier = 0.025000000372529,
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0 0 0",
				collisionvolumescales = "60 10 60",
				collisionvolumetype = "cylY",
				damage = 10000,
				description = "Commander Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 2500,
				object = "CORCOM_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 5000,
				description = "Commander Debris",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 1250,
				object = "2X2C",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sounds = {
			build = "nanlath2",
			canceldestruct = "cancel2",
			capture = "capture2",
			cloak = "kloak2",
			repair = "repair2",
			uncloak = "kloak2un",
			underattack = "warning2",
			unitcomplete = "kccorsel",
			working = "reclaim1",
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
				[1] = "kcormov",
			},
			select = {
				[1] = "kccorsel",
			},
		},
		weapondefs = {
			arm_disintegrator = {
				areaofeffect = 36,
				avoidfriendly = false,
				commandfire = true,
				craterboost = 0,
				cratermult = 0,
				energypershot = 500,
				explosiongenerator = "custom:DGUNTRACE",
				firestarter = 100,
				impulseboost = 0,
				impulsefactor = 0,
				name = "Disintegrator",
				noexplode = true,
				noselfdamage = true,
				range = 250,
				reloadtime = 1,
				soundhit = "xplomas2",
				soundstart = "disigun1",
				soundtrigger = true,
				tolerance = 10000,
				turret = true,
				weapontimer = 4.1999998092651,
				weapontype = "DGun",
				weaponvelocity = 300,
				damage = {
					default = 99999,
				},
			},
			armcomlaser = {
				areaofeffect = 12,
				avoidfeature = false,
				beamtime = 0.10000000149012,
				corethickness = 0.10000000149012,
				craterboost = 0,
				cratermult = 0,
				cylindertargetting = 1,
				edgeeffectiveness = 0.99000000953674,
				explosiongenerator = "custom:SMALL_RED_BURN",
				firestarter = 70,
				impactonly = 1,
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				laserflaresize = 7,
				name = "J7Laser",
				noselfdamage = true,
				range = 300,
				reloadtime = 0.40000000596046,
				rgbcolor = "1 0 0",
				soundhit = "lasrhit2",
				soundstart = "lasrfir1",
				soundtrigger = true,
				targetmoveerror = 0.050000000745058,
				thickness = 2,
				tolerance = 10000,
				turret = true,
				weapontype = "BeamLaser",
				weaponvelocity = 900,
				damage = {
					default = 75,
					l1bombers = 180,
					l1subs = 5,
					l2fighters = 110,
				},
			},
		},
		weapons = {
			[1] = {
				def = "ARMCOMLASER",
			},
			[3] = {
				def = "ARM_DISINTEGRATOR",
			},
		},
	},
}
