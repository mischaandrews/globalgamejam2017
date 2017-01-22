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

function Octopus:load(world, x, y, characterSprite)

    if characterSprite == nil then
       print ">>> Error! Octopus:load(characterSprite) was null <<<"
       love.event.quit()
       os.exit()
    end

    self.x = x
    self.y = y
    self.scaleX = 0.45
    self.scaleY = 0.45

    self.spriteLayerNames = {"body", "bottomlegs", "rightarm", "leftarm", "face"}
    
    self.animations = Animation.loadAnimations(characterSprite, {"idle", "grab"}, self.spriteLayerNames)
    self.currentAnimations = self.animations["idle"]

    self.physics = self:loadPhysics(world, x, y)

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

function Octopus:spawn(world, player, map)
    local npc2_spawnX = 450
    local npc2_spawnY = 450
    local npc2 = Octopus:new()
    npc2:load(world, npc2_spawnX, npc2_spawnY, "octopus")
    return npc2
end

function Octopus:update(dt)
    self:updateMovement()
    self:updateAnimation(dt)
end

function Octopus:updateMovement()

    local forceX, forceY = getOceanForce(self)

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
        self.currentAnimations[self.spriteLayerNames[i]]:draw(self.x, self.y, self.scaleX, self.scaleY, self.spriteLayerNames)
    end

    -- Bounding circle
    love.graphics.circle("line", self.x, self.y, octopusRadius)

end


