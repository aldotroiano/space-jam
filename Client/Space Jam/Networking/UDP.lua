
local socket = require("socket")

udp = socket.udp()
udp:setpeername("3.10.140.235", 55000)
udp:settimeout(0)

udp:send("Data!")

timer.performWithDelay( 50, function()

  data = udp:receive()
  if data then
      print("Received: ", data)
  end

end,0)
