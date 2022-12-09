require './Greeter'

def hi(name = "World")
    puts "Hello there, #{name}!"
end


hi("Alice")
hi "Bob"
hi "Mallory" "x"
hi


g = Greeter.new("Alex")

g.say_hi
g.say_bye

puts ('a'..'z').to_a

h = {:a => {:b => {:c=> 1}}}

p h.dig(:a, :b, :c)
path = [:a, :b, :c]
p h.dig(*path)
