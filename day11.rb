#!/usr/bin/env ruby

require 'set'
require 'matrix'


class Monkey
  attr_accessor :inspect
  attr_accessor :items
   
  def initialize(mult, testV, optTrue, optFalse, monkey_map)
      @mult = mult
      @test = testV
      @optTrue = optTrue
      @optFalse = optFalse
      @monkey_map = monkey_map
      @items = Queue.new
      @inspect = 0
  end

  def get_item(lvl)
      @items.push(lvl)
  end
  
  def use_item()
      @inspect += 1
      item = @items.pop
      new_item = @mult.call(item)
      # always divide by this, which is all monkey's divisors at once
      new_item = new_item.modulo(9699690)
      #new_item = new_item.modulo(96577)
      if new_item.modulo(@test) == 0
        @monkey_map[@optTrue].get_item(new_item)
      else
        @monkey_map[@optFalse].get_item(new_item)
      end
  end

  def use_all_items()
      loop do
        if @items.length == 0
          return
        end
        self.use_item()
      end
  end
end


def func(contents)
  monkeys = contents.split("\n\n")
  monkey_map = Hash[]
  monkeys.each do |monkey|
    mon = monkey.split("\n")
    mon[0].match(/Monkey (?<num>\d+):/)
    mon_num = $~[:num].to_i
    starting = mon[1].split(":")[1].split(", ").map(&:to_i)
    mon[2].split("= ")[1].match(/(?<one>[^ ]+) (?<op>.) (?<two>[^ ]+)/)
    my_proc = nil
    one = $~[:one]
    two = $~[:two]
    if one == "old" && two == "old"
      if $~[:op] == "*"
        my_proc = Proc.new{|old| old * old}
      elsif $~[:op] == "+"
        my_proc = Proc.new{|old| old+ old}
      end
    elsif one == "old"
      if $~[:op] == "*"
        my_proc = Proc.new{|old| old * two.to_i}
      elsif $~[:op] == "+"
        my_proc = Proc.new{|old| old + two.to_i}
      end
    end
    mon[3].match(/  Test: divisible by (?<val>\d+)/)
    testV = $~[:val].to_i
    mon[4].match(/    If true: throw to monkey (?<true_to>\d+)/)
    true_to = $~[:true_to].to_i
    mon[5].match(/    If false: throw to monkey (?<false_to>\d+)/)
    false_to = $~[:false_to].to_i
    m = Monkey.new(my_proc, testV, true_to, false_to, monkey_map)
    starting.each{|s| m.get_item(s)}
    monkey_map[mon_num] = m
  end
  (1..10000).each { |idx|
    monkey_map.values.each{ |mon|
      mon.use_all_items()
    }
  }

  a, b = monkey_map.values.map{|mon| mon.inspect}.sort.last(2)
  return a * b
end

if __FILE__ == $0
  # NOTE: both don't work at the same time
  x = func(File.read("day11_test.txt"))
  puts "final: #{x}"
  puts func(File.read("day11.txt"))
end