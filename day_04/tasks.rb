require 'set'

file = ARGV[0]

puts("Reading ", file)


priorities = {}

def to_range(line)
    inputs = line.split("-", 2).map { |str| str.to_i }
    Range::new(inputs[0], inputs[1])
end

def contains(r1, r2)
    r1.begin <= r2.begin && r1.end >= r2.end
end

def includes(r1, r2)
    r1.include?(r2.begin) || r1.include?(r2.end) || r2.include?(r1.begin) || r2.include?(r1.end)
end

def contains_full(r1, r2)
    contains(r1, r2) || contains(r2, r1)
end


total_contains = 0
total_includes = 0
IO.readlines(file, chomp: true).each do |line|
    puts(line)
    inputs = line.split(",", 2)
    r1 = to_range(inputs[0])
    r2 = to_range(inputs[1])
    if contains_full(r1, r2)
        total_contains+=1
    end
    if includes(r1, r2)
        total_includes+=1
    end
end

puts("total_contains: #{total_contains}")
puts("total_includes: #{total_includes}")
