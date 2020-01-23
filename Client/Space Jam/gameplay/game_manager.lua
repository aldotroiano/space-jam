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

  for k,v in pairs(tbl) do
      spawnObstacle(v)            --Spawning obstacles loop
      print(k,v)
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
