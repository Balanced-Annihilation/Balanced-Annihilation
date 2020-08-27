local root = "genericshellexplosion"
local definitions = {
  [root.."-tiny"] = {
    --groundflash = {
    --  air                = true,
    --      --  flashalpha         = 0.2,
    --  flashsize          = 67,
    --  ground             = true,
    --  ttl                = 13,
    --  water              = true,
    --underwater         = true,
    --  color = {
    --    [1]  = 1,
    --    [2]  = 0.75,
    --    [3]  = 0.3,
    --  },
    --},
    groundflash_small = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.7 0.3 0.28   0 0 0 0.01]],
        size               = 18,
        sizegrowth         = -0.5,
        ttl                = 12,
        texture            = [[groundflash]],
      },
    },
    groundflash_large = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.7 0.3 0.09   0 0 0 0.01]],
        size               = 36,
        sizegrowth         = -0.5,
        ttl                = 12,
        texture            = [[groundflash]],
      },
    },
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        heat               = 7,
        heatfalloff        = 1.2,
        maxheat            = 16,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 1.5,
        sizegrowth         = 4,
        speed              = [[0, 1 0, 0]],
        texture            = [[flare]],
      },
    },
    explosion = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = false,
      properties = {
        airdrag            = 0.77,
        colormap           = [[0 0 0 0   1 0.9 0.6 0.09   0.9 0.5 0.2 0.066   0.66 0.28 0.04 0.033   0 0 0 0]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 6,
        particlelife       = 6,
        particlelifespread = 5,
        particlesize       = 1,
        particlesizespread = 1.4,
        particlespeed      = 0.38,
        particlespeedspread = 1.8,
        pos                = [[0, 2, 0]],
        sizegrowth         = 0.2,
        sizemod            = 1.1,
        texture            = [[flashside2]],
        useairlos          = false,
      },
    },

    innersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.8,
        alwaysVisible = 0,
        sizeGrowth = 0.3,
        sizeMod = 1,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=35,
        emitRotSpread=40,
        emitVector = [[0, 1, 0]],
        gravity = [[0, 0.014, 0]],
