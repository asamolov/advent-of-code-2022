file = ARGV[0]

puts("Reading ", file)


shapes = {"A" => :rock, "B" => :paper, "C" => :scissors}

outcomes = {"X" => :lose, "Y" => :draw, "Z" => :win}
    
shape_score = {:rock => 1, :paper => 2, :scissors => 3}

strategies = {
    [:rock, :lose] => :scissors,
    [:rock, :draw] => :rock,
    [:rock, :win]  => :paper,
    [:paper, :lose] => :rock,
    [:paper, :draw] => :paper,
    [:paper, :win]  => :scissors,
    [:scissors, :lose] => :paper,
    [:scissors, :draw] => :scissors,
    [:scissors, :win]  => :rock
}

def strategy(opponent, outcome)


end

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
    outcome = outcomes[inputs[1]]
    you = strategies[[opponent, outcome]]
    total_score += shape_score[you] + match(opponent, you)
end

puts("total_score: #{total_score}")
