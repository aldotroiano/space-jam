local composer = require('composer')
local scene = composer.newScene()

local go_pressed = false

function scene:create(event)
Team_room_group = self.view


  local modal_background = display.newRect(display.contentCenterX, display.contentCenterY,display.actualContentWidth-50,600)
  modal_background:setFillColor(0,0,0,1)
  modal_background.strokeWidth = 8
  modal_background:setStrokeColor(255,255,255)

  local lbl_team_name = display.newText("TEAM : ".._G.team_name,65,display.contentCenterY-260,"fonts/FallingSky.otf",42 )
  lbl_team_name.anchorX = 0
  lbl_team_name:setFillColor(255,255,255)

  if (_G.is_host == 1) then
    lbl_team_name.text = lbl_team_name.text.." (HOST)"
  end

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

  local lbl_leave_room = display.newText("L E A V E",105,display.contentCenterY+210,"fonts/delirium.ttf",75 )
  lbl_leave_room.anchorX = 0
  lbl_leave_room:setFillColor(255,255,255)

  local lbl_start = display.newText("S T A R T",display.actualContentWidth-105,display.contentCenterY+210,"fonts/delirium.ttf",75 )
  lbl_start.anchorX = 1
  lbl_start:setFillColor(255,255,255)

  Team_room_group:insert(modal_background)
  Team_room_group:insert(lbl_team_name)
  Team_room_group:insert(bx_leave_room)
  Team_room_group:insert(bx_start)
  Team_room_group:insert(lbl_leave_room)
  Team_room_group:insert(lbl_start)
  multi_group:toBack()
  Team_room_group:toFront()
end

function leave_onPressed ()

coroutine.resume(leave_room)

end


function start_onPressed ()


end



function scene:hide( event )
    local full_group = self.view
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object

    if ( phase == "will" ) then

    end
end


scene:addEventListener( "hide", scene )
scene:addEventListener('create' , scene)
scene:addEventListener( "destroy", scene )
return scene
