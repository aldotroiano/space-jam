-- This class will hold all of the spaceships for the game_engine

local O = {}
local colors = {"0000ff","ff0000","00ff00","00ffff"}
local composer = require "composer"
require "Libraries.Hex2RGB"

function O.new(world,x,y)


  local mask = graphics.newMask( "Assets/trim_final.png" )

  local body = display.newImageRect(world.parent, "Assets/trim_final.png",80,160)
  body:setFillColor(hex2rgb(colors[math.random(1, 4)]))
  body.fill.effect = "filter.brightness"
  body.fill.effect.intensity = 0.5
  body.x ,body.y = x,y
	body.anchorY, body.anchorX = 1,0.5


  --local name = display.newText(world.parent,"name",body.x,body.y-125,"fonts/moiser.ttf",22 )
  --name:setFillColor(255,255,255)

--physics.addBody(body,"dynamic")
--physics.addBody( name, "dynamic")

  local frame = 0

  function world:collision(event)
    print("COLLIDED WITH OTHER SPACESHIP!")
  end

  world:insert(body)
  --world:insert(name)
  return body
end
return O
