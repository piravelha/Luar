local _core = require "_core"
local print = _core.println

local function Person(...)
  local _args = {...};
  local name = _args[1];

  local age = _args[2];

  return setmetatable({
    print_info = function(...)
      local _args = {...};

      return (function()
        print(("NAME: %s"):format(name));
        return print(("AGE: %s"):format(age));
      end)()
    end,
  }, {
    __name = "Person",
    __args = {...},
  })
end

local mark = Person(_string("Mark"), 42);

(mark).print_info()