colormap           = [[1 0.9 0.6 0.11   0.9 0.5 0.2 0.08   0.66 0.28 0.04 0.033   0 0 0 0]],
        Texture=[[graysmoke]],
        particleLife=5,
        particleLifeSpread=21,
        numparticles=2,
        particleSpeed=0.5,
        particleSpeedSpread=2,
        particleSize=3,
        particleSizeSpread=2.5,
        directional=0,
      },
    },
    outersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.4,
        alwaysVisible = 0,
        sizeGrowth = 0.35,
        sizeMod = 1.0,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=33,
        emitRotSpread=50,
        emitVector = [[0, 1, 0]],
        gravity = [[0, -0.02, 0]],
        colormap=[[1 0.66 0.4 0.45    0.3 0.2 0.13 0.4   0.18 0.15 0.11 0.35    0.13 0.12 0.1 0.32   0.11 0.1 0.093 0.25   0.063 0.062 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife=4,
        particleLifeSpread=18,
        numparticles=1,
        particleSpeed=1,
        particleSpeedSpread=3.3,
        particleSize=4,
        particleSizeSpread=2.5,
        directional=0,
      },
    },
    dirt = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      unit               = false,
      water              = false,
      air                = false,
      underwater         = false,
      properties = {
        airdrag            = 0.95,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66   0.1 0.07 0.033 0.58   0.1 0.07 0.033 0.5   0.1 0.07 0.033 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = 16,
        emitrotspread      = 40,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.3, 0]],
        numparticles       = 2,
        particlelife       = 5,
        particlelifespread = 3,
        particlesize       = 1.08,
        particlesizespread = -1,
        particlespeed      = 1.05,
        particlespeedspread = 1.2,
        pos                = [[0, 4, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
    dirt2 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      unit               = false,
      water              = false,
      air                = false,
      underwater         = false,
      properties = {
        airdrag            = 1,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66   0.1 0.07 0.033 0.58   0.1 0.07 0.033 0.5   0.1 0.07 0.033 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = -5,
        emitrotspread      = 11,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.3, 0]],
        numparticles       = 1,
        particlelife       = 5,
        particlelifespread = 3,
        particlesize       = 1.1,
        particlesizespread = -1,
        particlespeed      = 1.25,
        particlespeedspread = 1.4,
        pos                = [[0, 4, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
    clouddust = {
      air                = false,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.91,
        colormap           = [[0 0 0 0.01   0.025 0.025 0.025 0.035  0.06 0.06 0.06 0.08  0.05 0.05 0.05 0.065  0.026 0.026 0.026 0.035  0 0 0 0.01]],
        directional        = false,
        emitrot            = 45,
        emitrotspread      = 4,
        emitvector         = [[0.25, 0.8, 0.25]],
        gravity            = [[0, 0.015, 0]],
        numparticles       = 1,
        particlelife       = 8,
        particlelifespread = 40,
        particlesize       = 3,
        particlesizespread = 5,
        particlespeed      = 0.3,
        particlespeedspread = 1,
        pos                = [[0, 6, 0]],
        sizegrowth         = 0.1,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke]],
      },
    },
    --grounddust = {
    --  air                = false,
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  unit               = false,
    --  properties = {
    --    airdrag            = 0.86,
    --    colormap           = [[0.07 0.07 0.07 0.1 	0 0 0 0.0]],
    --    directional        = true,
    --    emitrot            = 90,
    --    emitrotspread      = -2,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, 0.02, 0]],
    --    numparticles       = 8,
    --    particlelife       = 10,
    --    particlelifespread = 40,
    --    particlesize       = 2,
    --    particlesizespread = 1.4,
    --    particlespeed      = 1.6,
    --    particlespeedspread = 0.55,
    --    pos                = [[0, 1, 0]],
    --    sizegrowth         = 0.1,
    --    sizemod            = 1.0,
    --    texture            = [[bigexplosmoke]],
    --  },
    --},

    
    outerflash = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        heat               = 7,
        heatfalloff        = 1.5,
        maxheat            = 15,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 2.5,
        sizegrowth         = 0.6,
        speed              = [[0, 1 0, 0]],
        texture            = [[orangenovaexplo]],
      },
    },

  },

 [root.."-small"] = {
    groundflash_small = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.7 0.3 0.32   0 0 0 0.01]],
        size               = 16,
        sizegrowth         = -0.5,
        ttl                = 6,
        texture            = [[groundflash]],
      },
    },
    groundflash_large = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.7 0.3 0.11   0 0 0 0.01]],
        size               = 26,
        sizegrowth         = -0.5,
        ttl                = 7,
        texture            = [[groundflash]],
      },
    },
    groundflash_white = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.9 0.75 0.55   0 0 0 0.01]],
        size               = 22,
        sizegrowth         = 0,
        ttl                = 3,
        texture            = [[groundflash]],
      },
    },
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater         = true,
      properties = {
        heat               = 7,
        heatfalloff        = 1.2,
        maxheat            = 16,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 2,
        sizegrowth         = 6,
        speed              = [[0, 1 0, 0]],
        texture            = [[flare]],
      },
    },
    explosion = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = false,
      properties = {
        airdrag            = 0.77,
        colormap           = [[0 0 0 0   1 0.9 0.6 0.09   0.9 0.5 0.2 0.066   0.66 0.28 0.04 0.033   0 0 0 0]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 5,
        particlelife       = 4,
        particlelifespread = 5,
        particlesize       = 1.5,
        particlesizespread = 2.2,
        particlespeed      = 0.3,
        particlespeedspread = 2.5,
        pos                = [[0, 2, 0]],
        sizegrowth         = 0.3,
        sizemod            = 1.1,
        texture            = [[flashside2]],
        useairlos          = false,
      },
    },

    innersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=0,
      properties = {
        airdrag=0.8,
        alwaysVisible = 0,
        sizeGrowth = 0.4,
        sizeMod = 1,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=35,
        emitRotSpread=40,
        emitVector = [[0, 1, 0]],
        gravity = [[0, 0.014, 0]],
colormap           = [[1 0.9 0.6 0.11   0.9 0.5 0.2 0.08   0.66 0.28 0.04 0.033   0 0 0 0]],
        Texture=[[graysmoke]],
        particleLife=1,
        particleLifeSpread=45,
        numparticles=3,
        particleSpeed=0.6,
        particleSpeedSpread=2.7,
        particleSize=3,
        particleSizeSpread=2.5,
        directional=0,
      },
    },
    outersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.4,
        alwaysVisible = 0,
        sizeGrowth = 0.35,
        sizeMod = 1.0,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=33,
        emitRotSpread=50,
        emitVector = [[0, 1, 0]],
        gravity = [[0, -0.02, 0]],
        colormap=[[1 0.66 0.4 0.45    0.3 0.2 0.13 0.4   0.18 0.15 0.11 0.35    0.13 0.12 0.1 0.32   0.11 0.1 0.093 0.25   0.063 0.062 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife=1.15,
        particleLifeSpread=25,
        numparticles=3,
        particleSpeed=1,
        particleSpeedSpread=3.3,
        particleSize=4,
        particleSizeSpread=2.5,
        directional=0,
      },
    },
    dirt = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = false,
      air                = false,
      ground             = true,
      unit               = false,
      nounit             = true,
      underwater         = false,
      properties = {
        airdrag            = 0.95,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66   0.1 0.07 0.033 0.58   0.1 0.07 0.033 0.5   0.1 0.07 0.033 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = 22,
        emitrotspread      = 40,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.3, 0]],
        numparticles       = 4,
        particlelife       = 1.7,
        particlelifespread = 4,
        particlesize       = 1.2,
        particlesizespread = -1,
        particlespeed      = 1.4,
        particlespeedspread = 1.75,
        pos                = [[0, 4, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
    dirt2 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = false,
      air                = false,
      ground             = false,
      unit               = false,
      nounit             = true,
      underwater         = false,
      properties = {
        airdrag            = 1,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66   0.1 0.07 0.033 0.58   0.1 0.07 0.033 0.5   0.1 0.07 0.033 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = -5,
        emitrotspread      = 11,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.3, 0]],
        numparticles       = 2,
        particlelife       = 1.55,
        particlelifespread = 4,
        particlesize       = 1.23,
        particlesizespread = -1,
        particlespeed      = 1.66,
        particlespeedspread = 2.4,
        pos                = [[0, 4, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
    clouddust = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 0,
      ground             = true,
      properties = {
        airdrag            = 0.91,
        colormap           = [[0 0 0 0.01   0.025 0.025 0.025 0.035  0.06 0.06 0.06 0.08  0.05 0.05 0.05 0.065  0.026 0.026 0.026 0.035  0 0 0 0.01]],
        directional        = false,
        emitrot            = 45,
        emitrotspread      = 4,
        emitvector         = [[0.25, 0.8, 0.25]],
        gravity            = [[0, 0.015, 0]],
        numparticles       = 1,
        particlelife       = 1.8,
        particlelifespread = 55,
        particlesize       = 5,
        particlesizespread = 8,
        particlespeed      = 0.5,
        particlespeedspread = 1.5,
        pos                = [[0, 6, 0]],
        sizegrowth         = 0.1,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke]],
      },
    },
    --grounddust = {
    --  air                = false,
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  unit               = false,
    --  properties = {
    --    airdrag            = 0.86,
    --    colormap           = [[0.07 0.07 0.07 0.1 	0 0 0 0.0]],
    --    directional        = true,
    --    emitrot            = 90,
    --    emitrotspread      = -2,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, 0.02, 0]],
    --    numparticles       = 12,
    --    particlelife       = 10,
    --    particlelifespread = 40,
    --    particlesize       = 3,
    --    particlesizespread = 2,
    --    particlespeed      = 2.2,
    --    particlespeedspread = 0.8,
    --    pos                = [[0, 1, 0]],
    --    sizegrowth         = 0.1,
    --    sizemod            = 1.0,
    --    texture            = [[bigexplosmoke]],
    --  },
    --},

    
    outerflash = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater         = true,
      properties = {
                heat               = 7,
        heatfalloff        = 1.5,
        maxheat            = 15,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 4,
        sizegrowth         = 1.2,
        speed              = [[0, 1 0, 0]],
        texture            = [[orangenovaexplo]],
      },
    },

  },

		
 [root.."-medium"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater         = true,
      properties = {
        heat               = 12,
        heatfalloff        = 1.3,
        maxheat            = 20,
        pos                = [[r-2 r2, 3, r-2 r2]],
        size               = 1.5,
        sizegrowth         = 6.5,
        speed              = [[0, 1 0, 0]],
        texture            = [[flare]],
      },
    },
    groundflash_small = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.7 0.3 0.38   0 0 0 0.01]],
        size               = 35,
        sizegrowth         = -1,
        ttl                = 17,
        texture            = [[groundflash]],
      },
    },
    groundflash_large = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.7 0.3 0.12   0 0 0 0.01]],
        size               = 70,
        sizegrowth         = -1,
        ttl                = 17,
        texture            = [[groundflash]],
      },
    },
    groundflash_white = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.9 0.75 1.9   0 0 0 0.01]],
        size               = 40,
        sizegrowth         = 4,
        ttl                = 6,
        texture            = [[groundflash]],
      },
    },
    explosion = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = false,
      properties = {
        airdrag            = 0.8,
        colormap           = [[0 0 0 0   1 0.9 0.6 0.12   0.9 0.5 0.2 0.09   0.66 0.28 0.04 0.04   0 0 0 0]],
        directional        = true,
        emitrot            = 40,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 5,
        particlelife       = 4,
        particlelifespread = 9,
        particlesize       = 4.4,
        particlesizespread = 5.66,
        particlespeed      = 1,
        particlespeedspread = 3,
        pos                = [[0, 2, 0]],
        sizegrowth         = 0.3,
        sizemod            = 1,
        texture            = [[flashside2]],
        useairlos          = false,
      },
    },
	explosion_blur= {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = false,
      properties = {
        airdrag            = 0.8,
        colormap           = [[1.0 1.0 1.0 0.04	0.9 0.55 0.25 0.01	0.75 0.2 0.1 0.01	0 0 0 0.01]],
        directional        = true,
        emitrot            = 20,
        emitrotspread      = 10,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.05, 0]],
        numparticles       = 2,
        particlelife       = 4,
        particlelifespread = 3,
        particlesize       = 9,
        particlesizespread = 3,
        particlespeed      = 1.5,
        particlespeedspread = 8,
        pos                = [[0, 2, 0]],
        sizegrowth         = 0.3,
        sizemod            = 1,
        texture            = [[flashside1]],
        useairlos          = false,
      },
    },

    innersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.75,
        alwaysVisible = 0,
        sizeGrowth = 0.5,
        sizeMod = 1.0,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=33,
        emitRotSpread=50,
        emitVector = [[0, 1, 0]],
        gravity = [[0, 0.02, 0]],
        colormap=[[1 0.66 0.4 0.45    0.3 0.2 0.13 0.4   0.18 0.15 0.11 0.35    0.13 0.12 0.1 0.32   0.11 0.1 0.093 0.25   0.063 0.062 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife=5,
        particleLifeSpread=44,
        numparticles=3,
        particleSpeed=1.5,
        particleSpeedSpread=4.5,
        particleSize=7,
        particleSizeSpread=12,
        directional=0,
      },
    },
    outersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.2,
        alwaysVisible = 0,
        sizeGrowth = 0.35,
        sizeMod = 1.0,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=33,
        emitRotSpread=50,
        emitVector = [[0, 1, 0]],
        gravity = [[0, -0.02, 0]],
        colormap=[[1 0.66 0.4 0.45    0.3 0.2 0.13 0.4   0.18 0.15 0.11 0.35    0.13 0.12 0.1 0.32   0.11 0.1 0.093 0.25   0.063 0.062 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife=4,
        particleLifeSpread=40,
        numparticles=3,
        particleSpeed=2.5,
        particleSpeedSpread=5.5,
        particleSize=4,
        particleSizeSpread=10,
        directional=0,
      },
    },
    
    dirt = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = false,
      air                = false,
      ground             = true,
      unit               = false,
      underwater         = false,
      properties = {
        airdrag            = 0.97,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66   0.1 0.07 0.033 0.58   0.1 0.07 0.033 0.5   0.1 0.07 0.033 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = 18,
        emitrotspread      = 33,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.3, 0]],
        numparticles       = 6,
        particlelife       = 4,
        particlelifespread = 5,
        particlesize       = 1.5,
        particlesizespread = -1.15,
        particlespeed      = 2.95,
        particlespeedspread = 2.9,
        pos                = [[0, 3, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
    dirt2 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = false,
      air                = false,
      ground             = false,
      unit               = false,
      nounit             = true,
      underwater         = false,
      properties = {
        airdrag            = 0.97,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66   0.1 0.07 0.033 0.58   0.1 0.07 0.033 0.5   0.1 0.07 0.033 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = -5,
        emitrotspread      = 13,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.3, 0]],
        numparticles       = 2.5,
        particlelife       = 4,
        particlelifespread = 5,
        particlesize       = 1.55,
        particlesizespread = -1.2,
        particlespeed      = 2.5,
        particlespeedspread = 4.3,
        pos                = [[0, 3, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },

    clouddust = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.85,
        colormap           = [[0 0 0 0.01   0.025 0.025 0.025 0.033  0.06 0.06 0.06 0.08  0.05 0.05 0.05 0.065  0.026 0.026 0.026 0.035  0 0 0 0.01]],
        directional        = false,
        emitrot            = 45,
        emitrotspread      = 4,
        emitvector         = [[0.5, 1, 0.5]],
        gravity            = [[0, 0.02, 0]],
        numparticles       = 1,
        particlelife       = 8,
        particlelifespread = 80,
        particlesize       = 8,
        particlesizespread = 22,
        particlespeed      = 0.8,
        particlespeedspread = 2.2,
        pos                = [[0, 4, 0]],
        sizegrowth         = 0.22,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke]],
      },
    },
    --grounddust = {
    --  air                = false,
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  unit               = false,
    --  properties = {
    --    airdrag            = 0.89,
    --    colormap           = [[0.07 0.07 0.07 0.1 	0 0 0 0.0]],
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = -2,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, 0.015, 0]],
    --    numparticles       = 18,
    --    particlelife       = 25,
    --    particlelifespread = 45,
    --    particlesize       = 4.25,
    --    particlesizespread = 2.25,
    --    particlespeed      = 2.8,
    --    particlespeedspread = 1.4,
    --    pos                = [[0, 5, 0]],
    --    sizegrowth         = 0.2,
    --    sizemod            = 1.0,
    --    texture            = [[bigexplosmoke]],
    --  },
    --},
    outerflash = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater         = true,
      properties = {
        heat               = 9,
        heatfalloff        = 1.5,
        maxheat            = 40,
        pos                = [[r-2 r2, 4, r-2 r2]],
        size               = 12,
        sizegrowth         = 0.55,
        speed              = [[0, 1 0, 0]],
        texture            = [[orangenovaexplo]],
      },
    },
    --kickedupwater = {
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  water              = true,
    --  underwater         = true,
    --  properties = {
    --    airdrag            = 0.87,
    --    colormap           = [[0.7 0.7 0.9 0.35	0 0 0 0.0]],
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = 5,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, 0.1, 0]],
    --    numparticles       = 120,
    --    particlelife       = 2,
    --    particlelifespread = 30,
    --    particlesize       = 1,
    --    particlesizespread = 1,
    --    particlespeed      = 10,
    --    particlespeedspread = 6,
    --    pos                = [[0, 1, 0]],
    --    sizegrowth         = 0.5,
    --    sizemod            = 1.0,
    --    texture            = [[wake]],
    --  },
    --},
  },

 [root.."-large"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater         = true,
      properties = {
        heat               = 10,
        heatfalloff        = 1.4,
        maxheat            = 14,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 3,
        sizegrowth         = 12,
        speed              = [[0, 1 0, 0]],
        texture            = [[flare]],
      },
    },
    groundflash_small = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.7 0.3 0.4   0 0 0 0.01]],
        size               = 70,
        sizegrowth         = -1.5,
        ttl                = 22,
        texture            = [[groundflash]],
      },
    },
    groundflash_large = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.7 0.3 0.125   0 0 0 0.01]],
        size               = 140,
        sizegrowth         = -1.5,
        ttl                = 22,
        texture            = [[groundflash]],
      },
    },
    groundflash_white = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.9 0.75 0.77   0 0 0 0.01]],
        size               = 110,
        sizegrowth         = 0,
        ttl                = 4,
        texture            = [[groundflash]],
      },
    },
    explosion = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = false,
      properties = {
        airdrag            = 0.82,
        colormap           = [[1 0.9 0.6 0.11   0.9 0.5 0.2 0.08   0.66 0.28 0.04 0.033   0 0 0 0]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1.1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 12,
        particlelife       = 2,
        particlelifespread = 15,
        particlesize       = 7.5,
        particlesizespread = 10,
        particlespeed      = 0.34,
        particlespeedspread = 3.9,
        pos                = [[0, 2, 0]],
        sizegrowth         = 0.4,
        sizemod            = 1,
        texture            = [[flashside2]],
        useairlos          = false,
      },
    },
	explosion_blur= {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = false,
      properties = {
        airdrag            = 0.8,
        colormap           = [[1.0 1.0 1.0 0.04	0.9 0.55 0.25 0.01	0.75 0.2 0.1 0.01	0 0 0 0.01]],
        directional        = true,
        emitrot            = 20,
        emitrotspread      = 10,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.05, 0]],
        numparticles       = 4,
        particlelife       = 7,
        particlelifespread = 5,
        particlesize       = 16,
        particlesizespread = 10,
        particlespeed      = 2,
        particlespeedspread = 9,
        pos                = [[0, 2, 0]],
        sizegrowth         = 0.3,
        sizemod            = 1,
        texture            = [[flashside1]],
        useairlos          = false,
      },
    },

    innersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.75,
        alwaysVisible = 0,
        sizeGrowth = 0.66,
        sizeMod = 1,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=33,
        emitRotSpread=50,
        emitVector = [[0, 1, 0]],
        gravity = [[0, 0.02, 0]],
        colormap=[[1 0.66 0.4 0.45    0.3 0.2 0.13 0.4   0.18 0.15 0.11 0.35    0.13 0.12 0.1 0.32   0.11 0.1 0.093 0.25   0.063 0.062 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife=30,
        particleLifeSpread=75,
        numparticles=6,
        particleSpeed=3.5,
        particleSpeedSpread=9,
        particleSize=11,
        particleSizeSpread=21,
        directional=0,
      },
    },
    outersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.6,
        alwaysVisible = 0,
        sizeGrowth = 0.35,
        sizeMod = 1,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=33,
        emitRotSpread=50,
        emitVector = [[0, 1, 0]],
        gravity = [[0, -0.02, 0]],
        colormap=[[1 0.66 0.4 0.45    0.3 0.2 0.13 0.4   0.18 0.15 0.11 0.35    0.13 0.12 0.1 0.32   0.11 0.1 0.093 0.25   0.063 0.062 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife=22,
        particleLifeSpread=50,
        numparticles=4,
        particleSpeed=5,
        particleSpeedSpread=8,
        particleSize=29,
        particleSizeSpread=21,
        directional=0,
      },
    },
    
    dirt = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      unit               = false,
      water              = false,
      air                = false,
      underwater         = false,
      properties = {
        airdrag            = 1,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66   0.1 0.07 0.033 0.58   0.1 0.07 0.033 0.5   0.1 0.07 0.033 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = 15,
        emitrotspread      = 36,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.33, 0]],
        numparticles       = 9,
        particlelife       = 26,
        particlelifespread = 5,
        particlesize       = 1.75,
        particlesizespread = -1.4,
        particlespeed      = 3.3,
        particlespeedspread = 3,
        pos                = [[0, 6, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
    dirt2 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = false,
      unit               = false,
      nounit             = true,
      water              = false,
      air                = false,
      underwater         = false,
      properties = {
        airdrag            = 1,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66   0.1 0.07 0.033 0.58   0.1 0.07 0.033 0.5   0.1 0.07 0.033 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = 1,
        emitrotspread      = 13,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.33, 0]],
        numparticles       = 5,
        particlelife       = 28,
        particlelifespread = 4,
        particlesize       = 1.8,
        particlesizespread = -1.4,
        particlespeed      = 3.6,
        particlespeedspread = 3.4,
        pos                = [[0, 6, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },

    clouddust = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.92,
        colormap           = [[0 0 0 0.01  0.025 0.02 0.02 0.033  0.06 0.055 0.055 0.072  0.043 0.04 0.04 0.055 0.0238 0.022 0.022 0.03  0 0 0 0.01]],
        directional        = false,
        emitrot            = 45,
        emitrotspread      = 4,
        emitvector         = [[0.5, 1, 0.5]],
        gravity            = [[0, 0.025, 0]],
        numparticles       = 2,
        particlelife       = 55,
        particlelifespread = 120,
        particlesize       = 60,
        particlesizespread = 40,
        particlespeed      = 1.2,
        particlespeedspread = 2.5,
        pos                = [[0, 4, 0]],
        sizegrowth         = 0.18,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke]],
      },
    },
    --grounddust = {
    --  air                = false,
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  unit               = false,
    --  properties = {
    --    airdrag            = 0.91,
    --    colormap           = [[0.075 0.075 0.075 0.11 	0 0 0 0.0]],
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = -2,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, 0.005, 0]],
    --    numparticles       = 20,
    --    particlelife       = 20,
    --    particlelifespread = 30,
    --    particlesize       = 4,
    --    particlesizespread = 2.5,
    --    particlespeed      = 5.5,
    --    particlespeedspread = 1.4,
    --    pos                = [[0, 4, 0]],
    --    sizegrowth         = 0.55,
    --    sizemod            = 1.0,
    --    texture            = [[bigexplosmoke]],
    --  },
    --},
    --grounddust2 = {
    --  air                = false,
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  unit               = false,
    --  properties = {
    --    airdrag            = 0.91,
    --    colormap           = [[0.09 0.09 0.09 0.13 	0 0 0 0.0]],
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = -2,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, 0.005, 0]],
    --    numparticles       = 11,
    --    particlelife       = 11,
    --    particlelifespread = 55,
    --    particlesize       = 13,
    --    particlesizespread = 6,
    --    particlespeed      = 1.4,
    --    particlespeedspread = 6.2,
    --    pos                = [[0, 4, 0]],
    --    sizegrowth         = 0.55,
    --    sizemod            = 1.0,
    --    texture            = [[bigexplosmoke]],
    --  },
    --},
    outerflash = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater         = true,
      properties = {
        heat               = 14,
        heatfalloff        = 1.3,
        maxheat            = 40,
        pos                = [[r-2 r2, 4, r-2 r2]],
        size               = 15,
        sizegrowth         = 1.1,
        speed              = [[0, 1 0, 0]],
        texture            = [[orangenovaexplo]],
      },
    },
    --kickedupwater = {
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  water              = true,
    --  underwater         = true,
    --  properties = {
    --    airdrag            = 0.87,
    --    colormap           = [[0.7 0.7 0.9 0.35	0 0 0 0.0]],
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = 5,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, 0.1, 0]],
    --    numparticles       = 120,
    --    particlelife       = 2,
    --    particlelifespread = 30,
    --    particlesize       = 2,
    --    particlesizespread = 1,
    --    particlespeed      = 10,
    --    particlespeedspread = 6,
    --    pos                = [[0, 1, 0]],
    --    sizegrowth         = 0.5,
    --    sizemod            = 1.0,
    --    texture            = [[wake]],
    --  },
    --},
  },

  [root.."-huge"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater         = true,
      properties = {
        heat               = 12,
        heatfalloff        = 1.3,
        maxheat            = 20,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 3,
        sizegrowth         = 14,
        speed              = [[0, 1 0, 0]],
        texture            = [[flare]],
      },
    },
    groundflash_small = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.7 0.3 0.34   0 0 0 0.01]],
        size               = 140,
        sizegrowth         = -2,
        ttl                = 25,
        texture            = [[groundflash]],
      },
    },
    groundflash_large = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.7 0.3 0.11   0 0 0 0.01]],
        size               = 240,
        sizegrowth         = -2,
        ttl                = 25,
        texture            = [[groundflash]],
      },
    },
    groundflash_white = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.9 0.75 0.85   0 0 0 0.01]],
        size               = 180,
        sizegrowth         = 0,
        ttl                = 5,
        texture            = [[groundflash]],
      },
    },
    explosion = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = false,
      properties = {
        airdrag            = 0.82,
        colormap           = [[0 0 0 0   1 0.9 0.6 0.09   0.9 0.5 0.2 0.066   0.66 0.28 0.04 0.033   0 0 0 0]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1.1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 16,
        particlelife       = 2,
        particlelifespread = 16,
        particlesize       = 16,
        particlesizespread = 18,
        particlespeed      = 0.5,
        particlespeedspread = 6,
        pos                = [[0, 2, 0]],
        sizegrowth         = 0,
        sizemod            = 1,
        texture            = [[flashside2]],
        useairlos          = false,
      },
    },
	explosion_blur= {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = false,
      properties = {
        airdrag            = 0.8,
        colormap           = [[1.0 1.0 1.0 0.04	0.9 0.55 0.25 0.01	0.75 0.2 0.1 0.01	0 0 0 0.01]],
        directional        = true,
        emitrot            = 20,
        emitrotspread      = 10,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.05, 0]],
        numparticles       = 4,
        particlelife       = 8,
        particlelifespread = 5,
        particlesize       = 18,
        particlesizespread = 10,
        particlespeed      = 2,
        particlespeedspread = 9,
        pos                = [[0, 2, 0]],
        sizegrowth         = 0.3,
        sizemod            = 1,
        texture            = [[flashside1]],
        useairlos          = false,
      },
    },

    innersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.66,
        alwaysVisible = 0,
        sizeGrowth = 0.8,
        sizeMod = 1,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=20,
        emitRotSpread=40,
        emitVector = [[0, 1, 0]],
        gravity = [[0, 0.02, 0]],
        colormap=[[1 0.66 0.4 0.45    0.3 0.2 0.13 0.4   0.18 0.15 0.11 0.35    0.13 0.12 0.1 0.32   0.11 0.1 0.093 0.25   0.063 0.062 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife=50,
        particleLifeSpread=110,
        numparticles=5,
        particleSpeed=6,
        particleSpeedSpread=22,
        particleSize=14,
        particleSizeSpread=15,
        directional=0,
      },
    },
    outersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.66,
        alwaysVisible = 0,
        sizeGrowth = -0.11,
        sizeMod = 1,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=25,
        emitRotSpread=40,
        emitVector = [[0, 1, 0]],
        gravity = [[0, -0.02, 0]],
        colormap=[[1 0.66 0.4 0.45    0.3 0.2 0.13 0.4   0.18 0.15 0.11 0.35    0.13 0.12 0.1 0.32   0.11 0.1 0.093 0.25   0.063 0.062 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife=25,
        particleLifeSpread=90,
        numparticles=4,
        particleSpeed=15,
        particleSpeedSpread=14,
        particleSize=40,
        particleSizeSpread=20,
        directional=0,
      },
    },

    dirt = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      unit               = false,
      water              = false,
      air                = false,
      underwater         = false,
      properties = {
        airdrag            = 1,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66   0.1 0.07 0.033 0.58   0.1 0.07 0.033 0.5   0.1 0.07 0.033 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = 16,
        emitrotspread      = 36,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.33, 0]],
        numparticles       = 5,
        particlelife       = 36,
        particlelifespread = 9,
        particlesize       = 2,
        particlesizespread = -1.3,
        particlespeed      = 3.9,
        particlespeedspread = 4,
        pos                = [[0, 6, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
    dirt2 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      unit               = false,
      water              = false,
      air                = false,
      underwater         = false,
      properties = {
        airdrag            = 1,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66   0.1 0.07 0.033 0.58   0.1 0.07 0.033 0.5   0.1 0.07 0.033 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = -5,
        emitrotspread      = 13,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.33, 0]],
        numparticles       = 4,
        particlelife       = 38,
        particlelifespread = 9,
        particlesize       = 1.85,
        particlesizespread = -1.3,
        particlespeed      = 3.8,
        particlespeedspread = 4.5,
        pos                = [[0, 6, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
	shockwave = {
     class              = [[CSpherePartSpawner]],
            count              = 1,
            ground             = true,
            water              = true,
            underwater         = true,
            air                = true,
				properties = {
                alpha           = 0.07,
                ttl             = 19.5,
                expansionSpeed  = 5,
                color           = [[1.0, 1.0, 1.0]],
                alwaysvisible      = true,
            },
	},
	


    clouddust = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.92,
        colormap           = [[0 0 0 0.01  0.025 0.02 0.02 0.033  0.06 0.055 0.055 0.072  0.043 0.04 0.04 0.055 0.0238 0.022 0.022 0.03  0 0 0 0.01]],
        directional        = false,
        emitrot            = 45,
        emitrotspread      = 4,
        emitvector         = [[0.5, 1, 0.5]],
        gravity            = [[0, 0.025, 0]],
        numparticles       = 2,
        particlelife       = 70,
        particlelifespread = 113,
        particlesize       = 90,
        particlesizespread = 55,
        particlespeed      = 2,
        particlespeedspread = 2.7,
        pos                = [[0, 4, 0]],
        sizegrowth         = 0.18,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke]],
      },
    },
    --grounddust = {
    --  air                = false,
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  unit               = false,
    --  properties = {
    --    airdrag            = 0.85,
	--			colormap           = [[0.07 0.07 0.07 0.1 	0 0 0 0.0]],
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = -2,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, 0.01, 0]],
    --    numparticles       = 55,
    --    particlelife       = 12,
    --    particlelifespread = 70,
    --    particlesize       = 4,
    --    particlesizespread = 1.6,
    --    particlespeed      = 9,
    --    particlespeedspread = 2.6,
    --    pos                = [[0, 4, 0]],
    --    sizegrowth         = 0.6,
    --    sizemod            = 1.0,
    --    texture            = [[bigexplosmoke]],
    --  },
    --},
    groundclouddust = {
      air                = false,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      unit               = false,
      properties = {
        airdrag            = 0.85,
        colormap           = [[0.14 0.14 0.14 0.18 	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = -2,
        emitvector         = [[0.22, 1, 0.22]],
        gravity            = [[0, 0, 0]],
        numparticles       = 5,
        particlelife       = 20,
        particlelifespread = 80,
        particlesize       = 17,
        particlesizespread = 5,
        particlespeed      = 0.8,
        particlespeedspread = 6.5,
        pos                = [[0, 4, 0]],
        sizegrowth         = 0.28,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke]],
      },
    },
    outerflash = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true, 
	  underwater         = true,
      properties = {
        heat               = 15,
        heatfalloff        = 1.3,
        maxheat            = 40,
        pos                = [[r-2 r2, 4, r-2 r2]],
        size               = 25,
        sizegrowth         = 1.1,
        speed              = [[0, 1 0, 0]],
        texture            = [[orangenovaexplo]],
      },
    },
  },
  
  
  [root.."-reap"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater         = true,
      properties = {
        heat               = 12,
        heatfalloff        = 1.3,
        maxheat            = 20,
        pos                = [[r-2 r2, 3, r-2 r2]],
        size               = 1,
        sizegrowth         = 6.5,
        speed              = [[0, 1 0, 0]],
        texture            = [[flare]],
      },
    },
    groundflash_small = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.7 0.3 0.38   0 0 0 0.01]],
        size               = 30,
        sizegrowth         = -1,
        ttl                = 17,
        texture            = [[groundflash]],
      },
    },
    groundflash_large = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.7 0.3 0.12   0 0 0 0.01]],
        size               = 40,
        sizegrowth         = -1,
        ttl                = 17,
        texture            = [[groundflash]],
      },
    },
    groundflash_white = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.9 0.85 1.9   0 0 0 0.01]],
        size               = 36,
        sizegrowth         = 4,
        ttl                = 4,
        texture            = [[groundflash]],
      },
    },

    explosion = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = false,
      properties = {
        airdrag            = 0.8,
        colormap           = [[0 0 0 0   1 0.9 0.6 0.12   0.9 0.5 0.2 0.09   0.66 0.28 0.04 0.04   0 0 0 0]],
        directional        = true,
        emitrot            = 40,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 5,
        particlelife       = 4,
        particlelifespread = 6,
        particlesize       = 3,
        particlesizespread = 3,
        particlespeed      = 0.5,
        particlespeedspread = 2,
        pos                = [[0, 2, 0]],
        sizegrowth         = 0.3,
        sizemod            = 1,
        texture            = [[flashside2]],
        useairlos          = false,
		
      },
    },
	explosion_blur= {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = false,
      properties = {
        airdrag            = 0.8,
        colormap           = [[1.0 1.0 1.0 0.04	0.9 0.55 0.25 0.01	0.75 0.2 0.1 0.01	0 0 0 0.01]],
        directional        = true,
        emitrot            = 20,
        emitrotspread      = 10,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.05, 0]],
        numparticles       = 2,
        particlelife       = 4,
        particlelifespread = 5,
        particlesize       = 5,
        particlesizespread = 3,
        particlespeed      = 2,
        particlespeedspread = 5,
        pos                = [[0, 2, 0]],
        sizegrowth         = 0.3,
        sizemod            = 1,
        texture            = [[flashside1]],
        useairlos          = false,
      },
    },

    innersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.75,
        alwaysVisible = 0,
        sizeGrowth = 0.5,
        sizeMod = 1.0,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=33,
        emitRotSpread=50,
        emitVector = [[0, 1, 0]],
        gravity = [[0, 0.02, 0]],
        colormap=[[1 0.66 0.4 0.45    0.3 0.2 0.13 0.4   0.18 0.15 0.11 0.35    0.13 0.12 0.1 0.32   0.11 0.1 0.093 0.25   0.063 0.062 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife=3,
        particleLifeSpread=50,
        numparticles=3,
        particleSpeed=1.5,
        particleSpeedSpread=4.5,
        particleSize=4,
        particleSizeSpread=12,
        directional=0,
      },
    },
    outersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.2,
        alwaysVisible = 0,
        sizeGrowth = 0.35,
        sizeMod = 1.0,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=33,
        emitRotSpread=50,
        emitVector = [[0, 1, 0]],
        gravity = [[0, -0.02, 0]],
        colormap=[[1 0.66 0.4 0.45    0.3 0.2 0.13 0.4   0.18 0.15 0.11 0.35    0.13 0.12 0.1 0.32   0.11 0.1 0.093 0.25   0.063 0.062 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife=2.9,
        particleLifeSpread=40,
        numparticles=3,
        particleSpeed=2.5,
        particleSpeedSpread=5.5,
        particleSize=3,
        particleSizeSpread=10,
        directional=0,
      },
    },

	
    dirt = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = false,
      air                = false,
      ground             = true,
      unit               = false,
      underwater         = false,
      properties = {
        airdrag            = 0.97,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66   0.1 0.07 0.033 0.58   0.1 0.07 0.033 0.5   0.1 0.07 0.033 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = 18,
        emitrotspread      = 33,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.3, 0]],
        numparticles       = 6,
        particlelife       = 2.8,
        particlelifespread = 5,
        particlesize       = 1.5,
        particlesizespread = -1.15,
        particlespeed      = 2.95,
        particlespeedspread = 2.9,
        pos                = [[0, 3, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
    dirt2 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = false,
      air                = false,
      ground             = false,
      unit               = false,
      nounit             = true,
      underwater         = false,
      properties = {
        airdrag            = 0.97,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66   0.1 0.07 0.033 0.58   0.1 0.07 0.033 0.5   0.1 0.07 0.033 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = -5,
        emitrotspread      = 13,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.3, 0]],
        numparticles       = 2.5,
        particlelife       = 3,
        particlelifespread = 5,
        particlesize       = 1.55,
        particlesizespread = -1.2,
        particlespeed      = 2.5,
        particlespeedspread = 4.3,
        pos                = [[0, 3, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },

    clouddust = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.85,
        colormap           = [[0 0 0 0.01   0.025 0.025 0.025 0.033  0.06 0.06 0.06 0.08  0.05 0.05 0.05 0.065  0.026 0.026 0.026 0.035  0 0 0 0.01]],
        directional        = false,
        emitrot            = 45,
        emitrotspread      = 4,
        emitvector         = [[0.5, 1, 0.5]],
        gravity            = [[0, 0.02, 0]],
        numparticles       = 1,
        particlelife       = 4,
        particlelifespread = 80,
        particlesize       = 5,
        particlesizespread = 17,
        particlespeed      = 0.8,
        particlespeedspread = 2.2,
        pos                = [[0, 4, 0]],
        sizegrowth         = 0.22,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke]],
      },
    },
    --grounddust = {
    --  air                = false,
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  unit               = false,
    --  properties = {
    --    airdrag            = 0.89,
    --    colormap           = [[0.07 0.07 0.07 0.1 	0 0 0 0.0]],
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = -2,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, 0.015, 0]],
    --    numparticles       = 18,
    --    particlelife       = 25,
    --    particlelifespread = 45,
    --    particlesize       = 4.25,
    --    particlesizespread = 2.25,
    --    particlespeed      = 2.8,
    --    particlespeedspread = 1.4,
    --    pos                = [[0, 5, 0]],
    --    sizegrowth         = 0.2,
    --    sizemod            = 1.0,
    --    texture            = [[bigexplosmoke]],
    --  },
    --},
    outerflash = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater         = true,
      properties = {
        heat               = 8,
        heatfalloff        = 1.5,
        maxheat            = 25,
        pos                = [[r-2 r2, 4, r-2 r2]],
        size               = 7,
        sizegrowth         = 0.7,
        speed              = [[0, 1 0, 0]],
        texture            = [[orangenovaexplo]],
      },
    },
	
    --kickedupwater = {
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  water              = true,
    --  underwater         = true,
    --  properties = {
    --    airdrag            = 0.87,
    --    colormap           = [[0.7 0.7 0.9 0.35	0 0 0 0.0]],
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = 5,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, 0.1, 0]],
    --    numparticles       = 120,
    --    particlelife       = 2,
    --    particlelifespread = 30,
    --    particlesize       = 1,
    --    particlesizespread = 1,
    --    particlespeed      = 10,
    --    particlespeedspread = 6,
    --    pos                = [[0, 1, 0]],
    --    sizegrowth         = 0.5,
    --    sizemod            = 1.0,
    --    texture            = [[wake]],
    --  },
    --},
  },
	
	
	[root.."-missile"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater         = true,
      properties = {
        heat               = 12,
        heatfalloff        = 1.3,
        maxheat            = 20,
        pos                = [[r-2 r2, 3, r-2 r2]],
        size               = 1.5,
        sizegrowth         = 6.5,
        speed              = [[0, 1 0, 0]],
        texture            = [[flare]],
      },
    },
   

	explosion_blur= {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = false,
      properties = {
        airdrag            = 0.8,
        colormap           = [[1.0 1.0 1.0 0.04	0.9 0.55 0.25 0.01	0.75 0.2 0.1 0.01	0 0 0 0.01]],
        directional        = true,
        emitrot            = 20,
        emitrotspread      = 10,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.05, 0]],
        numparticles       = 5,
        particlelife       = 10,
        particlelifespread = 5,
        particlesize       = 13,
        particlesizespread = 5,
        particlespeed      = 2,
        particlespeedspread = 10,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1,
        sizemod            = 1,
        texture            = [[flashside1]],
        useairlos          = false,
      },
    },

    innersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.75,
        alwaysVisible = 0,
        sizeGrowth = 0.66,
        sizeMod = 1,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=33,
        emitRotSpread=50,
        emitVector = [[0, 1, 0]],
        gravity = [[0, 0.02, 0]],
        colormap=[[1 0.66 0.4 0.45    0.3 0.2 0.13 0.4   0.18 0.15 0.11 0.35    0.13 0.12 0.1 0.32   0.11 0.1 0.093 0.25   0.063 0.062 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife=16,
        particleLifeSpread=40,
        numparticles=2,
        particleSpeed=3.5,
        particleSpeedSpread=9,
        particleSize=11,
        particleSizeSpread=21,
        directional=0,
      },
    },
	

    outersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.6,
        alwaysVisible = 0,
        sizeGrowth = 0.35,
        sizeMod = 1,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=33,
        emitRotSpread=50,
        emitVector = [[0, 1, 0]],
        gravity = [[0, -0.02, 0]],
        colormap=[[1 0.66 0.4 0.45    0.3 0.2 0.13 0.4   0.18 0.15 0.11 0.35    0.13 0.12 0.1 0.32   0.11 0.1 0.093 0.25   0.063 0.062 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife=16,
        particleLifeSpread=50,
        numparticles=2,
        particleSpeed=5,
        particleSpeedSpread=8,
        particleSize=27,
        particleSizeSpread=21,
        directional=0,
      },
    },

    dirt = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = false,
      air                = false,
      ground             = true,
      unit               = false,
      underwater         = false,
      properties = {
        airdrag            = 0.97,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66   0.1 0.07 0.033 0.58   0.1 0.07 0.033 0.5   0.1 0.07 0.033 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = 18,
        emitrotspread      = 33,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.3, 0]],
        numparticles       = 6,
        particlelife       = 4,
        particlelifespread = 5,
        particlesize       = 1.5,
        particlesizespread = -1.15,
        particlespeed      = 2.95,
        particlespeedspread = 2.9,
        pos                = [[0, 3, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
    dirt2 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = false,
      air                = false,
      ground             = false,
      unit               = false,
      nounit             = true,
      underwater         = false,
      properties = {
        airdrag            = 0.97,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66   0.1 0.07 0.033 0.58   0.1 0.07 0.033 0.5   0.1 0.07 0.033 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = -5,
        emitrotspread      = 13,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.3, 0]],
        numparticles       = 2.5,
        particlelife       = 4,
        particlelifespread = 5,
        particlesize       = 1.55,
        particlesizespread = -1.2,
        particlespeed      = 2.5,
        particlespeedspread = 4.3,
        pos                = [[0, 3, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
    clouddust = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.85,
        colormap           = [[0 0 0 0.01   0.025 0.025 0.025 0.033  0.06 0.06 0.06 0.08  0.05 0.05 0.05 0.065  0.026 0.026 0.026 0.035  0 0 0 0.01]],
        directional        = false,
        emitrot            = 45,
        emitrotspread      = 4,
        emitvector         = [[0.5, 1, 0.5]],
        gravity            = [[0, 0.02, 0]],
        numparticles       = 1,
        particlelife       = 7,
        particlelifespread = 40,
        particlesize       = 8,
        particlesizespread = 22,
        particlespeed      = 0.8,
        particlespeedspread = 2.2,
        pos                = [[0, 4, 0]],
        sizegrowth         = 0.22,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke]],
      },
    },
    --grounddust = {
    --  air                = false,
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  unit               = false,
    --  properties = {
    --    airdrag            = 0.89,
    --    colormap           = [[0.07 0.07 0.07 0.1 	0 0 0 0.0]],
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = -2,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, 0.015, 0]],
    --    numparticles       = 18,
    --    particlelife       = 25,
    --    particlelifespread = 45,
    --    particlesize       = 4.25,
    --    particlesizespread = 2.25,
    --    particlespeed      = 2.8,
    --    particlespeedspread = 1.4,
    --    pos                = [[0, 5, 0]],
    --    sizegrowth         = 0.2,
    --    sizemod            = 1.0,
    --    texture            = [[bigexplosmoke]],
    --  },
    --},
    outerflash = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater         = true,
      properties = {
        heat               = 9,
        heatfalloff        = 1.5,
        maxheat            = 40,
        pos                = [[r-2 r2, 4, r-2 r2]],
        size               = 12,
        sizegrowth         = 0.55,
        speed              = [[0, 1 0, 0]],
        texture            = [[orangenovaexplo]],
      },
    },
    --kickedupwater = {
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  water              = true,
    --  underwater         = true,
    --  properties = {
    --    airdrag            = 0.87,
    --    colormap           = [[0.7 0.7 0.9 0.35	0 0 0 0.0]],
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = 5,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, 0.1, 0]],
    --    numparticles       = 120,
    --    particlelife       = 2,
    --    particlelifespread = 30,
    --    particlesize       = 1,
    --    particlesizespread = 1,
    --    particlespeed      = 10,
    --    particlespeedspread = 6,
    --    pos                = [[0, 1, 0]],
    --    sizegrowth         = 0.5,
    --    sizemod            = 1.0,
    --    texture            = [[wake]],
    --  },
    --},
  },

}




