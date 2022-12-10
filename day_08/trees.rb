require 'strscan'
require 'set'


file = ARGV[0]

puts("Reading ", file)

forest = []

IO.readlines(file, chomp: true).each do |line|
    forest.push(line.each_char.map {|x| x.to_i})
end

p forest

rows = forest.size
cols = forest[0].size

visibility = Array.new(rows) {Array.new(cols, false)}

#marking outer borders as visible
(0...cols).each {|c| visibility.first[c] = visibility.last[c] = true}
(0...rows).each {|r| visibility[r][0] = visibility[r][cols - 1] = true}

p visibility

def handler_row(forest, visibility, row, enum)
    p row

    first = enum.next
    max_h = forest[row][first]
    loop do
        col = enum.next
        
        tree = forest[row][col]
        if tree > max_h # tree is visible because it's higher than previous max visible tree
            visibility[row][col] = true
            max_h = tree
        end
    end
    puts "forest row: #{forest[row]}"
    puts "visibility: #{visibility[row]}"
end

def handler_col(forest, visibility, col, enum)
    puts "Col #{col}"

    first = enum.next
    max_h = forest[first][col]
    puts "first: #{first}"
    puts "max_h: #{max_h}"
    loop do
        row = enum.next
        
        tree = forest[row][col]
        if tree > max_h # tree is visible because it's higher than previous max visible tree
            puts "new max_h: #{max_h}, row #{row}"
            visibility[row][col] = true
            max_h = tree
        end
    end
    p visibility
end

(1...rows-1).each do |row|
    # from left to right
    handler_row(forest, visibility, row, 0.upto(cols-1))
    # from right to left
    handler_row(forest, visibility, row, (cols-1).downto(0))
end
(1...cols-1).each do |col|
    # from top to bottom
    handler_col(forest, visibility, col, 0.upto(rows-1))
    # from bottom to top
    handler_col(forest, visibility, col, (rows-1).downto(0))
end


p visibility


visible_trees = visibility.flatten(1).count {|t| t}

p visible_trees