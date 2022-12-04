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

def halves(str)
    t = [str[0, str.size/2], str[str.size/2..-1]]
    if t[0].size != t[1].size
        fail "should have equal halves"
    end
    t
end

total = 0
IO.readlines(file, chomp: true).each do |line|
    puts(line)
    rucksack = halves(line)
    common = rucksack[0].chars.to_set & rucksack[1].chars.to_set
    if common.size != 1
        fail "should have exactly 1 common" 
    end
    puts "common element: #{common}"
    total += priorities[common.to_a[0]]
end

puts("total: #{total}")
