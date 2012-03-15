return {
	bladew = {
		acceleration = 0.26399999856949,
		brakerate = 5.5,
		buildcostenergy = 1200,
		buildcostmetal = 54,
		buildpic = "BLADEW.DDS",
		buildtime = 2073,
		canfly = true,
		canmove = true,
		category = "ALL WEAPON VTOL NOTSUB NOTHOVER",
		collide = false,
		cruisealt = 78,
		description = "Light Paralyzer Drone",
		energymake = 2,
		explodeas = "TINY_BUILDINGEX",
		footprintx = 2,
		footprintz = 2,
		hoverattack = true,
		icontype = "air",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 75,
		maxslope = 10,
		maxvelocity = 10.35000038147,
		maxwaterdepth = 0,
		name = "Bladewing",
		nochasecategory = "COMMANDERS VTOL",
		objectname = "BLADEW",
		seismicsignature = 0,
		selfdestructas = "TINY_BUILDINGEX",
		sightdistance = 364,
		turnrate = 1144,
		upright = true,
		usesmoothmesh = 0,
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
			bladewing_lyzer = {
				areaofeffect = 8,
				avoidfriendly = false,
				beamtime = 0.10000000149012,
				collidefriendly = false,
				corethickness = 0.10000000149012,
				craterboost = 0,
				cratermult = 0,
				cylindertargetting = 1,
				duration = 0.0099999997764826,
				explosiongenerator = "custom:EMPFLASH20",
				impactonly = 1,
				impulseboost = 0,
				impulsefactor = 0,
				laserflaresize = 5,
				name = "Paralyzer",
				noselfdamage = true,
				paralyzer = true,
				paralyzetime = 7,
				range = 220,
				reloadtime = 1.2000000476837,
				rgbcolor = "1 1 0",
				soundhit = "lashit",
				soundstart = "hackshot",
				soundtrigger = true,
				targetmoveerror = 0.30000001192093,
				thickness = 1.2000000476837,
				tolerance = 10000,
				turret = true,
				weapontype = "BeamLaser",
				weaponvelocity = 800,
				damage = {
					default = 800,
				},
			},
		},
		weapons = {
			[1] = {
				def = "BLADEWING_LYZER",
				maindir = "0 0 1",
				maxangledif = 90,
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
