return {
	corcrw = {
		acceleration = 0.154,
		activatewhenbuilt = true,
		brakerate = 0.375,
		buildcostenergy = 72627,
		buildcostmetal = 5075,
		buildpic = "CORCRW.DDS",
		buildtime = 84229,
		canfly = true,
		canmove = true,
		category = "ALL WEAPON VTOL NOTSUB NOTHOVER",
		collide = true,
		cruisealt = 80,
		description = "Flying Fortress",
		explodeas = "SMALL_BUILDING",
		footprintx = 3,
		footprintz = 3,
		hoverattack = true,
		icontype = "air",
		idleautoheal = 15,
		idletime = 1200,
		maxdamage = 15000,
		maxslope = 10,
		maxvelocity = 3.83,
		maxwaterdepth = 0,
		name = "Krow",
		nochasecategory = "VTOL",
		objectname = "CORCRW",
		seismicsignature = 0,
		selfdestructas = "LARGE_BUILDING",
		sightdistance = 494,
		turninplaceanglelimit = 360,
		turnrate = 297,
		upright = true,
		blocking = false,
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
				[1] = "vtolcrmv",
			},
			select = {
				[1] = "vtolcrac",
			},
		},
		weapondefs = {
			krowlaser = {
				areaofeffect = 8,
				avoidfeature = false,
				beamtime = 0.1,
				corethickness = 0.1,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				cylindertargeting = 1,
				energypershot = 50,
				explosiongenerator = "custom:SMALL_GREEN_LASER_BURN",
				firestarter = 90,
				impulseboost = 0,
				impulsefactor = 0,
				laserflaresize = 8,
				name = "HighEnergyLaser",
				noselfdamage = true,
				proximitypriority = 1,
				range = 575,
				reloadtime = 0.65,
				rgbcolor = "0 1 0",
				soundhitdry = "",
				soundhitwet = "sizzle",
				soundhitwetvolume = 0.5,
				soundstart = "Lasrmas2",
				soundtrigger = 1,
				targetmoveerror = 0.3,
				thickness = 2.75,
				tolerance = 10000,
				turret = true,
				weapontype = "BeamLaser",
				weaponvelocity = 800,
				damage = {
					default = 90,
					subs = 5,
				},
			},
			krowlaser2 = {
				areaofeffect = 32,
				avoidfeature = false,
				beamtime = 0.25,
				corethickness = 0.2,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				cylindertargeting = 1,
				energypershot = 100,
				explosiongenerator = "custom:LARGE_GREEN_LASER_BURN",
				firestarter = 90,
				impulseboost = 0,
				impulsefactor = 0,
				laserflaresize = 10,
				name = "HighEnergyLaser",
				noselfdamage = true,
				range = 525,
				reloadtime = 1.3,
				rgbcolor = "0 1 0",
				soundhitdry = "",
				soundhitwet = "sizzle",
				soundhitwetvolume = 0.5,
				soundstart = "Lasrmas2",
				soundtrigger = 1,
				targetmoveerror = 0.15,
				thickness = 3,
				tolerance = 10000,
				turret = true,
				weapontype = "BeamLaser",
				weaponvelocity = 800,
				damage = {
					default = 250,
					subs = 5,
				},
			},
		},
		weapons = {
			[1] = {
				def = "KROWLASER2",
				onlytargetcategory = "SURFACE",
			},
			[2] = {
				def = "KROWLASER",
				onlytargetcategory = "SURFACE",
			},
			[3] = {
				def = "KROWLASER",
				onlytargetcategory = "SURFACE",
			},
		},
	},
}