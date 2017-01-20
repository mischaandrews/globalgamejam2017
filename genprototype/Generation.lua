
local chanceToStartAlive = 0.4
local birthLimit = 4
local deathLimit = 3

function buildGrid(numCellsX, numCellsY)
    
    local grid = initialise(numCellsX, numCellsY)

    for i=1,6 do
        grid = updateMap(grid)
    end

    return grid
end

function initialise(numCellsX, numCellsY)
    local grid = {}
    for j = 1, numCellsY do
        grid[j] = {}
        for i = 1, numCellsX do
            grid[j][i] = math.random() < chanceToStartAlive
        end
    end
    return grid
end

function updateMap(oldGrid)
    local numCellsX = #oldGrid[1]
    local numCellsY = #oldGrid
    local grid = {}
    for j = 1, numCellsY do
        grid[j] = {}
        for i = 1, numCellsX do
            
            local nbc = countNeighbours(oldGrid, i, j)
            
            if oldGrid[j][i] then
                if nbc < deathLimit then
                    grid[j][i] = false
                else
                    grid[j][i] = true
                end
            else
                if nbc > birthLimit then
                   grid[j][i] = true
                else
                   grid[j][i] = false
                end
            end
        end
    end
    return grid
end

function countNeighbours(grid, x, y)
    local numCellsX = #grid[1]
    local numCellsY = #grid
    local count = 0

    --Initialise empty grid
    for j = -1, 1 do
        local ny = y + j
        for i = -1, 1 do
            local nx = x + i
            if i == 0 and j == 0 then
                                  --Own cell doesnt count
            elseif nx < 1 or ny < 1 or nx > numCellsX or ny > numCellsY then
                count = count + 1 --Boundaries count
            elseif grid[ny][nx] then
                count = count + 1 --Depends on neighbour
            end

        end
    end
    return count
end
























