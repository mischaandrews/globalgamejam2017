require "Animation"

Character = {
    x,
    y,
    scale,
    animations,
    currentAnimation,
    physics
}

function Character:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Character:load(world, x, y, characterSprite)

    if characterSprite == nil then
       print ">>> Error! Character:load(characterSprite) was null <<<"
       love.event.quit()
       os.exit()
    end

    self.x = x
    self.y = y
    self.scale = 0.45

    self.animations = Animation.loadAnimations(characterSprite, {"idle", "move"})
    self.currentAnimation = self.animations["idle"]

    self.physics = {}
    --remember, the shape (the rectangle we create next) anchors to the body from its center
    self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic") 

end


function Character:update(dt)
    self.currentAnimation:update(dt)
end

function Character:draw()

    love.graphics.setColor(255, 255, 255)

    love.graphics.rectangle("line", self.x-3, self.y-3, 106,106)
    self.currentAnimation:draw(self.x, self.y, self.scale)
    
    --for i=1, #(self.animation) do
        --self.animation[i]:draw(self.x, self.y, 0, self.scale, self.scale, 256 / 2, 256 / 2)
    --end
end

function Character:getPosition()
    return self.x, self.y
end

function Character:getVelocity()
    return self.physics.body:getLinearVelocity()
end

function Character:getTotalVelocity()
    local vx, vy = self.physics.body:getLinearVelocity()
    return math.sqrt(vx*vx + vy*vy)
end

function Character:applyForce(fx,fy)
    self.physics.body:applyForce(fx,fy)
end

function Character:setMass(mass)
    self.physics.body:setMass(mass)
end

function Character:getPhysics()
    return self.physics
end

function Character:characterSprite()
    if self.characterSprite == nil then
        return "unknown"
    else
        return self.characterSprite
    end
end
