local _core = require "_core"
local print = _core.println

local function read(...)
  local _args = {...}
  local file = _args[1]
  return (function()
    (io).input(file)
    return (io).read("*all")
  end)()
end


print(read("compiler.py"))
