local physics = require "physics"
local asteroid = {}
local map = display.newGroup()


function asteroid.new(world,x_cord,y)
instance = display.newGroup()


  local r_rand, g_rand, b_rand = math.random(), math.random(),math.random()

  local aster = display.newCircle(x_cord,y,40)
  aster.anchorX = 0
  aster:setFillColor(r_rand,g_rand,b_rand)
  aster:setStrokeColor(r_rand+0.2,g_rand+0.2,b_rand+0.2)

  aster.strokeWidth = 5

  instance:insert(aster)


    physics.addBody(aster, "dynamic", {friction= 30, density = 60, bounce = 100})
    aster.myName = "asteroid"


  world:insert(instance)  -- Inserting the left and right obstacle in the world

  return instance
end

return asteroid
