require "Animation"

Octopus = {
    x,
    y,
    animations,
    currentAnimations,
    physics,
    spriteLayerNames,
    transitionState = "none",        -- "none" -> "transit" -> "done"
    transitScale = 1.0
}

function Octopus:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local octopusRadius = 30

function Octopus:load(world, characterSprite)

    if characterSprite == nil then
       print ">>> Error! Octopus:load(characterSprite) was null <<<"
       love.event.quit()
       os.exit()
    end

    self.x = 0
    self.y = 0

    self.spriteLayerNames = {"body", "bottomlegs", "rightarm", "leftarm", "face"}

    self.animations = Animation.loadAnimations(characterSprite, {"idle", "grab"}, self.spriteLayerNames)
    self.currentAnimations = self.animations["idle"]

    self.physics = self:loadPhysics(world, self.x, self.y)

end

function Octopus:loadPhysics(world, x, y)
    local physics = {}
    physics.body = love.physics.newBody(world, x, y, "dynamic")
    physics.shape = love.physics.newCircleShape(octopusRadius)
    physics.fixture = love.physics.newFixture(physics.body, physics.shape, 1)
    physics.fixture:setUserData({"octopus",self})
    physics.fixture:setRestitution(0.8)
    return physics
end

function Octopus:transitionToNextGrid(map)
    if self.transitionState == "none" then
       self.transitionState = "transit" 
    end
end

function Octopus:spawn(player, map)
    local x, y = self:getSpawnLocation(player, map)

    self.physics.body:setPosition(x, y)
    
end

function Octopus:getSpawnLocation(player, map)

    local activeGrid = map:getActiveGrid()
    local pcx, pcy = getCellForPoint(player.x, player.y, map.cellWidth, map.cellHeight)

    return (pcx + 1) * map.cellWidth,
           (pcy + 1) * map.cellHeight

end

function Octopus:update(dt, player, map)

    if self.transitionState ~= "done" then
        self:updateMovement(player, map)
        self:updateTransition(dt)
        self:updateAnimation(dt)
    end
end

function Octopus:updateTransition(dt)
    if self.transitionState == "transit" then
        self.transitScale = self.transitScale - dt
        if self.transitScale <= 0 then
            self.transitScale = 0
            self.transitionState = "done"
            self.physics.body:destroy()
        end
    end
end

function Octopus:fleePlayer(player)
    
    local vecX, vecY = normalise(self.x - player.x, self.y - player.y)

    return 2000 * vecX, 2000 * vecY
end

function Octopus:headForOpenWater(map)

    local ocx, ocy = getCellForPoint(self.x, self.y, map.cellWidth, map.cellHeight)

    local candidateCells = getCandidateCells(ocx, ocy) 

    local grid = map:getActiveGrid()
    local lncx, lncy = getLeastNeighbourCell(grid, candidateCells)

    local vecX = 0
    local vecY = 0

    if ocx ~= lncx and lncy ~= cy then
        local x = map.cellWidth * lncx
        local y = map.cellHeight * lncy
        vecX, vecY = normalise(x - self.x, y - self.y)
    end

    return 900 * vecX, 900 * vecY
end

function getLeastNeighbourCell(grid, candidateCells)

    --Start with the center
    local cx, cy = candidateCells[5][1], candidateCells[5][2]

    local cellIdxWithMinNeighbours = 5
    local lastNeighbourCount = countNeighbours(grid, cx, cy)

    -- Compare to the rest
    for ci=1,#candidateCells do

       cx, cy = candidateCells[ci][1], candidateCells[ci][2]

       local nc = countNeighbours(grid, cx, cy)
       if nc < lastNeighbourCount then
           lastNeighbourCount = nc
           cellIdxWithMinNeighbours = ci
       end

   end

   return candidateCells[cellIdxWithMinNeighbours][1],
          candidateCells[cellIdxWithMinNeighbours][2]

end

function getCandidateCells(ocx, ocy)
    return { {ocx-1,ocy-1} --top row
           , {ocx  ,ocy-1}
           , {ocx+1,ocy-1}

           , {ocx-1,ocy  } --middle row
           , {ocx  ,ocy  }
           , {ocx+1,ocy  }

           , {ocx-1,ocy+1} --bottom row
           , {ocx  ,ocy+1}
           , {ocx+1,ocy+1}
           }
end

function Octopus:updateMovement(player, map)

    local forceX, forceY = getOceanForce(self)

    local repelX, repelY = self:fleePlayer(player)

    forceX = forceX + repelX
    forceY = forceY + repelY

    local openX, openY = self:headForOpenWater(map)
    forceX = forceX + openX
    forceY = forceY + openY

    --Pass the force to the physics engine
    self.physics.body:applyForce(forceX, forceY)

    --Get the position back out of the physics engine
    --From last frame, but whatever
    self.x, self.y = self.physics.body:getPosition()

end

function Octopus:updateAnimation(dt)
    for i=1, #self.spriteLayerNames do
        self.currentAnimations[self.spriteLayerNames[i]]:update(dt, self.spriteLayerNames)
    end
end

local graphicalScaleX = 0.45
local graphicalScaleY = 0.45

function Octopus:draw()

    love.graphics.setColor(255, 255, 255)

    for i=1, #self.spriteLayerNames do
        self.currentAnimations[self.spriteLayerNames[i]]:draw(
            self.x + 37,
            self.y + 37,
            0,
            graphicalScaleX * self.transitScale,
            graphicalScaleY * self.transitScale,
            self.spriteLayerNames)
    end

    -- Bounding circle
    love.graphics.circle("line", self.x, self.y, octopusRadius)

end


