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

- `a`: The first value
> `ord`

---

- `b`: The second value
> `ord`

## Returns

- `returns`: The maximum between the first and the second value, based on the return type of the `(>)` operation on the parameters
> `ord`