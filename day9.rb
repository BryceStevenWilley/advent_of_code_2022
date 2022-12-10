#!/usr/bin/env ruby

# [0]: up, down, [1]: left, right

# NOTE: `require 'matrix'` lets you use `Vector[1, 0]` and supports sums

require 'set'

def update_tail(head_pos, tail_pos)
  adjacent_vert = head_pos[0] <= tail_pos[0] + 1 && head_pos[0] >= tail_pos[0] - 1
  adjacent_horiz = head_pos[1] <= tail_pos[1] + 1 && head_pos[1] >= tail_pos[1] - 1
  if adjacent_vert && adjacent_horiz
    return tail_pos
  end
  mv_vert = 0
  mv_horiz = 0
  if head_pos[0] > tail_pos[0]
    mv_vert = 1
  elsif head_pos[0] < tail_pos[0]
    mv_vert = -1
  end
  if head_pos[1] > tail_pos[1]
    mv_horiz = 1
  elsif head_pos[1] < tail_pos[1]
    mv_horiz = -1
  end
  return [tail_pos[0] + mv_vert, tail_pos[1] + mv_horiz]
end

def update_pos(head_pos, direction)
  case direction
  when "U" then [head_pos[0] + 1, head_pos[1]]
  when "D" then [head_pos[0] - 1, head_pos[1]]
  when "L" then [head_pos[0], head_pos[1] - 1]
  when "R" then [head_pos[0], head_pos[1] + 1]
  end
end

def two_knots()
  head = [0, 0]
  tail = [0, 0]
  tail_set = Set[]
  tail_set.add(tail)
  File.read("day9.txt").split("\n").each{ |step |
    step_s = step.split(" ")
    (1..step_s[1].to_i).each { |time|
      head = update_pos(head, step_s[0])
      tail = update_tail(head, tail)
      tail_set.add(tail)
    }
  }
  puts tail_set.length
end


if __FILE__ == $0
  # NOTE: alt: knots = [[0, 0]] * 10
  knots = []
  (1..10).each{ |knot_idx|
    knots.append([0, 0])
  }
  tail_set = Set[]
  tail_set.add(knots.last)
  File.read("day9.txt").split("\n").each{ |step| 
    step_s = step.split(" ")
    (1..step_s[1].to_i).each { |time|
      knots[0] = update_pos(knots[0], step_s[0])
      (1..knots.length-1).each {|idx|
        knots[idx] = update_tail(knots[idx-1], knots[idx])
      }
      tail_set.add(knots.last)
    }
  }
  puts tail_set.length
end

# started 09:37:26
# finished `update_tail`: 9:58:59, paused
# restarted around 9am, next day (whups)
# finished pt 1: 09:12:00
# finished pt 2: 09:19:00