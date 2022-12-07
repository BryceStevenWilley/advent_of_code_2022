#!/usr/bin/env ruby
require 'set'

def recg(signal, ss =4)
    (ss..signal.length-1).each { |last_idx|
        tt = Set[]
        (1..ss).each { | ii |
            tt.add(signal[last_idx- ii])
        }
        if tt.length == ss
            return last_idx
        end
    }
end

def recg_msg(signal)
    (4..signal.length-1).each { |last_idx|
        if Set[signal[last_idx-4], signal[last_idx-3], signal[last_idx-2], signal[last_idx-1]].length == 4
            return last_idx
        end
    }
end

if __FILE__ == $0
    puts recg("bvwbjplbgvbhsrlpgdmjqwftvncz")
    puts recg("nppdvjthqldpwncqszvftbrmjlhg")
    sig = File.read("day6.txt")
    puts recg(sig)
    puts recg(sig, ss=14)
end

# Started 16:41
# pt1 16:48:32
# pt2 16:51:42

# Felt good! was pretty fast, only slowed down because I implented a thing that I thought would be fine
# hardcoded, and ended up needed to be more flexible