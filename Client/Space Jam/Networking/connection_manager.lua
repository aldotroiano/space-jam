local udp = require("Networking.UDP")
local tcp = require("Networking.TCP")
local global = {}

function global.start_conn_tcp()
  tcp.game_conn()
end

function global.close_tcp_connection()
  tcp.close_connection()
end

function global.init_tcp()
  return tcp.handshake_management()
end

function global.init_udp()
  udp.startUDP()
end

function global.initial_game_tcp()
  tcp.initial_game()
end

function global.choose_team_routine()
  tcp.choose_team()
end

function global.udp_tcp_intermediary(message)
  tcp.game_conn(message)
end


return global
