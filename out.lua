local _core = require "_core"
local print = _core.println

local function Set(...)
  local _args = {...}
  local values = _args[1]

  return setmetatable({
    insert = function(...)
      local _args = {...}
      local value = _args[1]

      return (function()
        if not (values).find(value) then
          return Set(values + array(value))
        else
          return Set(values)
        end
      end)()
    end,
  }, {
    __bor = function(_, _args)
      local _args = {_args}
      local others
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        others = getmetatable(_args[1]).__args[1]
      else
        others = _args[1][1]
      end
      return (others).reduce(Set(values), (function(_args)
        local set = _args[1]
        local other = _args[2]
        return (set).insert(other)      
end))
    end,
    __name = "Set",
    __args = {...},
  })
end

local mySet = Set(array(1, 2, 3))

print(mySet | Set(array(4, 5, 6, 2, 3)))
