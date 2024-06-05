array = range(1, 100000000)

def reduce(arr, acc, fn):
    for x in arr:
        acc = fn(acc, x)
    return acc

def add(acc, x):
    return acc + x

print(reduce(array, 0, add))