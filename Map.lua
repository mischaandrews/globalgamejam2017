require "Generation"

local numCellsX = 128
local numCellsY = 128

local cellWidth = 100
local cellHeight = 100

Map = {
    player,
    grids,
    gridScales,
    gridOpacities,
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
    self.grids, self.gridScales, self.gridOpacities = Map.loadGridsAndScalesAndOpacs()
    self.player = player
    self:genPhysics(world)

end

function Map.loadGridsAndScalesAndOpacs()
    local activeGrid = buildGrid(numCellsX, numCellsY)
    local backGrid1 = buildGrid(numCellsX, numCellsY)
    local backGrid2 = buildGrid(numCellsX, numCellsY)
    local backGrid3 = buildGrid(numCellsX, numCellsY)

    return {backGrid3, backGrid2, backGrid1, activeGrid},
           {     0.12,      0.25,      0.50,          1},
           {      255,       128,       128,        128}
end

function Map:populateLettuces(physics)
    return populateLettuces(physics, self:getActiveGrid(), cellWidth, cellHeight)
end

function Map:getActiveGrid()
   return self.grids[4]
end

function Map:genPhysics(world)
    local mapPhys = {}
    for j = 1, numCellsY do
        for i = 1, numCellsX do
            if self:getActiveGrid()[j][i] == "edge" then
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

    for layerNum=1,4 do

        local scaleAdjustment = 50 + 10 * layerNum
        local scale = self.gridScales[layerNum] - fartScale / scaleAdjustment

        camera:set(scale)
        self:drawGrid(self.grids[layerNum], camera, winWidth, winHeight, self.gridOpacities[layerNum], scale)

        if layerNum == 3 then
            self:drawPlayerCell(self.grids[layerNum])
        end

        camera:unset()
    end


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
        love.graphics.setColor(200, 64, 64, 224 * self.player.z)
    else
        love.graphics.setColor(200, 200, 64, 224 * self.player.z)
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

