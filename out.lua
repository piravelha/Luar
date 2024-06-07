local _core = require "_core"
local print = _core.println

-- START INCLUDE: std/maybe.luar
local None;
None = setmetatable({
  map = function(...)
    local _args = {...};
    local fn = _args[1];

    return None
  end,
  flatmap = function(...)
    local _args = {...};
    local fn = _args[1];

    return None
  end,
}, {
  __bor = function(_, _args)
    local _args = {_args};
    local other = _args[1];
    return other
  end,
  __band = function(_, _args)
    local _args = {_args};
    local other = _args[1];
    return None
  end,
  __name = "None",
  __args = {},
});

local function Some(...)
  local _args = {...};
  local value = _args[1];

  return setmetatable({
    map = function(...)
      local _args = {...};
      local fn = _args[1];

      return Some(fn(value))
    end,
    flatmap = function(...)
      local _args = {...};
      local fn = _args[1];

      return fn(value)
    end,
  }, {
    __bor = function(_, _args)
      local _args = {_args};
      local other = _args[1];
      return Some(value)
    end,
    __band = function(_, _args)
      local _args = {_args};
      local other = _args[1];
      return other
    end,
    __name = "Some",
    __args = {...},
  })
end

-- END INCLUDE: std/maybe.luar

local function div(a, b)
  return (function()
    if (function(a, b)
      return _eq(a, b);
  end)(b, 0) then
      return None
    else
      return Some((a / b))
    end
  end)();
end

local function factorial(x)
  return (function()
    local function aux(x)
      return (function()
        if (function(a, b)
          return _lte(a, b);
      end)(x, 1) then
          return 1
        else
          return (x * aux((x - 1)))
        end
      end)();
    end
    return (function()
      if (function(a, b)
        return _lt(a, b);
    end)(x, 0) then
        return None
      else
        return Some(aux(x))
      end
    end)();
  end)();
end

local function main()
  return (function()
    return (div(8, 0)).flatmap((function(a)
      return (function()
        return (factorial(a)).flatmap((function(b)
          return (function()
            return Some(b);
          end)();
        end));
      end)();
    end));
  end)();
end

print(main())
