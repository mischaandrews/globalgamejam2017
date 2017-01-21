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
    self.healthPercent = 50
    self.boostPercent = 50

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

    if keysDown({"left","a"}) then
        leftRight = leftRight - 1
    end
    if keysDown({"right","d"}) then
        leftRight = leftRight + 1
    end
    if keysDown({"up","w"}) then
        upDown = upDown - 1
    end
    if keysDown({"down","s"}) then
        upDown = upDown + 1
    end
    return leftRight, upDown
end

function keysDown(keys)
   for i=1,#keys do
       if love.keyboard.isDown(keys[i]) then
           return true
       end
   end
   return false
end

function Player:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", self.x-3, self.y-3, 106,106)
    self.currentAnimation:draw(self.x, self.y, self.scale)
end
