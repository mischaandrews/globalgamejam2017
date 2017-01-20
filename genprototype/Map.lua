require "Generation"

Map = {
    numCellsX = 100,
    numCellsY = 100,
    cellWidth = 4,
    cellHeight = 4,
    grid
}

function Map:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Map:load()
    self.grid = buildGrid(self.numCellsX, self.numCellsY)
end

function Map:update(dt)
end

function Map:draw()

    for j = 1, self.numCellsY do
        for i = 1, self.numCellsX do
            
            local colour; 
            
            if self.grid[j][i] then
                colour = 172
            else
                colour = 64
            end
            
            love.graphics.setColor(colour, colour, colour, 255)
            
            love.graphics.rectangle(
                "fill", self.cellWidth * i, self.cellHeight * j, self.cellWidth, self.cellHeight)
        end
    end

end
