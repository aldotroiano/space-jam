-- This class will hold all of the spaceships for the game_engine
local physics = require "physics"
local O = {}
local colors = {"0000ff","ff0000","00ff00","00ffff"}
local composer = require "composer"
require "Libraries.Hex2RGB"

function O.new(world,i,x,y,name)

local full_opponent = display.newGroup()


local sheet_firespace = graphics.newImageSheet( "Assets/spaceship.png", {width=85, height=149, numFrames = 8}  )
  local body = display.newSprite( sheet_firespace, {start=1, count=8, time=400, loopCount=0,loopDirection="forward"} )
  body:setFillColor(hex2rgb(colors[i]))
  body.x ,body.y = x,y
  body.fill.effect = "filter.brightness"
  body.fill.effect.intensity = 0.4
	body.anchorY, body.anchorX = 0.5,0.5


  body:play()

  full_opponent:insert(body)

  --[[local name = display.newText(world,tostring(name),body.x,body.y+5,"fonts/FallingSky.otf",14 )
  name.anchorX = 0.5
  name:setFillColor(255,255,255)

  full_opponent:insert(name)
--]]
  physics.addBody(body, "kinematic",{density=30,friction=0,bounce=0})

  body.isSleepingAllowed = false
  body.myName = "opponent"

  world:insert(full_opponent)

  return body
end
return O
