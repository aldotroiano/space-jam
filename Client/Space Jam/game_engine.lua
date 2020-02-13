
local composer = require( "composer" )
local scene = composer.newScene()
local physics = require "physics"
local opponents = require "gameplay.opponents"
local boundaries = require "gameplay.boundaries"
local finish = require "gameplay.finish_line"
local sidebar = require "gameplay.sidebar"
local terrains = require "gameplay.terrain_generator"
local asteroids = require "gameplay.asteroid_generator"

local perspective = require("Libraries.perspective")
require "ssk2.loadSSK"
--local conn_man = require("Networking.connection_manager")
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local world, spaceship
local terrain, asteroid = {},{}
local players = {}
local terrain_c, asteroid_c = 1,1
local num_players = 4
local start,finished = false,false

camera = perspective.createView()
_G.ssk.init()

function scene:create( event )
	game_group = self.view
physics.start()
physics.pause()

	physics.setGravity( 0, 0 )

	world = display.newGroup()

	background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor(0,0,0)
	background.strokeWidth = 15

	local options_bar = display.newRect(display.screenOriginX+8,display.screenOriginY+8,screenW-16,100)
	options_bar.anchorX = 0
	options_bar.anchorY = 0
	options_bar.alpha = 0.6
	options_bar:toFront()
	options_bar:setFillColor(0.25,0.25,0.25)

	health_title_lbl = display.newText("HEALTH:", (display.actualContentWidth/6),display.screenOriginY +15 )
	health_title_lbl.anchorX, health_title_lbl.anchorY = 0.5,0
	health_title_lbl.size = 22
	health_title_lbl:addEventListener("touch",start_var)

	health_lbl = display.newText("100%", (display.actualContentWidth/6),display.screenOriginY +50 )
	health_lbl.anchorX, health_lbl.anchorY = 0.5,0
	health_lbl.size = 35

	boost_title_lbl = display.newText("BOOST:", (display.actualContentWidth/6)*5,display.screenOriginY +15 )
	boost_title_lbl.anchorX, boost_title_lbl.anchorY = 0.5,0
	boost_title_lbl.size = 22

	boost_lbl = display.newText("0%", (display.actualContentWidth/6)*5,display.screenOriginY +50 )
	boost_lbl.anchorX, boost_lbl.anchorY = 0.5,0
	boost_lbl.size = 35

	Position_lbl = display.newText("3rd", (display.actualContentWidth/6)*3,display.screenOriginY +55 )
	Position_lbl.anchorX, Position_lbl.anchorY = 0.5,0.5
	Position_lbl.size = 80

	--realtime_player_pos = display.newRect(display.screenOriginX+8,display.screenOriginY+8,screenW-16,100)

	status_message = display.newText( "Connecting",display.contentCenterX,180,"fonts/FallingSky.otf",30 )

	countdown_lbl = display.newText( " ",display.contentCenterX,180,"fonts/FallingSky.otf",100 )


local sheet_firespace = graphics.newImageSheet( "Assets/spaceship.png", {width=85, height=149, numFrames = 8}  )
spaceship = display.newSprite( sheet_firespace, {start=1, count=8, time=400, loopCount=0,loopDirection="forward"} )
spaceship.y = 600
spaceship.myName = "spaceship"
spaceship.x = display.contentCenterX
spaceship.speed = 550

--local outline1 = graphics.newOutline( 1, sheet_firespace, 1)
spaceship.anchorY, spaceship.anchorX = 0.5,0.5
spaceship:play()
spaceship.collision = onLocalCollision

spaceship:addEventListener( "collision" )

physics.addBody( spaceship, "dynamic", {density=30,friction=0,bounce=0})

--spaceship.isFixedRotation = true
spaceship.isBullet = true

--world:insert(rightwall)
--touchjoint = physics.newJoint( "touch", spaceship, spaceship.x, spaceship.y+20 )

  spawnBoundaries()
	spawnSidebar()



	game_group:insert(background)
	game_group:insert(options_bar)
	game_group:insert(health_lbl)

	game_group:insert(spaceship)
	--game_group:insert(rightwall)
	game_group:insert(health_title_lbl)
	game_group:insert(boost_title_lbl)
	game_group:insert(boost_lbl)
	game_group:insert(Position_lbl)

--camera:setBounds(0,display.actualContentWidth,false,display.actualContentHeight-100)
camera:add(spaceship,1)
 camera.damping = 15
ship_movement()
camera:setFocus(spaceship)
camera:track()
--ls
--physics.setDrawMode( "hybrid" )   -- Shows collision engine outlines only
--spawnPlayers(1,200,600,"ha")
physics.start()

end

function start_var()
	if start == false then
			start = true
		else
			start = false
	end
end

function updateTimer_start(rem_time)

	 tmr_countdown = timer.performWithDelay( 1000, function()

		    rem_time = rem_time - 1

			if(rem_time ~= 0) then

				if(rem_time < 4) then
					status_message.alpha = 0
		    	countdown_lbl.text = rem_time
				end
			else
				countdown_lbl.size = 110
				countdown_lbl.text = "GO!"
				timer.cancel( tmr_countdown)
				timer.performWithDelay( 700, function()
				transition.fadeOut( countdown_lbl, { time=200 } )
					start = true

				end,1)
			end
	end,0)
end

function set_status_message(message)
status_message.text = message
end

function spawnBoundaries()
bond = boundaries.new(world,spaceship)
bond:toBack()
--camera:add(bond,7)
end

function spawnEnd(y_val)
finishline = finish.new(world,-y_val)
finishline:toBack()
camera:add(finishline,7)
end

