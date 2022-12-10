#!/usr/bin/env ruby
 
# NOTE: the more consice way would be to put everything into Hashes
# (shapes, outcomes, scores of each, and the results in a double hash)
# https://github.com/ahorner/advent-of-code/blob/main/lib/2022/02.rb
def run_game1(one, two)
  if one == "A"
    if two == "X"
      return 1 + 3
    elsif two == "Y"
      return 2 + 6
    elsif two == "Z"
      return 3 + 0
    else
      # Wrong?
      return 0
    end
  elsif one == "B"
    if two == "X"
      return 1 + 0
    elsif two == "Y"
      return 2 + 3
    elsif two == "Z"
      return 3 + 6
    else
      # Wrong?
      return 0
    end
  elsif one == "C"
    if two == "X"
      return 1 + 6
    elsif two == "Y"
      return 2 + 0
    elsif two == "Z"
      return 3 + 3
    else
      # Wrong?
      return 0
    end
  else
    return 0
  end
end

def run_game2(one, two)
  if one == "A"
    if two == "X"
      return 3 + 0
    elsif two == "Y"
      return 1 + 3
    elsif two == "Z"
      return 2 + 6
    else
      # Wrong?
      return 0
    end
  elsif one == "B"
    if two == "X"
      return 1 + 0
    elsif two == "Y"
      return 2 + 3
    elsif two == "Z"
      return 3 + 6
    else
      # Wrong?
      return 0
    end
  elsif one == "C"
    if two == "X"
      return 2 + 0
    elsif two == "Y"
      return 3 + 3
    elsif two == "Z"
      return 1 + 6
    else
      # Wrong?
      return 0
    end
  else
    return 0
  end
end

if __FILE__ == $0
  lines = File.read("day2.txt")
  puts lines.split("\n").map { |game|
    g = game.split(" ")
    run_game2(g[0], g[1])
  }.sum
end

# Started: ~14:07:27
# Stopped mucking with history in irb: 14:13:11

# Part 1: 14:22:47
# Part 2: 14:25:40 (18 min, 13 sec total)