
struct Person(name, age) = {
    set_name(n) = Person(n, age)
}

println(Person("Ian", 5).set_name("Miguel"))
--> Person(Miguel, 5)

