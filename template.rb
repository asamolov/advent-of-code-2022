file = ARGV[0]

puts("Reading ", file)

IO.readlines(file, chomp: true).each do |line|
    puts(line)
end