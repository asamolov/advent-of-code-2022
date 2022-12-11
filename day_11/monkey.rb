require 'strscan'
require 'set'

file = ARGV[0]

puts("Reading ", file)

class Monkey
    def initialize(n, items, opProc, divider, monkeyIfTrue, monkeyIfFalse)
        @n = n
        @items = items.dup
        @opProc = opProc
        @nextMonkeyProc = -> (item) { item % divider == 0 ? monkeyIfTrue : monkeyIfFalse}
        @divider = divider
        @inspected = 0
    end

    def add(item)
        @items.push(item)
    end
    
    def to_s
        "Monkey #{@n}: #{@items.join(", ")}"
    end

    def inspected
        @inspected
    end

    def divider
        @divider
    end

    # returns list of pairs [monkey, item]
    def round(reduce_stress = true)
        # puts "Monkey #{@n}:"
        result = []
        while @items.size > 0 do
            item = @items.shift
            # puts "  Monkey inspects an item with a worry level of #{item}."
            @inspected += 1
            item = @opProc.call(item)
            # puts "    Worry level increased to #{item}."
            item = reduce_stress ? item / 3 : item
            # puts "    Monkey gets bored with item. Worry level is divided by 3 to #{item}."            
            monkey = @nextMonkeyProc.call(item)
            # puts "    Item with worry level #{item} is thrown to monkey #{monkey}."
            result.push([monkey, item])
        end
        return result
    end
end

def parse(n, lines)
    items = []
    opProc = nil
    divider = 0
    monkeyIfTrue = -1
    monkeyIfFalse = -1
    p lines
    lines.each do |line|
        p line
        case line
        when /Starting items: ([\d\s,]+)/
            items = $1.split(", ").map {|x| x.to_i}
            p items
        when /Operation: new = old \* old/
            opProc = ->(old) { old * old }
        when /Operation: new = old \+ (\d+)/
            arg = $1.to_i
            opProc = ->(old) { old + arg }
        when /Operation: new = old \* (\d+)/
            arg = $1.to_i
            opProc = ->(old) { old * arg }
        when /Test: divisible by (\d+)/
            divider = $1.to_i
        when /If true: throw to monkey (\d+)/
            monkeyIfTrue = $1.to_i
        when /If false: throw to monkey (\d+)/
            monkeyIfFalse = $1.to_i
        else
            raise "Cannot parse line: #{line}"
        end
    end
    return Monkey.new(n, items, opProc, divider, monkeyIfTrue, monkeyIfFalse)
end

lines = IO.readlines(file, chomp: true).each
monkeys = []
divider = 1

loop do
    line = lines.next
    case line
    when /Monkey (\d+):/
        n = $1.to_i
        input = []
        5.times {input.push(lines.next)}
        monkey = parse(n, input)
        monkeys.push(monkey)
        divider *= monkey.divider
    when ""
        #noop
    else
        raise "Unexpected line: #{line}"
    end
end

(1..10000).each do |round|
    monkeys.each do |monkey|
        result = monkey.round(false)
        result.each {|x| monkeys[x[0]].add(x[1] % divider)}
    end
    puts "After round #{round}, the monkeys are holding items with these worry levels:"
    monkeys.each {|m| puts m}
end

max_monkeys = monkeys.max(2) {|a, b| a.inspected <=> b.inspected }

p max_monkeys

monkey_business_level = max_monkeys.map {|x| x.inspected}.inject(1, :*)

puts "level of monkey business: #{monkey_business_level}"

