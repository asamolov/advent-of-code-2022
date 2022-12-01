file = ARGV[0]

puts("Reading ", file)


max_elf = 0
elf = 0

IO.readlines(file, chomp: true).each do |line|
    puts(line)
    if line == ''
        max_elf = elf > max_elf ? elf : max_elf
        elf = 0
        next
    end
    elf += line.to_i
end

max_elf = elf > max_elf ? elf : max_elf

puts("Max Total Calories: ", max_elf)
