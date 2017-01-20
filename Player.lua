require "Animation"

Player = {
    x,
    y,
    scale,
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

    if characterSprite == nil then
       print ">>> Error! Player:load(characterSprite) was null <<<"
       love.event.quit()
       os.exit()
    end

    self.x = x
    self.y = y
    self.scale = 0.6

    self.animations = Animation.loadAnimations(characterSprite, {"idle", "walk"})
    self.currentAnimation = self.animations["walk"]

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
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", self.x-3, self.y-3, 106,106)
    self.currentAnimation:draw(self.x, self.y, self.scale)
end
