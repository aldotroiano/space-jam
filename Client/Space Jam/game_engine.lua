-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()


local physics = require "physics"

--------------------------------------------


local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

function scene:create( event )


	local sceneGroup = self.view


	physics.start()
	physics.pause()
	physics.setGravity( 0, -9.8 )




	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor(0,0,0 )
	background.strokeWidth = 15


	spaceship = display.newImageRect( "Assets/rocket.png", 140, 280 )
	spaceship.x, spaceship.y = display.contentCenterX, display.actualContentHeight-80
	spaceship.anchorY = 1
	spaceship.rotation = 0
	spaceship:addEventListener("touch",moveShip)
	spaceship:addEventListener("tap",moveShip)


	physics.addBody( spaceship, { density=10.0, friction=0.3, bounce=0.3 } )



	sceneGroup:insert( background )
	sceneGroup:insert( spaceship )

end

function moveShip(event)
	if(event.x > 60 and event.x < display.actualContentWidth - 60) then
spaceship.x =  event.x
end
return true
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then

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
