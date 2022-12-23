require 'set'
require 'strscan'

file = ARGV[0]

puts("Reading ", file)


input = []

def parse(line)
    current = []
    result = nil
    s = StringScanner.new(line)

    while !s.eos?
        token = nil
        if (token = s.scan(/\d+/)) != nil
            current.last.push(token.to_i)
        elsif s.scan(/\[/) != nil
            n = Array.new()
            if current.last != nil 
                current.last.push(n)
            end
            current.push(n)
        elsif s.scan(/\]/) != nil
            result = current.pop
        elsif s.scan(/,/) != nil
            # noop
        else
            raise "unexpected token!"
        end
    end
    return result
end

# compares two arrays
def compare(a, b)
    result = 0
    min_len = a.size < b.size ? a.size : b.size
    (0...min_len).each do |idx|
        x = a[idx]
        y = b[idx]

        if (x.is_a? Numeric) && 
            (y.is_a? Numeric)
            result = x - y
        else
            if x.is_a? Numeric
                x = [x]
            end
            if y.is_a? Numeric
                y = [y]
            end
            result = compare(x, y)
        end

        if result != 0
            return result
        end
    end

    result = a.size - b.size

    return result
end

a = nil
b = nil

DIV_2 = [[2]]
DIV_6 = [[6]]

packets = []
index = 0
sum = 0
IO.readlines(file, chomp: true).each do |line|
    puts(line)
    if line == ""
        index += 1
        p a
        p b
        if compare(a, b) <= 0
            puts "Pair #{index} is in order!"
            sum += index
        else
            puts "Pair #{index} is out of order!"
        end
        a = nil
        b = nil
    else
        if a == nil
            a = parse(line)
            packets.push(a)
        else
            b = parse(line)
            packets.push(b)
        end
    end
end

puts "Sum of in-order pair indices: #{sum}"

packets.push(DIV_2)
packets.push(DIV_6)

packets.sort! {|a, b| compare(a, b)}

idx_2 = packets.bsearch_index {|x| compare(DIV_2, x)} + 1
idx_6 = packets.bsearch_index {|x| compare(DIV_6, x)} + 1

puts "Divider packets: #{idx_2}, #{idx_6}. Decoder key: #{idx_2 * idx_6}"
