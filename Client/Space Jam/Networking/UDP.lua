local socket = require("socket")
local group = "226.192.1.1"
local port = 9002
local c = (socket.udp4())
c:setoption("reuseport", true)
c:setsockname("*", port)
c:settimeout(0)
print((c:setoption("ip-add-membership", {multiaddr = group, interface = "*"})))


timer.performWithDelay( 50, function()
    buf, ip, port = c:receivefrom()
    if buf then
    print("IP Address: ", buf)
    end
end,0)
