local _core = require "_core"
local print = _core.println

-- START INCLUDE: std/point.luar
-- START INCLUDE: std/math.luar
local function max(a, b)
  return (function()
    if (function(a, b)
      return _gt(a, b);
  end)(a, b) then
      return a
    else
      return b
    end
  end)();
end

local function min(a, b)
  return (function()
    if (function(a, b)
      return _lt(a, b);
  end)(a, b) then
      return a
    else
      return b
    end
  end)();
end

local function exp(x)
  return ((Math).e ^ x);
end

local function log(x)
  return (math).log(x);
end

local function log10(x)
  return (math).log10(x);
end

local function sin(x)
  return (math).sin(x);
end

local function cos(x)
  return (math).cos(x);
end

local function tan(x)
  return (math).tan(x);
end

local function asin(x)
  return (math).asin(x);
end

local function acos(x)
  return (math).acos(x);
end

local function atan(x)
  return (math).atan(x);
end

local function sinh(x)
  return (math).sinh(x);
end

local function cosh(x)
  return (math).cosh(x);
end

local function tanh(x)
  return (math).tanh(x);
end

local function ceil(x)
  return (math).ceil(x);
end

local function floor(x)
  return (math).floor(x);
end

local function abs(x)
  return (math).abs(x);
end

local function mod(x, y)
  return (x % y);
end

local function pow(x, y)
  return (x ^ y);
end

local function clamp(x, min, max)
  return (Math).max(min, (Math).min(max, x));
end

local function factorial(n)
  return (function()
    if (function(a, b)
      return _eq(a, b);
  end)(n, 0) then
      return 1
    else
      return (n * (Math).factorial((n - 1)))
    end
  end)();
end

local function gcd(a, b)
  return (function()
    if (function(a, b)
      return _eq(a, b);
  end)(b, 0) then
      return a
    else
      return (Math).gcd(b, (a % b))
    end
  end)();
end

local function lcm(a, b)
  return ((a * b) / (Math).gcd(a, b));
end

local function binomial(n, k)
  return (function()
    local function product_range(...)
      local _args = {...}
      local a = _args[1];

      local b = _args[2];

      _args[3] = _args[3] or 1;
      local acc = _args[3];

      return (function()
        if (function(a, b)
          return _lte(a, b);
      end)(a, b) then
          return product_range((a + 1), b, (acc * a))
        else
          return acc
        end
      end)()
    end
    return (function()
      if (function(a, b)
        return _gt(a, b);
    end)(k, n) then
        return 0
      else
        return (function()
        if (function(a, b)
        return a or b;
      end)((function(a, b)
          return _eq(a, b);
      end)(k, 0), (function(a, b)
          return _eq(a, b);
      end)(k, n)) then
          return 1
        else
          return (function()
          local new_k = (Math).min(k, (n - k));
          return (function(a, b)
            if type(a) ~= "table" and type(b) ~= "table" then
              return _idiv(a, b);
            end
            return getmetatable(a).__idiv(a, b);
          end)(product_range(((n - k) + 1), n), product_range(1, k));
        end)()
        end
      end)()
      end
    end)();
  end)();
end

