require 'strscan'
require 'set'

file = ARGV[0]

puts("Reading ", file)

def move_tail(head, tail)
    if (head[0] - tail[0]).abs <= 1 &&
        (head[1] - tail[1]).abs <= 1
        # head and tail are touching
        return tail
    end

    # rewriten in single statement
    return [
        tail[0] + (head[0] <=> tail[0]),
        tail[1] + (head[1] <=> tail[1])
    ]
end

def move_rope(rope)
    (1...rope.size).each do |x|
        rope[x] = move_tail(rope[x-1], rope[x])
    end
end

rope = Array.new(10) {Array.new(2, 0)}
tails = Set.new
tails.add(rope.last)

CMD = /(\w) (\d+)/

IO.readlines(file, chomp: true).each do |line|
    puts line
    m = line.match(CMD)
    direction = m[1]
    steps = m[2].to_i
    
    steps.times do 
        case direction
            when "L"
                rope.first[1] -= 1                
            when "R"
                rope.first[1] += 1
            when "U"
                rope.first[0] += 1
            when "D"
                rope.first[0] -= 1
        end        
        move_rope(rope)
        tails.add(rope.last)
    end
end


puts "tail visited: #{tails.size}"