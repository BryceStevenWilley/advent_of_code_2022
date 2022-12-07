#!/usr/bin/env ruby


class File
    def initialize(name, parent, size)
        @name = name
        @parent = parent
        @size = size
    end

    def get_size()
        @size
    end
end

# https://www.ruby-lang.org/en/documentation/quickstart/3/
class Dir
    attr_accessor :data
    attr_accessor :name
    attr_accessor :parent

    def initialize(name, parent)
        @name = name
        if parent == nil
            # https://www.rubyguides.com/2020/04/self-in-ruby/
            @parent = self
        else
            @parent = parent
        end
        @data = Hash.new
    end

    def add_file(name, size)
        data[name] = File.new(name, self, size)
        return data[name]
    end

    def add_dir(name)
        if !data.include?(name)
            data[name] = Dir.new(name, self)
        end
        return data[name]
    end

    def get_size()
        return data.map{ |n, v| v.get_size }.sum
    end
end

def make_dirs_from_steps(steps)
    root = Dir.new('/', nil)
    current = root
    all_dirs = [root]

    steps.each { |step|
        if step[0] == "$"
            step = step[2,step.length]
            if step == "ls"
                # https://stackoverflow.com/a/4010063
                next # we'll assume things not starting with "$" are ls, no state change
            end
            if step == "cd /"
                current = root
                next
            end
            if step == "cd .."
                current = current.parent
                next
            end
            if step.start_with?("cd")
                name = step.split(" ")[1]
                if current.data.include?(name)
                    current = current.data[name]
                else
                    all_dirs.append(current.add_dir(name))
                    current = all_dirs[-1]
                end
            end
        else
            if step.start_with?("dir")
                name = step.split(" ")[1]
                if !current.data.include?(name)
                    all_dirs.append(current.add_dir(name))
                end
                next
            end
            size = step.split(" ")[0].to_i
            name = step.split(" ")[1]
            current.add_file(name, size)
        end
    }
    puts all_dirs.map{ |v| 
        size = v.get_size
        if size < 100000
            size
        else
            0
        end
    }.sum
    remaining = 70000000 - root.get_size
    needed = 30000000 - remaining
    puts all_dirs.map{ |v| v.get_size}.select{|v| v> needed}.min
    return root
end



if __FILE__ == $0
    x = make_dirs_from_steps(File.read("day7.txt").split("\n"))
    print x
    puts ""
end

# Started: 21:47
# pt 1: 22:32:47
# pt 2: 22:37:47