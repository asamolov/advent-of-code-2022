class Greeter
    def initialize(name = "world")
        @name = name
    end

    def say_hi
        puts "Hello, #{@name}!"
    end

    def say_bye
        puts "Sayonara, #{@name}!"
    end

end