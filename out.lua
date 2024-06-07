local _core = require "_core"
local print = _core.println

-- START INCLUDE: std/io.luar
local IO;
IO = setmetatable({
  read = function(...)
    local _args = {...};
    local file = _args[1];

    return (function()
      (io).input(rawstr(file));
      (io).read(rawstr(_string("*all")));
    end)()
  end,
  write = function(...)
    local _args = {...};
    local contents = _args[1];

    return (function()
      (io).write(rawstr(contents));
    end)()
  end,
}, {
  __name = "IO",
  __args = {},
});

-- END INCLUDE: std/io.luar

local str = (_string("Hello, World!\n")).replace(_string("World"), _string("Luar"));

(IO).write(str)
