require("game_engine")

function stats_receive(jsn)

print("Received Game stat")
timer.performWithDelay( 200, function() composer.showOverlay( "game_engine", {effect = "fade", time = 200})end )
end

function order_received(jsn)

print("Received packet from TCP")
end
