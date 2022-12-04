#!/usr/bin/env ruby

if __FILE__ == $0

  lines = File.read("day1.txt")
  puts lines.split("\n\n").map { |elf|
    elf.split("\n").map{ |snack|
        snack.to_i
    }.sum
  }.sort.reverse[0, 3].sum
end

# Started: ~10:18:23

# Part 1: 10:34:25
# Part 2: 10:35:59 (17 min, 36 sec total)