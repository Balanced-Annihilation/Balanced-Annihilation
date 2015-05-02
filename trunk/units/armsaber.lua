return {
	armsaber = {
		acceleration = 0.288,
		brakerate = 0.46,
		buildcostenergy = 5984,
		buildcostmetal = 201,
		buildpic = "ARMSABER.DDS",
		buildtime = 9016,
		canfly = true,
		canmove = true,
		cansubmerge = true,
		category = "ALL NOTLAND MOBILE WEAPON NOTSUB ANTIFLAME ANTIEMG ANTILASER VTOL NOTSHIP NOTHOVER",
		collide = false,
		cruisealt = 100,
		description = "Seaplane Gunship",
		energymake = 0.8,
		energyuse = 0.8,
		explodeas = "BIG_UNITEX",
		footprintx = 3,
		footprintz = 3,
		hoverattack = true,
		icontype = "air",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 911,
		maxslope = 10,
		maxvelocity = 5.23,
		maxwaterdepth = 255,
		name = "Sabre",
		nochasecategory = "VTOL",
		objectname = "ARMSABER",
		seismicsignature = 0,
		selfdestructas = "BIG_UNIT",
		sightdistance = 595,
		turninplaceanglelimit = 360,
		turnrate = 931,
		customparams = {},
		sounds = {
			build = "nanlath1",
			canceldestruct = "cancel2",
			repair = "repair1",
			underattack = "warning1",
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
				[1] = "vtolcrmv",
			},
			select = {
				[1] = "seapsel1",
			},
		},
		weapondefs = {
			vtol_emg2 = {
				accuracy = 100,
				areaofeffect = 20,
				burnblow = true,
				cegtag = "banthablaster",
				craterboost = 0,
				cratermult = 0,
				duration = 0.05,
				explosiongenerator = "custom:FLASHBANTHA",
				impulseboost = 0.123,
				impulsefactor = 0.123,
				intensity = 4,
				name = "LightningBolt",
				noselfdamage = true,
				proximitypriority = 1,
				range = 475,
				reloadtime = 0.8,
				rgbcolor = "0.05 0.05 1",
				soundhit = "xplosml3",
				soundstart = "Lasrhvy2",
				thickness = 10,
				tolerance = 10000,
				turret = false,
				weapontype = "LaserCannon",
				weaponvelocity = 400,
				damage = {
					bombers = 10,
					commanders = 40,
					default = 60,
					fighters = 10,
					subs = 1,
					vtol = 10,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "VTOL_EMG2",
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
