require "Animation"

Player = {
    x,
    y,
    animation
}

function Player:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Player:load(characterSprite)
    local animation = Animation:new()
    animation:load(characterSprite)
    self.animation = animation
end

function Player:update(dt)

    ---- Update animation
    for i=1, #(self.currentAnimation) do
        self.currentAnimation[i]:update(dt)
    end

    ---- Update character variables
    --self.x, self.y = self.physics.body:getX(), self.physics.body:getY()
    --intPlayerVelX, intPlayerVelY = self.physics.body:getLinearVelocity()

    ---- Keyboard RIGHT 
    if love.keyboard.isDown("right") then
        self.x = self.x + intPlayerSpeed
        self.currentAnimation = self.animations["wiggle"]

    ---- Keyboard LEFT
    elseif love.keyboard.isDown("left") then
        self.x = self.x - intPlayerSpeed
        self.currentAnimation = self.animations["wiggle"]

    ---- Keyboard UP
    elseif love.keyboard.isDown("up") then
        self.y = self.y - intPlayerSpeed
        self.currentAnimation = self.animations["wiggle"]

    ---- Keyboard DOWN
    elseif love.keyboard.isDown("down") then 
        self.y = self.y + intPlayerSpeed
        self.currentAnimation = self.animations["wiggle"]

    -- TODO: combined states (up/right, down/left, etc)

    -- NO KEYBOARD
    else
        movementKeyDown = false
        self.currentAnimation = self.animations["idle"]
    end

end

function Player:draw()

    love.graphics.setColor(255, 255, 255, 255)
    --self.currentAnim:draw(self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)

    for i=1, #(self.currentAnimation) do
        self.currentAnimation[i]:draw(self.x, self.y, 0, self.scale, self.scale, self.width / 2, self.height / 2)
    end

    -- Variable reference:
    -- position (x), position (y), ?, scale (x), scale (y), offset X, offsetY
    -- TODO: check this offset. It might need to be scaled too.

end
