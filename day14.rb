#!/usn/bin/env ruby


require 'matrix'


def make_cave(cave_text)
  rocks = cave_text.split("\n")
  rock_lines = rocks.map{|r| r.split(" -> ").map{|s| Vector.elements(s.split(",").map(&:to_i))}}
  all = rock_lines.flatten.to_a
  min_y = 0
  max_y = all.map{|a| a[1]}.max + 2
  min_x = 0 # all.map{|a| a[0]}.min
  max_x = max_y + 500 # triangle plus a bunch# all.map{|a| a[0]}.max
  full_arr = [[]] * (max_y + 1)
  full_arr.map!{|f| [:empty] * (max_x - min_x + 1)}
  rock_lines.each{ |rock_line|
    rock_line.each_cons(2) {|a, b|
      dir = b - a
      unit_dir = dir / dir.norm
      (0..dir.norm).each { |i|
        val = a + i * unit_dir
        full_arr[val[1]][val[0] - min_x] = :rock
      }
    }
  }
  full_arr[-1].map!{:rock}
  return full_arr, min_x
end

def drop_sand(cave, min_x)
  # returns [y, x] if stopped, or :abyss if into the abyss
  start = [0, 500 - min_x]
  loop do
    if cave[start[0] + 1][start[1]] == :empty
      start[0] += 1
      next
    end
    if start[1] - 1 < 0
      return :abyss
    end
    if cave[start[0] + 1][start[1] - 1] == :empty
      start[0] += 1
      start[1] -= 1
      next
    end
    if start[1] + 1 >= cave[0].length
      return :abyss
    end
    if cave[start[0] + 1][start[1] + 1] == :empty
      start[0] += 1
      start[1] += 1
      next
    end
    if start[0] == 0 && start[1] == 500 - min_x
      return :plugged
    end
    return start
  end
end

def fill_cave(cave, min_x)
  count = 0
  loop do
    place = drop_sand(cave, min_x)
    if place == :abyss
      print_cave cave
      return count
    end
    count += 1
    if place == :plugged
      print_cave cave
      return count
    end
    cave[place[0]][place[1]] = :sand
    #print_cave cave
    #puts ""
    #puts ""
  end
end

def print_cave(cave)
  cave.each {|l| l.each{|c| print (c == :empty) ? '.' : ((c== :rock) ? '#' : 'o')}; puts ""}
end

if __FILE__ == $0
  cave, min_x = make_cave(File.read("day14.txt"))
  print_cave cave
  puts ""
  puts fill_cave cave, min_x
  # puts max

end