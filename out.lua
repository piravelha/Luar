local _core = require "_core"
local print = _core.println

local function myAdd(...)
  local _args = {...}
  local x = _args[1]

  local y = _args[2]

  return x + y + 1
end

local function myMul(...)
  local _args = {...}
  local x = _args[1]

  local y = _args[2]

  return x * y + 1
end

print(myAdd(1, myMul(2, 3)))
