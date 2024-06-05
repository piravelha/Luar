
struct Person(name, age) = {}

local birthdays(people) = people.map({name, age} to Person(name, age + 1))

local myArray = {Person("Bob", 42), Person("John", 23), Person("Jane", 18)}
println(birthdays(myArray))

