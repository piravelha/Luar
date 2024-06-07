local _core = require "_core"
local print = _core.println

print((array{1, 2, 3}).map((function(...)
  local _args = {...};
  local x = _args[1];
  return (function()
    local a = x;
    local b = 1;
    asserttype(a, "+", 2, Constrain("+"));
    asserttype(b, "+", 2, Constrain("+"));
    return a + b;
  end)()
end)))
