local _core = require "_core"
local print = _core.println

local function factors(...)
  local _args = {...}
  local n = _args[1]

  _args[2] = _args[2] or 2
  local start = _args[2]

  _args[3] = _args[3] or array(array{})
  local acc = _args[3]

  return (function()
    
    return (function()
      if n <= 1 then
        return (function()
        
        return acc
      end)()
      else
        return (function()
        
        return (function()
          if n % start == 0 then
            return (function()
            
            return factors(n / start, start + 1, (function()
              if (acc).find(start) then
                return (function()
                
                return acc
              end)()
              else
                return (function()
                
                return acc + array{start}
              end)()
              end
            end)())
          end)()
          else
            return (function()
            
            return (function()
              
              return factors(n, start + 1, acc)
            end)()
          end)()
          end
        end)()
      end)()
      end
    end)()
  end)()
end

local function is_prime(...)
  local _args = {...}
  local n = _args[1]

  return # factors(n) == 1
end

local solution = (function()
  local _obj = (factors(600851475143)).filter(is_prime)
  local _index = - 1
  return _obj[type(_index) == "number" and _index < 0 and #_obj + _index + 1 or _index]
end)()

print(solution)
