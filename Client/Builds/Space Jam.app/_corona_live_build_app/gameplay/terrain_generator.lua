local terr = {}
local map = display.newGroup()


function terr.new(world,y)
  local instance = display.newGroup()

  local left_max = math.random(0,display.actualContentWidth-200)
  local r_rand = math.random()
  local g_rand = math.random()
  local b_rand = math.random()

  local r1 = display.newRect(display.actualContentWidth+10, y,(-left_max),95)
  r1.anchorX = 0
  r1:setFillColor(r_rand,g_rand,b_rand)
  r1:setStrokeColor(255,255,255)

  local l1 = display.newRect(-10,y,display.actualContentWidth-left_max-150,95)
  l1.anchorX = 0
  l1:setFillColor(r_rand,g_rand,b_rand)

  l1:setStrokeColor(255,255,255)

  l1.strokeWidth, r1.strokeWidth = 8,8
  instance:insert(r1)
  instance:insert(l1)

  world:insert(instance)  -- Inserting the left and right obstacle in the world

  return instance
end

return terr
