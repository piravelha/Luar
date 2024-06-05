require "lib"

local [Token('NAME', 'Box'), Tree(Token('RULE', 'parameter_list'), [Tree(Token('RULE', 'name_pattern'), [Token('NAME', 'value')])])] = {
}
local function test(...)
  local _args = {...}
  local values
  if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
    values = getmetatable(_args[1]).__args[1]
  else
    values = _args[1][1]
  end

  return (function()
    local _args = {values}
    local a, b, rest
    if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
      a = getmetatable(_args[1]).__args[1]
      b = getmetatable(_args[1]).__args[2]
      rest = {unpack(getmetatable(_args[1]).__args, 3)}
    else
      a = _args[1][1]
      b = _args[1][2]
      rest = {unpack(_args[1], 3)}
    end
    return println(a + b, rest)
  end)()
end

local myBox = Box({1, 2, 3, 4, 5, 6})

test(myBox)

println((function()
  local z = 1 + 2
  return z
end)())
