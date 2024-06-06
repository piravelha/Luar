
array = [[x * y for x in range(99, 999)] for y in range(99, 999)]

def is_palindrome(number):
    original_number = number
    reversed_number = 0

    while number > 0:
        digit = number % 10
        reversed_number = reversed_number * 10 + digit
        number = number // 10

    return original_number == reversed_number

flattened = []
for xs in array:
    for x in xs:
        flattened.append(x)

filtered = list(filter(is_palindrome, flattened))

print(max(filtered))