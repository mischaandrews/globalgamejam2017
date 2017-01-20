require "Generation"

Map = {
    numCellsX = 100,
    numCellsY = 100,
    cellWidth = 16,
    cellHeight = 16,
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
            
            local colour = 0; 
            
            if self.grid[j][i] == "free" then
                colour = 172
            elseif self.grid[j][i] == "edge" then
                colour = 64
            elseif self.grid[j][i] == "block" then
                colour = 140
            end
            
            love.graphics.setColor(colour, colour, colour, 255)
            
            love.graphics.rectangle(
                "fill", self.cellWidth * (i-1), self.cellHeight * (j-1), self.cellWidth, self.cellHeight)
        end
    end

end
