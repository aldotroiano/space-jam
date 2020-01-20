require("game_engine")
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

function terrain_generation(table_arr)

print("GOT IT")
end
