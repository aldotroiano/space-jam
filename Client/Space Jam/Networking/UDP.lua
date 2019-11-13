local json = require "json"
local socket = require("socket")
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
timer.performWithDelay( 50, function()

  data = udp:receive()

  if data then

    if (json.decode(data)) then
      local jsn = json.decode(data)
        print("Received: ", data)
        

    end
  end

end,0)
end
return utility
