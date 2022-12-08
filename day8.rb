
test_str = "30373\n25512\n65332\n33549\n35390"

def is_visible(trees, row, col)
    height = trees[row][col]
    if (0..(row - 1)).all?{|t_row| trees[t_row][col] < height}
        return true 
    end
    if ((row + 1)..trees.length - 1).all?{|t_row| trees[t_row][col] < height}
        return true 
    end
    if (0..(col - 1)).all?{|t_col| trees[row][t_col] < height}
        return true
    end
    if ((col+ 1)..trees[row].length - 1).all?{|t_col| trees[row][t_col] < height}
        return true 
    end
    return false
end

def tree_score(trees, row, col)
    height = trees[row][col]
    uscore = 0
    # https://stackoverflow.com/q/2070574, tricky, can't do (4..1)
    for t_row in (row - 1).downto(0) do 
        if trees[t_row][col] < height
            uscore += 1
        else
            uscore += 1
            break
        end
    end
    dscore = 0
    ((row + 1)..trees.length-1).each{|t_row| 
        if trees[t_row][col] < height
            dscore += 1
        else
            dscore += 1
            break
        end
    }
    lscore = 0
    for t_col in (col-1).downto(0) do
        if trees[row][t_col] < height
            lscore += 1
        else 
            lscore += 1
            break
        end
    end
    rscore = 0
    ((col+1)..(trees[row].length - 1)).each{|t_col| 
        if trees[row][t_col] < height
            rscore += 1
        else
            rscore += 1
            break
        end
    }
    return lscore * rscore * uscore * dscore
end


if __FILE__ == $0
    #trees = test_str.split("\n")
    trees = File.read("day8.txt").split("\n") # test_str.split("\n")
    puts tree_score(trees, 1, 2)
    puts (0..(trees.length-1)).map{|row|
        (0..(trees[row].length-1)).map{|col|
            v = is_visible(trees, row, col)
            if v
                1
            else
                0
            end
        }.sum
    }.sum
    puts (0..(trees.length-1)).map{|row|
        (0..(trees[row].length-1)).map{|col|
            tree_score(trees, row, col)
        }.max
    }.max
end



# started 7:09:15
# pt1: 7:23:50

# stoped at 7:45, slept for a long time, did like, 5 more minutes