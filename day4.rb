#!/usr/bin/env ruby

require 'uri'

def contains(as1, as2)
  return as1[0] <= as2[0] && as1[1] >= as2[1]
end

def overlap(as1, as2)
  return (as1[0] <= as2[0] && as1[1] >= as2[0]) || (as1[0] <= as2[1] && as1[1] >= as2[1])
end


if __FILE__ == $0
  lines = File.read("day4.txt")
  puts lines.split("\n").map{ |pair|
    p = pair.split(",")
    as1 = p[0].split("-").map{|num| num.to_i}
    as2 = p[1].split("-").map{|num| num.to_i}
    if overlap(as1, as2) || overlap(as2, as1)
      1
    else
      0
    end
  }.sum
end

# Started 10:42:02 (8 minutes total)
# pt1: (had to wait 40 sec extra)
# pt2: 10:53:57 (11 minutes total)

# Added the URL download later