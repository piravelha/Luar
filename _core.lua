
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

function array(...)
    local values = {...}
    return setmetatable({
        map = function(fn)
            local new = {}
            for i, v in pairs(values) do
                new[i] = fn({v})
            end
            return array(unpack(new))
        end,
        ...,
    }, {
        __tostring = function()
            return show(values)
        end
    })
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

return {
    show = show,
    array = array,
    println = println,
}