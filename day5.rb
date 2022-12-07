#!/usr/bin/env ruby

def create_input(file_text)
    start_lines = file_text.split("\n\n")[0].split("\n").reverse
    full_struct = []
    nums = -1
    start_line = start_lines[0]
    nums = start_line.split("  ")[-1].to_i
    (1..nums).to_a.each{ |num |
        full_struct.append([])
    }
    start_lines[1,start_lines.length].each_with_index { | blocks, idx |
        (1..nums).each { |idx|
            crate = blocks[1+((idx - 1)*4)]
            if crate != " " 
                full_struct[idx - 1].push(crate)
            end
        }
    }
    return full_struct
end

def do_steps(block_struct, steps)
    print block_struct
    puts ""
    steps.each {|step_line|
        locs = step_line.split("from")[1].split("to")
        from = locs[0].to_i - 1
        to = locs[1].to_i - 1
        # puts step_line
        number = step_line.split("from")[0].split("move")[1].to_i
        (1..number).each {|count|
            block_struct[to].push(block_struct[from].pop)
            #print block_struct
            #puts ""
        }
        #puts "Done a step"
    }
    return block_struct.map{|block| block.pop}
end

def do_steps_9001(block_struct, steps)
    print block_struct
    puts ""
    steps.each {|step_line|
        locs = step_line.split("from")[1].split("to")
        from = locs[0].to_i - 1
        to = locs[1].to_i - 1
        # puts step_line
        number = step_line.split("from")[0].split("move")[1].to_i
        tmp = []
        (1..number).each {|count|
            tmp.push(block_struct[from].pop)
            #print block_struct
            #puts ""
        }
        print tmp
        puts ""
        (1..number).each {|count|
            block_struct[to].push(tmp.pop)
        }
        #puts "Done a step"
    }
    return block_struct.map{|block| block.pop}
end

if __FILE__ == $0
    lines = File.read("day5.txt")
    x = create_input(lines)
    tops = do_steps_9001(x, lines.split("\n\n")[1].split("\n"))
    str = ""
    tops.each{|let| str = str.concat(let)}
    print str
    puts ""
end

# Started 15:37 
# Pt 1: 16:31
# PT 2: 16:37

# Generally, had a descent amount of small things that I should know better about:
# indexs start at 1, which end does push and pop go from, what needs to be reversed, etc.