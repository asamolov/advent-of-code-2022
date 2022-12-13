require 'strscan'
require 'set'

file = ARGV[0]

puts("Reading ", file)

class MapFinder
    def initialize(map)
        @map = map
        @visited = {}
    end

    def try_go(path, row, col)
        if row.between?(0, @map.size-1) &&
            col.between?(0, @map[row].size-1)
            point = [row, col]
            current = @map.dig(*path.last)
            if @map[row][col] - current >= -1
                return [point, path + [point]]
            end
        end
        return nil
    end

    def find_path(start, finish)
        # Dijkstra
        candidates = []
        # start from prev step
        if @visited.empty?
            candidates << [start, [start]] # path to start is start
        else
            # continue where we stopped
            candidates = @visited.to_a
        end

        while !(@visited.include?(finish) || candidates.empty?)do
            #p candidates
            #p @visited
            #STDIN.gets
            new_candidates = []

            candidates.each do |c|
                point = c[0]
                path  = c[1]

                if @visited.include?(point)
                    old_path = @visited[point]
                    @visited[point] = path.size < old_path.size ? path : old_path
                else
                    @visited[point] = path
                    # where can go
                    new_candidates << try_go(path, point[0] - 1, point[1]) # up
                    new_candidates << try_go(path, point[0] + 1, point[1]) # down
                    new_candidates << try_go(path, point[0], point[1] - 1) # left
                    new_candidates << try_go(path, point[0], point[1] + 1) # right
                end
            end

            candidates = new_candidates.compact # remove nils
        end
        return @visited[finish]
    end
end


map = []
start = nil
finish = nil
starts = []

IO.readlines(file, chomp: true).each do |line|
    row = []
    line.each_char do |x|
        case x
        when "S"
            start = [map.size, row.size]
            starts.push(start)
            row.push("a".ord)
        when "E"
            finish = [map.size, row.size]
            row.push("z".ord)
        when "a"
            starts.push([map.size, row.size])
            row.push(x.ord)
        else
            row.push(x.ord)
        end
    end
    map.push(row)
end

map.each {|row| p row}

finder = MapFinder.new(map)

path = finder.find_path(finish, start)

puts "Path to end from very start is #{path.size} long"

idx = 0

all_paths = starts.each.map do |s|
    puts "#{idx} looking for path from #{finish} to #{s}"
    path = finder.find_path(finish, s)    
    puts "#{idx} Path from #{finish} to #{s} is #{path ? path.size : "unavailable"}"
    idx += 1
    path ? path.size : 100000000
end

puts "Minimal of all paths is #{all_paths.min} long"
