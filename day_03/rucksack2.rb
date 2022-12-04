require 'set'

file = ARGV[0]

puts("Reading ", file)


priorities = {}

prio = 1

('a'..'z').each do |k|
    priorities[k] = prio
    prio+=1
end

('A'..'Z').each do |itm2|
    priorities[itm2] = prio
    prio+=1
end

total = 0
IO.readlines(file, chomp: true).each_slice(3) do |group|
    fail "should be 3 elves" if group.size != 3
    common = group[0].chars.to_set & group[1].chars.to_set & group[2].chars.to_set 
    if common.size != 1
        fail "should have exactly 1 common" 
    end
    puts "common element: #{common}"
    total += priorities[common.to_a[0]]
end

puts("total: #{total}")
