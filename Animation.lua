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


    if characterSprite == nil then
       print ">>> Error! Animation:load(characterSprite) was null <<<"
       love.event.quit()
       os.exit()
    end

    if characterSprite == "pink" then
        self:loadPinkSprite(animationName)
    elseif characterSprite == "blue" then
        self:loadBlueSprite(animationName)
    elseif characterSprite == "green" then
        self:loadGreenSprite(animationName)
    else
        print ("Couldn't load animation: " .. characterSprite)
    end
end

function Animation:loadPinkSprite(animationName)

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
    
end

function Animation:loadBlueSprite(animationName)
    self.scale = 0.6
    self.width = 256
    self.height = 256
    self.animationSpeed = 0.2
    self.numLayers = 3
    self.animations = {}

    -- Idle
    if animationName == "idle" then
        self.layers = createAnimationLayers("blue", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", {1, 1, 3})
    end

    -- Walk
    if animationName == "walk" then
        self.layers = createAnimationLayers("blue", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", {4, 1, 3})
    end

end

function Animation:loadGreenSprite(animationName)
    self.scale = 0.6
    self.width = 256
    self.height = 256
    self.animationSpeed = 0.1
    self.numLayers = 4
    self.animations = {}

    -- Idle
    if animationName == "idle" then
        self.layers = createAnimationLayers("green", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "bounce", {1, 1, 5, 5})
    end

    -- Walk
    if animationName == "walk" then
        self.layers = createAnimationLayers("green", "walk", self.width, self.height, self.animationSpeed, self.numLayers, "loop", {9, 1, 5, 5})
    end

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

function createAnimationLayers(assetName, animationName, width, height, animationSpeed, numLayers, animationMode, spriteFrameNums)

    sprites = {}
    for i=1, numLayers do
        -- Resource path example: assets/pink/idle-0.png
        sprites[i] = love.graphics.newImage("assets/sprites/" .. assetName .. "/" .. animationName .. "-" .. i .. ".png")    
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
