require 'strscan'
require 'set'
require 'stringio'
require 'io/console'

file = ARGV[0]

class Field
    def initialize(paths, start = [500, 0])
        flat = paths.flatten(1)
        @cols = flat.minmax {|a, b| a[0] <=> b[0] }.map {|x| x[0]}
        @rows = flat.minmax {|a, b| a[1] <=> b[1] }.map {|x| x[1]}
        @rows[0] = 0 # rows start from zero
        @paths = paths
        @field = Array.new(@rows[1] + 1) {Array.new(tr_col(@cols[1]) + 1, '.')}

        @start = tr(start)
        # fill field
        @field[@start[0]][@start[1]] = '+'

        paths.each {|p| do_rock(p)}

        @sand = nil
        @counter = 0
    end

    def counter
        @counter
    end

    def step
        if @sand == nil
            @sand = @start.dup
        end

        if overflow_bottom?
            return 'end' # reached end
        end        
        if move_down
            return 'next_step'
        end
        if overflow_left?
            return 'end' # reached end
        end
        if move_left
            return 'next_step'
        end
        if overflow_right?
            return 'end' # reached end
        end
        if move_right
            return 'next_step'
        end

        # nowhere to move sand, standing still
        @field[@sand[0]][@sand[1]] = 'o'
        @counter += 1
        @sand = nil
        return 'next_sand'
    end

    def overflow_bottom?
        @sand[0] >= @rows[1]
    end
    def overflow_left?
        @sand[1] <= tr_col(@cols[0])
    end
    def overflow_right?
        @sand[1] >= tr_col(@cols[1])
    end

    def move_down
        if @field[@sand[0] + 1][@sand[1]] == '.'
            @sand[0] += 1
            return true
        else
            return false
        end
    end
    def move_left
        if @field[@sand[0] + 1][@sand[1] - 1] == '.'
            @sand[0] += 1
            @sand[1] -= 1
            return true
        else
            return false
        end
    end
    def move_right
        if @field[@sand[0] + 1][@sand[1] + 1] == '.'
            @sand[0] += 1
            @sand[1] += 1
            return true
        else
            return false
        end
    end

    def do_rock(path)
        path.reduce {|prev, nextt| do_rock_segment(prev, nextt)}
    end

    def do_rock_segment(a, b)
        if a != nil && b != nil 
            raise "Cannot put rock in non-straight lines!" if a[0] != b[0] && a[1] != b[1]
            t = a.dup
            delta = [b[0] <=> a[0], b[1] <=> a[1]]
            while t != b do
                @field[t[1]][tr_col(t[0])] = '#'
                t[0] += delta[0]
                t[1] += delta[1]
            end
            @field[b[1]][tr_col(b[0])] = '#'
        end
        b
    end

    def tr(pt)
        [pt[1], tr_col(pt[0])]
    end

    def tr_col(col) #translates column index
        col - @cols[0]
    end

    def to_s
        p @rows
        p @cols
        io = StringIO.new
        pad = @rows[1].to_s.size

        tmp = nil
        if @sand != nil
            tmp = @field[@sand[0]][@sand[1]]
            @field[@sand[0]][@sand[1]] = '0'
        end
        @field.each_index do |index|
            row = @field[index]
            io.puts "#{index.to_s.rjust(pad)} #{row.join("")}"
        end
        if @sand != nil
            @field[@sand[0]][@sand[1]] = tmp
        end
        io.string
    end
end


puts("Reading ", file)

POINT = /(\d+),(\d+)/
ARROW = /\s+->\s+/
paths = []

IO.readlines(file, chomp: true).each do |line|
    #puts line
    path = []
    s = StringScanner.new(line)
    while !s.eos? do
        s.scan(POINT)
        path.push([s[1].to_i, s[2].to_i])
        s.skip(ARROW)
    end
    paths.push(path)
end

#paths.each {|path| p path}

f = Field.new(paths)

puts f

$stdin.echo = false
$stdin.raw!

stop_next_sand = false
stop_at_end = false

loop do
    res = f.step
    case res
        when 'end'
            break
        when 'next_sand'
            $stdout.clear_screen 
            puts res
            puts f
            stop_next_sand = false
    end
    if stop_next_sand || stop_at_end
        #sleep (1.0/100)
    else
        $stdout.clear_screen 
        puts res
        puts f
        case $stdin.getc
            when "c"
                break
            when " "
                stop_next_sand = true
            when "e"
                stop_at_end = true
        end
    end
    #sleep (1.0/25)
end

puts "N of sand: #{f.counter}"