function tableMerge(t1, t2)
    for k,v in pairs(t2) do
    	if type(v) == "table" then
    		if type(t1[k] or false) == "table" then
    			tableMerge(t1[k] or {}, t2[k] or {})
    		else
    			t1[k] = v
    		end
    	else
    		t1[k] = v
    	end
    end
    return t1
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- add different sizes
definitions[root] = definitions[root.."-small"]
local sizes = {
    tiny = {

    },

    small = {

    },
	
	medium = {
	
	},
	
	large = {
	
	},
	
	huge = {
	
	},
}
for size, effects in pairs(sizes) do
  --definitions[root.."-"..size] = tableMerge(deepcopy(definitions[root.."-small"]), deepcopy(effects))
  definitions[root.."-"..size].explosion.properties.numparticles = math.ceil(definitions[root.."-"..size].explosion.properties.numparticles/1.7)
  definitions[root.."-"..size].explosion2 = deepcopy(definitions[root.."-"..size].explosion)
  definitions[root.."-"..size].explosion2.properties.colormap = [[1 0.33 0 0.1   0.5 0.15 0 0.05   0.07 0.03 0 0.02   0 0 0 0]]
  definitions[root.."-"..size].explosion2.properties.numparticles = definitions[root.."-"..size].explosion.properties.numparticles-1