function spawnObstacle(x,y)
	print("Spawning terrain blocks")
	terrain[#terrain+1] = terrains.new(world,x, display.contentCenterY - y)
	terrain[#terrain]:toBack()
	terrain_c = terrain_c + 1
	camera:add(terrain[#terrain],3)
end

function spawnAsteroid(x,y)
	print("Spawning Asteroids")
	asteroid[#asteroid+1] = asteroids.new(world,x, display.contentCenterY/3 - (asteroid_c*y))
	asteroid[#asteroid]:toBack()
	asteroid_c = asteroid_c + 1
	camera:add(asteroid[#asteroid],5)
end

function spawnSidebar()

sidebar.createcontainer()
sidebar.createline()
end

function spawnSidebarMain(i,spaceship_y)

sidebar.spawnMain(i,spaceship_y)

end

function spawnSidebarOpponent(i,opponent_y)
sidebar.spawnOpponent(i,opponent_y)
end

function onLocalCollision( self, event )

	if self.myName == "spaceship" and event.other.myName == "asteroid" then
		_G.health = _G.health - 1
		health_lbl.text = _G.health.."%"
	end
	if self.myName == "spaceship" and event.other.myName == "opponent" then
		_G.health = _G.health - 1
		health_lbl.text = _G.health.."%"
	end


	if ( event.phase == "began" ) then

		print( "collision began wit")

	elseif ( event.phase == "ended" ) then

		if self.myName == "spaceship" and event.other.myName == "finishline" then
			print("WON!!!!!!!!!!!")
			finished = true
		end
		print("collision ended")

	end
end


function spawnPlayerMain(x,y)
print("Spawning Main Player")
    _G.x = x
		_G.y = y
		_G.health = 100;
	print("x,y of MAIN : ", x, " ", y)
spaceship.x, spaceship.y = x, y

end

function spawnPlayers(i,x,y,name)
	print("Spawning opponents at", x , y)
	players[i] = opponents.new(world,i,x,y,name)
	players[i]:toFront()
	camera:add(players[i],4)

end

function setPlayerPos(tbl)

	for i = 1,_G.Pnum,1 do
		if(i ~= _G.Pindex) then
		transition.to( players[i], { x=tbl[tostring(i)].x,y=tbl[tostring(i)].y, rotation = tbl[tostring(i)].rot, time = 150})
		sidebar.setOpponent(i,tbl[tostring(i)].y)
	elseif((i == _G.Pindex)) then
		sidebar.setMain(i,spaceship.y)

end
	end

end

function ship_movement()

tmr_move = timer.performWithDelay( 2, function()
if start and finished == false then

	--spaceship:setLinearVelocity( 0, -50,spaceship.x,spaceship.y)

--spaceship:applyForce(spaceship.speed*xComp,spaceship.speed*yComp,spaceship.x,spaceship.y)

ssk.actions.move.forward( spaceship, {rate = spaceship.speed} )
bond[1].y = spaceship.y
bond[2].y = spaceship.y

	--ssk.actions.movep.forward( spaceship, {rate = spaceship.speed} )
--ssk.actions.movep.impulseForward( spaceship, {rate = spaceship.speed} )
--spaceship:applyLinearImpulse(spaceship.speed*xComp, spaceship.speed*yComp, spaceship.x, spaceship.y)
				                        --  "up" the screen is negative
	--spaceship:applyForce((math.cos(math.rad(spaceship.rotation)) * spaceship.speed),(-1 * math.sin(math.rad(spaceship.rotation)) * (spaceship.speed)))
	--spaceship:translate(0,-spaceship.speed)
--	health_title_lbl.text = math.floor(spaceship.y)
	_G.y = spaceship.y
	_G.x = spaceship.x
	_G.rotation = math.floor(spaceship.rotation)
end

end,0)
end

local function Moveship(event)
	if(event.x > 60 and event.x < display.actualContentWidth - 60) then

		--local vecX, vecY = angle2VecDeg( spaceship.rotation )

		--spaceship.angularVelocity = 0
	 --spaceship:applyForce ( vecX, vecY, spaceship.x, spaceship.y-30 )
		--spaceship:applyAngularImpulse( 10 )
		--spaceship:applyTorque(1)
		--spaceship:applyForce( 0, -20, spaceship.x, spaceship.y)
		--ssk.actions.movep.thrustForward( spaceship, { rate = 1 } )
		--ssk.actions.movep.thrustForward( spaceship, { rate = spaceship.speed } )
		if(event.x > 350) then
		spaceship.rotation = -(event.x-350)*0.35

	elseif(event.x < 332) then

		spaceship.rotation = (332 - event.x)*0.35

	end

		--spaceship.x = event.x				--TODO: prev. used code

		--spaceship.rotation = (display.actualContentWidth/2 - event.x)*0.3
--local angle  = spaceship.rotation
--local newVec = angle2Vector( angle, true )
--local scaledVec = scale( impulseVal , newVec )
--spaceship:applyLinearImpulse( scaledVec.x, scaledVec.y, spaceship.x, spaceship.y)
		--touchjoint:setTarget( normDeltaX,normDeltaY)
		--spaceship.x =  event.x
		--spaceship:applyAngularImpulse( 10 )
		--_G.x = event.x
	end
end


function scene:show( event )
	local game_group = self.view
	local phase = event.phase

	if phase == "will" then
		background:addEventListener("touch",Moveship)
		--Runtime:addEventListener("enterFrame",onFrames)



	elseif phase == "did" then
		composer.removeScene( "main_menu",false)
		print("Removing Menu scene")


	end
end

function scene:hide( event )
	local game_group = self.view
	local phase = event.phase

	if event.phase == "will" then

	--	physics.stop()
	elseif phase == "did" then
		Runtime:removeEventListener("enterFrame",onFrames)
		--Runtime:removeEventListener("touch",Moveship)
	end

end

function scene:destroy( event )
	local game_group = self.view

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
