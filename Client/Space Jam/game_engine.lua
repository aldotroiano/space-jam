
local composer = require( "composer" )
local scene = composer.newScene()
local physics = require "physics"
local opponents = require "gameplay.opponents"
local terrains = require "gameplay.terrain_generator"

local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local world, spaceship
local terrain = {}
local players = {}
local terrain_count = 1
local num_players = 3


function scene:create( event )
	local sceneGroup = self.view

	physics.start()
	physics.pause()
	physics.setGravity(0,-9.8 )

	world = display.newGroup()

	terrain[1] = terrains.new(world,display.contentCenterY)

	for _ = 1,100 do spawnTerrain() end
	print("Spawning terrain blocks")

	for i = 1, num_players do spawnPlayers(i) end
	print("Spawning players")

	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor(0,0,0)
	background.strokeWidth = 15

	local options_bar = display.newRect(display.screenOriginX,display.screenOriginY,screenW,50)
	options_bar.anchorX = 0
	options_bar.anchorY = 0
	options_bar:setFillColor(0.5,0,0)


	spaceship = display.newImageRect( "Assets/rocket.png", 140, 280 )
	spaceship.x, spaceship.y = display.contentCenterX, display.actualContentHeight-80
	spaceship.anchorY = 1
	spaceship.rotation = 0
	spaceship.alpha = 1
	spaceship:addEventListener("touch",moveShip)
	spaceship:addEventListener("tap",moveShip)

	physics.addBody( spaceship, { density=10.0, friction=0.3, bounce=0.3 } )

	sceneGroup:insert( background )

	sceneGroup:insert(world)
	sceneGroup:insert( spaceship )
	sceneGroup:insert(options_bar)


end

function spawnTerrain()
	terrain[#terrain+1] = terrains.new(world, display.contentCenterY - (terrain_count*500))
	terrain[#terrain]:toBack()
	terrain_count = terrain_count + 1
end

function spawnPlayers(i)
	players[#players+1] = opponents.new(world,(display.actualContentWidth/5)*i,display.actualContentHeight - 150)
	players[#players]:toBack()
end

function moveShip(event)
	if(event.x > 60 and event.x < display.actualContentWidth - 60) then
		spaceship.x =  event.x
	end
return true
end

local function onFrames(event)

--spaceship.y = spaceship.y - 1
--world.y = world.y + 5
--print("HELLOOO!!")
local sx, sy = spaceship:localToContent(0,0)

--print("sy - ",sy)
--print("secondoutput",display.actualContentHeight)
world.y = world.y + 5  -- TODO ADD SPEED TO PLAYER THRIOGUH SPEED VAR
-- physics to move ship and loc of ship to be ion contentCenterX



end
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		Runtime:addEventListener("enterFrame",onFrames)
	elseif phase == "did" then

	--physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view

	local phase = event.phase

	if event.phase == "will" then

		physics.stop()
	elseif phase == "did" then
		Runtime:removeEventListener("enterFrame",onFrames)
	end

end

function scene:destroy( event )


	local sceneGroup = self.view

	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


-----------------------------------------------------------------------------------------

return scene