end

-- add coloring
local colors = {
  air = {
    groundflash_small = false,
    groundflash_large = false,
    groundflash_white = false,
    underwaterexplosionsparks = false,
    kickedupwater = false,
    dirt = false,
    dirt2 = false,
    --grounddust = false,
    centerflare = {air=false, ground=false, water=false, unit=true},
    clouddust = {air=false, ground=false, water=false, unit=true},
    explosion = {air=false, ground=false, water=false, unit=true},
    explosion2 = {air=false, ground=false, water=false, unit=true},
    outerflash = {air=false, ground=false, water=false, unit=true},
  },
  aa = {
    groundflash_small = false,
    groundflash_large = false,
    groundflash_white = false,
    underwaterexplosionsparks = false,
    kickedupwater = false,
    dirt = false,
    dirt2 = false,
    --grounddust = false,
    centerflare = {ground=false, water=false},
    clouddust = {ground=false, water=false},
    explosion = {ground=false, water=false, properties={colormap=[[0 0 0 0   1 0.9 0.8 0.09   0.9 0.5 0.55 0.066   0.66 0.28 0.35 0.033   0 0 0 0]]}},
    explosion2 = {ground=false, water=false, properties={colormap=[[0 0 0 0   1 0.6 0.4 0.09   0.6 0.3 0.45 0.066   0.46 0.18 0.25 0.033   0 0 0 0]]}},
    outerflash = {ground=false, water=false},
  },
  uw = {
    groundflash_small = false,
    groundflash_large = false,
    groundflash_white = false,
    underwaterexplosionsparks = false,
    kickedupwater = false,
    explosion = {ground=false, water=false, air=false, underwater=true, properties={colormap=[[0 0 0 0   1 0.75 0.9 0.09   0.45 0.4 0.66 0.066   0.33 0.3 0.05 0.033   0 0 0 0]]}},
    explosion2 = {ground=false, water=false, air=false, underwater=true, properties={colormap=[[0 0 0 0   1 0.5 0.7 0.09   0.3 0.27 0.44 0.066   0.22 0.2 0.03 0.033   0 0 0 0]]}},
    dirt = false,
    dirt2 = false,
  },
  bomb = {
    explosion = {properties={colormap=[[0 0 0 0   1 0.62 0.38 0.09   0.7 0.27 0.1 0.066   0.5 0.15 0.025 0.033   0 0 0 0]]}},
    explosion2 = {properties={colormap=[[0 0 0 0   1 0.32 0.18 0.09   0.7 0.17 0.05 0.066   0.3 0.08 0.015 0.033   0 0 0 0]]}},
    innersmoke = {properties={colormap=[[1 0.6 0.4 0.4    0.5 0.24 0.14 0.5   0.27 0.17 0.13 0.42    0.21 0.16 0.14 0.35   0.105 0.095 0.088 0.25   0.07 0.064 0.058 0.17    0 0 0 0.01]]}},
    outersmoke = {properties={colormap=[[1 0.58 0.36 0.4    0.48 0.24 0.14 0.45   0.26 0.16 0.13 0.4    0.2 0.16 0.14 0.35   0.1 0.09 0.088 0.25   0.07 0.063 0.058 0.17    0 0 0 0.01]]}},
    groundflash_small = {properties={colormap=[[1 0.47 0.25 0.08   0 0 0 0.01]]}},
    groundflash_large = {properties={colormap=[[1 0.47 0.25 0.08   0 0 0 0.01]]}},
  }
}
for color, effects in pairs(colors) do
  for size, e in pairs(sizes) do
  	definitions[root.."-"..size.."-"..color] = tableMerge(deepcopy(definitions[root.."-"..size]), deepcopy(effects))
    for pname, defs in pairs(effects) do
      if defs == false then
        definitions[root.."-"..size.."-"..color][pname] = nil
      end
    end
  end
