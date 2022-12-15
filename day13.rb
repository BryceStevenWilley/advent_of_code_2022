#!/usr/bin/env ruby

require 'json'

# 1 is correct order, 0 is next, -1 is wrong order
def compare_entries(e1, e2)
  if e1.class == Integer && e2.class == Integer
    if e1 == e2
      return 0
    end
    return (e1 < e2) ? -1 : 1
  end
  if e1.class == Array && e2.class == Array
    max_len = [e1.length - 1, e2.length - 1].max
    (0..max_len).each { |idx|
      if e1.length - 1 < idx
        return -1
      end
      if e2.length - 1 < idx
        return 1
      end
      val = compare_entries(e1[idx], e2[idx])
      if val != 0
        return val
      end
    }
    return 0
  end
  if e1.class == Integer
    e1 = [e1]
  end
  if e2.class == Integer
    e2 = [e2]
  end
  return compare_entries(e1, e2)
end

def compare_wrapper(e1, e2)
  val = compare_entries(e1, e2)
  if val == 0
    val == -1
  end
  return val
end


if __FILE__ == $0
  pairs = File.read("day13.txt").split("\n\n").map{|p| p.split("\n")}
  all_lines = pairs.reduce(&:concat)
  all_lines = all_lines.map{ |pj| JSON.parse pj}
  impt1 = [[2]]
  impt2 = [[6]]
  all_lines.append(impt1)
  all_lines.append(impt2)
  print all_lines
  puts ""
  sorted_lines = all_lines.sort{ |a, b| compare_wrapper(a, b)}
  #pairs.each_with_index { |p, idx|
  #  pj = p.map{|i| JSON.parse i}
  #  val = compare_entries(pj[0], pj[1])
  #  puts "compare: #{idx+1}: #{val}"
  #  if val == 1 or val == 0
  #    idxs.append(idx + 1)
  #  end
  #}
  sorted_lines.each_with_index{ |s, idx|
    if s == impt1 || s == impt2
      puts idx + 1
    end
  }
end