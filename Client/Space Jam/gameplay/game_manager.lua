require("game_engine")
tablex = require("Libraries.tablex")
local json = require "json"
--require("Networking.connection_manager")
--require("Networking.TCP")
--local composer = require( "composer" )

function stats_receive(jsn)

print("Received Game stat")
if jsn.TYPE == "INITPACK_GAME" then
--composer.showOverlay( "game_engine", {effect = "fade", time = 200})
end

end

function order_received(jsn)

print("Received packet from TCP")
end

function update_message(message)
set_status_message(message)
end

function terrain_generation(tbl)

for i = 1, #tbl, 1 do
  if i < 200 then
    spawnObstacle(tbl[i][1],tbl[i][2])
    print(i)
  elseif i >= 200 and i <= 265 then
    spawnAsteroid(tbl[i][1],tbl[i][2])
  end
end
end

function player_generation(tbl)
print("Got playerinfo")
for i = 1,_G.Pnum,1 do

  if(i == _G.Pindex) then
    spawnPlayerMain(tbl[tostring(i)].x,tbl[tostring(i)].y)
  else
    spawnPlayers(i,tbl[tostring(i)].x,tbl[tostring(i)].y,tbl[tostring(i)].Usr)
  end
end
end

function server_start(timestamp)
  local ost = os.time(os.date('!*t'))
  local rem_time = (timestamp - ost)      -- Subtracting local timestamp from server timestamp for start time

  print(TIME_UNTIL_START)
  updateTimer_start(rem_time)
end

function set_player_pos(tbl)

setPlayerPos(tbl)

end
