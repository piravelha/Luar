
local factors(n, start = 2, acc = array{}) = do
    if n <= 1 then
        acc
    else if n % start == 0 then
        factors(n / start, start + 1, if acc.find(start) then acc else acc + {start})
    else do
        factors(n, start + 1, acc)
    end
end

local is_prime(n) = #factors(n) == 1

local solution = factors(600851475143).filter(is_prime)[-1]

print(solution)

