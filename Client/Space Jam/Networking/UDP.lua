json = require "json"
local socket = require("socket")
local utility = {}
local host, port = "3.10.140.235", 41555
local periodic_timer= nil
local tcp = nil

function handshake_management()
tcp = assert(socket.tcp())


end
