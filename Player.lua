require "Animation"

Player = {
    x,
    y,
    scale,
    animations,
    currentAnimation,
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

    ---- Update animation
    self.currentAnimation:update(dt)

    ---- Keyboard RIGHT 
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.x = self.x + self.movementSpeed
        self.currentAnimation = self.animations["move"]

    ---- Keyboard LEFT
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.x = self.x - self.movementSpeed
        self.currentAnimation = self.animations["move"]

    ---- Keyboard UP
    elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        self.y = self.y - self.movementSpeed
        self.currentAnimation = self.animations["move"]

    ---- Keyboard DOWN
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then 
        self.y = self.y + self.movementSpeed
        self.currentAnimation = self.animations["move"]

    -- TODO: combined states (up/right, down/left, etc)

    -- NO KEYBOARD
    else
        movementKeyDown = false
        self.currentAnimation = self.animations["idle"]
    end

end

function Player:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", self.x-3, self.y-3, 106,106)
    self.currentAnimation:draw(self.x, self.y, self.scale)
end
