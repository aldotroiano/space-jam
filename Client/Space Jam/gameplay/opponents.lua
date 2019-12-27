-- This class will hold all of the spaceships for the game_engine

local O = {}
local colors = {"0000ff","ff0000","00ff00","00ffff"}
local composer = require "composer"
require "Libraries.Hex2RGB"

function O.new(world,x,y)

local full_opponent = display.newGroup()


local sheet_firespace = graphics.newImageSheet( "Assets/spaceship.png", {width=481, height=840, numFrames = 8} )
  local body = display.newSprite( sheet_firespace, {start=1, count=8, time=400, loopCount=0,loopDirection="forward"} )
  body.x ,body.y = x,y
  body:setFillColor(hex2rgb(colors[math.random(1, 4)]))
  body.fill.effect = "filter.brightness"
  body.fill.effect.intensity = 0.3
	body.anchorY, body.anchorX = 1,0.5
  body:scale(0.18, 0.18)
  body:play()
  --[[
  local body = display.newImageRect(world.parent, "Assets/trim_final.png",80,160)
  body:setFillColor(hex2rgb(colors[math.random(1, 4)]))
  body.fill.effect = "filter.brightness"
  body.fill.effect.intensity = 0.5
  body.x ,body.y = x,y
	body.anchorY, body.anchorX = 1,0.5--]]
  full_opponent:insert(body)

  local name = display.newText(world.parent,"name",body.x,body.y-125,"fonts/moiser.ttf",22 )
  name:setFillColor(255,255,255)
  full_opponent:insert(name)

  function world:collision(event)
    print("COLLIDED WITH OTHER SPACESHIP!")
  end

  world:insert(full_opponent)
  --world:insert(name)
  return full_opponent
end
return O
