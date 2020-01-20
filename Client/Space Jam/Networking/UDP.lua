local json = require "json"
local socket = require("socket")
require("Modals.Team_room")
--require("Networking.connection_manager")
require("gameplay.game_manager")
require("Modals.intermediary")
local tcp = require("Networking.TCP")
local utility = {}
udp = socket.udp()
udp:setpeername("3.8.48.250", 55000)
udp:settimeout(0)

function utility.startUDP()
  udp:send(json.encode({TYPE = 'INITIATE',TCPADDRESS = _G.remoteAddress_TCP}))
  print("UDP STARTED")
  receive_room_participants()
end

function receive_room_participants()

tmr_room_part = timer.performWithDelay( 250, function()
  data = udp:receive()
  if data then
    if (json.decode(data)) then
      local jsn = json.decode(data)
        if has_key(jsn,"HOST0") then
          update_room(jsn)
        end
        if jsn.TYPE == "INITPACK_GAME" and jsn.RES == "OK" then
          print("initpack")
          --native.showAlert( "ALERT", "RECEIVED START PACKET" ,{ "GOT IT" })
          timer.cancel(tmr_room_part)
          game_stats()

          --start_conn_tcp()
        end

    end
  end
end,0)
end

function game_stats()
  show_gm()         --Showing game on screen
  tmr_gamestats = timer.performWithDelay( 20, function()

      data = udp:receive()

      if data then
        if (json.decode(data)) then
          local jsn = json.decode(data)

            if(jsn.TYPE == "INIT_GAME" and _G.Status == 0) then
              _G.Status = jsn.STATUS
              _G.Tid = jsn.Tid
              _G.Pindex = jsn.Pindex
              print("Status 1 confirmed")
              tcp.game_conn({TYPE = "CONFIRM_STATUS", STATUS = _G.Status, Tid = _G.Tid, Pnum = _G.Pindex})
              update_message("(1) Connecting Players...")
            end

            if(jsn.TYPE == "INIT_GAME" and _G.Status == 1 and jsn.STATUS > _G.Status) then
              print("Status 2 confirmed")
              _G.Status = jsn.STATUS

              -- TODO need to save player and transmit it to the player placeholders in game engine

              tcp.game_conn({TYPE = "CONFIRM_STATUS", STATUS = _G.Status, Tid = _G.Tid, Pnum = _G.Pindex})
              update_message("(2) Receiving Player Data...")
            end


            if(jsn.TYPE == "INIT_GAME" and _G.Status == 2 and jsn.STATUS > _G.Status) then
              print("Status 3 confirmed")
              _G.Status = jsn.STATUS
              tcp.game_conn({TYPE = "CONFIRM_STATUS", STATUS = _G.Status, Tid = _G.Tid, Pnum = _G.Pindex})
              terrain_generation(jsn.MAP)
              update_message("(3) Receiving and Rendering Terrain...")

            end



        end
      end
  end,0)
end

function utility.send(message)

  udp:send(json.encode(message))      --Sending UDP packet

end

function has_key(table, key)
    return table[key]~=nil
end



return utility
