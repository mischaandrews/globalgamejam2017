require "Animation"

Octopus = {
    x,
    y,
    scaleX,
    scaleY,
    animations,
    currentAnimations,
    physics,
    spriteLayerNames
}

function Octopus:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local octopusRadius = 30

function Octopus:load(world, x, y, characterSprite)

    if characterSprite == nil then
       print ">>> Error! Octopus:load(characterSprite) was null <<<"
       love.event.quit()
       os.exit()
    end

    self.x = x
    self.y = y
    self.scaleX = 0.45
    self.scaleY = 0.45

    self.spriteLayerNames = {"body", "bottomlegs", "rightarm", "leftarm", "face"}
    
    self.animations = Animation.loadAnimations(characterSprite, {"idle", "grab"}, self.spriteLayerNames)
    self.currentAnimations = self.animations["idle"]

    self.physics = {}
    --remember, the shape (the rectangle we create next) anchors to the body from its center
    self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic") 

end

function Octopus:spawn(physics, player, map)
    local npc2_spawnX = 450
    local npc2_spawnY = 450
    local npc2 = Octopus:new()
    npc2:load(physics, npc2_spawnX, npc2_spawnY, "octopus")
    return npc2
end

function Octopus:update(dt)
  -- self.currentAnimations:update(dt, self.spriteLayerNames)
    for i=1, #self.spriteLayerNames do
        self.currentAnimations[self.spriteLayerNames[i]]:update(dt, self.spriteLayerNames)
    end
end

function Octopus:draw()

    love.graphics.setColor(255, 255, 255)

    for i=1, #self.spriteLayerNames do
        self.currentAnimations[self.spriteLayerNames[i]]:draw(self.x, self.y, self.scaleX, self.scaleY, self.spriteLayerNames)
    end

    -- Bounding circle
    love.graphics.circle("line", self.x, self.y, octopusRadius)

end


