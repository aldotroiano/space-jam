local json = require "json"
local socket = require("socket")
local utility = {}
udp = socket.udp()
udp:setpeername("3.10.140.235", 55000)
udp:settimeout(0)

function utility.startUDP()
  udp:send(json.encode({TYPE = 'INITIATE',TCPADDRESS = _G.remoteAddress_TCP}))
end

timer.performWithDelay( 50, function()

  data = udp:receive()
  if data then
      print("Received: ", data)
  end

end,0)

return utility
