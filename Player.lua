require "Animation"

Player = {
    x,
    y,
    scale,
    animations,
    currentAnimation,
    vx,
    vy,
    movementSpeed,
    healthPercent,
    boostPercent
}

function Player:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Player:load(world, x, y, characterSprite)

    if characterSprite == nil then
       print ">>> Error! Player:load(characterSprite) was null <<<"
       love.event.quit()
       os.exit()
    end

    self.x = x
    self.y = y
    self.scale = 0.35
    self.movementSpeed = 6
    self.healthPercent = 100
    self.boostPercent = 100

    self.animations = Animation.loadAnimations(characterSprite, {"idle", "move"})
    self.currentAnimation = self.animations["move"]

end

function Player:update(dt)

    local leftRight, upDown = self:getKeyboardVector()

    self.x = self.x + dt * leftRight * 125
    self.y = self.y + dt * upDown * 125

    ---- Update animation
    self.currentAnimation:update(dt)

end

function Player:getKeyboardVector()
    local leftRight = 0
    local upDown = 0
    if love.keyboard.isDown("left") then
        leftRight = leftRight - 1
    end
    if love.keyboard.isDown("right") then
        leftRight = leftRight + 1
    end
    if love.keyboard.isDown("up") then
        upDown = upDown - 1
    end
    if love.keyboard.isDown("down") then
        upDown = upDown + 1
    end
    return leftRight, upDown
end

function Player:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", self.x-3, self.y-3, 106,106)
    self.currentAnimation:draw(self.x, self.y, self.scale)
end
