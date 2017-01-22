require "Animation"

Octopus = {
    x,
    y,
    scaleX,
    scaleY,
    animations,
    currentAnimations,
    physics,
    spriteLayerNames
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
    self.scaleX = 0.45
    self.scaleY = 0.45

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
    physics.fixture:setUserData({"player",self})
    physics.fixture:setRestitution(0.8)
    return physics
end

function Octopus:spawn(player, map)
    local x, y = self:getSpawnLocation(player, map)

    self.physics.body:setPosition(x, y)
    
end

function Octopus:getSpawnLocation(player, map)
    
    local activeGrid = map:getActiveGrid()
    
    
    local pcx, pcy = getCellForPoint(player.x, player.y, map.cellWidth, map.cellHeight)

    return (pcx + 1) * map.cellWidth, pcy * map.cellHeight
    
end

function Octopus:update(dt, player)
    self:updateMovement(player)
    self:updateAnimation(dt)
end

function Octopus:fleePlayer(player)
    return 100, 0
end

function Octopus:updateMovement(player)

    local forceX, forceY = getOceanForce(self)

    local repelX, repelY = self:fleePlayer(player)

    forceX = forceX + repelX
    forceY = forceY + repelY

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

function Octopus:draw()

    love.graphics.setColor(255, 255, 255)

    for i=1, #self.spriteLayerNames do
        self.currentAnimations[self.spriteLayerNames[i]]:draw(
            self.x + 37,
            self.y + 37,
            self.scaleX,
            self.scaleY,
            self.spriteLayerNames)
    end

    -- Bounding circle
    love.graphics.circle("line", self.x, self.y, octopusRadius)

end


