require "Animation"

Player = {
    x,
    y,
    animations,
    currentAnimation
}

function Player:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Player:load(world, x, y, characterSprite)
    local currentAnimation = Animation:new()
    currentAnimation:load(characterSprite)
    self.currentAnimation = currentAnimation
end

function Player:update(dt)

    ---- Update animation
    --self.currentAnimation:update(dt)

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
        --self.currentAnimation = self.animations["idle"]
    end

end

function Player:draw()

end
