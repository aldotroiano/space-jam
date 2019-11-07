function check_internet_connection()
local socket = require("socket")

local check = socket.tcp()
check:settimeout(1000)

local testResult = check:connect("www.google.com", 80)
print(testResult)
if (testResult == 1) then
    print("Internet OK")
else
   print("Internet NOT OK")
    testResult = 0
end

check:close()
return 1
end