end

-- adjust ceg used for flak
definitions[root.."-large-aa"].explosion.properties.particlesize = definitions[root.."-large-aa"].explosion.properties.particlesize * 0.5
definitions[root.."-large-aa"].explosion.properties.numparticles = math.floor(definitions[root.."-large-aa"].explosion.properties.numparticles * 0.5)
definitions[root.."-large-aa"].explosion2.properties.particlesize = definitions[root.."-large-aa"].explosion2.properties.particlesize * 0.5
definitions[root.."-large-aa"].explosion2.properties.numparticles = math.floor(definitions[root.."-large-aa"].explosion2.properties.numparticles * 0.5)


-- adjust for beam weapons
local devideBy = 12
for size, e in pairs(sizes) do
	local defname = root.."-"..size.."-beam"
	definitions[defname] = deepcopy(definitions[root.."-"..size])
    definitions[defname].clouddust = nil
    if definitions[defname].groundclouddust ~= nil then
        definitions[defname].groundclouddust.properties.numparticles = nil
    end
    definitions[defname].groundflash_small.colormap    = [[0.5 0.35 0.15 0.02   0 0 0 0.01]]
    definitions[defname].groundflash_large.colormap    = [[0.5 0.35 0.15 0.01   0 0 0 0.01]]
    definitions[defname].groundflash_white = false
	definitions[defname].centerflare.properties.heat = math.ceil(definitions[defname].centerflare.properties.heat / devideBy)
	definitions[defname].centerflare.properties.maxheat = math.ceil(definitions[defname].centerflare.properties.maxheat / devideBy)
    definitions[defname].explosion.properties.numparticles = [[0 r1.05]]
    definitions[defname].explosion2.properties.numparticles = [[0 r1.05]]
    definitions[defname].dirt.properties.numparticles = [[0 r2.1]]
    definitions[defname].dirt2.properties.numparticles = [[0 r2.1]]


    if definitions[defname].innersmoke ~= nil then
        definitions[defname].innersmoke.properties.numparticles = [[0 r1.7]]
    end
    if definitions[defname].outersmoke ~= nil then
      definitions[defname].outersmoke.properties.numparticles = [[0 r1.3]]
    end
    --if definitions[defname].grounddust ~= nil then
    --  definitions[defname].grounddust.properties.particlespeed = definitions[defname].grounddust.properties.particlespeed / 2
    --  definitions[defname].grounddust.properties.particlespeedspread = definitions[defname].grounddust.properties.particlespeedspread * 2
    --  definitions[defname].grounddust.properties.numparticles = math.ceil(definitions[defname].grounddust.properties.numparticles / 5)
    --end
