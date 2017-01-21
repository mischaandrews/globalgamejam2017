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

    self.physics = {}
    --remember, the shape (the rectangle we create next) anchors to the body from its center
    self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic") 

end


function Pickup:update(dt)
    self.currentAnimation:update(dt)
end

function Pickup:draw()

    love.graphics.setColor(255, 255, 255)

    love.graphics.rectangle("line", self.x-3, self.y-3, 106,106)
    self.currentAnimation:draw(self.x, self.y, self.scale)

    -- todo: load width and height properly
    
    --for i=1, #(self.animation) do
        --self.animation[i]:draw(self.x, self.y, 0, self.scale, self.scale, 256 / 2, 256 / 2)
    --end
    -- todo: load width and height properly


    --self.animation:draw(self.x,self.y)
end

function Pickup:getPosition()
    return self.x, self.y
end

function Pickup:getVelocity()
    return self.physics.body:getLinearVelocity()
end

function Pickup:getTotalVelocity()
    local vx, vy = self.physics.body:getLinearVelocity()
    return math.sqrt(vx*vx + vy*vy)
end

function Pickup:applyForce(fx,fy)
    self.physics.body:applyForce(fx,fy)
end

function Pickup:setMass(mass)
    self.physics.body:setMass(mass)
end

function Pickup:getPhysics()
    return self.physics
end

function Pickup:pickupSprite()
    if self.pickupSprite == nil then
        return "unknown"
    else
        return self.pickupSprite
    end
end
