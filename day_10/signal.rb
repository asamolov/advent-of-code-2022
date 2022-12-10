require 'strscan'
require 'set'

file = ARGV[0]

puts("Reading ", file)

clock = 0
reg = 1

breakpoint = 20
total_signal_strength = 0

IO.readlines(file, chomp: true).each do |line|
    puts line
    delta = 0
    case line        
        when "noop" then clock += 1
        when /addx (-?\d+)/
            clock += 2
            delta = $1.to_i
    end
    if clock >= breakpoint
        signal_strength = breakpoint * reg
        puts "breakpoint #{breakpoint}, signal_strength: #{signal_strength}"
        total_signal_strength += signal_strength
        breakpoint += breakpoint < 220 ? 40 : 10000000 # breakpoint very far in future after 220th cycle
    end
    reg += delta
    puts "clock: #{clock}, reg: #{reg}"
end

puts "total_signal_strength: #{total_signal_strength}"