require "lib"

local function Person(...)
  local _args = {...}
  local name = _args[1]
  local age = _args[2]
  return setmetatable({
  }, {
    __name = "Person",
    __args = {...},
  })
end

local function birthdays(...)
  local _args = {...}
  local people = _args[1]
  return (people).map((function(_args)
    local name, age
    if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
      name = getmetatable(_args[1]).__args[1]
      age = getmetatable(_args[1]).__args[2]
    else
      name = _args[1][1]
      age = _args[1][2]
    end
    return Person(name, age + 1)  
end))
end

local myArray = array(Person("Bob", 42), Person("John", 23), Person("Jane", 18))

println(birthdays(myArray))
