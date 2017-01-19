require "Animation"

Character = {
    x,
    y,
    animation,
    physics
}

function Character:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Character:load(world, x, y, characterSprite)

    self.x = x
    self.y = y

    local animation = Animation:new()
    animation.load(characterSprite)
    self.animation = animation

    self.physics = {}
    --remember, the shape (the rectangle we create next) anchors to the body from its center
    self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic") 

end

function createAnimations(assetName, animationName, width, height, animationSpeed, numLayers, animationMode, spriteFrameNums)

    sprites = {}
    for i=1, numLayers do
        -- Resource path example: assets/pink/idle-0.png
        sprites[i] = love.graphics.newImage("assets/" .. assetName .. "/" .. animationName .. "-" .. i .. ".png")    
    end

    animations = {}
    for i=1, numLayers do
        animations[i] = newAnimation(sprites[i], width, height, animationSpeed, spriteFrameNums[i]) 
    end

    for i=1, #(animations) do
        animations[i]:setMode(animationMode)
    end

    return animations
end

function Character:update(dt)

end

function Character:draw()
    love.graphics.setColor(255, 255, 255)

    love.graphics.rectangle("fill", self.x, self.y, 100,100)

    --self.currentAnim:draw(self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)

    --for i=1, #(self.currentAnimation) do
    --    self.currentAnimation[i]:draw(self.x, self.y, 0, self.scale, self.scale, self.width / 2, self.height / 2)
    --end

    -- Variable reference:
    -- position (x), position (y), ?, scale (x), scale (y), offset X, offsetY
    -- TODO: check this offset. It might need to be scaled too.
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
