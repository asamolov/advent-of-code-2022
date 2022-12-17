require 'set'

file = ARGV[0]

puts("Reading ", file)

class Sensor
    def initialize(sensor, beacon)
        @sensor = sensor
        @beacon = beacon
    end
end

sensors = []

start_row = 0
max_row = 4000000 # 20 for input_mini

start_col = 0
max_col = 4000000 # 20 for input_mini
col_range = (start_col..max_col)

IO.readlines(file, chomp: true).each do |line|
    # Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    m = /Sensor at x\=(-?\d+), y\=(-?\d+)\: closest beacon is at x\=(-?\d+), y\=(-?\d+)/.match(line)
    s = {:sensor => [m[1].to_i, m[2].to_i], :beacon => [m[3].to_i, m[4].to_i]}

    s[:radius] = (s[:sensor][0] - s[:beacon][0]).abs + 
                   (s[:sensor][1] - s[:beacon][1]).abs

    sensors.push(s)
end

sensors.each {|s| p s}

(start_row..max_row).each do |row_of_interest|
    if row_of_interest % 10000 == 0
        puts "row #{row_of_interest}"
    end
    ranges = []
    beacons_on_row = Set.new
    sensors.each do |s|
        sensor = s[:sensor]
        radius = s[:radius]
        if row_of_interest.between?(sensor[1] - radius, sensor[1] + radius)
            y_distance = (row_of_interest - sensor[1]).abs
            x_distance = radius - y_distance
            affected_cells = Range.new(sensor[0] - x_distance, sensor[0] + x_distance)
            ranges.push(affected_cells)
            #puts "Sensor #{sensor} gives #{affected_cells}"
        else
            #puts "Ignoring sensor #{sensor}"
        end
        if row_of_interest == s[:beacon][1]
            #puts "Beacon #{s[:beacon]} is on row #{row_of_interest}"
            beacons_on_row.add(s[:beacon])
        end
    end

    ranges.sort! {|a, b| a.begin <=> b.begin }

    range = ranges.first
    squashed = []

    blocked = 0
    ranges.each do |r|
        if range.include?(r.begin) ||
            range.end == r.begin + 1
            #puts "Merging #{range} and #{r}"
            range = Range.new(range.begin, r.end > range.end ? r.end : range.end)
        else
            squashed.push(range)
            blocked += range.size
            range = r
        end
    end
    squashed.push(range) # last range
    blocked += range.size

    # find gap
    squashed.each do |r|
        if col_range.include?(r.end)
            p squashed
            puts "Found gap! #{r.end + 1}, #{row_of_interest}"
            freq = (r.end + 1)* 4000000 + row_of_interest
            puts "freq: #{freq}"
            return
        end
    end
end
