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
    if head[0] == tail[0] # moving horizontally
        row = tail[0]
        col = head[1] > tail[1] ? tail[1] + 1 : tail[1] - 1
    elsif head[1] == tail[1] # moving vertically
        row = head[0] > tail[0] ? tail[0] + 1 : tail[0] - 1
        col = tail[1]
    else # moving diagonally        
        row = head[0] > tail[0] ? tail[0] + 1 : tail[0] - 1
        col = head[1] > tail[1] ? tail[1] + 1 : tail[1] - 1
    end

    # rewriten in single
    row =
    if head[0] == tail[0]
        tail[0]
    else
        head[0] > tail[0] ? tail[0] + 1 : tail[0] - 1
    end
    col =
    if head[1] == tail[1]
        tail[1]
    else
        head[1] > tail[1] ? tail[1] + 1 : tail[1] - 1
    end
        
    return [row, col]
end

head = [0, 0]
tail = [0, 0]
tails = Set.new
tails.add(tail)
CMD = /(\w) (\d+)/


IO.readlines(file, chomp: true).each do |line|
    puts line
    m = line.match(CMD)
    direction = m[1]
    steps = m[2].to_i
    
    steps.times do 
        case direction
            when "L"
                head[1] -= 1                
            when "R"
                head[1] += 1
            when "U"
                head[0] += 1
            when "D"
                head[0] -= 1
        end        
        tail = move_tail(head, tail)
        tails.add(tail)
        #p tails
    end
end


puts "tail visited: #{tails.size}"
