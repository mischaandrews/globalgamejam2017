require "Animation"

Pickup = {
    x,
    y,
    scaleX,
    scaleY,
    rot,
    animations,
    currentAnimations,
    physics,
    destroyed,
    spriteLayerNames
}

function Pickup:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local pickupRadius = 10

function Pickup:load(world, x, y, pickupSprite)

    if pickupSprite == nil then
       print ">>> Error! Pickup:load(pickupSprite) was null <<<"
       love.event.quit()
       os.exit()
    end

    self.rot = math.random()

    local jitter = 50
    self.x = x + math.random(-jitter, jitter)
    self.y = y + math.random(-jitter, jitter)
    self.scaleX = 0.6
    self.scaleY = 0.6

    self.spriteLayerNames = {"body"}
    
    self.animations = Animation.loadAnimations(pickupSprite, {"float"}, self.spriteLayerNames)
    self.currentAnimations = self.animations["float"]

    self.physics = {}
    self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic") 
    self.physics.shape = love.physics.newCircleShape(pickupRadius)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 1)
    self.physics.fixture:setUserData({"pickup",self})
    self.physics.fixture:setRestitution(0.0) --TODO 

    self.destroyed = false
    
end



function Pickup:update(dt)
    if self.destroyed == false then
        self:updateMovement()
        --self.currentAnimations:update(dt)
    end
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
    --self.currentAnimations:draw(self.x, self.y, self.scaleX, self.scaleY, self.spriteLayerNames)
    for i=1, #self.spriteLayerNames do
        self.currentAnimations[self.spriteLayerNames[i]]:draw(
            self.x,
            self.y,
            self.rot,
            self.scaleX,
            self.scaleY,
            self.spriteLayerNames)
    end

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


function Pickup:destroy()
-- TODO: please fix this John? thank you :)
    self.x = -999999
    self.y = -999999
    self.physics.body:destroy()
    self.destroyed = true

end
