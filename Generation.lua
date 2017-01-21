
local chanceToStartBlock = 0.45
local birthLimit = 4
local deathLimit = 3

function buildGrid(numCellsX, numCellsY)
    local grid = initialise(numCellsX, numCellsY)
    for i=1,6 do
        grid = updateMap(grid)
    end
    labelEdges(grid, numCellsX, numCellsY)
    return grid
end

function labelEdges(grid, numCellsX, numCellsY)
    for j = 1, numCellsY do
        for i = 1, numCellsX do
            local nbc = countNeighbours(grid, i, j)

            if grid[j][i] == "block" and nbc < 8 then
                grid[j][i]="edge"
            end
        end
    end
end

function populateLettuces(physics)

    local pickup1_spawnX = 400
    local pickup1_spawnY = 350
    local pickup1 = Pickup:new()
    pickup1:load(physics, pickup1_spawnX, pickup1_spawnY, "lettuce")

    local pickup2_spawnX = 250
    local pickup2_spawnY = 100
    local pickup2 = Pickup:new()
    pickup2:load(physics, pickup2_spawnX, pickup2_spawnY, "lettuce")

    local pickup3_spawnX = 410
    local pickup3_spawnY = 460
    local pickup3 = Pickup:new()
    pickup3:load(physics, pickup3_spawnX, pickup3_spawnY, "lettuce")

    return {pickup1, pickup2, pickup3}
end

function initialise(numCellsX, numCellsY)
    local grid = {}
    for j = 1, numCellsY do
        grid[j] = {}
        for i = 1, numCellsX do
            if math.random() < chanceToStartBlock then
                grid[j][i] = "block"
            else
                grid[j][i] = "free"
            end
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
            
            if oldGrid[j][i] == "block" then
                if nbc < deathLimit then
                    grid[j][i] = "free"
                else
                    grid[j][i] = "block"
                end
            else
                if nbc > birthLimit then
                   grid[j][i] = "block"
                else
                   grid[j][i] = "free"
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
            elseif grid[ny][nx] ~= "free" then
                count = count + 1 --Depends on neighbour
            end

        end
    end
    return count
end
