local function dot(...)
  local _args = {...}
  local a = _args[1];

  local b = _args[2];

  _args[3] = _args[3] or 0;
  local acc = _args[3];

  return (function()
assert((function(a, b)
        return _eq(a, b);
    end)(# a, # b), _string("Math.dot(): vectors must have the same length"));
    return (function()
      if (function(a, b)
        return _eq(a, b);
    end)(# a, 0) then
        return acc
      else
        return (Math).dot((function()
        local _obj = a
        local _start = 2
        local _end = #_obj
        local _step = 1
        return _obj.slice(type(_start) == "number" and _start < 0 and #_obj + _start + 1 or _start, type(_end) == "number" and _end < 0 and #_obj + _end + 1 or _end, type(_step) == "number" and _step < 0 and #_obj + _step + 1 or _step)
      end)(), (function()
        local _obj = b
        local _start = 2
        local _end = #_obj
        local _step = 1
        return _obj.slice(type(_start) == "number" and _start < 0 and #_obj + _start + 1 or _start, type(_end) == "number" and _end < 0 and #_obj + _end + 1 or _end, type(_step) == "number" and _step < 0 and #_obj + _step + 1 or _step)
      end)(), (acc + ((function()
        local _obj = a
        local _index = 1
        return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
      end)() * (function()
        local _obj = b
        local _index = 1
        return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
      end)())))
      end
    end)();
  end)()
end

local function cross(a, b)
  return (function()
assert((function(a, b)
      return a and b;
    end)((function(a, b)
        return _eq(a, b);
    end)(# a, 3), (function(a, b)
        return _eq(a, b);
    end)(# b, 3)), _string("Math.cross(): vectors must have length 3"));
    return array{(((function()
      local _obj = a
      local _index = 2
      return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
    end)() * (function()
      local _obj = b
      local _index = 3
      return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
    end)()) - ((function()
      local _obj = a
      local _index = 3
      return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
    end)() * (function()
      local _obj = b
      local _index = 2
      return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
    end)())), (((function()
      local _obj = a
      local _index = 3
      return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
    end)() * (function()
      local _obj = b
      local _index = 1
      return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
    end)()) - ((function()
      local _obj = a
      local _index = 1
      return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
    end)() * (function()
      local _obj = b
      local _index = 3
      return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
    end)())), (((function()
      local _obj = a
      local _index = 1
      return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
    end)() * (function()
      local _obj = b
      local _index = 2
      return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
    end)()) - ((function()
      local _obj = a
      local _index = 2
      return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
    end)() * (function()
      local _obj = b
      local _index = 1
      return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
    end)()))};
  end)();
end

local Constants;
Constants = setmetatable({
}, {
  __name = "Constants",
  __args = {},
});

-- END INCLUDE: std/math.luar

local function Point(...)
  local _args = {...};
  local x = _args[1];

  local y = _args[2];

  return setmetatable({
    distance = function(...)
      local _args = {...};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end

      return sqrt((((x - x2) ^ 2) + ((y - y2) ^ 2)))
    end,
    dot = function(...)
      local _args = {...};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end

      return ((x * x2) + (y * y2))
    end,
  }, {
    __tostring = function(_, _args)
      local _args = {_args};
      return ("(%s, %s)"):format(x, y)
    end,
    __add = function(_, _args)
      local _args = {_args};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end
      return Point((x + x2), (y + y2))
    end,
    __sub = function(_, _args)
      local _args = {_args};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end
      return Point((x - x2), (y - y2))
    end,
    __mul = function(_, _args)
      local _args = {_args};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end
      return Point((x * x2), (y * y2))
    end,
    __div = function(_, _args)
      local _args = {_args};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end
      return Point((x / x2), (y / y2))
    end,
    __idiv = function(_, _args)
      local _args = {_args};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end
      return Point((function(a, b)
        if type(a) ~= "table" and type(b) ~= "table" then
          return _idiv(a, b);
        end
        return getmetatable(a).__idiv(a, b);
      end)(x, x2), (function(a, b)
        if type(a) ~= "table" and type(b) ~= "table" then
          return _idiv(a, b);
        end
        return getmetatable(a).__idiv(a, b);
      end)(y, y2))
    end,
    __mod = function(_, _args)
      local _args = {_args};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end
      return Point((x % x2), (y % y2))
    end,
    __pow = function(_, _args)
      local _args = {_args};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end
      return Point((x ^ x2), (y ^ y2))
    end,
    __concat = function(_, _args)
      local _args = {_args};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end
      return ((x * x2) + (y * y2))
    end,
    __band = function(_, _args)
      local _args = {_args};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end
      return Point((function(a, b)
        if type(a) ~= "table" and type(b) ~= "table" then
          return _band(a, b);
        end
        return getmetatable(a).__band(a, b);
      end)(x, x2), (function(a, b)
        if type(a) ~= "table" and type(b) ~= "table" then
          return _band(a, b);
        end
        return getmetatable(a).__band(a, b);
      end)(y, y2))
    end,
    __bor = function(_, _args)
      local _args = {_args};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end
      return Point((function(a, b)
        if type(a) ~= "table" and type(b) ~= "table" then
          return _bor(a, b);
        end
        return getmetatable(a).__bor(a, b);
      end)(x, x2), (function(a, b)
        if type(a) ~= "table" and type(b) ~= "table" then
          return _bor(a, b);
        end
        return getmetatable(a).__bor(a, b);
      end)(y, y2))
    end,
    __bxor = function(_, _args)
      local _args = {_args};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end
      return Point((function(a, b)
        if b then
          if type(a) ~= "table" then
            return _bxor(a, b);
          end
          return getmetatable(a) and getmetatable(a).__bxor(a, b);
        end
        if type(a) ~= "table" then
          return _bnot(a);
        end
        return getmetatable(a) and getmetatable(a).__bnot(a);
      end)(x, x2), (function(a, b)
        if b then
          if type(a) ~= "table" then
            return _bxor(a, b);
          end
          return getmetatable(a) and getmetatable(a).__bxor(a, b);
        end
        if type(a) ~= "table" then
          return _bnot(a);
        end
        return getmetatable(a) and getmetatable(a).__bnot(a);
      end)(y, y2))
    end,
    __shl = function(_, _args)
      local _args = {_args};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end
      return Point((function(a, b)
        if type(a) ~= "table" and type(b) ~= "table" then
          return _shl(a, b);
        end
        return getmetatable(a).__shl(a, b);
      end)(x, x2), (function(a, b)
        if type(a) ~= "table" and type(b) ~= "table" then
          return _shl(a, b);
        end
        return getmetatable(a).__shl(a, b);
      end)(y, y2))
    end,
    __shr = function(_, _args)
      local _args = {_args};
      local x2, y2
      if getmetatable(_args[1]) and getmetatable(_args[1]).__args then
        x2 = getmetatable(_args[1]).__args[1];
        y2 = getmetatable(_args[1]).__args[2];
      else
        x2 = _args[1][1];
        y2 = _args[1][2];
      end
      return Point((function(a, b)
        if type(a) ~= "table" and type(b) ~= "table" then
          return _shr(a, b);
        end
        return getmetatable(a).__shr(a, b);
      end)(x, x2), (function(a, b)
        if type(a) ~= "table" and type(b) ~= "table" then
          return _shr(a, b);
        end
        return getmetatable(a).__shr(a, b);
      end)(y, y2))
    end,
    __bnot = function(_, _args)
      local _args = {_args};
      return Point((function(a, b)
        if b then
          if type(a) ~= "table" then
            return _bxor(a, b);
          end
          return getmetatable(a) and getmetatable(a).__bxor(a, b);
        end
        if type(a) ~= "table" then
          return _bnot(a);
        end
        return getmetatable(a) and getmetatable(a).__bnot(a);
      end)(x), (function(a, b)
        if b then
          if type(a) ~= "table" then
            return _bxor(a, b);
          end
          return getmetatable(a) and getmetatable(a).__bxor(a, b);
        end
        if type(a) ~= "table" then
          return _bnot(a);
        end
        return getmetatable(a) and getmetatable(a).__bnot(a);
      end)(y))
    end,
    __unm = function(_, _args)
      local _args = {_args};
      return Point(- x, - y)
    end,
    __cast_Array = function(_)
      return array{x, y}
    end,
    __cast_Complex = function(_)
      return Complex(x, y)
    end,
    __name = "Point",
    __args = {...},
  })
end

-- END INCLUDE: std/point.luar

print((_cast(Point(3, 4), "Complex") + Complex(1, 2)))
