require 'strscan'
require 'set'

file = ARGV[0]

puts("Reading ", file)

class Buffer
    def initialize(size)
        @buf = Array.new(size) # at the beginning all are nil
        @cnt = 0
    end

    def push(ch)
        @buf.push(ch) # append to end
        @buf.shift    # take first element
        @cnt += 1
    end

    def unique?
        @buf.compact.to_set.size == @buf.size # all non-nil elements are unique if set size equals buffer size
    end
end

IO.readlines(file, chomp: true).each do |line|
    s = StringScanner.new(line)    
    b = Buffer.new(14) # start-of-message size 14 # packet header size 4
    while s.rest? do
        b.push(s.getch)
        break if b.unique?        
    end
    p b
end
