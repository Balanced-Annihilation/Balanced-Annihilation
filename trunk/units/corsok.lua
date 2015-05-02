return {
	corsok = {
		acceleration = 0.09,
		brakerate = 0.135,
		buildcostenergy = 58466,
		buildcostmetal = 3910,
		builder = false,
		buildtime = 63001,
		canattack = true,
		canguard = true,
		canhover = true,
		canmove = true,
		canpatrol = true,
		canstop = 1,
		cantbetransported = true,
		category = "ALL HOVER MOBILE WEAPON NOTSUB NOTSHIP NOTAIR SURFACE",
		collisionvolumeoffsets = "0 3 0",
		collisionvolumescales = "80 48 90",
		collisionvolumetype = "CylY",
		corpse = "dead",
		description = "Heavy Hovertank",
		energymake = 2.2,
		energyuse = 2,
		explodeas = "BIG_UNIT",
		footprintx = 4,
		footprintz = 4,
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 16800,
		maxslope = 16,
		maxvelocity = 1.6,
		maxwaterdepth = 0,
		movementclass = "HHOVER3",
		name = "Sokolov",
		nochasecategory = "VTOL",
		objectname = "CORSOK",
		radardistance = 0,
		selfdestructas = "BIG_UNIT",
		side = "CORE",
		sightdistance = 650,
		sonardistance = 700,
		turninplace = 0,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 1.056,
		turnrate = 290,
		waterline = 7,
		customparams = {},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				damage = 7000,
				description = "Sokolov Wreckage",
				featuredead = "heap",
				featurereclamate = "smudge01",
				footprintx = 4,
				footprintz = 4,
				height = 15,
				hitdensity = 100,
				metal = 2584,
				object = "corsok_dead",
				reclaimable = true,
				seqnamereclamate = "tree1reclamate",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 3500,
				description = "Sokolov Heap",
				featurereclamate = "smudge01",
				footprintx = 4,
				footprintz = 4,
				height = 4,
				hitdensity = 100,
				metal = 971,
				object = "4x4d",
				reclaimable = true,
				resurrectable = 0,
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
				[1] = "hovlgok2",
			},
			select = {
				[1] = "hovlgsl2",
			},
		},
		weapondefs = {
			corsok_depthcharge = {
				areaofeffect = 110,
				burst = 2,
				burstrate = 0.6,
				craterboost = 0,
				cratermult = 0,
				firestarter = 70,
				flighttime = 5,
				impulseboost = 0,
				impulsefactor = 0,
				model = "Advtorpedo",
				name = "Torpedo",
				range = 725,
				reloadtime = 2.6,
				rgbcolor = "1.000 0.000 0.000",
				soundhitdry = "xplosml1",
				soundstart = "torpedo1",
				soundtrigger = true,
				startsmoke = 1,
				startvelocity = 270,
				tolerance = 15000,
				tracks = true,
				turnrate = 48000,
				waterweapon = true,
				weaponacceleration = 125,
				weapontimer = 5,
				weapontype = "Cannon",
				weaponvelocity = 320,
				damage = {
					default = 395,
					nothover = 290,
					notship = 290,
					notsub = 290,
				},
			},
			corsok_laser = {
				areaofeffect = 20,
				burnblow = true,
				collideenemy = true,
				corethickness = 1,
				craterboost = 0,
				cratermult = 0,
				duration = 10,
				edgeeffectiveness = 0.7,
				energypershot = 1000,
				impulseboost = 0,
				impulsefactor = 0,
				name = "Disruptor Phaser",
				noexplode = true,
				range = 725,
				reloadtime = 9,
				rgbcolor = "0.000 1.000 0.72",
				rgbcolor2 = "0.000 1.000 0.3",
				soundhitdry = "emgpuls1",
				soundstart = "annigun1",
				thickness = 2,
				tolerance = 525,
				tracks = true,
				turnrate = 20000,
				turret = true,
				weapontimer = 3,
				weapontype = "BeamLaser",
				weaponvelocity = 1000,
				damage = {
					default = 850,
					subs = 5,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "CORSOK_LASER",
				onlytargetcategory = "NOTSUB",
			},
			[3] = {
				badtargetcategory = "VTOL",
				def = "CORSOK_DEPTHCHARGE",
			},
		},
	},
}
