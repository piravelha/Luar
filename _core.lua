
local op_lookup = {
    ["+"] = "add",
    ["-"] = "sub",
    ["unary_-"] = "unm",
    ["*"] = "mul",
    ["/"] = "div",
    ["//"] = "idiv",
    ["%"] = "mod",
    ["^"] = "pow",
    ["=="] = "eq",
    ["~="] = "neq",
    ["<"] = "lt",
    [">"] = "gt",
    ["<="] = "lte",
    [">="] = "gte",
    ["|"] = "bor",
    ["&"] = "band",
    ["~"] = "bxor",
    ["<<"] = "shl",
    [">>"] = "shr",
    [".."] = "concat",
    ["unary_~"] = "bnot",
    ["unary_#"] = "len",
    ["tostring"] = "tostring",
    ["index"] = "index",
}

local _supported_ops = {
    number = {
        "+", "-", "unary_-", "*", "/", "//", "%", "^", "==", "~=", "<", ">", "<=", ">=", "|", "&", "~", "<<", ">>", "unary_~", "tostring"
    },
}

function asserttype(obj, func, level, ...)
    types = {...}
    match = false
    for _, typ in pairs(types) do
        if type(typ) == "table" and typ.kind == "constrain" then
            local methods = typ.methods
            if _supported_ops[type(obj)] then
                local found = false
                for _, method in pairs(methods) do
                    for _, op in pairs(_supported_ops[type(obj)]) do
                        if method == op then
                            found = true
                        end
                    end
                end
                if found then
                    match = true
                end
            end
            if type(obj) == "table" then
                local has_all = true
                for _, method in pairs(methods) do
                    if not getmetatable(obj)["__" .. op_lookup[method]] then
                        has_all = false
                    end
                end
                if has_all then
                    match = true
                end
            end
        elseif typeof(obj) == typ then
            match = true
        end
    end
    if not match then
        local info = debug.getinfo(2, "n").name and debug.getinfo(2, "n").name .. "()" or "Unknown"
        if #types == 1 then
            error(string.format("(%s) %s: Could not match type '%s' with expected type '%s'.", func, info, typeof(obj), types[1]), level + 1)
        end
        error(string.format("(%s) %s: Could not match type '%s' with one of the expected types: %s", func, info, typeof(obj), table.concat(types, ", ")), level + 1)
    end
end

function Constrain(...)
    local methods = {}
    for _, m in pairs({...}) do
        table.insert(methods, type(m) == "string" and m or rawstr(m))
    end
    return setmetatable({
        methods = methods,
        kind = "constrain"
    }, {
        __tostring = function()
            return string.format("Constrain {%s}", table.concat(methods, ", "))
        end,
    })
end

function typeof(obj)
    if type(obj) ~= "table" then
        return type(obj)
    end
    return getmetatable(obj).__type
end

function show(obj, depth)
    depth = depth or 0
    if depth > 10 then
        return "{...}"
    end

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
            str = str .. show(a, depth + 1)
            if i < #args then
                str = str .. ", "
            end
        end
        str = str .. ")"
        if #args == 0 then
            str = str:sub(1, -3)
        end
        return str
    end

    local str = "{"
    local empty = true
    for k, v in pairs(obj) do
        empty = false
        if type(k) == "number" then
            str = str .. show(v, depth + 1)
        else
            str = str .. "[" .. show(k, depth + 1) .. "] = " .. show(v, depth + 1)
        end
        str = str .. ", "
    end
    if empty then
        return "{}"
    end
    str = str:sub(1, -3)
    return str .. "}"
end

