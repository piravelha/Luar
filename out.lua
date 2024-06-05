local _core = require "_core"
local print = _core.println

local result = (range(100000000, 1, - 1)).reduce(1, (function(_args)
  local a, b = _args[1], _args[2]
  return a + b
end))

print(result)
