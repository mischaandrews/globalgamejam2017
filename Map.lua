require "Generation"

Map = {
    numCellsX = 64,
    numCellsY = 64,
    cellWidth,
    cellHeight,
    activeGrid,
    backGrid1,
    backGrid2,
    mapPhys
}

function Map:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Map:load(world, cellWidth, cellHeight)

    math.randomseed(12345)

    self.activeGrid = buildGrid(self.numCellsX, self.numCellsY)
    self.backGrid1 = buildGrid(self.numCellsX, self.numCellsY)
    self.backGrid2 = buildGrid(self.numCellsX, self.numCellsY)

    self.cellWidth = cellWidth
    self.cellHeight = cellHeight
    
    self:genPhysics(world)
end

function Map:genPhysics(world)
    local mapPhys = {}
    for j = 1, self.numCellsY do
        for i = 1, self.numCellsX do
            if self.activeGrid[j][i] == "edge" then
                genBlock(world, self.cellWidth * i, self.cellHeight * j, self.cellWidth, self.cellHeight)
            end
        end
    end
    return mapPhys
end

function genBlock(world, x, y, width, height)
    local body = love.physics.newBody(world, x, y, "static")
    local shape = love.physics.newRectangleShape(width, height)
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setUserData("edge")
end

function Map:update(dt)
end

function Map:draw(camera)

    camera:set(0.15)
    self:drawGrid(self.backGrid2, 255, 0.83)
    camera:unset()

    camera:set(0.66)
    self:drawGrid(self.backGrid1, 128, 0.66)
    camera:unset()

    camera:set(1)
    self:drawGrid(self.activeGrid, 128, 1)
    camera:unset()

end

function Map:drawGrid(grid, alpha, scale)

    local halfCellWidth = self.cellWidth / 2
    local halfCellHeight = self.cellHeight / 2

    for j = 1, self.numCellsY do
        for i = 1, self.numCellsX do
            
            local colour_r = 0; 
            local colour_g = 0;
            local colour_b = 0;
            local colour_a = alpha

            if grid[j][i] == "free" then
                colour_r = 40
                colour_g = 91
                colour_b = 93
            elseif grid[j][i] == "edge" then
                colour_r = 18 
                colour_g = 44
                colour_b = 45
                colour_a = 255
            elseif grid[j][i] == "block" then
                colour_r = 21 * scale
                colour_g = 59 * scale
                colour_b = 61 * scale
                colour_a = 255
            end

            love.graphics.setColor(colour_r, colour_g, colour_b, colour_a)

            local drawAtX = self.cellWidth * (i-1)    -- Because lua indexes from 1
                          + halfCellWidth             -- Because physics calls x,y the centre

            local drawAtY = self.cellHeight * (j-1)   -- Because lua indexes from 1
                          + halfCellHeight            -- Because physics calls x,y the centre

            love.graphics.rectangle(
                "fill", scale * drawAtX, scale * drawAtY, scale * self.cellWidth, scale * self.cellHeight)
        end
    end
end

