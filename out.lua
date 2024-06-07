local _core = require "_core"
local print = _core.println


local rest = (function()
  local _args = {array{1, 2, 3, 4, 5}};
  local x, y, rest
  if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
    x = getmetatable(_args[1]).__args[1];
    y = getmetatable(_args[1]).__args[2];
    rest = array{unpack(getmetatable(_args[1]).__args, 3)};
  else
    x = _args[1][1];
    y = _args[1][2];
    rest = array{unpack(_args[1], 3)};
  end
  print(("X: %s"):format(x));
  print(("Y: %s"):format(y));
  return rest;
end)();

print(("REST: %s"):format(rest))
