
function show(obj)
    if type(obj) ~= "table" then
        return tostring(obj)
    end

    local mt = getmetatable(obj)

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
end

function println(obj)
    print(show(obj))
end