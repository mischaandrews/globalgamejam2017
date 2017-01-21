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
end

function Pickup:pickupSprite()
    if self.pickupSprite == nil then
        return "unknown"
    else
        return self.pickupSprite
    end
end
