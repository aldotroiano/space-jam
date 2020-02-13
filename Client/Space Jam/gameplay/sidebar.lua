local sidebar = {}
local colors = {"005ce6","e60000","b82e8a","990033","cc3300"}
require "Libraries.Hex2RGB"
sdbr_grp = display.newGroup()
local players = {}
totaly_global = 0


function sidebar.createcontainer()

  local container = display.newRoundedRect(display.actualContentWidth+10,150,60,750,15)
  container.anchorX,container.anchorY = 1,0
  container:setFillColor(0,0,0)
  container:setStrokeColor(1,1,1)
  container.strokeWidth = 5

  sdbr_grp:insert(container)

end

function sidebar.createline()

  local line = display.newRect(display.actualContentWidth-22,525,5,650)
  line.anchorX,line.anchorY = 0.5,0.5
  line:setFillColor(hex2rgb("708090"))
  line.alpha = 0.8

  local startline = display.newRect(line.x,line.y+325,20,3)
  startline.anchorX,line.anchorY = 0.5,0.5
  startline:setFillColor(hex2rgb("708090"))
  startline.alpha = 0.9

  local finishline = display.newRect(line.x,line.y-325,20,3)
  finishline.anchorX,line.anchorY = 0.5,0.5
  finishline:setFillColor(hex2rgb("708090"))
  finishline.alpha = 0.9

  local lbl_start = display.newText("START",line.x,line.y+340,"fonts/FallingSky.otf",14 )
  lbl_start.anchorX, lbl_start.anchorY = 0.5,0.5
  lbl_start:setFillColor(255,255,255)

  local lbl_finish = display.newText("FINISH",line.x,line.y-340,"fonts/FallingSky.otf",14 )
  lbl_finish.anchorX, lbl_finish.anchorY = 0.5,0.5
  lbl_finish:setFillColor(255,255,255)

  sdbr_grp:insert(line)
  sdbr_grp:insert(startline)
  sdbr_grp:insert(finishline)
  sdbr_grp:insert(lbl_start)
  sdbr_grp:insert(lbl_finish)

end


function sidebar.spawnMain(index,spaceshipy)

  main = display.newRoundedRect(display.actualContentWidth-12,proportions(spaceshipy),60,10,13)

  main:setFillColor(1,1,1)
  players[index] = main
end

function sidebar.spawnOpponent(index,opponenty)
  opponent = display.newRoundedRect(display.actualContentWidth-8,proportions(opponenty),50,9,13)
  opponent:setFillColor(hex2rgb(colors[index]))
  opponent.alpha = 0.7
  players[index] = opponent
end

function sidebar.setAlpha()
sdbr_grp.alpha = 0.5
end

function sidebar.setMain(i,spaceshipy)
transition.to( players[i], {y=proportions(spaceshipy), time = 50})
end

function sidebar.setOpponent(i,opponenty)
transition.to( players[i], {y=proportions(opponenty), time = 50})
end

function proportions(spacey)
  if _G.totaly ~= nil then
    local prop = 640/(_G.totaly)
    if spacey < 0 then
      return (850+(-prop*(-spacey)))
    else
      return 850
    end
  else
    return 850
  end
end

return sidebar
