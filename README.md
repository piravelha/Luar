# Luar

Luar is a dialect of Lua, with many desirable modern language features.

## Important Info

Luar has a few key aspects that are different from Lua, this includes:

### Arrays x Objects x Tables

Luar has a key distinction between those three data types.

Arrays are defined as follows:

```lua
{1, 2, 3, 4, 5}
```

Objects:

```lua
{
    name = "Bob",
    age = 42,
}
```

And tables (more like dictionaries):

```lua
{
    [1] = 2,
    ["my_key"] = 42,
    [true] = false,
    [{1, 2, 3}] = {3, 2, 1},
}
```

### Concise functions

In Luar, all functions just return an expression, however, blocks are expressions too!

So that means, that this is valid Luar code:

```lua
local add(x, y) = x + y
```

But if you need more complexity, you can use a block:

```lua
local complexAdd(x, y) = do
    local z = x + y - 1
    z + 1
end
```

> NOTE: The final expression of a `do` block is the one that gets returned.

### Concise Annonymous Functions

Luar has a pretty neat syntax for annonymous functions (lambdas):

```lua
x to x + 1
```

You can also use them with blocks:

```lua
(x, y, z) to do
    local w = x + y
    local v = z + y
    w * x
end
```

### If ~~statements~~ expressions

In luar, you can perform basic conditional flow as follows:

```lua
local a = 3
local b = 5
local c = if a > b then a else b
```

They are more just like ternary expressions, but because blocks are also expressions, you can use them almost just like you would use if statements in lua:

```lua
local maximum(first, second) = do
    if first > second then
        print(`{first} is bigger than {second}.`)
        first
    else do
        print(`{second} is bigger than {first}`)
        second
    end
end

maximum(2, 3)
```

For convenience, you can omit the 'do' block at the 'then' statement, otherwise, it would look like this:

```lua
local maximum(first, second) = do
    if first > second then do
        print(`{first} is bigger than {second}.`)
        first
    end else do
        print(`{second} is bigger than {first}`)
        second
    end
end

maximum(2, 3)
```

### Structs

Structs are a way to create a special data-type, they allow you to create something similar to
classes in other languages, but in a more functional style.

```lua
struct Person(name, age) = {
    greet = `Hello, my name is {name}, and i am {age} years old!`
}
```

> NOTE: String literal syntax is also supported

### Pattern De-Structuring

Luar supports natural de-structuring of arrays and structs.

You can use this special syntax when declaring a variable, or in function parameters. De-structuring of objects is not currently supported, but that will change soon.

```lua
local processArray({a, b, c, ...rest}) = do
    println(`A: {a}`)
    println(`B: {b}`)
    println(`C: {c}`)
    rest
end

processArray({1, 2, 3, 4, 5}) -- prints 1, 2, 3, and returns {4, 5}
```

> NOTE: Currently, de-structuring only supports one level of pattern matching, to de-structure complex nested objects, you will need to perform multiple variable declarations.

### Inlining

Luar supports inlining of variables, and functions.

Inline variables are names that the compiler replaces by its values at compile-time, whenever they are used.

Inline functions are similar to inline variables, but they are parameterized, they currently do not support de-structuring on the arguments.

```lua
inline add(x, y) = x + y
println(3 * add(2, 1))
```

That gets compiled to:

```lua
println(3 * (2 + 1))
```

> NOTE: Inlining is not just text replacement, it works on the actual syntax tree.
