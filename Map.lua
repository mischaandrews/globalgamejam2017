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
            
            local colour_r = 0; 
            local colour_g = 0;
            local colour_b = 0;
            
            
            if self.grid[j][i] == "free" then
                colour_r = 40
                colour_g = 91
                colour_b = 93
            elseif self.grid[j][i] == "edge" then
                colour_r = 18
                colour_g = 44
                colour_b = 45
            elseif self.grid[j][i] == "block" then
                colour_r = 21
                colour_g = 59
                colour_b = 61
            end
            
            love.graphics.setColor(colour_r, colour_g, colour_b, 255)
            
            love.graphics.rectangle(
                "fill", self.cellWidth * (i-1), self.cellHeight * (j-1), self.cellWidth, self.cellHeight)
        end
    end

end
