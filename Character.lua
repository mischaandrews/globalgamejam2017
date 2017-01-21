require "Animation"

Character = {
    x,
    y,
    scaleX,
    scaleY,
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
    self.scaleX = 0.45
    self.scaleY = 0.45

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

    -- Bounding box
    --love.graphics.rectangle("line", self.x-3, self.y-3, 106,106)
    
    self.currentAnimation:draw(self.x, self.y, self.scaleX, self.scaleY)
    
end

function Character:characterSprite()
    if self.characterSprite == nil then
        return "unknown"
    else
        return self.characterSprite
    end
end
