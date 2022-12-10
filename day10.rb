#!/usr/bin/env ruby

def first()
  cycle = 0
  look = []
  reg = 1
  File.read("day10.txt").split("\n").each{ |instr|
    cycle += 1
    if cycle == 20 || cycle == 60 || cycle == 100 || cycle == 140 || cycle == 180 || cycle == 220
      look.append(reg * cycle)
    end
    if instr == "noop"
      next
    end
    # only addx
    num = instr.split(" ")[1].to_i
    cycle += 1
    if cycle == 20 || cycle == 60 || cycle == 100 || cycle == 140 || cycle == 180 || cycle == 220
      look.append(reg * cycle)
    end
    reg += num
  }
  return look
end

def draw(cycle, reg)
  x_pos = (cycle-1).modulo(40)
  if x_pos >= reg - 1 && x_pos <= reg + 1
    "#"
  else
    "."
  end
end

def second()
  cycle = 0
  screen = []
  reg = 1
  File.read("day10.txt").split("\n").each{ |instr|
    cycle += 1
    puts "#{cycle}, #{reg}"
    screen.append(draw(cycle, reg))
    if instr == "noop"
      next
    end
    # only addx
    num = instr.split(" ")[1].to_i
    cycle += 1
    puts "#{cycle}, #{reg}"
    screen.append(draw(cycle, reg))
    reg += num
  }
  return screen
end

if __FILE__ == $0
  look = second()
  look.each_slice(40).each{|slice|
    print slice.reduce(&:concat)
    puts ""
  }
  puts first().sum
end

# started: 09:20:00
# pt1: 09:32:21 (12:21 total) (100 was 5:17)
# p12: 09:50:54 (30:54 total) (100 was 12:17)