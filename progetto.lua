-- local colors = require 'ansicolors'
-- local queue = require 'queu

function sleep(s)
    local ntime = os.clock() + s
    repeat until os.clock() > ntime
  end
  
  local function shallowCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = value
    end
    return copy
end

local function stringifyTable(t)
    local entries = {}
    for k, v in pairs(t) do
        -- if we find a nested table, convert that recursively
        if type(v) == "table" then
            v = stringifyTable(v)
        else
            v = tostring(v)
        end
        k = tostring(k)
 
        -- add another entry to our stringified table
        table.insert(entries,string.format("%s = %s",k, v))
    end
 
    -- the memory location of the table
    --local id = tostring(t):sub(8)
 
    return string.format("{%s}",entries)
end

function data_table_print(list,sublevel)
    sublevel = sublevel or 0
    for i =1, sublevel do io.write("\t") end
    io.write("{ ")
    for key, value in pairs(list) do
        for i =1, sublevel do io.write("\t") end
        print(key," = ",value)
        if type(value) == "table" then
            data_table_print(value,sublevel + 1)
        end
    end
    io.write(" }")
end

-- given a 2D table, sum the value of all the elements
function table_sum(a)
    local sum = 0
    local table_width = #a
    for i = 1, table_width, 1 do
        local partial_table_heigth = #a[i]
        for j = 1, partial_table_heigth, 1 do 
            sum = sum + a[i][j]
        end
    end
    return sum
end

-- given a 2D table, print all the elements row by row
function table_print(a,w,h)
    for i = 1,w,1 do
        io.write("\n")
        for j = 1,h,1 do
            io.write(a[i][j])
        end
    end
    io.write("\n")
end

function table_reverse(a)
  local reversed_table = {}
  local j = 1
  for i = #a, 1, -1 do
    reversed_table[j] = a[i]
  end
  return reversed_table
end

-- given a 2D table, transforms it into a node for the A* algorithm
function nodify(a,i,j)
    local node = {board = a, row = i, column = j, toggled = 0, visited = 0, heuristic_f = 0, 
        heuristic_g = 0, heuristic_h = 0, parent = nil, position = 0, sum = table_sum(a)}
    return node
end

-- given a list, append a node to the last position
function append(list,node)
    --local list_length = #list + 1
    --list[list_length] = node
    --node["position"] = list_length
    table.insert(list,node)
    node["position"] = #list
end

-- given a list, return and remove the node in the first position
function dequeue(list)
    --[[local node = list[1]
    -- remove the reference on the first_position index
    for i=1,#list do
        if list[i+1] ~= nil then
            list[i] = list[i+1]
        end
    end
    return node
    ]]
    
    return table.remove(list)
    
end

-- given a list, return and remove the node in the specified position
function pop(list,index)
    --[[local node = list[index]
    for i=index,#list do
        if list[i+1] ~= nil then
            list[i] = list[i+1]
        end
    end
    return node
    ]]
    return table.remove(list,index)
end

function dequeue_lowest_f(list)
    local i = 1
    local min_f = 10000000
    local node = nil
    for i = 1,#list,1 do
        if list[i]["heuristic_f"] < min_f then
            min_f = list[i]["heuristic_f"]
            node = list[i]
        end
    end
    return node,min_f
end

function search_node(list,node)
    local i = node["row"]
    local j = node["column"]
    for i=1,#list do
        if list[i]["row"] == i and list[i]["column"] == j then
          return true
          end
      end
      return false
  end

function toggle_lights(node)
  local a = node["board"]
  local i = node["row"]
    local j = node["column"]
  
  local light_positions = {{-1,0},{0,0},{1,0},{0,-1},{0,1}}
            -- for each neighbor in the 4 directions and the central cell do...
            for _,light_position in pairs(light_positions) do
                -- print("vecchia riga", tmp_row)
                --print("vecchia colonna",tmp_col)
                --print("nuova riga",tmp_row + light_position[1])
                --print("nuova colonna", tmp_col + light_position[2])
                -- print(new_board)
                local new_row = i + light_position[1]
                local new_col = j + light_position[2]
                -- if the light is in bound, toggle it
                if new_row >=1 and new_row <= 5 and new_col >= 1 and new_col <= 5 then
                    -- print(new_board[new_row][new_col])
                    if a[new_row][new_col] == 1 then 
                        a[new_row][new_col] = 0
                    else
                        a[new_row][new_col] = 1
                    end
                end
            end
  node["toggled"] = 1
  end

function append_adjacent_nodes(list,node)
    local i = node["row"]
    local j = node["column"]
    toggle_lights(node)
    -- the positions of the 8 adjacent nodes
    local positions = { {-1,-1}, {-1,0}, {-1, 1}, {0,1}, {1,1}, {1,0}, {1,-1}, {0,-1}}
    -- each position is a neighbor node, so for each neighbor node do...
    for _,position in pairs(positions) do
        local tmp_row = i + position[1]
        local tmp_col = j + position[2]
        -- if the coordinates of the neighbor are not out of bound...
        if tmp_row >= 1 and tmp_row <= 5 and tmp_col >= 1 and tmp_col <= 5 then
            -- local board of a single neighbor that will be toggled
            local new_board = shallowCopy(node["board"])
            -- positions of the 4 neighbors and the central light that must be toggled
            
            
            -- create a new node with the modified board
            local new_adjacent_node = nodify(new_board,tmp_row,tmp_col)
            -- RIVEDERE IL TOGGLE CHE NON MI FA AGGIUNGERE NODI ALLA OPEN_LIST
            --new_adjacent_node["toggled"] = 1
            --print(tmp_row)
            --print(tmp_col)
            -- set this further step in solution as neighbor of current node
            new_adjacent_node["parent"] = node
            --append(list,new_adjacent_node)
            table.insert(list,new_adjacent_node)
            --print(new_adjacent_node["board"])
            -- print(new_adjacent_node["sum"])
            -- sleep(2)
        end
    end
