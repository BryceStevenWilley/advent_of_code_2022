#!/usr/bin/env ruby
require 'set'

def convert_to_val(c)
    # https://stackoverflow.com/a/12713365/11416267
    # NOTE: could have done `case c\nwhen /[A-Z]/ then c.ord - "A".ord + 27, etc.`
    if /[[:upper:]]/.match(c)
      # https://stackoverflow.com/a/5180396/11416267
      c.ord - 38
    else
      # wtf does return do?
      c.ord - 96
    end
end

def old_ruck_map(ruck)
    split_len = ruck.length / 2
    # NOTE: ruck.each_slice(ruck.length / 2) gets an iterater of both
    pt1 = ruck[0, split_len]
    pt2 = ruck[split_len, ruck.length]
    # https://ruby-doc.org/stdlib-2.7.1/libdoc/set/rdoc/Set.html
    s1 = Set[]
    # NOTE: could use `[pt1, pt2].reduce(&:&)` (set intersection proc)
    # http://ablogaboutcode.com/2012/01/04/the-ampersand-operator-in-ruby#set-intersection
    pt1.each_char.each{|c| s1.add(c)}
    dup = ''
    pt2.each_char.each{ |c|
      if s1.include?(c)
        dup = c
      end
    }
    convert_to_val(dup)
end

if __FILE__ == $0
  lines = File.read("day3.txt")
  # old
  # puts lines.split("\n").map{ |ruck| old_ruck_map(ruck)}.sum
  lines2 = []
  arr = []
  # https://careerkarma.com/blog/ruby-each-with-index/
  # NOTE: could have been doen with `lines.each_slice(3).map {|ruck_group| ...`
  lines.split("\n").each_with_index { |ruck, idx|
    arr.append(ruck)
    # https://www.geeksforgeeks.org/ruby-numeric-modulo-function/
    if idx.modulo(3) == 2
      lines2.append(arr)
      arr = []
    end
  }
  puts lines2.map{|ruck_group|
    s1 = Set[]
    puts ruck_group
    ruck_group[0].each_char.each{|c| s1.add(c)}
    s2 = Set[]
    ruck_group[1].each_char.each{|c|
      if s1.include?(c)
        s2.add(c)
      end
    }
    badge = ''
    ruck_group[2].each_char.each{|c|
      if s2.include?(c)
        badge = c
      end
    }
    convert_to_val(badge)
  }.sum
end

# Started: 11:45:15

# Pt1 12:03:21 (18 min, 6 sec)
# Pt2 12:19:57 (34 min, 42 sec total)