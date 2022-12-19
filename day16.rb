#!/usr/bin/env ruby

# copied from day 12
class Node
  attr_accessor :edges
  attr_accessor :name
  attr_accessor :flow

  def initialize(name, flow)
    @name = name
    @flow = flow
    @edges = []
  end

  def to_s
    return "#{name} (flow: #{flow})"
  end
end

def bfs(nodes, start_node)
  visited = {}
  q = Queue.new
  q.push([0, start_node])
  visited[start_node.name] = 0
  loop do
    if q.length == 0
      return visited
    end
    entry = q.pop
    #puts "#{entry[0]}, (#{entry[1].letter}, #{entry[1].idx})"
    dist = entry[0]
    entry[1].edges.each { |other|
      if !visited.include?(other.name)
        visited[other.name] = dist +1
        q.push([dist + 1, other])
      end
    }
  end
  return visited
end

def make_graph(lines)
  graph = {}
  nodes = []
  lines.each {|l|
    l.split("; ")[0].match(/Valve (?<name>[A-Z]{2}) has flow rate=(?<flow>\d+)/)
    name = $~[:name]
    graph[name]= Node.new(name, $~[:flow].to_i)
    nodes.append(name)
  }
  lines.each_with_index {|l, idx|
    puts l
    t = l.split("valves ")
    if t.length == 1
      t = l.split("valve ")
    end
    t[1].split(", ").each{ |e|
      graph[nodes[idx]].edges.append(graph[e])
    }
  }
  return graph, "AA"
end

def greedy_choice(start, graph, ds, turns)
  best = 0
  best_node = start
  dist_cost = 0
  ds[start.name].each{|k, v|
    turn_dist = 1 + v
    val = k.flow * (turns - turn_dist)
    if val > best
      best = val
      best_node = k
      dist_cost = turn_dist
    end
  }
  puts "best: #{best_node}, #{best}, #{dist_cost}"
  return best_node, best, dist_cost
end

def best_soln(start, graph, ds, turns)
  best_choices = []
  best = 0
  bturn_dist = 0
  #puts "test"
  ds[start.name].each{|k, v|
    if graph[k].flow == 0
      next
    end
    turn_dist = 1 + v
    if turns < turn_dist
      next
    end
    val = graph[k].flow * (turns - turn_dist)
    #puts "val: turns: #{turns}, graph: #{graph}, val: #{val}"
    choices, opt_val = best_soln(graph[k], graph.transform_values{|n| (n.name == k) ? Node.new(n.name, 0) : n}, ds, turns - turn_dist)
    if val + opt_val > best
      bturn_dist = turn_dist
      best = val+opt_val
      best_choices = choices.prepend([k, graph[k].flow, turns - turn_dist])
    end
  }
  #puts "Best: turns: #{turns}, choices: #{best_choices}, best: #{best}, bturn_dist: #{bturn_dist}"
  return best_choices, best
end


if __FILE__ == $0
  g, start = make_graph(File.read("day16.txt").split("\n"))
  ds = {}
  g.each{ |k, v| ds[k] = bfs(g.values, v)}
  ds.each {|k, v| puts "#{k} goes to #{v}"}
  puts ""
  turns = 30
  acc = 0
  curr = g[start]

  choices, val = best_soln(curr, g, ds, turns)
  puts val
  print choices
  puts ""
   
  # Greedy choice: didn't work
  #loop do
  #  puts turns
  #  best_choice, best_val, dist_cost = greedy_choice(curr, g, ds, turns)
  #  turns -= dist_cost
  #  if turns < 0 || best_val == 0
  #    puts acc
  #    return
  #  end
  #  acc += best_val
  #  puts acc
  #  best_choice.flow = 0
  #  curr = best_choice
  #end


  # start at start
  # greedy algo: if valve in all tunnels: val * (remturns -(1+dist)) > current val *(remturns -1) go to other and do it?
end