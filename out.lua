local _core = require "_core"
local print = _core.println

local function maximum(...)
  local _args = {...}
  local first = _args[1]

  local second = _args[2]

  return (function()
    return (function()
      if first > second then
        return (function()
print(("%s is bigger than %s."):format(first, second))        return first
      end)()
      else
        return (function()
print(("%s is bigger than %s"):format(second, first))        return second
      end)()
      end
    end)()
  end)()
end

maximum(7, 4)
