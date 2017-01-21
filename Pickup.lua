require "Animation"

Pickup = {
    x,
    y,
    scaleX,
    scaleY,
    animations,
    currentAnimation,
    physics
}

function Pickup:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local pickupRadius = 20

function Pickup:load(world, x, y, pickupSprite)

    if pickupSprite == nil then
       print ">>> Error! Pickup:load(pickupSprite) was null <<<"
       love.event.quit()
       os.exit()
    end

    self.x = x
    self.y = y
    self.scaleX = 0.6
    self.scaleY = 0.6

    self.animations = Animation.loadAnimations(pickupSprite, {"float"})
    self.currentAnimation = self.animations["float"]

    self.physics = {}
    self.physics.body = love.physics.newBody(world, x, y, "dynamic") 
    self.physics.shape = love.physics.newCircleShape(pickupRadius)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 1)
    self.physics.fixture:setUserData({"pickup",self})
    self.physics.fixture:setRestitution(0.0) --TODO 

end



function Pickup:update(dt)
    self:updateMovement()
    self.currentAnimation:update(dt)
end

function Pickup:updateMovement()

    local forceX, forceY = getOceanForce(self)

    --Pass the force to the physics engine
    self.physics.body:applyForce(forceX, forceY)

    --Get the position back out of the physics engine
    --From last frame, but whatever
    self.x, self.y = self.physics.body:getPosition()

end

function Pickup:draw()
    love.graphics.setColor(255, 255, 255)
    self.currentAnimation:draw(self.x, self.y, self.scaleX, self.scaleY)
    
    -- Bounding box
    --love.graphics.circle("line", self.x, self.y, pickupRadius)
end

function Pickup:pickupSprite()
    if self.pickupSprite == nil then
        return "unknown"
    else
        return self.pickupSprite
    end
end
