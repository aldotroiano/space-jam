local terr = {}
local map = display.newGroup()


function terr.new(world,y)
instance = display.newGroup()

  --[[for i = 1,40,1
  do
  	star = display.newCircle(math.random(5,display.actualContentWidth), math.random(y,250), 1 )
    star.alpha = 0.45
    instance:insert(star)
  end--]]

  local left_max = math.random(0,display.actualContentWidth-200)
  local r_rand, g_rand, b_rand = math.random(), math.random(),math.random()

  local r1 = display.newRect(display.actualContentWidth+10, y,(-left_max),95)
  r1.anchorX = 0
  r1:setFillColor(r_rand,g_rand,b_rand)
  r1:setStrokeColor(255,255,255)

  local l1 = display.newRect(-10,y,display.actualContentWidth-left_max-150,95)
  l1.anchorX = 0
  l1:setFillColor(r_rand,g_rand,b_rand)
  --physics.addBody(l1,"dynamic")
  l1:setStrokeColor(255,255,255)

  l1.strokeWidth, r1.strokeWidth = 8,8

  instance:insert(r1)
  instance:insert(l1)

  world:insert(instance)  -- Inserting the left and right obstacle in the world


  return instance
end

return terr
