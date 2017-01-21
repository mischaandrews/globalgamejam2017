require "Generation"

local numCellsX = 128
local numCellsY = 128

local cellWidth = 100
local cellHeight = 100

Map = {
    player,
    activeGrid,
    backGrid1,
    backGrid2,
    backGrid3, -- invisible
    mapPhys,

    transitionState = "none",  -- "none" -> "fartPrep" -> "farting" -> "none"
    transitionAmount = "0"  -- [0.0, 1.0)
}

function Map:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Map:load(world, player)

    math.randomseed(12345)

    self.activeGrid = buildGrid(numCellsX, numCellsY)
    self.backGrid1 = buildGrid(numCellsX, numCellsY)
    self.backGrid2 = buildGrid(numCellsX, numCellsY)
    self.backGrid3 = buildGrid(numCellsX, numCellsY)

    self.player = player

    --self:genPhysics(world)
end

function Map:populateLettuces(physics)
    return populateLettuces(physics, self.activeGrid, cellWidth, cellHeight)
end

function Map:genPhysics(world)
    local mapPhys = {}
    for j = 1, numCellsY do
        for i = 1, numCellsX do
            if self.activeGrid[j][i] == "edge" then
                genBlock(world, cellWidth * i, cellHeight * j, cellWidth, cellHeight)
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

function Map:draw(camera, winWidth, winHeight)

    local fartScale = self.player.z

    camera:set(0.12 - fartScale / 40)
    self:drawGrid(self.backGrid3, camera, winWidth, winHeight, 255, 0.12)
    self:drawPlayerCell(self.backGrid3)
    camera:unset()

    camera:set(0.25 - fartScale / 30)
    self:drawGrid(self.backGrid2, camera, winWidth, winHeight, 128, 0.25)
    self:drawPlayerCell(self.backGrid2)
    camera:unset()

    camera:set(0.50 - fartScale / 20)
    self:drawGrid(self.backGrid1, camera, winWidth, winHeight, 128, 0.50)
    self:drawPlayerCell(self.backGrid1)
    camera:unset()

    camera:set(1 - fartScale / 10)
    self:drawGrid(self.activeGrid, camera, winWidth, winHeight, 128, 1)
    --self:drawPlayerCell()
    camera:unset()

end

function Map:getDrawRange(camera, winWidth, winHeight, scale)

    local blocksToLeft = math.ceil ((camera.x - cellWidth / 2) / cellWidth)
    local blocksPerScreenW = math.ceil (winWidth / (cellWidth * scale))
    local blocksToRight = blocksToLeft + blocksPerScreenW

    local blocksToTop = math.ceil ((camera.y - cellHeight / 2) / cellHeight)
    local blocksPerScreenH = math.ceil (winHeight / (cellHeight * scale))
    local blocksToBottom = blocksToTop + blocksPerScreenH

    return math.max (blocksToLeft, 1),
           math.min (blocksToRight, numCellsX),
           math.max (blocksToTop, 1),
           math.min (blocksToBottom, numCellsY)
end

function Map:drawPlayerCell(grid)

    local halfCellWidth = cellWidth / 2
    local halfCellHeight = cellHeight / 2

    local cx, cy = self.player:getCurrentCell(cellWidth, cellHeight)

    if grid ~= nil and grid[cy][cx] ~= "free" then
        love.graphics.setColor(200, 64, 64, 192)
    else
        love.graphics.setColor(200, 200, 64, 192)
    end

    local drawAtX = cellWidth * (cx-1)    -- Because lua indexes from 1
                  + halfCellWidth         -- Because physics calls x,y the centre

    local drawAtY = cellHeight * (cy-1)   -- Because lua indexes from 1
                  + halfCellHeight        -- Because physics calls x,y the centre

    love.graphics.rectangle(
                "fill", drawAtX, drawAtY,
                cellWidth, cellHeight)

end

function Map:drawGrid(grid, camera, winWidth, winHeight, alpha, scale)

    local blocksToLeft, blocksToRight, blocksToTop, blocksToBottom =
            self:getDrawRange(camera, winWidth, winHeight, scale)

    local blocksDrawn = 0

    local halfCellWidth = cellWidth / 2
    local halfCellHeight = cellHeight / 2

    for j = blocksToTop, blocksToBottom do
        for i = blocksToLeft, blocksToRight do
            
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

            local drawAtX = cellWidth * (i-1)    -- Because lua indexes from 1
                          + halfCellWidth             -- Because physics calls x,y the centre

            local drawAtY = cellHeight * (j-1)   -- Because lua indexes from 1
                          + halfCellHeight            -- Because physics calls x,y the centre

            blocksDrawn = blocksDrawn + 1

            love.graphics.rectangle(
                "fill", drawAtX, drawAtY,
                cellWidth, cellHeight)
        end
    end

    --print (blocksDrawn)

end

