
local array = {1, 2, 3, 4, 5}

(function()
    local new = {}
    for _, x in pairs(array) do
        new[#new + 1] = x ^ 2
    end
    for _, x in pairs(new) do
        print(x)
    end
    return new
end)()