local _core = require "_core"
local print = _core.println

local Math = setmetatable({
  max = function(...)
    local _args = {...}
    local a = _args[1]
    local b = _args[2]

    return (function()
      if a > b then
        return a
      else
        return b
      end
    end)()
  end,
  min = function(...)
    local _args = {...}
    local a = _args[1]
    local b = _args[2]

    return (function()
      if a < b then
        return a
      else
        return b
      end
    end)()
  end,
  is_palindrome = function(...)
    local _args = {...}
    local number = _args[1]

    return (function(a, b)
        return _eq(a, b)
    end)((string).reverse(tostring(number)), tostring(number))
  end,
}, {
  __name = "Math",
  __args = {},
})


local solve = ((((range(99, 999)).map((function(...)
  local _args = {...}
  local x = _args[1]
  return (range(99, x)).map((function(...)
    local _args = {...}
    local y = _args[1]
    return x * y
  end))
end))).flatten()).filter((Math).is_palindrome)).reduce(0, (Math).max)

print(solve)
