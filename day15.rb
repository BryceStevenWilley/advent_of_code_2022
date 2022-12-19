#!/usr/bin/env ruby

require 'matrix'
require 'set'
require 'ruby-prof'

reg = /Sensor at x=(?<sx>-?\d+), y=(?<sy>-?\d+): closest beacon is at x=(?<bx>-?\d+), y=(?<by>-?\d+)/

def manhat_dist(v1, v2)
    tmp = v1 - v2
    return tmp[0].abs + tmp[1].abs
end

class Sensor

    attr_accessor :min_dist
    attr_accessor :sensor_pos
    attr_accessor :closest_beacon_pos

    def initialize(sensor_x, sensor_y, closest_beacon_x, closest_beacon_y)
        @sensor_pos = Vector[sensor_x, sensor_y]
        @closest_beacon_pos = Vector[closest_beacon_x, closest_beacon_y]
        @min_dist = manhat_dist(@sensor_pos, @closest_beacon_pos)
        #print @sensor_pos
        #puts ""
        #puts @min_dist
        #puts ""
    end

end


def cant_be_set(sensors, given_y)
    se = Set.new
    sensors.each { |s| 
        dist_rem = (s.sensor_pos[1] - given_y).abs
        if dist_rem <= s.min_dist
            dist_rem = s.min_dist - dist_rem
            ((s.sensor_pos[0] - (dist_rem))..(s.sensor_pos[0] + (dist_rem))).each { |i|
                se.add(i)
            }
        end
        if s.closest_beacon_pos[1] == given_y
            se.delete(s.closest_beacon_pos[0])
        end
    }
    return se
end

def get_range(sensor, x)
    dist_to = (sensor.sensor_pos[0] - x).abs
    if dist_to <= sensor.min_dist
        dist_rem = sensor.min_dist - dist_to
        return [sensor.sensor_pos[1] - dist_rem, sensor.sensor_pos[1] + dist_rem]
    else
        return [nil, nil]
    end
end

def blackout_fast(sensors, max_p)
    x = 0
    y = 0
    h = {}
    loop do
        if x == 0
          RubyProf.start
        end
        if x == 10000
          result = RubyProf.stop
          printer = RubyProf::GraphPrinter.new(result)
          printer.print(STDOUT)
        end
        filt_s = sensors.select{|s| (s.sensor_pos[0]-x).abs < s.min_dist}.sort_by{|a|
            a.min_dist
        }.map{|s| get_range(s, x)}
        loop do
            y = h.fetch(x, 0)
            valid = true
            filt_s.each{ |s|
                r_low = s[0]
                r_hi = s[1] 
                if r_low <= y && r_hi > y
                    valid = false
                    y = r_hi
                    (x..(x+(s[0]-s[1]).abs  * 2)).each{|xi|
                        hhi = h.fetch(x, 0)
                        if r_low <= hhi && r_hi > hhi
                            h[xi] = r_hi
                        else
                            break
                        end
                    }
                    break
                end
            }
            if valid
              puts "#{x}, #{y} is valid!"
              puts "#{x * 4000000 + y}"
            end
            y += 1
            h[x] = y
            if y > max_p
                break
            end
        end
        h.delete(x)
        x += 1
        if x > max_p
            break
        end
    end
end

def blackout(sensors, max_p)
    (0..max_p).each {|x|
      puts "x: #{x}"
      (0..max_p).each {|y|
        v = Vector[x, y]
        valid = true
        sensors.each { |s| 
          if valid && manhat_dist(v, s.sensor_pos) <= s.min_dist
            valid = false
          end
        }
        if valid
            puts "#{x}, #{y} is valid!"
            puts "#{x * 4000000 + y}"
        end
      }
    }
end

if __FILE__ == $0
    sensors = File.read("day15.txt").split("\n").map{ |line|
      line.match(reg)
      #puts line
      #puts reg
      sx = $~[:sx].to_i
      sy = $~[:sy].to_i
      bx = $~[:bx].to_i
      by = $~[:by].to_i
      Sensor.new(sx, sy, bx, by)
    }

    #se = cant_be_set(sensors, 2000000)
    #puts se.length
    blackout_fast(sensors, 4000000)
end
