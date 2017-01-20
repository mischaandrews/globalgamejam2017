
local chanceToStartAlive = 0.45

function buildGrid(numCellsX, numCellsY)
    return initialise(numCellsX, numCellsY)
end

function initialise(numCellsX, numCellsY)
    local grid = {}
    for j = 1, numCellsY do
        grid[j] = {}
        for i = 1, numCellsX do
            if math.random() < chanceToStartAlive then
                grid[j][i]=true
            else
                grid[j][i]=false
            end
        end
    end
    return grid
end