function _string(value)
    asserttype(value, "string", 2, "string")
    return setmetatable({
        reverse = function()
            return _string(string.reverse(value))
        end,
        split = function(sep)
            asserttype(sep, "string.split()", 2, "string")
            local parts = {}
            for part in value:gmatch(getmetatable(_string("([^") .. sep .. _string("]+)")).__value) do
                table.insert(parts, _string(part))
            end
            return array(parts)
        end,
        lower = function()
            return _string(string.lower(value))
        end,
        upper = function()
            return _string(string.upper(value))
        end,
        trim = function()
            return _string(value:gsub("^%s*(.-)%s*$", "%1"))
        end,
        trimleft = function()
            return _string(value:gsub("^%s*", ""))
        end,
        trimright = function()
            return _string(value:gsub("%s*$", ""))
        end,
        startswith = function(prefix)
            asserttype(prefix, "string.startswith()", 2, "string")
            return value:sub(1, #prefix) == prefix
        end,
        endswith = function(suffix)
            asserttype(suffix, "string.endswith()", 2, "string")
            return value:sub(-#suffix) == suffix
        end,
        contains = function(sub)
            asserttype(sub, "string.contains()", 2, "string")
            return value:find(getmetatable(sub).__value) ~= nil
        end,
        replace = function(old, new)
            asserttype(old, "string.replace()", 2, "string")
            asserttype(new, "string.replace()", 2, "string")
            return _string(value:gsub(getmetatable(old).__value, getmetatable(new).__value))
        end,
        find = function(sub)
            asserttype(sub, "string.find()", 2, "string")
            return value:find(getmetatable(sub).__value)
        end,
        count = function(sub)
            asserttype(sub, "string.count()", 2, "string")
            local count = 0
            for _ in value:gmatch(getmetatable(sub).__value) do
                count = count + 1
            end
            return count
        end,
    }, {
        __index = function(self, key)
            if type(key) == "number" then
                return value:sub(key, key)
            end
            return rawget(self, key)
        end,
        __tostring = function()
            return "\"" .. value .. "\""
        end,
        __eq = function(_, other)
            return value == getmetatable(other).__value
        end,
        __concat = function(_, other)
            return _string(value .. getmetatable(other).__value)
        end,
        __mul = function(_, other)
            return _string(value:rep(other))
        end,
        __len = function()
            return #value
        end,
        __type = "string",
        __value = value,
    })
end

function rawstr(obj)
    return getmetatable(obj).__value
end

function array(values)
    values = values or {}
    local old = {}
    for i, v in pairs(values) do
        old[i] = v
    end
    local obj = values
    obj.slice = function(start, stop, step)
        local new = {}
        for i = start, stop, step do
            new[#new + 1] = values[i]
        end
        return array(new)
    end
    obj.join = function(sep)
        local str = _string("")
        for i, v in pairs(old) do
            str = str .. v
            if i < #old then
                str = str .. sep
            end
        end
        return str
    end
    obj.zipwith = function(fn, other)
        if not getmetatable(other) or getmetatable(other).__type ~= "array" then
            error("attempt to perform elemwise operation on an array and a non-array value ") 
        end
        local new = {}
        for i, v in pairs(values) do
            if type(i) == "number" then
                new[i] = fn(v, getmetatable(other).__values[i])
            end
        end
        return array(new)
    end
    obj.map = function(fn)
        local new = {}
        for i, v in pairs(old) do
            if type(i) == "number" then
                new[i] = fn(v)
            end
        end
        return array(new)
    end
    obj.reduce = function(default, fn)
        local acc = default
        for i, v in pairs(values) do
            if type(i) == "number" then
                acc = fn(acc, v)
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
            if type(i) == "number" and fn(v) then
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
    obj.flatten = function()
        local new = {}
        for i, arr in pairs(old) do
            for j, v in pairs(arr) do
                if type(j) == "number" then
                    new[#new + 1] = v
                end
            end
        end
        return array(new)
    end
    setmetatable(obj, {
        __values = old,
        __type = "array",
        __tostring = function()
            return show(old)
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
        end,
        __eq = function(_, other)
            if not getmetatable(other) or getmetatable(other).__type ~= "array" then
                return false
            end
            if #values ~= #getmetatable(other).__values then
                return false
            end
            for i, v in pairs(old) do
                if v ~= getmetatable(other).__values[i] then
                    return false
                end
            end
            return true
        end,
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
    for i, obj in pairs({...}) do
        local repr = show(obj)
        if getmetatable(obj) and getmetatable(obj).__type == "string" then
            repr = repr:sub(2, -2)
        end
        reprs[#reprs + 1] = repr
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

function _eq(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then
        return a == b
    end

    local mt = getmetatable(a)
    if mt and mt.__eq then
        return mt.__eq(a, b)
    end

    if mt and mt.__name and  mt.__args then
        local bmt = getmetatable(b)
        if not bmt or bmt.__name ~= mt.__name or #bmt.__args ~= #mt.__args then
            return false
        end
        for i, arg in pairs(mt.__args) do
            if not _eq(arg, bmt.__args[i]) then
                return false
            end
        end
        return true
    end

    return false
end

function _lt(a, b)
    asserttype(a, "<", 2, Constrain("<"))
    asserttype(b, ">", 2, Constrain(">"))
    if type(a) ~= "table" or type(b) ~= "table" then
        return a < b
    end

    local mt = getmetatable(a)
    if mt and mt.__lt then
        return mt.__lt(a, b)
    end

    if mt and mt.__name and  mt.__args then
        local bmt = getmetatable(b)
        if not bmt or bmt.__name ~= mt.__name or #bmt.__args ~= #mt.__args then
            return false
        end
        for i, arg in pairs(mt.__args) do
            if not _lt(arg, bmt.__args[i]) then
                return false
            end
        end
        return true
    end

    return false
end

function _lte(a, b)
    asserttype(a, "<=", 2, Constrain("<="))
    asserttype(b, "<=", 2, Constrain("<="))
    if type(a) ~= "table" or type(b) ~= "table" then
        return a <= b
    end

    local mt = getmetatable(a)
    if mt and mt.__le then
        return mt.__le(a, b)
    end

    if mt and mt.__name and  mt.__args then
        local bmt = getmetatable(b)
        if not bmt or bmt.__name ~= mt.__name or #bmt.__args ~= #mt.__args then
            return false
        end
        for i, arg in pairs(mt.__args) do
            if not _le(arg, bmt.__args[i]) then
                return false
            end
        end
        return true
    end

    return false
end

function _gt(a, b)
    asserttype(a, ">", 2, Constrain(">"))
    asserttype(b, ">", 2, Constrain(">"))
    if type(a) ~= "table" or type(b) ~= "table" then
        return a > b
    end

    local mt = getmetatable(a)
    if mt and mt.__gt then
        return mt.__gt(a, b)
    end

    if mt and mt.__name and  mt.__args then
        local bmt = getmetatable(b)
        if not bmt or bmt.__name ~= mt.__name or #bmt.__args ~= #mt.__args then
            return false
        end
        for i, arg in pairs(mt.__args) do
            if not _gt(arg, bmt.__args[i]) then
                return false
            end
        end
        return true
    end

    return false
end

function _gte(a, b)
    asserttype(a, ">=", 2, Constrain(">="))
    asserttype(b, ">=", 2, Constrain(">="))
    if type(a) ~= "table" or type(b) ~= "table" then
        return a >= b
    end

    local mt = getmetatable(a)
    if mt and mt.__ge then
        return mt.__ge(a, b)
    end

    if mt and mt.__name and  mt.__args then
        local bmt = getmetatable(b)
        if not bmt or bmt.__name ~= mt.__name or #bmt.__args ~= #mt.__args then
            return false
        end
        for i, arg in pairs(mt.__args) do
            if not _ge(arg, bmt.__args[i]) then
                return false
            end
        end
        return true
    end

    return false
end

return {
    show = show,
    array = array,
    println = println,
}