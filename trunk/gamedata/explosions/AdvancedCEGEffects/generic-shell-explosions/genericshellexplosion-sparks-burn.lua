-- genericshellexplosion-small-sparks-burn
-- genericshellexplosion-medium-sparks-burn
-- genericshellexplosion-large-sparks-burn

return {
  ["genericshellexplosion-small-sparks-burn"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true, 
	  underwater         = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 1.3,
        maxheat            = 20,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 0.66,
        sizegrowth         = 5,
        speed              = [[0, 0, 0]],
        texture            = [[flare]],
      },
    },
    kickedupdirt = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.55 0.22 0.0 0.3	0.45 0.45 0.0 0.3	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.11, 0]],
        numparticles       = 14,
        particlelife       = 3,
        particlelifespread = 18,
        particlesize       = 8,
        particlesizespread = 3.5,
        particlespeed      = 2,
        particlespeedspread = 4.5,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.45,
        sizemod            = 0.7,
        texture            = [[randomdots]],
      },
    },
    kickedupwater = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true, 
	  underwater         = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.7 0.7 0.9 0.35	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 15,
        particlelife       = 2,
        particlelifespread = 15,
        particlesize       = 2,
        particlesizespread = 1,
        particlespeed      = 1,
        particlespeedspread = 6,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.5,
        sizemod            = 0.7,
        texture            = [[wake]],
      },
    },
    orangeexplosionspikes = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true, 
	  underwater         = true,
      properties = {
        airdrag            = 0.8,
        alwaysvisible      = true,
        colormap           = [[0.75 0.66 0.4 0.07   0.9 0.6 0.2 0.01]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 7,
        particlelife       = 8,
        particlelifespread = 0,
        particlesize       = 2,
        particlesizespread = 9,
        particlespeed      = 0.7,
        particlespeedspread = 2.5,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1,
        sizemod            = 0.5,
        texture            = [[gunshot]],
        useairlos          = false,
      },
    },
    underwaterexplosionspikes = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      underwater         = 1,
      properties = {
        airdrag            = 0.9,
        alwaysvisible      = true,
        colormap           = [[0.7 0.8 0.9 0.03   0.2 0.5 0.9 0.01		0 0 0 0.0]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.5, 0]],
        numparticles       = 4,
        particlelife       = 4,
        particlelifespread = 15,
        particlesize       = 1,
        particlesizespread = 0,
        particlespeed      = 3,
        particlespeedspread = 2,
        pos                = [[0, 2, 0]],
        sizegrowth         = 2,
        sizemod            = 0.25,
        texture            = [[wake]],
        useairlos          = false,
      },
    },
  },

  ["genericshellexplosion-medium-sparks-burn"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true, 
	  underwater         = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 1.3,
        maxheat            = 20,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 0.66,
        sizegrowth         = 8,
        speed              = [[0, 0, 0]],
        texture            = [[flare]],
      },
    },
    kickedupdirt = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.8 0.2 0.0 0.35	0.5 0.5 0.0 0.35	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 15,
        particlelife       = 2,
        particlelifespread = 15,
        particlesize       = 2,
        particlesizespread = 1,
        particlespeed      = 2,
        particlespeedspread = 6,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.5,
        sizemod            = 0.7,
        texture            = [[randomdots]],
      },
    },
    kickedupwater = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true, 
	  underwater         = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.7 0.7 0.9 0.35	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 15,
        particlelife       = 2,
        particlelifespread = 15,
        particlesize       = 2,
        particlesizespread = 1,
        particlespeed      = 2,
        particlespeedspread = 6,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.5,
        sizemod            = 0.7,
        texture            = [[wake]],
      },
    },
    orangeexplosionspikes = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true, 
	  underwater         = true,
      properties = {
        airdrag            = 0.8,
        alwaysvisible      = true,
        colormap           = [[0.7 0.8 0.9 0.03   0.9 0.5 0.2 0.01]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 8,
        particlelife       = 8,
        particlelifespread = 0,
        particlesize       = 0.5,
        particlesizespread = 0,
        particlespeed      = 5,
        particlespeedspread = 2,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1,
        sizemod            = 0.5,
        texture            = [[gunshot]],
        useairlos          = false,
      },
    },
    underwaterexplosionspikes = {
      class              = [[CSimpleParticleSystem]],
      count              = 2,
      underwater         = 1,
      properties = {
        airdrag            = 0.9,
        alwaysvisible      = true,
        colormap           = [[0.7 0.8 0.9 0.03   0.2 0.5 0.9 0.01		0 0 0 0.0]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.5, 0]],
        numparticles       = 4,
        particlelife       = 4,
        particlelifespread = 15,
        particlesize       = 1,
        particlesizespread = 0,
        particlespeed      = 3,
        particlespeedspread = 2,
        pos                = [[0, 2, 0]],
        sizegrowth         = 2,
        sizemod            = 0.25,
        texture            = [[wake]],
        useairlos          = false,
      },
    },
  },

  ["genericshellexplosion-large-sparks-burn"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true, 
	  underwater         = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 1.3,
        maxheat            = 20,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 0.66,
        sizegrowth         = 5,
        speed              = [[0, 0, 0]],
        texture            = [[flare]],
      },
    },
    kickedupdirt = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.8 0.2 0.0 0.35	0.5 0.5 0.0 0.35	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 15,
        particlelife       = 2,
        particlelifespread = 15,
        particlesize       = 1,
        particlesizespread = 1,
        particlespeed      = 4,
        particlespeedspread = 6,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.7,
        sizemod            = 0.7,
        texture            = [[randomdots]],
      },
    },
    kickedupwater = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true, 
	  underwater         = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.7 0.7 0.9 0.35	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 15,
        particlelife       = 2,
        particlelifespread = 15,
        particlesize       = 2,
        particlesizespread = 1,
        particlespeed      = 4,
        particlespeedspread = 6,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.7,
        sizemod            = 0.7,
        texture            = [[wake]],
      },
    },
    orangeexplosionspikes = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true, 
	  underwater         = true,
      properties = {
        airdrag            = 0.8,
        alwaysvisible      = true,
        colormap           = [[0.7 0.8 0.9 0.03   0.9 0.5 0.2 0.01]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 8,
        particlelife       = 8,
        particlelifespread = 0,
        particlesize       = 0.25,
        particlesizespread = 0,
        particlespeed      = 7,
        particlespeedspread = 2,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1,
        sizemod            = 0.5,
        texture            = [[gunshot]],
        useairlos          = false,
      },
    },
    underwaterexplosionspikes = {
      class              = [[CSimpleParticleSystem]],
      count              = 2,
      underwater         = 1,
      properties = {
        airdrag            = 0.9,
        alwaysvisible      = true,
        colormap           = [[0.7 0.8 0.9 0.03   0.2 0.5 0.9 0.01		0 0 0 0.0]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.5, 0]],
        numparticles       = 4,
        particlelife       = 4,
        particlelifespread = 15,
        particlesize       = 0.66,
        particlesizespread = 0,
        particlespeed      = 3,
        particlespeedspread = 2,
        pos                = [[0, 2, 0]],
        sizegrowth         = 2,
        sizemod            = 0.25,
        texture            = [[wake]],
        useairlos          = false,
      },
    },
  },

}

