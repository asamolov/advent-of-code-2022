require 'strscan'

file = ARGV[0]

puts("Reading ", file)

stacks = []

def parse(line)    
    s = StringScanner.new(line)
    row = []
    while s.rest? do
        s.getch
        ch = s.getch
        if ch == " "
            row.push(nil)
        elsif /\d/.match(ch)
            row.push(ch.to_i)
        else
            row.push(ch)
        end
        s.getch
        s.getch
    end
    row
end

handling_crates = true

IO.readlines(file, chomp: true).each do |line|
    if handling_crates
        row = parse(line)
        p row
        if stacks.empty?
            # init stack
            stacks = Array.new(row.size) {Array.new}
        end
        if row[0].is_a?(Integer)
            handling_crates = false
        else
            stacks.each_index do |idx|
                stacks[idx].prepend(row[idx]) if row[idx] != nil
            end
        end
    elsif line.empty?
        p stacks
    else
        command = /move (?<n>\d+) from (?<from>\d+) to (?<to>\d+)/.match(line)
        from = stacks[command[:from].to_i - 1]
        to   = stacks[command[:to].to_i   - 1]
        temp = from.pop(command[:n].to_i).reverse
        p temp
        to.concat(temp)
        p stacks
    end
end

result = ""
stacks.each do |stack|
    result << stack.pop
end

puts result