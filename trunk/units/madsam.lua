return {
	madsam = {
		acceleration = 0,
		airsightdistance = 700,
		brakerate = 0,
		buildangle = 8192,
		buildcostenergy = 5750,
		buildcostmetal = 295,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 5,
		buildinggrounddecalsizey = 5,
		buildinggrounddecaltype = "madsam_aoplane.dds",
		buildpic = "MADSAM.DDS",
		buildtime = 5237,
		category = "ALL NOTLAND WEAPON NOTSUB NOTSHIP NOTAIR",
		corpse = "DEAD",
		description = "Hardened Missile Battery",
		energyuse = 5,
		explodeas = "LARGE_BUILDINGEX",
		footprintx = 3,
		footprintz = 3,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 2500,
		maxslope = 10,
		maxwaterdepth = 0,
		name = "SAM",
		objectname = "MADSAM",
		seismicsignature = 0,
		selfdestructas = "LARGE_BUILDING",
		sightdistance = 375,
		usebuildinggrounddecal = true,
		yardmap = "ooooooooo",
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				damage = 1500,
				description = "SAM Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 10,
				hitdensity = 100,
				metal = 257,
				object = "MADSAM_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "all",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 750,
				description = "SAM Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				hitdensity = 100,
				metal = 103,
				object = "2X2C",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "all",
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
				[1] = "twrturn3",
			},
			select = {
				[1] = "twrturn3",
			},
		},
		weapondefs = {
			madsam_missile = {
				areaofeffect = 16,
				burnblow = true,
				burst = 4,
				burstrate = 0.20000000298023,
				canattackground = false,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:FLASH2",
				firestarter = 72,
				flighttime = 2,
				impulseboost = 0.12300000339746,
				impulsefactor = 0.12300000339746,
				model = "missile",
				name = "AA2Missile",
				noselfdamage = true,
				proximitypriority = 1,
				range = 840,
				reloadtime = 2.5499999523163,
				smoketrail = true,
				soundhit = "packohit",
				soundstart = "packolau",
				soundtrigger = true,
				startvelocity = 520,
				texture2 = "coresmoketrail",
				toairweapon = true,
				tolerance = 9950,
				tracks = true,
				turnrate = 68000,
				turret = true,
				weaponacceleration = 160,
				weapontimer = 2,
				weapontype = "MissileLauncher",
				weaponvelocity = 820,
				damage = {
					default = 113,
					gunships = 72,
					hgunships = 72,
					l1subs = 5,
					l2subs = 5,
					l3subs = 5,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "NOTAIR",
				def = "MADSAM_MISSILE",
			},
		},
	},
}
