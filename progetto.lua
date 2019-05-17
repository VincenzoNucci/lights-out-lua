-- local colors = require 'ansicolors'
local queue = require 'queue'



-- given a 2D table, sum the value of all the elements
function table_sum (a)
    local sum = 0
    local table_width = table.getn(a)
    for i = 1, table_width, 1 do
        local partial_table_heigth = table.getn(a[i])
        for j = 1, partial_table_heigth, 1 do 
            sum = sum + a[i][j]
        end
    end
    return sum
end

-- class Node for the A* algorithm
Node = {f = 0, g = 0, h = 0, parent = nil, position = 0, matrix = {}, sum = 0}

function Node:new (o,par,pos,matx)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    parent = par or nil
    position = pos or 0
    matrix = matx or {}
    sum = table_sum(matrix)
    return o
end
function Node:calculate_h(o,)
    o = o or {}
    setmetatable(o,self)
    self.__index = self

end

function heuristic(node)
    dx = abs(node.x - goal.x)
    dy = abs(node.y - goal.y)
    return D * (dx + dy)
end

-- creo la tabella che conterrà i segnalini
board_height = 5
board_width = 5

color_red = 1
color_blue = 5

moves = 0


board = {}          -- create the matrix
    for i=1,board_width do
      board[i] = {}     -- create a new row
      for j=1,board_height do
        board[i][j] = 0
      end
    end

red = false
blue = true

for i=1,board_width do
    for j=1,board_height do
        token_color = math.random()
        if token_color < 0.5 then
            board[i][j] = color_red
        else
            board[i][j] = color_blue
        end
    end
end

--[[for i=1,table_width do
    print("\n")
    for j=1,table_height do
        if table[i][j] == color_red then
            -- io.write(ansicolors("%{red}o"))
            io.write(colors('%{white}' .. color_red))
        else
            -- io.write(ansicolors("%{blue}o"))
            io.write(colors('%{gray}' .. color_blue))
        end
    end
end
]]

for i=1,board_width do
    print("\n")
    for j=1,board_height do
        io.write(table[i][j])
    end
end

-- applying A* algorithm to get the solution
open_list = Queue.new()
closed_list = Queue.new()
-- start_time = os.time()

-- selecting the initial node from the matrix representation
-- the initital node is the entire matrix
-- the end node is the matrix with all the values for nodes put to 5 (sum is 125)

start_node = Node:new(nil,0,board)
Queue.enqueue(open_list,start_node)
end_node = Node:new(nil,0,board)

while(Queue.size(open_list)>0) do
    current_node = Queue.dequeue(open_list)
    current_index = 0
    for _,node in ipairs(open_list) do
        if node.f < current_node.f then
            current_node = node
            current_index = node.position
        end
    end

    Queue.pop(open_list,current_index)
    Queue.enqueue(current_node)

    -- Found the goal
    if current_node == end_node then 
        path = Queue.new()
        local current = current_node
        while not current == nil do
            path.enqueue(current)
            current = current.parent
        end
        -- return reversed path
    end

    -- generate children
    children = Queue.new()
    for new_position = 0,
end

-- end_time = os.time()

-- elapsed_time = os.difftime(end_time,start_time)