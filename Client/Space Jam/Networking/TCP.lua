local json = require "json"
local socket = require("socket")
--require("Networking.UDP")
require("gameplay.game_manager")
local utility = {}
local host, port = "35.178.99.133", 41555
local tcp = nil

function utility.handshake_management()
tcp = assert(socket.tcp())

  if setConnection() then
   Handshake()
   return true
 else
   native.showAlert( "Error", "Cannot connect to Server" ,{ "OK" })
   return false
end
end

function setConnection ()
  tcp:setoption("tcp-nodelay",true)
  tcp:setoption("keepalive",true)
  tcp:setoption("reuseport", true)
  if tcp:connect(host, port) then
    return true
  else
    return false
  end
end

function Handshake()
  tcp:settimeout(0)
  tcp:send(json.encode({TYPE = 'HANDSHAKE'}))
  tmr_initial_handshake = timer.performWithDelay( 200, function()
      local x,y,message = tcp:receive()
      if (json.decode(message)) then
        local jsn = json.decode(message)
        if jsn.RES == "OK" and jsn.TYPE == "HANDSHAKE" then
          print("CONNECTED")
          _G.remoteAddress_TCP = jsn.IPADDRESS
          timer.cancel( tmr_initial_handshake )
        end
    end
  end,0)

end

function utility.choose_team()

  tcp:settimeout(0)
  tcp:send(json.encode({TYPE = "CREATE_TEAM", NAME = _G.team_name, USERNAME = _G.username}))

  tmr_team = timer.performWithDelay( 200, function()
    local x,y,message = tcp:receive()
    if (json.decode(message)) then
      local jsn = json.decode(message)
      if jsn.TYPE == "CREATE_TEAM" and jsn.RES == "OK" then
        _G.is_host = jsn.ISHOST
        print("RECEIVED TEAM JSON")
        timer.cancel(tmr_team)
        coroutine.resume(hide_screen_choose_team)
        --udp.startUDP()
      end
    end
  end,0)
end

function utility.initial_game()

  tcp:settimeout(0)
  tcp:send(json.encode({TYPE = "START_MATCH"}))

  tmr_start = timer.performWithDelay(200, function()
    local x,y,message = tcp:receive()

    if(json.decode(message)) then
      local jsn = json.decode(message)

      if  jsn.TYPE == "MATCH" and jsn.RES == "OK" then
        print("RECEIVING INFO FROM SERVER")
        print("Closing HOST CONNECTION")
        timer.cancel( tmr_start )
      end
    end
  end,0)
end

function utility.game_conn(message)

  tcp:settimeout(0)
  tcp:send(json.encode(message))

  tmr_gm = timer.performWithDelay(20, function()
    local x,y,message = tcp:receive()

      if(json.decode(message)) then
        local jsn = json.decode(message)
        --order_received(jsn)
      end

  end,0)
end


function utility.close_connection()
tcp:close()
print("DISCONNECTED")
end

return utility
