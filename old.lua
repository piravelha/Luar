
local function Box(value)
    return {
        __type = "Box",
        value = value,
    }
end

local function test(box)
    local a = box.value[1]
    local b = box.value[2]
    local rest = {unpack(box.value, 3)}
    print(a + b, rest)
end

local myBox = Box({1, 2, 3, 4, 5, 6})
test(myBox)
--> 3   table: 0x755da48e8b78

