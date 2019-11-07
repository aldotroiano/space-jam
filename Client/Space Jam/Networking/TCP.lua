local json = require "json"
local socket = require("socket")
local udp = require("Networking.UDP")
local utility = {}
local host, port = "3.10.140.235", 41555
local periodic_timer= nil
local tcp = nil

function handshake_management()
tcp = assert(socket.tcp())

tmr_handshake_management = timer.performWithDelay(100, function()

  if setConnection() then
   Handshake()
   timer.cancel(tmr_handshake_management)
  else
    native.showAlert("Server Unreachable", { "OK" })
    -- TODO: ADD loop that retries the handshake from the start DONE
  end




end,0)



end

function setConnection ()
  local res = 0
  tcp:setoption("tcp-nodelay",true)
  tcp:setoption("keepalive",true)
  tcp:setoption("reuseport", true)
  if assert(tcp:connect(host, port)) then
    res = 1
    print("Res 1")
  else
    native.showAlert( "Error", "Cannot connect to Server" ,{ "OK" })

end

return res
end

function Handshake()
  tcp:settimeout(0)
  tcp:send(json.encode({TYPE = 'HANDSHAKE'}))
  local counter = 0;
  tmr_initial_handshake = timer.performWithDelay( 200, function()

      if message ~= '' and message ~= nil then
      if handshake_json.RES == "OK" and handshake_json.TYPE == "HANDSHAKE" then
        print("CONNECTED")
        _G.remoteAddress_TCP = handshake_json.IPADDRESS
        timer.cancel( tmr_initial_handshake )
      end
    end
  end,0)

end

co = coroutine.create(function ()

    tcp:settimeout(0)
    tcp:send(json.encode({TYPE = "KEEPALIVE"}))

          if (json_receive.TYPE == "KEEPALIVE") and (json_receive.RES == "OK")then
            print("KAP RETURNED")
          else
            print("KAP TRANSMISSION ERROR")  --TODO: Add listener for this and interrupt game
          end
end)

function close_connection()
tcp:close()
print("DISCONNECTED")
end



function utility.choose_team()

  tcp:settimeout(0)
  tcp:send(json.encode({TYPE = "CREATE_TEAM", NAME = _G.team_name, USERNAME = _G.username}))

  tmr_team = timer.performWithDelay( 200, function()

    local x,y,message = tcp:receive()
    if message ~= '' and message ~= nil then
      local json_receive = json.decode(message)
      if json_receive.TYPE == "CREATE_TEAM" and json_receive.RES == "OK" then
        _G.is_host = json_receive.ISHOST
        print("RECEIVED TEAM JSON")

        timer.cancel(tmr_team)

        coroutine.resume(hide_screen_choose_team)

      end
    end
  end,0)
end



function utility.leave_room()
  tcp:settimeout(0)
  tcp:send(json.encode({TYPE = "LEAVE_ROOM", NAME = _G.team_name}))

  tmr_receive_team_confirm = timer.performWithDelay( 200, function()
    local x,y,message = tcp:receive()
    if message ~= '' and message ~= nil then
      local json_receive = json.decode(message)
      if json_receive.TYPE == "LEAVE_ROOM" and json_receive.RES == "OK" then
        timer.cancel(tmr_receive_team_confirm)
        coroutine.resume(hide_screen_team_room)
        close_connection()
      end
    end
  end,0)

end


return utility
