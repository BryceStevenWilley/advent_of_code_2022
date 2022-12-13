#!/usr/bin/env ruby

require 'set'

class Node
  attr_accessor :edges
  attr_accessor :letter
  attr_accessor :height
  attr_accessor :idx

  def initialize(letter, idx)
    @letter = letter
    if letter == 'S'
      @height = 0
    elsif letter == 'E'
      @height = 25
    else
      @height = letter.ord - 97
    end
    @idx = idx
    @edges = []
  end

  def consider_add_edge(other_node)
    if (other_node.height - self.height) <= 1
      @edges.append(other_node)
    end
  end
end

def bfs(nodes, start_node, end_node)
  visited = Set.new
  q = Queue.new
  q.push([0, start_node])
  visited.add(start_node)
  loop do
    if q.length == 0
      return 1000000000
    end
    entry = q.pop
    #puts "#{entry[0]}, (#{entry[1].letter}, #{entry[1].idx})"
    dist = entry[0]
    entry[1].edges.each { |other|
      if other == end_node
        return dist + 1
      elsif !visited.include?(other)
        visited.add(other)
        q.push([dist + 1, other])
      end
    }
  end
end

if __FILE__ == $0
  height_map = File.read("day12.txt").split("\n").map(&:chars)
  nodes = height_map.map.with_index{ |line, lat| line.map.with_index{ |cell, longi | Node.new(cell, [lat, longi]) }}
  start_node = nil
  end_node = nil
  all_as = []
  nodes.each_with_index { |line, lat| line.each_with_index{ |n, long |
    if n.letter == 'S'
      start_node = n
      all_as.append(start_node)
    end
    if n.letter == 'E'
      end_node = n
    end
    if n.letter == 'a'
      all_as.append(n)
    end
    if lat - 1 >= 0
      n.consider_add_edge(nodes[lat-1][long])
    end
    if lat + 1 < nodes.length
      n.consider_add_edge(nodes[lat+1][long])
    end
    if long - 1 >= 0
      n.consider_add_edge(nodes[lat][long - 1])
    end
    if long + 1 < line.length
      n.consider_add_edge(nodes[lat][long + 1])
    end
  }}
  # Brute force babyyy
  puts all_as.map{|a| puts a; bfs(nodes, a, end_node) }.min
  # TODO: navigate graph with BFS
end

# Compile errors:
# 1. missing day12_test.txt
# 2. undefined local variable or method 'node', line 54 (should have been n)
# 3. infinite loop
# 4. Undefined method `letter` for array line 37 (should have been entry[1].letter)
# 5. Missing visited array
# 6. unitialized constant Set (missing require 'set')
# 7-10. idx[1] was nil (wasn't using map.with_index)
# 11. still too long for real version
# 12. moved visited to after put in queue (lots of duplicates)
# 13: right!