file = ARGV[0]

puts("Reading ", file)


shapes = {"A" => :rock, "B" => :paper, "C" => :scissors,
    "X" => :rock, "Y" => :paper, "Z" => :scissors}

shape_score = {:rock => 1, :paper => 2, :scissors => 3}

def match(opponent, you)
    puts("#{opponent}\tvs\t#{you}")
    # draw
    if opponent == you
        return 3
    # you win
    elsif (opponent == :rock && you == :paper) ||
        (opponent == :paper && you == :scissors) ||
        (opponent == :scissors && you == :rock)
        return 6
    else
    # you lose
        return 0
    end 
end

total_score = 0

IO.readlines(file, chomp: true).each do |line|
    puts(line)
    inputs = line.split(" ", 2)
    opponent = shapes[inputs[0]]
    you = shapes[inputs[1]]
    total_score += shape_score[you] + match(opponent, you)
end

puts("total_score: #{total_score}")
