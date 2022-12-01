class Bag
    def initialize(size = 3, min = 0)
        @bag = Array.new(size, min)
        @min = min
    end

    def add(val)
        if val > @min
            @bag.delete_at(@bag.index(@min))
            @bag.push(val)
            old_min = @min
            @min = @bag.min
            return old_min
        end
        return val
    end

    def sum()
        return @bag.sum
    end
end


file = ARGV[0]

puts("Reading ", file)


max_elf = 0
elf = 0

bag = Bag.new
IO.readlines(file, chomp: true).each do |line|
    puts(line)
    if line == ''
        bag.add(elf)
        elf = 0
        next
    end
    elf += line.to_i
end

bag.add(elf)

puts("Top 3 Calories: ", bag.sum)
