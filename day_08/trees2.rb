require 'strscan'
require 'set'


file = ARGV[0]

puts("Reading ", file)

forest = []

IO.readlines(file, chomp: true).each do |line|
    forest.push(line.each_char.map {|x| x.to_i})
end

p forest

ROWS = forest.size
COLS = forest[0].size

visibility = Array.new(ROWS) {Array.new(COLS, false)}

#marking outer borders as visible
(0...COLS).each {|c| visibility.first[c] = visibility.last[c] = true}
(0...ROWS).each {|r| visibility[r][0] = visibility[r][COLS - 1] = true}

p visibility



def handler_row(forest, row, enum)
    p row

    first = enum.next
    max_h = forest[row][first] # current tree
    score = 0
    loop do
        col = enum.next
        score += 1        
        tree = forest[row][col]
        if tree >= max_h # stop at first tree same height or higher
            break
        end
    end
    puts "score: #{score}"
    return score
end

def handler_col(forest, col, enum)
    puts "Col #{col}"

    first = enum.next
    max_h = forest[first][col]
    score = 0
    loop do
        row = enum.next        
        score += 1        
        tree = forest[row][col]
        if tree >= max_h # stop at first tree same height or higher
            break
        end
    end
    puts "score: #{score}"
    return score
end

def scenicScore(forest, row, col)

    total_score = 1
    # left
    total_score *= handler_row(forest, row, col.downto(0))

    # right
    total_score *= handler_row(forest, row, col.upto(COLS - 1))

    # up
    total_score *= handler_col(forest, col, row.downto(0))
    
    # down
    total_score *= handler_col(forest, col, row.upto(ROWS - 1))

    puts "Score[#{row}, #{col}]: #{total_score}"
    return total_score
end


max_score = 0
(1...ROWS-1).each do |row|
    (1...COLS-1).each do |col|
        score = scenicScore(forest, row, col)
        if score > max_score
            max_score = score
            puts "New max score: #{max_score}"
        end
    end
end

puts "Max scenic score: #{max_score}"
