-- snipercooloff

return {
  ["snipercooloff"] = {
    greytowhitepuff = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 1,
        colormap           = [[0.2 0.2 0.2 0.6		0.5 0.5 0.5 0.5		0 0 0 0.01]],
        directional        = true,
        emitrot            = 1,
        emitrotspread      = 5,
        emitvector         = [[dir]],
        gravity            = [[0.0, 0, .0]],
        numparticles       = 1,
        particlelife       = 8,
        particlelifespread = 0,
        particlesize       = 2,
        particlesizespread = 2,
        particlespeed      = 0,
        particlespeedspread = 3,
        pos                = [[0.0, 1, 0.0]],
        sizegrowth         = 1,
        sizemod            = 1,
        texture            = [[dirt]],
        useairlos          = true,
      },
    },
    heatparticles = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.5,
        alwaysvisible      = true,
        colormap           = [[1 1 1 0.01	 0.9 0.8 0.7 0.03 	0.9 0.5 0.2 0.01	0.9 0.9 0.9 1.0 	0.5 0.5 0.9 0.0]],
        directional        = true,
        emitrot            = 90,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -1, 0]],
        numparticles       = 1,
        particlelife       = 5,
        particlelifespread = 10,
        particlesize       = 1,
        particlesizespread = 1,
        particlespeed      = 1,
        particlespeedspread = 10,
        pos                = [[r-1 r1, 1, r-1 r1]],
        sizegrowth         = 0,
        sizemod            = 1.0,
        texture            = [[randomdots]],
        useairlos          = true,
      },
    },
    whiteparticles = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
      properties = {
        airdrag            = 0.5,
        alwaysvisible      = true,
        colormap           = [[0.9 0.9 0.9 1.0	0.5 0.5 0.9 0.0]],
        directional        = true,
        emitrot            = 90,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -1, 0]],
        numparticles       = 1,
        particlelife       = 5,
        particlelifespread = 10,
        particlesize       = 1,
        particlesizespread = 1,
        particlespeed      = 1,
        particlespeedspread = 10,
        pos                = [[r-1 r1, 1, r-1 r1]],
        sizegrowth         = 0,
        sizemod            = 1.0,
        texture            = [[randomdots]],
        useairlos          = true,
      },
    },
    whitepuff = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
      properties = {
        airdrag            = 1,
        colormap           = [[1 1 1 0.5		0 0 0 0.01]],
        directional        = true,
        emitrot            = 1,
        emitrotspread      = 5,
        emitvector         = [[dir]],
        gravity            = [[0.0, 0, .0]],
        numparticles       = 1,
        particlelife       = 8,
        particlelifespread = 0,
        particlesize       = 2,
        particlesizespread = 2,
        particlespeed      = 0,
        particlespeedspread = 3,
        pos                = [[0.0, 1, 0.0]],
        sizegrowth         = 1,
        sizemod            = 1,
        texture            = [[dirt]],
        useairlos          = true,
      },
    },
  },

}

