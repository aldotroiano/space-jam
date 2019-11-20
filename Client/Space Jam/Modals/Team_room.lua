local composer = require('composer')
local utility_TCP = require("Networking.TCP")
--local utility_UDP = require("Networking.UDP")
local scene = composer.newScene()


local leave_pressed = false
local max_players = 4
array_players = {}

function scene:create(event)
Team_room_view = self.view
leave_pressed = false

  local modal_background = display.newRect(display.contentCenterX, display.contentCenterY,display.actualContentWidth-50,600)
  modal_background:setFillColor(0,0,0,1)
  modal_background.strokeWidth = 8
  modal_background:setStrokeColor(255,255,255)

  local lbl_team_name = display.newText("LOBBY: ".._G.team_name,65,display.contentCenterY-260,"fonts/FallingSky.otf",42 )
  lbl_team_name.anchorX = 0
  lbl_team_name:setFillColor(255,255,255)

  --[[if (_G.is_host == 1) then
    lbl_team_name.text = lbl_team_name.text.." (HOST)"
  end--]]

  local bx_leave_room = display.newRect(60, display.contentCenterY+210,220,100)
  bx_leave_room.anchorX = 0
  bx_leave_room:setFillColor(51,0,0,0.3)
  bx_leave_room.strokeWidth = 8
  bx_leave_room:setStrokeColor(255,255,255)
  bx_leave_room:addEventListener( "tap" , leave_onPressed)

  local bx_start = display.newRect(display.actualContentWidth-60, display.contentCenterY+210,220,100)
  bx_start.anchorX = 1
  bx_start:setFillColor(0,51,0,0.3)
  bx_start.strokeWidth = 8
  bx_start:setStrokeColor(255,255,255)
  bx_start:addEventListener( "tap" , start_onPressed)

  lbl_leave_room = display.newText("L E A V E",170,display.contentCenterY+210,"fonts/delirium.ttf",75 )
  lbl_leave_room.anchorX = 0.5
  lbl_leave_room:setFillColor(255,255,255)

  local lbl_start = display.newText("S T A R T",display.actualContentWidth-105,display.contentCenterY+210,"fonts/delirium.ttf",75 )
  lbl_start.anchorX = 1
  lbl_start:setFillColor(255,255,255)


  lbl_players = display.newText("Loading Team...",65,display.contentCenterY-200,"fonts/FallingSky.otf",42  )
  lbl_players.anchorX = 0
  lbl_players.anchorY = 0
  lbl_players:setFillColor(255,255,255)


  Team_room_view:insert(modal_background)
  Team_room_view:insert(lbl_team_name)
  Team_room_view:insert(bx_leave_room)
  Team_room_view:insert(bx_start)
  Team_room_view:insert(lbl_leave_room)
  Team_room_view:insert(lbl_start)
  Team_room_view:insert(lbl_players)
  --Team_room_view:toFront()
end

function leave_onPressed ()
leave_pressed = true
utility_TCP.leave_room()
lbl_leave_room.text = "L E A V I N G"
end


function start_onPressed ()
print("START")
end

hide_screen_team_room = coroutine.create(function ()
composer.hideOverlay("slideRight", 200)
coroutine.yield()
end)

tmr_shw_plys = timer.performWithDelay(2000, function()

  lbl_players.text = ""
  if(_G.tbl_roomplyrs ~= nil) then       --REFRESH PLAYERS IN LBL lbl_players
    local counter = 0
    for k,v in pairs(_G.tbl_roomplyrs) do
      print("INMAIN")

      if(k == "NAME"..counter) then
        print("in name if")
        lbl_players.text = lbl_players.text..(counter+1)..") "..v.."\n"
        counter = counter + 1
        elseif (k == "HOST"..counter) then

          --TODO: FIX host not showing correctly and changing layout of text message

        --[[  print("in host if")
        if(v == 1) then
          print("host YES")
          lbl_players.text = lbl_players.text.."  (HOST)".."\n"
          counter = counter + 1
        else
          print("host NO")
          lbl_players.text = lbl_players.text.."\n"
          counter = counter + 1
        end
        print("counter : "..counter)
--]]
      end
  end
end
return true
end,0)

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then


	elseif phase == "did" then
		-- Called when the scene is now on screen
		--

		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
    local full_group = self.view
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object

    if ( phase == "will" ) then

      elseif phase == "did" then
        if(leave_pressed) then
          leave_pressed = false
          parent:back_from_room()

        end

      -- Called when the scene is now off screen
      end
end


scene:addEventListener( "hide", scene )
scene:addEventListener('create' , scene)
scene:addEventListener( "destroy", scene )
scene:addEventListener( "show", scene )
return scene
