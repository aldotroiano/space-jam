local json = require "json"
local socket = require("socket")
require("Modals.Team_room")
require("gameplay.game_manager")
require("Networking.TCP")
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
          --native.showAlert( "ALERT", "RECEIVED START PACKET" ,{ "GOT IT" })
          timer.cancel(tmr_room_part)
          game_stats()
          game_conn()
        end

    end
  end
end,0)
end

function game_stats()

  tmr_gamestats = timer.performWithDelay( 20, function()
      data = udp:receive()

      if data then
        if (json.decode(data)) then
          local jsn = json.decode(data)

            if(jsn.TYPE == "INIT_GAME" and _G.Status ~= 0) then
              _G.Status = jsn.STATUS
              _G.Tid = jsn.Tid
              _G.Pnum = jsn.Pnum
              game_conn({TYPE = "CONFIRM_STATUS", STATUS = 0, Tid = _G.Tid,Pnum = _G.Pnum})
            end

        --  print("TESTING NEW UDP RECEIVER")
        end
      end
  end,0)
end

function has_key(table, key)
    return table[key]~=nil
end



return utility
