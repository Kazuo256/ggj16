
local sprites = require 'resources.sprites'

local numparticles = 10
local particles = {}
local standbyparticles = {}

local function particles.reset()
  if numparticles then
    --DO STUFF
    for i =1,numparticles do
      local tmpp = love.graphics.newParticleSystem(sprites.particle1, 10)
      table.insert(standbyparticles, tmpp)
    end
    numparticles = nil --sujo
  else
    for i = #particles,1,-1 do
      if particles[i][2]:getEmitterLifetime() >= 0 then
        particles[i][2]:stop()
      end
    end
  end
end

function particles.update ()
  local todelete = {}
  for i,v in ipairs(particles) do
    todelete[i] = not v[2]:isActive()
    v[2]:update(FRAME)
  end
  for i = #particles,1,-1 do
    if todelete[i] then
      table.insert(standbyparticles, particles[i][2])
      table.remove(particles, i)
    end
  end
end

local factories = {}

function factories.blood (p)
  p:reset()
  p:setTexture(sprites.particle3)
  p:setParticleLifetime(0.3, math.min(1.0, blinglevel))
  p:setEmissionRate(40)
  p:setSizes(1)
  p:setSizeVariation(1)
  p:setSpread(2*math.pi)
  p:setSpeed(128,128)
  p:setLinearAcceleration(0, 400, 0, 400)
  p:setColors(120, 0, 0, 255, 0, 0, 0, 0) -- Fade to transparency.
  p:setEmitterLifetime(.2)
  p:start()
  -- local posx, posy = self.getpos():unpack()
end

function factories.sparkle (p)
  p:reset()
  p:setTexture(sprites.particle1)
  p:setParticleLifetime(.5, math.log(blinglevel)/3)
  p:setEmissionRate(15)
  p:setSizes(1, 1+math.min(blinglevel,2), .5)
  p:setSizeVariation(1)
  p:setDirection(-math.pi/2)
  p:setSpread(0)
  p:setAreaSpread('normal', 4+blinglevel, 4+blinglevel)
  p:setLinearAcceleration(0, -80, 0, -80)
  p:setColors(255, 255, 255, 255)
  p:setEmitterLifetime(-1)
  p:start()
end

return particles

