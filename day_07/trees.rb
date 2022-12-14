require 'strscan'
require 'set'

file = ARGV[0]

puts("Reading ", file)

fs = {}
path = []

DISK_SIZE = 70000000
UPDATE_SIZE = 30000000

def dir_size(path, dir, &block)
    p path
    total_size = 0
    dir.each_pair do |k, v|
        if v.is_a?(Integer)
            total_size += v
        else
            total_size += dir_size(path.push(k), v, &block)
            path.pop
        end
    end
    block.call path, total_size
    return total_size
end

IO.readlines(file, chomp: true).each do |line|
    puts line
    case line
    when /\$ cd (\S+)/
        dir = $1
        if ".." == dir
            path.pop
        elsif "/" == dir
            path = []
        else
            path.push(dir)
        end
        p path
    when /\$ ls/
        # noop
        p path
    when /dir (\S+)/ # dir
        # adding dir entry
        dir = $1
        p fs
        p path
        parent = path.size == 0 ? fs : fs.dig(*path)
        parent[dir] = {} # new dir
        p fs
    when /(\d+) (\S+)/ # file
        size = $1.to_i
        file = $2
        parent = path.size == 0 ? fs : fs.dig(*path)
        parent[file] = size
        p parent
    else
        raise "Unknown output"    
    end
end

p fs

puts "Calculating total sizes..."

sum = 0
dir_sizes = []

dir_size([], fs) do |path, size|    
    puts "#{path} => #{size}"
    if size <= 100000
        puts "adding to total..."
        sum += size
    end
    dir_sizes.push(size)
end


puts "final sum: #{sum}"
dir_sizes.sort!

p dir_sizes

unused = DISK_SIZE - dir_sizes.last
puts "root size #{dir_sizes.last},  unused: #{unused}"
required = UPDATE_SIZE - unused

puts "required for update: #{required}"

to_remove = dir_sizes.bsearch {|x| x >= required}

puts "size of dir to remove: #{to_remove}"