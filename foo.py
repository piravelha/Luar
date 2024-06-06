from collections import deque

stack = deque()
append = stack.append
pop = stack.pop

for _ in range(15_000_000):
    append(69)
    pop()

print("Finished!")