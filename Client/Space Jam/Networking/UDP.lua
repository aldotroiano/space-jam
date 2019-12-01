local json = require "json"
local socket = require("socket")
require("Modals.Team_room")
local utility = {}
udp = socket.udp()
udp:setpeername("3.10.140.235", 55000)
udp:settimeout(0)

function utility.startUDP()
  udp:send(json.encode({TYPE = 'INITIATE',TCPADDRESS = _G.remoteAddress_TCP}))
  print("UDP STARTED")
  receive()
end

function receive()
timer.performWithDelay( 500, function()

  data = udp:receive()

  if data then
    if (json.decode(data)) then
      local jsn = json.decode(data)
      print("received",data)
        if has_key(jsn,"HOST0") then
          update_room(jsn)
        end
    end
  end

end,0)
end


function has_key(table, key)
    return table[key]~=nil
end

return utility