end

definitions['antinukeexplosion'] = deepcopy(definitions[root.."-large"])

definitions['genericshellexplosion-debris'] = deepcopy(definitions[root.."-tiny"])
definitions['genericshellexplosion-debris'].explosion.properties.colormap = [[0 0 0 0   1 0.77 0.44 0.06   0.75 0.38 0.14 0.045   0.55 0.22 0.04 0.02   0 0 0 0]]
definitions['genericshellexplosion-debris'].explosion.properties.numparticles = 3
definitions['genericshellexplosion-debris'].explosion.properties.particlesize = 0.44
definitions['genericshellexplosion-debris'].explosion.properties.particlesizespread = 0.6
definitions['genericshellexplosion-debris'].explosion.properties.particlespeed = 0.35
definitions['genericshellexplosion-debris'].explosion.properties.particlespeedspread = 1.1
definitions['genericshellexplosion-debris'].innersmoke.properties.particleLife = 7
definitions['genericshellexplosion-debris'].innersmoke.properties.particleLifeSpread = 10
definitions['genericshellexplosion-debris'].innersmoke.properties.particlesize = 4
definitions['genericshellexplosion-debris'].innersmoke.properties.particlesizespread = 2.2
definitions['genericshellexplosion-debris'].innersmoke.properties.particlespeedspread = 1.2
definitions['genericshellexplosion-debris'].groundflash_small.properties.colormap = [[1 0.6 0.25 0.2   0 0 0 0.01]]
definitions['genericshellexplosion-debris'].groundflash_small.properties.size = 13
definitions['genericshellexplosion-debris'].groundflash_small.properties.ttl = 9
definitions['genericshellexplosion-debris'].explosion2 = nil
definitions['genericshellexplosion-debris'].outersmoke = nil
definitions['genericshellexplosion-debris'].groundflash_large = nil
definitions['genericshellexplosion-debris'].centerflare = nil
definitions['genericshellexplosion-debris'].dirt = nil
definitions['genericshellexplosion-debris'].dirt2 = nil
definitions['genericshellexplosion-debris'].clouddust = nil
definitions['genericshellexplosion-debris'].outerflash = nil

definitions['genericshellexplosion-debris2'] = deepcopy(definitions[root.."-debris"])
definitions['genericshellexplosion-debris2'].explosion.properties.numparticles = 2
definitions['genericshellexplosion-debris2'].explosion.properties.particlesize = 0.35
definitions['genericshellexplosion-debris2'].explosion.properties.particlesizespread = 0.45
definitions['genericshellexplosion-debris2'].explosion.properties.particlespeed = 0.25
definitions['genericshellexplosion-debris2'].explosion.properties.particlespeedspread = 0.66
definitions['genericshellexplosion-debris2'].explosion2 = nil

definitions['genericshellexplosion-catapult'] = deepcopy(definitions[root.."-large-bomb"])
definitions['genericshellexplosion-catapult'].explosion.properties.numparticles = 4
definitions['genericshellexplosion-catapult'].explosion.properties.colormap = [[0 0 0 0   1 0.45 0.25 0.09   0.75 0.35 0.15 0.066   0.44 0.25 0.06 0.033   0 0 0 0]]
definitions['genericshellexplosion-catapult'].explosion2.properties.numparticles = 4
definitions['genericshellexplosion-catapult'].explosion2.properties.colormap = [[0 0 0 0   1 0.38 0.1 0.09   0.55 0.22 0.05 0.066   0.25 0.08 0.03 0.033   0 0 0 0]]
definitions['genericshellexplosion-catapult'].dirt.properties.numparticles = 2
definitions['genericshellexplosion-catapult'].dirt2.properties.numparticles = 2
definitions['genericshellexplosion-catapult'].clouddust.properties.numparticles = 1

