-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------


local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"
local animation = require("plugin.animation")
require("Networking.TCP")
require("Networking.ping")
local animation_triggered = false

-- TODO : Check connection on Click on multiplayer  OK
-- TODO: Put players in the same team  OK
-- TODO: Reference json library lua github rxi
--------------------------------------------


local function init_stars()

for i = 1,200,1
do
	display.newCircle( math.random(0,display.actualContentWidth), math.random(-200,display.actualContentHeight), 1.5 ):toBack()

end
end

function scene:create( event )
	sceneGroup = self.view

  title_group, single_group, multi_group, multi_group_btns = display.newGroup(), display.newGroup(), display.newGroup(), display.newGroup()

	local background = display.newRect(display.actualContentWidth, display.actualContentHeight,display.actualContentWidth,-display.actualContentHeight)
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX
	background.y = 0 + display.screenOriginY

	init_stars()				--fill background with stars

	local lbl_GameTitle_l1 = display.newText("Space",display.contentCenterX-45,35,"fonts/star.ttf",110 )
	lbl_GameTitle_l1:setFillColor(255,0,0)

  local lbl_GameTitle_l2 = display.newText("Jam",display.contentCenterX+95,110,"fonts/star.ttf",110 )
	lbl_GameTitle_l2:setFillColor(255,0,0)

	local btn_single_player = display.newRect((display.actualContentWidth/2),400, 400, 100)
	btn_single_player.strokeWidth = 6
	btn_single_player:setStrokeColor(53,49,49)
	btn_single_player:setFillColor(0,0,5,0.4)

	lbl_single = display.newText("S I N G L E  P L A Y E R",display.contentCenterX,400,"fonts/delirium.ttf",90 )
	lbl_single:setFillColor(255,255,255)

	local btn_multiplayer = display.newRect((display.actualContentWidth/2),550, 400, 100)
	btn_multiplayer.strokeWidth = 6
	btn_multiplayer:setStrokeColor(255,255, 100)
	btn_multiplayer:setFillColor(0,0,5,0.4)
	btn_multiplayer:addEventListener( "tap" , animations_multi)

	local lbl_multi = display.newText("M U L T I P L A Y E R",display.contentCenterX,550,"fonts/delirium.ttf",90 )
	lbl_single:setFillColor(255,255,255)

  btn_multi_team = display.newRect((display.actualContentWidth/2),720, 500, 100)
	btn_multi_team.strokeWidth = 4
	btn_multi_team:setStrokeColor(255,255, 100)
	btn_multi_team:setFillColor(0,0,5,0.4)
  btn_multi_team.alpha= 0.0
  btn_multi_team:addEventListener( "tap" , team_management)

  lbl_multi_team = display.newText("T  E  A  M  S",display.contentCenterX,720,"fonts/delirium.ttf",70 )
  lbl_single:setFillColor(255,255,255)
  lbl_multi_team.alpha = 0.0

  btn_multi_online = display.newRect((display.actualContentWidth/2),860, 500, 100)
	btn_multi_online.strokeWidth = 4
	btn_multi_online:setStrokeColor(255,255, 100)
	btn_multi_online:setFillColor(0,0,5,0.4)
  btn_multi_online.alpha= 0.0

  lbl_multi_online = display.newText("O  N  L  I  N  E",display.contentCenterX,860,"fonts/delirium.ttf",70 )
  lbl_multi_online:setFillColor(255,255,255)
  lbl_multi_online.alpha = 0.0

	local sheet_firespace = graphics.newImageSheet( "Assets/spaceship.png", {width=481, height=840, numFrames = 8} )

	local spaceship_fire = display.newSprite( sheet_firespace, {start=1, count=8, time=400, loopCount=0,loopDirection="forwardf"} )
	spaceship_fire.x, spaceship_fire.y = display.contentCenterX, display.actualContentHeight * 0.8

spaceship_fire:scale(0.25, 0.25)
spaceship_fire:play()

	sceneGroup:insert( background )
	sceneGroup:insert(spaceship_fire)
	title_group:insert(lbl_GameTitle_l1)
	title_group:insert(lbl_GameTitle_l2)
  single_group:insert(btn_single_player)
  single_group:insert(lbl_single)
  multi_group:insert(btn_multiplayer)
	multi_group:insert(lbl_multi)
  multi_group:insert(btn_multi_team)
  multi_group:insert(lbl_multi_team)
  multi_group:insert(btn_multi_online)
  multi_group:insert(lbl_multi_online)
	sceneGroup:insert(title_group)
	sceneGroup:insert(single_group)
	sceneGroup:insert(multi_group)

end

function animations_multi()
if check_internet_connection() == 1 then
	--
  if(animation_triggered == false) then
    animation_triggered = true
    transition.moveBy(single_group, {y=-120, time=200, alpha=0.3})
    transition.moveBy(multi_group, {y=-200, time=200})
    btn_multi_team.alpha, btn_multi_online.alpha = 1,1
    lbl_multi_team.alpha, lbl_multi_online.alpha = 1,1
  else
    animation_triggered = false
    transition.moveBy(single_group, {y=120, time=200, alpha=1})
    transition.moveBy(multi_group, {y=200, time=200})
    btn_multi_team.alpha, btn_multi_online.alpha = 0,0
    lbl_multi_team.alpha, lbl_multi_online.alpha = 0,0
end
else
	native.showAlert( "ALERT", "Check your Internet Connection and retry" ,{ "GOT IT" })
end
end

function team_management()
if handshake_management()  then
timer.performWithDelay(200, function()
composer.showOverlay("Modals.Choose_Team", {isModal = true, effect = "fromRight", time = 200})end)
end

return true
end

function scene:close_team_game()
	close_connection()
	return true
end


function scene:init_team_game()
timer.performWithDelay(200, function() composer.showOverlay("Modals.Team_room", {isModal = true, effect = "fromRight", time = 200} )end)

return true
end

function scene:back_from_room()
sceneGroup:toFront()
close_connection()
native.showAlert( "ALERT", "You Left Team: \n".._G.team_name.." " ,{ "OK" })
return true
end

function scene:starting_game()
	print("Went back to parent")
	initial_game()
	sceneGroup:toBack()
	timer.performWithDelay( 200, function() composer.showOverlay( "game_engine", {effect = "fade", time = 200})end )
	sceneGroup:toBack()
	return true
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--

		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--

		-- INSERT code here to pause the scene
		-- e.g. stop timers, srtop animation, unload sounds, etc.)
	elseif phase == "did" then

		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
