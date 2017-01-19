Animation = {
    characterSprite,
    animationName,
    scale,
    width,
    height,
    animationSpeed,
    numLayers,
    layers
}

function Animation:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Animation:load(characterSprite, animationName)

<<<<<<< HEAD
    if characterSprite == "pink" then

        -- Sprite order:
        -- legs (behind), body, face, legs (in front)

        self.scale = 0.6
        self.width = 256
        self.height = 256
        self.animationSpeed = 0.2
        self.numLayers = 3
        self.layers = {}

        -- Idle
        if animationName == "idle" then
            self.layers = createAnimationLayers("pink", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", {1, 1, 3})
        end
        
        -- Walk
        if animationName == "walk" then
            self.layers = createAnimationLayers("pink", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", {4, 1, 3})
        end
        
    elseif characterSprite == "blue" then

        self.scale = 0.6
        self.width = 256
        self.height = 256
        self.animationSpeed = 0.2
        self.numLayers = 3
        self.layers = {}

        -- Idle
        if animationName == "idle" then
            self.layers = createAnimationLayers("blue", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", {1, 1, 3})
        end
            
        -- Walk
        if animationName == "walk" then
            self.layers = createAnimationLayers("blue", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", {4, 1, 3})
        end
            
    elseif characterSprite == "green" then
        
        self.scale = 0.6
        self.width = 256
        self.height = 256
        self.animationSpeed = 0.1
        self.numLayers = 4
        self.layers = {}

        -- Idle
        if animationName == "idle" then
            self.layers = createAnimationLayers("green", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "bounce", {1, 1, 5, 5})
        end
            
        -- Walk
        if animationName == "walk" then
            self.layers = createAnimationLayers("green", "walk", self.width, self.height, self.animationSpeed, self.numLayers, "loop", {9, 1, 5, 5})
        end
=======
    if characterSprite == nil then
       print ">>> Error! Animation:load(characterSprite) was null <<<"
       love.event.quit()
       os.exit()
    end

    if characterSprite == "pink" then
        self:loadPinkSprite()
    elseif characterSprite == "blue" then
        self:loadBlueSprite()
    elseif characterSprite == "green" then
        self:loadGreenSprite()
    else
        print ("Couldn't load animation: "..characterSprite)
    end
end

function Animation:loadPinkSprite()
    -- Sprite order:
    -- legs (behind), body, face, legs (in front)

    self.scale = 0.6
    self.width = 256
    self.height = 256
    self.animationSpeed = 0.2
    self.numLayers = 3
    self.animations = {}

    -- Idle
    local idleFrameNums = {1, 1, 3} -- Legs, body, face
    self.animations["idle"] = createAnimations("pink", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", idleFrameNums)

    -- Walk
    local walkFrameNums = {4, 1, 3}
    self.animations["walk"] = createAnimations("pink", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", walkFrameNums)
    
    self.currentAnimation = self.animations["idle"]
end

function Animation:loadBlueSprite()
    self.scale = 0.6
    self.width = 256
    self.height = 256
    self.animationSpeed = 0.2
    self.numLayers = 3
    self.animations = {}

    -- Idle
    local idleFrameNums = {1, 1, 3} -- Legs, body, face
    self.animations["idle"] = createAnimations("blue", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", idleFrameNums)

    -- Walk
    local walkFrameNums = {4, 1, 3}
    self.animations["walk"] = createAnimations("blue", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", walkFrameNums)

    self.currentAnimation = self.animations["idle"]
end

function Animation:loadGreenSprite()
    self.scale = 0.6
    self.width = 256
    self.height = 256
    self.animationSpeed = 0.1
    self.numLayers = 4
    self.animations = {}

    -- Idle
    local idleFrameNums = {1, 1, 5, 5} -- Legs, ears, body, face
    self.animations["idle"] = createAnimations("green", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "bounce", idleFrameNums)

    -- Walk
    local walkFrameNums = {9, 1, 5, 5} -- Legs, ears, body, face
    self.animations["walk"] = createAnimations("green", "walk", self.width, self.height, self.animationSpeed, self.numLayers, "loop", walkFrameNums)
>>>>>>> 23ebdae8ce9c91d18c395744785b0bd1c8471561

    self.currentAnimation = self.animations["idle"]
end

function Animation:update(dt)
    ---- Update animation
    --for i=1, #(self.currentAnimation) do
        --self.currentAnimation[i]:update(dt)
    --end

end

function Animation:draw(x,y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", x, y, 100,100)
    --self.currentAnim:draw(self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)

    --for i=1, #(self.currentAnimation) do
    --    self.currentAnimation[i]:draw(self.x, self.y, 0, self.scale, self.scale, self.width / 2, self.height / 2)
    --end

    -- Variable reference:
    -- position (x), position (y), ?, scale (x), scale (y), offset X, offsetY
    -- TODO: check this offset. It might need to be scaled too.
end
