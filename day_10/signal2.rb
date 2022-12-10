require 'strscan'
require 'set'

file = ARGV[0]

puts("Reading ", file)

class Range
    def move(delta)
        return Range.new(self.begin + delta, self.end + delta, self.exclude_end?)
    end
end

clock = 0
reg = 1

breakpoint = 20
total_signal_strength = 0
SCREEN = Array.new(6) {Array.new(40, ".")}
sprite = 0..2

def draw(clock, sprite)
    row, col = clock.divmod(40)
    SCREEN[row][col] = sprite.include?(col) ? "#" : "."
end


IO.readlines(file, chomp: true).each do |line|
    puts line
    delta = 0
    case line        
        when "noop"
            draw(clock, sprite)
            clock += 1
        when /addx (-?\d+)/
            draw(clock, sprite)
            clock += 1
            draw(clock, sprite)
            clock += 1
            delta = $1.to_i
    end
    sprite = sprite.move(delta)
    reg += delta
    puts "clock: #{clock}, reg: #{reg}, sprite: #{sprite}"
end

SCREEN.each {|row| puts row.join("")}
