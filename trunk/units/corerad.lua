return {
	corerad = {
		acceleration = 0,
		airsightdistance = 1000,
		brakerate = 0,
		buildangle = 65536,
		buildcostenergy = 8723,
		buildcostmetal = 748,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 6,
		buildinggrounddecalsizey = 6,
		buildinggrounddecaltype = "corerad_aoplane.dds",
		buildpic = "CORERAD.DDS",
		buildtime = 19958,
		category = "ALL WEAPON STRATEGIC NOTSUB NOTAIR",
		corpse = "DEAD",
		description = "Bomb-Resistant Medium-Range Missile Battery",
		explodeas = "LARGE_BUILDINGEX",
		footprintx = 4,
		footprintz = 4,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 2600,
		maxslope = 10,
		maxwaterdepth = 0,
		name = "Eradicator",
		objectname = "CORERAD",
		seismicsignature = 0,
		selfdestructas = "LARGE_BUILDING",
		sightdistance = 350,
		usebuildinggrounddecal = true,
		yardmap = "oooooooooooooooo",
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				damage = 1560,
				description = "Eradicator Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 4,
				footprintz = 4,
				height = 20,
				hitdensity = 100,
				metal = 486,
				object = "CORERAD_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 780,
				description = "Eradicator Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 194,
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
				[1] = "twrturn3",
			},
			select = {
				[1] = "twrturn3",
			},
		},
		weapondefs = {
			cor_erad = {
				areaofeffect = 144,
				burnblow = true,
				burst = 3,
				burstrate = 0.20000000298023,
				canattackground = false,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:CORE_FIRE_SMALL",
				firestarter = 20,
				flighttime = 3,
				impulseboost = 0,
				impulsefactor = 0,
				model = "missile",
				name = "ExplosiveRockets",
				noselfdamage = true,
				proximitypriority = -4,
				range = 1250,
				reloadtime = 3.2000000476837,
				smoketrail = true,
				soundhit = "xplosml2",
				soundstart = "rocklit1",
				soundtrigger = true,
				startvelocity = 750,
				texture2 = "coresmoketrail",
				toairweapon = true,
				tolerance = 10000,
				tracks = true,
				turnrate = 25000,
				turret = true,
				weaponacceleration = 200,
				weapontimer = 3,
				weapontype = "MissileLauncher",
				weaponvelocity = 1500,
				damage = {
					amphibious = 10,
					anniddm = 10,
					antibomber = 10,
					antifighter = 10,
					antiraider = 10,
					atl = 10,
					blackhydra = 10,
					commanders = 10,
					crawlingbombs = 10,
					default = 440,
					dl = 10,
					["else"] = 10,
					flakboats = 10,
					flaks = 10,
					flamethrowers = 10,
					gunships = 130,
					heavyunits = 10,
					hgunships = 130,
					jammerboats = 10,
					krogoth = 10,
					l1bombers = 210,
					l1fighters = 210,
					l1subs = 5,
					l2bombers = 210,
					l2fighters = 210,
					l2subs = 5,
					l3subs = 5,
					mechs = 10,
					mines = 10,
					nanos = 10,
					otherboats = 10,
					plasmaguns = 10,
					radar = 10,
					seadragon = 10,
					spies = 10,
					tl = 10,
					vradar = 210,
					vtol = 210,
					vtrans = 210,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "COR_ERAD",
			},
		},
	},
}
