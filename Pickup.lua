require "Animation"

Pickup = {
    x,
    y,
    scale,
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
    self.scale = 0.6

    self.animations = Animation.loadAnimations(pickupSprite, {"float"})
    self.currentAnimation = self.animations["float"]

    self.physics = Pickup.loadPhysics(world, x, y)
end

function Pickup.loadPhysics(world, x, y)
    local phys = {}
    phys.body = love.physics.newBody(world, x, y, "dynamic") 
    phys.shape = love.physics.newCircleShape(pickupRadius)
    phys.fixture = love.physics.newFixture(phys.body, phys.shape, 1)
    phys.fixture:setUserData("pickup")
    phys.fixture:setRestitution(0.0) --TODO 
    return phys
end

function Pickup:update(dt)
    self.currentAnimation:update(dt)
end

function Pickup:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", self.x-3, self.y-3, 106,106)
    self.currentAnimation:draw(self.x, self.y, self.scale)
    -- todo: load width and height properly
end

function Pickup:pickupSprite()
    if self.pickupSprite == nil then
        return "unknown"
    else
        return self.pickupSprite
    end
end
