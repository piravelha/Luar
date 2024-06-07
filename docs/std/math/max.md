# `max(a, b)`

## Data Types

- `ord`: Any struct which supports both `(<)`, and `(>)` operations.

## Signature


```lua
(ord, ord) -> ord
```

## Throws When

1. Arguments do not provide support for `(>)` operation.

## Parameters

- `a`: The first value.
> `ord`

- `b`: The second value.
> `ord`

## Returns

- `returns`: The maximum between the first and the second value, based on the return type of the `(>)` operation applied to the parameters.
> `ord`

## Examples

```lua
include "math"

struct Box(value) = {
    operator <({other}) = value < other,
    operator >({other}) = value > other,
}

print(max(Box(10), Box(15)))
--> Output: Box(15)

print(max(Box(3), Box(2)))
--> Output: Box(3)
```