end

function check_node_equality(node1,node2)
  for key,value in pairs(node1) do
    if node2.key ~= key or node2[key] ~= value then
      return false
    end
  end
  return true
end

function calculate_h(node,goal_node)
    -- for now the heuristic function is how much is left to reach 0
    -- local current_sum = node["sum"]
    -- local goal_sum = goal_node["sum"]
    -- to get the solution, sum must reach 0
    --return manhattan_distance(current_sum,goal_sum)
    --return node["sum"]
    local light_positions = {{-1,0},{0,0},{1,0},{0,-1},{0,1}}
    for _,light_position in light_positions do
      
      end
end

function manhattan_distance(node,goal_node)
    -- manhattan distance of a single cell
    dx = math.abs(node["sum"] - goal_node["sum"])
    dy = math.abs(node["sum"] - goal_node["sum"])
    return 1 * (dx + dy)
end

-- diagonal distance of a single cell
function diagonal_distance(node,goal_node)
    local h = 0
    h = math.max(math.abs(node.row - goal_node.row),math.abs(node.column - goal_node.column))
    return h 
end


function min_f_score(list)
  
end

light_on = 1
light_off = 0

moves = 0
solution = nil
target_moves = 7

-- creo la tabella che conterrà i segnalini
board_height = 5
board_width = 5

-- fixed starting board
board =   {{0, 1, 0, 1, 0 },
          { 1, 1, 0, 0, 0 },
          { 1, 0, 0, 0, 0 },
          { 1, 1, 1, 0, 0 },
          { 1, 0, 1, 1, 1 }}


--[[random starting board
board = {}          -- create the matrix
    for i=1,board_width,1 do
      board[i] = {}     -- create a new row
      for j=1,board_height,1 do
        token_color = math.random()
        if token_color < 0.5 then
            board[i][j] = light_on
        else
            board[i][j] = light_off
        end
      end
    end
]]

table_print(board,board_width,board_height)

-- applying A* algorithm to get the solution
    -- first contains the index of the first element to remove
    -- last contains the index of the next element to insert
open_list = {}
closed_list = {}

--data_table_print(open_list)
--data_table_print(closed_list)
-- start_time = os.time()

-- selecting the initial node from the matrix representation
-- the initital node is always the top left node (cell)
-- the end node is the matrix with all the values for nodes put to 0 (sum is 0)

-- start_node = nodify(board,random row, random column)
start_node = nodify(board,1,1)
append(open_list,start_node)

data_table_print(open_list)


end_node = nodify(board,_,_)
end_node["sum"] = 0

-- data_table_print(end_node)
-- print("open_list:")
-- data_table_print(open_list)
while(#open_list>0) do
    print("inizio while loop generale")
    --moves = moves + 1
    -- obtain the node with the lowest cost f
    local current_node = dequeue_lowest_f(open_list)
    print(current_node["row"])
    print(current_node["column"])
    print("open_list no.",#open_list)
    -- print("current_node:")
    -- data_table_print(current_node)

    local current_index = current_node["position"]
    --print("current_index",current_index)

    pop(open_list,current_index)
    -- print("open_list:")
    -- data_table_print(open_list)
    current_node["visited"] = 1
    --append(closed_list,current_node)
    -- print("closed_list:")
    -- data_table_print(closed_list)

    -- Found the goal
    if current_node["sum"] == 0 then 
        print("solution found")
        path = {}
        local current = current_node
        while not current == nil do
            append(path,current)
            current = current["parent"]
        end
          solution = table_reverse(path)
          break
    end

    -- else generate children
    children = {}
    -- and append the 8 neighbors of the current_node
    append_adjacent_nodes(children,current_node)
    print("children no: ",#children)
    for _,child in pairs(children) do
        -- il child non è nella closed_list ovvero non è stato ancora visitato
        local node,min_f = dequeue_lowest_f(open_list)
            if not search_node(open_list,child) and child["visited"] == 0 and child["toggled"] == 0 and child["heuristic_f"] <= min_f then
                -- plus 1 is the distance between the current_node and the child
                child["heuristic_g"] = current_node["heuristic_g"] + 1
                child["heuristic_h"] = calculate_h(child,end_node)
                child["heuristic_f"] = child["heuristic_g"] + child["heuristic_h"]
                append(open_list,child)
                
                  --[[ se il child non è stato togglato, posso visitare i suoi vicini
                    if child["toggled"] == 0 and child["heuristic_g"] <= open_node["heuristic_g"] then
                        append(open_list,child)
                    end
                    ]]
                
            end
             
    end
end

print("fine while loop generale")
print("the path to the solution is",solution)
-- end_time = os.time()

-- elapsed_time = os.difftime(end_time,start_time)