definitions['genericshellexplosion-fat'] = deepcopy(definitions[root.."-large"])
definitions['genericshellexplosion-fat'].groundflash_white.properties.colormap    = [[1 0.9 0.80 3   0 0 0 0.01]]
definitions['genericshellexplosion-fat'].groundflash_white.properties.size    = 100
definitions['genericshellexplosion-fat'].groundflash_white.properties.sizegrowth    = 3
definitions['genericshellexplosion-fat'].groundflash_white.properties.ttl    = 7
definitions['genericshellexplosion-fat'].groundflash_white.properties.texture    = [[groundflash]]

definitions["genericshellexplosion-fat"].shockwave = {
	 class              = [[CSpherePartSpawner]],
            count              = 1,
            ground             = true,
            water              = true,
            underwater         = true,
            air                = true,
	properties = {
                alpha           = 0.07,
                ttl             = 18,
                expansionSpeed  = 5,
                color           = [[1.0, 1.0, 1.0]],
                alwaysvisible      = true,
            },
}

definitions['genericshellexplosion-riot'] = deepcopy(definitions[root.."-medium"])
definitions['genericshellexplosion-riot'].groundflash_white.properties.colormap    = [[1 0.9 0.85 1.9   0 0 0 0.01]]
definitions['genericshellexplosion-riot'].groundflash_white.properties.size    = 42
definitions['genericshellexplosion-riot'].groundflash_white.properties.sizegrowth    = 4
definitions['genericshellexplosion-riot'].groundflash_white.properties.ttl    = 6
definitions['genericshellexplosion-riot'].groundflash_white.properties.texture    = [[groundflash]]

definitions['genericshellexplosion-croc'] = deepcopy(definitions[root.."-small"])
definitions['genericshellexplosion-croc'].groundflash_white.properties.colormap    = [[1 0.9 0.85 1.9   0 0 0 0.01]]
definitions['genericshellexplosion-croc'].groundflash_white.properties.size    = 22
definitions['genericshellexplosion-croc'].groundflash_white.properties.sizegrowth    = 4
definitions['genericshellexplosion-croc'].groundflash_white.properties.ttl    = 4
definitions['genericshellexplosion-croc'].groundflash_white.properties.texture    = [[groundflash]]

definitions['genericshellexplosion-bull'] = deepcopy(definitions[root.."-medium"])
definitions['genericshellexplosion-bull'].groundflash_white.properties.colormap    = [[1 0.9 0.85 1.9   0 0 0 0.01]]
definitions['genericshellexplosion-bull'].groundflash_white.properties.size    = 60
definitions['genericshellexplosion-bull'].groundflash_white.properties.sizegrowth    = 4
definitions['genericshellexplosion-bull'].groundflash_white.properties.ttl    = 6
definitions['genericshellexplosion-bull'].groundflash_white.properties.texture    = [[groundflash]]
-- definitions['genericshellexplosion-bull'].usedefaultexplosions=1

definitions['genericshellexplosion-battleshiplarge'] = deepcopy(definitions[root.."-large"])
definitions['genericshellexplosion-battleshiplarge'].outerflash.properties.heat  = 9
definitions['genericshellexplosion-battleshiplarge'].outerflash.properties.heatfalloff  = 1.5
definitions['genericshellexplosion-battleshiplarge'].outerflash.properties.maxheat = 40
definitions['genericshellexplosion-battleshiplarge'].outerflash.properties.pos    = [[r-2 r2, 4, r-2 r2]]
definitions['genericshellexplosion-battleshiplarge'].outerflash.properties.size   = 12
definitions['genericshellexplosion-battleshiplarge'].outerflash.properties.sizegrowth = 0.55
definitions['genericshellexplosion-battleshiplarge'].outerflash.properties.speed  = [[0, 1 0, 0]]



definitions['genericshellexplosion-battleshiplarge'].innersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.75,
        alwaysVisible = 0,
        sizeGrowth = 0.66,
        sizeMod = 1,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=33,
        emitRotSpread=50,
        emitVector = [[0, 1, 0]],
        gravity = [[0, 0.02, 0]],
        colormap=[[1 0.66 0.4 0.45    0.3 0.2 0.13 0.4   0.18 0.15 0.11 0.35    0.13 0.12 0.1 0.32   0.11 0.1 0.093 0.25   0.063 0.062 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife=20,
        particleLifeSpread=15,
        numparticles=6,
        particleSpeed=3.5,
        particleSpeedSpread=9,
        particleSize=11,
        particleSizeSpread=21,
        directional=0,
      },
    }
   
definitions['genericshellexplosion-battleshiplarge'].outersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.6,
        alwaysVisible = 0,
        sizeGrowth = 0.35,
        sizeMod = 1,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=33,
        emitRotSpread=50,
        emitVector = [[0, 1, 0]],
        gravity = [[0, -0.02, 0]],
        colormap=[[1 0.66 0.4 0.45    0.3 0.2 0.13 0.4   0.18 0.15 0.11 0.35    0.13 0.12 0.1 0.32   0.11 0.1 0.093 0.25   0.063 0.062 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife=14,
        particleLifeSpread=14,
        numparticles=4,
        particleSpeed=5,
        particleSpeedSpread=8,
        particleSize=29,
        particleSizeSpread=21,
        directional=0,
      },
    }
	
definitions['genericshellexplosion-battleshiplarge'].clouddust = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.92,
        colormap           = [[0 0 0 0.01  0.025 0.02 0.02 0.033  0.06 0.055 0.055 0.072  0.043 0.04 0.04 0.055 0.0238 0.022 0.022 0.03  0 0 0 0.01]],
        directional        = false,
        emitrot            = 45,
        emitrotspread      = 4,
        emitvector         = [[0.5, 1, 0.5]],
        gravity            = [[0, 0.025, 0]],
        numparticles       = 2,
        particlelife       = 22,
        particlelifespread = 13,
        particlesize       = 60,
        particlesizespread = 40,
        particlespeed      = 1.2,
        particlespeedspread = 2.5,
        pos                = [[0, 4, 0]],
        sizegrowth         = 0.18,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke]],
      },
    }
    


definitions['genericshellexplosion-punisher'] = deepcopy(definitions[root.."-large"])

definitions['genericshellexplosion-punisher'].outerflash.properties.size    = 7
definitions['genericshellexplosion-punisher'].outerflash.properties.heat    = 8
definitions['genericshellexplosion-punisher'].outerflash.properties.maxheat    = 30
definitions['genericshellexplosion-punisher'].outerflash.properties.sizegrowth    = 0.55
definitions['genericshellexplosion-punisher'].explosion.properties.numparticles = 8
definitions['genericshellexplosion-punisher'].explosion_blur.properties.numparticles = 1
definitions['genericshellexplosion-punisher'].clouddust.properties.particlelife    = 3
definitions['genericshellexplosion-punisher'].dirt.properties.particlelife    = 2
definitions['genericshellexplosion-punisher'].dirt2.properties.particlelife    = 3
definitions['genericshellexplosion-punisher'].groundflash_white.properties.colormap    = [[1 0.9 0.85 1.9   0 0 0 0.01]]
definitions['genericshellexplosion-punisher'].groundflash_white.properties.size    = 60
definitions['genericshellexplosion-punisher'].groundflash_white.properties.sizegrowth    = 5
definitions['genericshellexplosion-punisher'].groundflash_white.properties.ttl    = 7
definitions['genericshellexplosion-punisher'].groundflash_white.properties.texture    = [[groundflash]]
definitions['genericshellexplosion-punisher'].centerflare.properties.size = 1.5
definitions['genericshellexplosion-punisher'].groundflash_small.properties.size = 35
definitions['genericshellexplosion-punisher'].groundflash_large.properties.size = 50
definitions['genericshellexplosion-punisher'].explosion.properties.particlesize = 2.5
definitions['genericshellexplosion-punisher'].dirt.properties.particlelifespread = 4
definitions['genericshellexplosion-punisher'].dirt2.properties.particlelifespread = 4
definitions['genericshellexplosion-punisher'].clouddust.properties.particlelifespread = 4
definitions['genericshellexplosion-punisher'].outersmoke.properties.particlelife    = 3
definitions['genericshellexplosion-punisher'].innersmoke.properties.particlelife    = 3
definitions['genericshellexplosion-punisher'].explosion.properties.particlelife = 2
definitions['genericshellexplosion-punisher'].explosion.properties.particlelifespread = 5
definitions['genericshellexplosion-punisher'].explosion.properties.particlesizespread = 5.66
definitions['genericshellexplosion-punisher'].explosion.properties.particlespeedspread = 3
definitions['genericshellexplosion-punisher'].explosion_blur.properties.particlesize = 2

definitions['genericshellexplosion-punisher'].explosion_blur.properties.particlelife = 2
definitions['genericshellexplosion-punisher'].explosion_blur.properties.particlelifespread = 5
definitions['genericshellexplosion-punisher'].explosion_blur.properties.particlesizespread = 5.66
definitions['genericshellexplosion-punisher'].explosion_blur.properties.particlespeedspread = 3



definitions['genericshellexplosion-behe'] = deepcopy(definitions[root.."-large"])
definitions['genericshellexplosion-behe'].groundflash_white.properties.colormap    = [[1 0.9 0.8 2   0 0 0 0.01]]
definitions['genericshellexplosion-behe'].groundflash_white.properties.size    = 70
definitions['genericshellexplosion-behe'].groundflash_white.properties.sizegrowth    = 9
definitions['genericshellexplosion-behe'].groundflash_white.properties.ttl    = 7
definitions['genericshellexplosion-behe'].groundflash_white.properties.texture    = [[groundflash]]



definitions['genericshellexplosion-toaster'] = deepcopy(definitions[root.."-large"])
definitions['genericshellexplosion-toaster'].groundflash_white.properties.colormap    = [[1 0.9 0.85 1.9   0 0 0 0.01]]
definitions['genericshellexplosion-toaster'].groundflash_white.properties.size    = 80
definitions['genericshellexplosion-toaster'].groundflash_white.properties.sizegrowth    = 5
definitions['genericshellexplosion-toaster'].groundflash_white.properties.ttl    = 8
definitions['genericshellexplosion-toaster'].groundflash_white.properties.texture    = [[groundflash]]

