
function show(obj)
    if type(obj) ~= "table" then
        return tostring(obj)
    end

    local mt = getmetatable(obj)

    if mt and mt.__tostring then
        return mt.__tostring(obj)
    end

    if mt and mt.__args then
        local name = mt.__name
        local args = mt.__args
        local str = name .. "("
        for i, a in pairs(args) do
            str = str .. show(a)
            if i < #args then
                str = str .. ", "
            end
        end
        return str .. ")"
    end

    local str = "{"
    for k, v in pairs(obj) do
        if type(k) == "number" then
            str = str .. show(v)
        else
            str = str .. "[" .. show(k) .. "] = " .. show(v)
        end
        str = str .. ", "
    end
    str = str:sub(1, -3)
    return str .. "}"
end

function array(values)
    local obj = values
    obj.map = function(fn)
        local new = {}
        for i, v in pairs(values) do
            if type(i) == "number" then
                new[i] = fn({v})
            end
        end
        return array(new)
    end
    obj.reduce = function(default, fn)
        local acc = default
        for i, v in pairs(values) do
            if type(i) == "number" then
                acc = fn({acc, v})
            end
        end
        return acc
    end
    obj.reverse = function()
        local new = {}
        for i, v in pairs(values) do
            if type(i) == "number" then
                new[#values - i + 1] = v
            end
        end
        return array(new)
    end
    obj.filter = function(fn)
        local new = {}
        for i, v in pairs(values) do
            if type(i) == "number" and fn({v}) then
                table.insert(new, v)
            end
        end
        return array(new)
    end
    obj.find = function(needle)
        for i, v in pairs(values) do
            if type(i) == "number" and v == needle then
                return i
            end
        end
        return nil
    end
    setmetatable(obj, {
        __values = values,
        __type = "array",
        __tostring = function()
            return show(values)
        end,
        __add = function(_, other)
            if not getmetatable(other) or getmetatable(other).__type ~= "array" then
                error("attempt to perform add operation on an array and a non-array value ") 
            end
            local new = {}
            for i, v in pairs(values) do
                if type(i) == "number" then
                    new[i] = v
                end
            end
            for i, v in pairs(getmetatable(other).__values) do
                if type(i) == "number" then
                    new[#new + 1] = v
                end
            end
            return array(new)
        end
    })
    return obj
end

function range(min, max, step)
    if not max then
        max = min
        min = 1
    end
    step = step or 1
    local values = {}
    for i = min, max, step do
        table.insert(values, i)
    end
    return array(values)
end

function unpack(tbl, index)
    index = index or 1
    if index > 1 then
        local new = {}
        for i, v in pairs(tbl) do
            new[i] = v
        end
        table.remove(new, 1)
        return unpack(new, index - 1)
    end
    if #tbl == 1 then
        return tbl[1]
    end
    local new = {}
    for i, v in pairs(tbl) do
        new[i] = v
    end
    table.remove(new, 1)
    return tbl[1], unpack(new)
end

function println(...)
    local reprs = {}
    for _, obj in pairs({...}) do
        table.insert(reprs, show(obj))
    end
    print(unpack(reprs))
end

function _idiv(a, b)
    return math.floor(a / b)
end

function _band(a, b)
    local result = 0
    local bit = 1
    while a > 0 and b > 0 do
      if (a % 2 == 1) and (b % 2 == 1) then
          result = result + bit
      end
         a = math.floor(a / 2)
        b = math.floor(b / 2)
        bit = bit * 2
    end
    return result
end

function _bor(a, b)
    local result = 0
    local bit = 1
    while a ~= 0 or b ~= 0 do
         if (a % 2 == 1) or (b % 2 == 1) then
             result = result + bit
         end
         a = math.floor(a / 2)
          b = math.floor(b / 2)
         bit = bit * 2
    end
    return result
end

function _bxor(a, b)
    local result = 0
    local bit = 1
    while a ~= 0 or b ~= 0 do
        if (a % 2 ~= b % 2) then
            result = result + bit
        end
        a = math.floor(a / 2)
        b = math.floor(b / 2)
        bit = bit * 2
    end
    return result
end

function _bnot(a)
    local result = 0
    local bit = 1
    for i = 1, 32 do
        if a % 2 == 0 then
           result = result + bit
        end
        a = math.floor(a / 2)
        bit = bit * 2
    end
    return result
end

function _shl(a, n)
    return a * (2 ^ n)
end

function _shr(a, n)
    return math.floor(a / (2 ^ n))
end

return {
    show = show,
    array = array,
    println = println,
}