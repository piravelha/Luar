
struct Box(value) = {}

local test({values}) = do
    local {a, b, ...rest} = values
    println(a + b, rest)
end

local myBox = Box({1, 2, 3, 4, 5, 6})
test(myBox)
--> 3   {3, 4, 5, 6}

inline add(x, y) = do
    local z = x + y
    z
end

println(add(1, 2))