-- definitions['genericshellexplosion-bull'].usedefaultexplosions=1

definitions['genericshellexplosion-goli'] = deepcopy(definitions[root.."-huge"])
definitions['genericshellexplosion-goli'].groundflash_white.properties.colormap    = [[1 0.9 0.85 1.9   0 0 0 0.01]]
definitions['genericshellexplosion-goli'].groundflash_white.properties.size    = 96
definitions['genericshellexplosion-goli'].groundflash_white.properties.sizegrowth    = 7
definitions['genericshellexplosion-goli'].groundflash_white.properties.ttl    = 7
definitions['genericshellexplosion-goli'].groundflash_white.properties.texture    = [[groundflash]]

definitions['genericshellexplosion-smallmissile'] = deepcopy(definitions[root.."-missile"])
definitions['genericshellexplosion-smallmissile'].clouddust.properties.particlesize = 4
definitions['genericshellexplosion-smallmissile'].innersmoke.properties.particlesize = 4
definitions['genericshellexplosion-smallmissile'].outersmoke.properties.particlesize = 5
definitions['genericshellexplosion-smallmissile'].outersmoke.properties.particlelifespread = 4
definitions['genericshellexplosion-smallmissile'].innersmoke.properties.particlelifespread = 4
definitions['genericshellexplosion-smallmissile'].clouddust.properties.particlelifespread = 5
definitions['genericshellexplosion-smallmissile'].outersmoke.properties.particleLife = 8


definitions['genericshellexplosion-banthamissile'] = deepcopy(definitions[root.."-missile"])
definitions['genericshellexplosion-banthamissile'].clouddust.properties.particlesize = 4
definitions['genericshellexplosion-banthamissile'].innersmoke.properties.particlesize = 4
definitions['genericshellexplosion-banthamissile'].outersmoke.properties.particlesize = 5
definitions['genericshellexplosion-banthamissile'].outersmoke.properties.particlelifespread = 4
definitions['genericshellexplosion-banthamissile'].innersmoke.properties.particlelifespread = 4
definitions['genericshellexplosion-banthamissile'].clouddust.properties.particlelifespread = 5
definitions['genericshellexplosion-banthamissile'].outersmoke.properties.particleLife = 8
definitions['genericshellexplosion-banthamissile'].dirt = nil



definitions['genericshellexplosion-parrow'] = deepcopy(definitions[root.."-large"])
definitions['genericshellexplosion-parrow'].groundflash_white.properties.colormap    = [[1 0.9 0.85 1.9   0 0 0 0.01]]
definitions['genericshellexplosion-parrow'].groundflash_white.properties.size    = 96
definitions['genericshellexplosion-parrow'].groundflash_white.properties.sizegrowth    = 5
definitions['genericshellexplosion-parrow'].groundflash_white.properties.ttl    = 7
definitions['genericshellexplosion-parrow'].groundflash_white.properties.texture    = [[groundflash]]

definitions['genericshellexplosion-vang'] = deepcopy(definitions[root.."-huge"])
definitions['genericshellexplosion-vang'].groundflash_white.properties.colormap    = [[1 0.9 0.85 2.2   0 0 0 0.01]]
definitions['genericshellexplosion-vang'].groundflash_white.properties.size    = 128
definitions['genericshellexplosion-vang'].groundflash_white.properties.sizegrowth    =9
definitions['genericshellexplosion-vang'].groundflash_white.properties.ttl    = 9
definitions['genericshellexplosion-vang'].groundflash_white.properties.texture    = [[groundflash]]

definitions['genericshellexplosion-brtha'] = deepcopy(definitions[root.."-huge"])
definitions['genericshellexplosion-brtha'].groundflash_white.properties.colormap    = [[1 0.9 0.8 2.9   0 0 0 0.01]]
definitions['genericshellexplosion-brtha'].groundflash_white.properties.size    = 110
definitions['genericshellexplosion-brtha'].groundflash_white.properties.sizegrowth    =14
definitions['genericshellexplosion-brtha'].groundflash_white.properties.ttl    = 14
definitions['genericshellexplosion-brtha'].groundflash_white.properties.texture    = [[groundflash]]

definitions['genericshellexplosion-sniper'] = deepcopy(definitions[root.."-large"])
definitions['genericshellexplosion-sniper'].explosion.properties.colormap    = [[0 0 0 0   1 0.3 0.15 0.01   1 0.2 0.12 0.01   0.8 0.16 0.09 0.01   0 0 0 0]]
definitions['genericshellexplosion-sniper'].explosion.properties.numparticles = definitions['genericshellexplosion-sniper'].explosion.properties.numparticles*1.3
definitions['genericshellexplosion-sniper'].explosion2.properties.colormap    = [[0 0 0 0   1 0 0 0.01   1 0.1 0.09 0.01   0.8 0.1 0.05 0.01   0 0 0 0]]
definitions['genericshellexplosion-sniper'].explosion2.properties.numparticles = definitions['genericshellexplosion-sniper'].explosion2.properties.numparticles*1.3
definitions['genericshellexplosion-sniper'].explosion.properties.particlesize = definitions['genericshellexplosion-sniper'].explosion.properties.particlesize * 0.85
definitions['genericshellexplosion-sniper'].explosion.properties.particlesizespread = definitions['genericshellexplosion-sniper'].explosion.properties.particlesizespread * 0.85
definitions['genericshellexplosion-sniper'].explosion2.properties.particlesize = definitions['genericshellexplosion-sniper'].explosion2.properties.particlesize * 0.85
definitions['genericshellexplosion-sniper'].explosion2.properties.particlesizespread = definitions['genericshellexplosion-sniper'].explosion2.properties.particlesizespread * 0.85




definitions['expldgun'] = deepcopy(definitions[root.."-small"])
definitions['expldgun'].groundflash_small = {
  class              = [[CSimpleGroundFlash]],
  count              = 1,
  air                = true,
  ground             = true,
  water              = true,
  properties = {
    colormap           = [[1 0.66 0.25 0.07   0 0 0 0.01]],
    size               = 20,
    sizegrowth         = 1,
    ttl                = 18,
    texture            = [[groundflash]],
  },
}
definitions['expldgun'].groundflash_large = {
  class              = [[CSimpleGroundFlash]],
  count              = 1,
  air                = true,
  ground             = true,
  water              = true,
  properties = {
    colormap           = [[1 0.66 0.25 0.025   0 0 0 0.01]],
    size               = 90,
    sizegrowth         = 0,
    ttl                = 18,
    texture            = [[groundflash]],
  },
}
definitions['expldgun'].groundflash_white = nil
definitions['expldgun'].heatedgroundflash = {
  class              = [[CSimpleGroundFlash]],
  count              = 1,
  air                = false,
  ground             = true,
  unit               = false,
  water              = false,
  properties = {
    colormap           = [[0.4 0.06 0.02 0.6   0 0 0 0.01]],
    size               = 16,
    sizegrowth         = 0,
    ttl                = 80,
    texture            = [[groundflash]],
  },
}

definitions['expldgun'].dirt.properties.numparticles = 3
definitions['expldgun'].dirt2.properties.numparticles = 2

--definitions['expldgun'].groundflash2 = {
--    class              = [[CSimpleGroundFlash]],
--    properties = {
--    	size = 150,
--    	ttl = 200,
--    	texture = [[bigexplosmoke]],
--      colormap  = [[0.2 0.4 0.1 0.62 	0 0 0 0.0]],
--    }
--}

definitions['expldgun'].centerflare.properties.size               = definitions['expldgun'].centerflare.properties.size*2.2
definitions['expldgun'].explosion.properties.numparticles         = definitions['expldgun'].explosion.properties.numparticles
definitions['expldgun'].explosion.properties.particlesize         = definitions['expldgun'].explosion.properties.particlesize*1.8
definitions['expldgun'].explosion.properties.particlesizespread   = definitions['expldgun'].explosion.properties.particlesizespread*1.5
definitions['expldgun'].explosion.properties.particlespeedspread  = definitions['expldgun'].explosion.properties.particlespeedspread*0.85
definitions['expldgun'].explosion2.properties.numparticles         = definitions['expldgun'].explosion.properties.numparticles
definitions['expldgun'].explosion2.properties.particlesize         = definitions['expldgun'].explosion.properties.particlesize*1.8
definitions['expldgun'].explosion2.properties.particlesizespread   = definitions['expldgun'].explosion.properties.particlesizespread*1.5
definitions['expldgun'].explosion2.properties.particlespeedspread  = definitions['expldgun'].explosion.properties.particlespeedspread*0.85
definitions['expldgun'].dirt.properties.particlelife              = definitions['expldgun'].dirt.properties.particlelife*1.2
definitions['expldgun'].dirt.properties.particlespeed             = definitions['expldgun'].dirt.properties.particlespeed*1.25
definitions['expldgun'].dirt.properties.particlespeedspread       = definitions['expldgun'].dirt.properties.particlespeedspread*1.4

definitions['expldgun'].clouddust.properties.numparticles = definitions['expldgun'].clouddust.properties.numparticles/2
definitions['expldgun'].innersmoke.properties.particleSize = definitions['expldgun'].innersmoke.properties.particleSize*0.6
definitions['expldgun'].innersmoke.properties.numparticles = definitions['expldgun'].innersmoke.properties.numparticles*0.7
definitions['expldgun'].innersmoke.properties.sizeGrowth = definitions['expldgun'].innersmoke.properties.sizeGrowth*0.6
definitions['expldgun'].innersmoke.properties.particleLife = definitions['expldgun'].innersmoke.properties.particleLife*2
definitions['expldgun'].outersmoke.properties.particleSize = definitions['expldgun'].outersmoke.properties.particleSize*0.65
definitions['expldgun'].outersmoke.properties.numparticles = definitions['expldgun'].outersmoke.properties.numparticles*0.7
definitions['expldgun'].outersmoke.properties.particleLife = definitions['expldgun'].outersmoke.properties.particleLife*1.5
--definitions['expldgun'].grounddust = nil



return definitions
