require "Generation"

Map = {
    player,
    grids,
    gridScales,
    gridOpacities,
    mapPhys,
    numCellsX = 128,
    numCellsY = 128,
    cellWidth = 100,
    cellHeight = 100,
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
    self.grids, self.gridScales, self.gridOpacities = self:loadGridsAndScalesAndOpacs()
    self.player = player
    self:genPhysics(world)

end

function Map:loadGridsAndScalesAndOpacs()
    local activeGrid = buildGrid(self.numCellsX, self.numCellsY)
    local backGrid1 = buildGrid(self.numCellsX, self.numCellsY)
    local backGrid2 = buildGrid(self.numCellsX, self.numCellsY)
    local backGrid3 = buildGrid(self.numCellsX, self.numCellsY)

    return {backGrid3, backGrid2, backGrid1, activeGrid},
           {     0.12,      0.25,      0.50,          1},
           {      255,       128,       128,        128}
end

function Map:populateLettuces(physics)
    return populateLettuces(physics, self:getActiveGrid(), self.cellWidth, self.cellHeight)
end

function Map:getActiveGrid()
   return self.grids[4]
end

function Map:getNextGrid()
    return self.grids[3]
end

function Map:genPhysics(world)
    local mapPhys = {}
    for j = 1, self.numCellsY do
        for i = 1, self.numCellsX do
            if self:getActiveGrid()[j][i] == "edge" then
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

function Map:drawTop(camera, winWidth, winHeight)
    local fartScale = self.player.z
    for layerNum=4,4 do
        local scaleAdjustment = 50 + 10 * layerNum
        local scale = self.gridScales[layerNum] - fartScale / scaleAdjustment
        camera:set(scale)
        self:drawGrid(self.grids[layerNum], camera, winWidth, winHeight, self.gridOpacities[layerNum], scale)
        camera:unset()
    end
end

function Map:drawRest(camera, winWidth, winHeight)
    local fartScale = self.player.z
    for layerNum=1,3 do
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

    local blocksToLeft = math.ceil ((camera.x - self.cellWidth / 2) / self.cellWidth)
    local blocksPerScreenW = math.ceil (winWidth / (self.cellWidth * scale))
    local blocksToRight = blocksToLeft + blocksPerScreenW

    local blocksToTop = math.ceil ((camera.y - self.cellHeight / 2) / self.cellHeight)
    local blocksPerScreenH = math.ceil (winHeight / (self.cellHeight * scale))
    local blocksToBottom = blocksToTop + blocksPerScreenH

    return math.max (blocksToLeft, 1),
           math.min (blocksToRight, self.numCellsX),
           math.max (blocksToTop, 1),
           math.min (blocksToBottom, self.numCellsY)
end

function Map:drawPlayerCell(grid)

    local halfCellWidth = self.cellWidth / 2
    local halfCellHeight = self.cellHeight / 2

    local pcx, pcy = getCellForPoint(self.player.x, self.player.y, self.cellWidth, self.cellHeight)

    if grid ~= nil and grid[pcy][pcx] ~= "free" then
        love.graphics.setColor(200, 64, 64, 224 * self.player.z)
    else
        love.graphics.setColor(200, 200, 64, 224 * self.player.z)
    end

    local drawAtX = self.cellWidth * (pcx-1)    -- Because lua indexes from 1
                  + halfCellWidth         -- Because physics calls x,y the centre

    local drawAtY = self.cellHeight * (pcy-1)   -- Because lua indexes from 1
                  + halfCellHeight        -- Because physics calls x,y the centre

    love.graphics.rectangle(
                "fill", drawAtX, drawAtY,
                self.cellWidth, self.cellHeight)

end

function Map:drawGrid(grid, camera, winWidth, winHeight, alpha, scale)

    local blocksToLeft, blocksToRight, blocksToTop, blocksToBottom =
            self:getDrawRange(camera, winWidth, winHeight, scale)

    local blocksDrawn = 0

    local halfCellWidth = self.cellWidth / 2
    local halfCellHeight = self.cellHeight / 2

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

            local drawAtX = self.cellWidth * (i-1)    -- Because lua indexes from 1
                          + halfCellWidth             -- Because physics calls x,y the centre

            local drawAtY = self.cellHeight * (j-1)   -- Because lua indexes from 1
                          + halfCellHeight            -- Because physics calls x,y the centre

            blocksDrawn = blocksDrawn + 1

            love.graphics.rectangle(
                "fill", drawAtX, drawAtY,
                self.cellWidth, self.cellHeight)
        end
    end

    --print (blocksDrawn)

end

