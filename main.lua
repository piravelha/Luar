
struct Set(values) = {
    insert(value) = if not values.find(value)
        then Set(values + {value})
        else Set(values),
    operator |({others}) = others.reduce(
        Set(values),
        (set, other) to set.insert(other),
    ),
}

local mySet = Set({1, 2, 3})
print(mySet | Set({4, 5, 6, 2, 3})) -->> Set({1, 2, 3, 4, 5, 6})

