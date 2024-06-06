local _core = require "_core"
local print = _core.println

print((array{1, 2, 3}).map((function(...)
  local _args = {...}
  local x = _args[1]
  return (x + 1)
end)))
