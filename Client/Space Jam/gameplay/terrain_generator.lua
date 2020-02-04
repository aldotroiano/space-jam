local physics = require "physics"
local terr = {}
local colors = {"005ce6","e60000","b82e8a","990033","cc3300"}


function terr.new(world,x_cord,y)
instance = display.newGroup()


  --[[for i = 1,40,1
  do
  	star = display.newCircle(math.random(5,display.actualContentWidth), math.random(y,250), 1 )
    star.alpha = 0.45
    instance:insert(star)
  end--]]

  --local left_max = math.random(0,display.actualContentWidth-200)
  local left_max = x_cord
  local color = math.random(1,5)
  local r_rand, g_rand, b_rand = math.random(), math.random(),math.random()

  local l1 = display.newRoundedRect(-10,y,left_max-75,60,15)
  l1.anchorX = 0
  l1:setFillColor(hex2rgb(colors[color]))
  l1:setStrokeColor(r_rand+0.2,g_rand+0.2,b_rand+0.2)
l1:setStrokeColor(255,255,255)

  local r1 = display.newRoundedRect(left_max+75,y,display.actualContentWidth+10,60,15)
  r1.anchorX = 0 -- should be 1
  r1:setFillColor(hex2rgb(colors[color]))
  r1:setStrokeColor(r_rand+0.2,g_rand+0.2,b_rand+0.2)
  r1:setStrokeColor(255,255,255)

  l1.strokeWidth = 5
  r1.strokeWidth = 5

  instance:insert(l1)
  instance:insert(r1)

  physics.addBody( r1, "static")
  physics.addBody( l1, "static")
  l1.isSleepingAllowed = false
  r1.isSleepingAllowed = false
  world:insert(instance)  -- Inserting the left and right obstacle in the world

  return instance
end

return terr
