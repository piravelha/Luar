require "lib"

local function Person(...)
  _args = {...}
  local name = _args[1]
  local age = _args[2]
  return setmetatable({
    set_name = function(...)
      _args = {...}
      local n = _args[1]
      return Person(n, age)
    end,
  }, {
    __name = "Person",
    __args = {...},
  })
end

println((Person("Ian", 5)).set_name("Miguel"))
