
local maximum(first, second) = do
    if first > second then
        print(`{first} is bigger than {second}.`)
        first
    else do
        print(`{second} is bigger than {first}`)
        second
    end
end

maximum(7, 4)