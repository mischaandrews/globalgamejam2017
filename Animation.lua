Animation = {
    characterSprite,
    animationName,
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

function Animation.loadAnimations(characterSprite, animsToLoad)
    local animations = {}
    for i=1,#animsToLoad do
        animations[animsToLoad[i]] = Animation:new()
        animations[animsToLoad[i]]:load(characterSprite, animsToLoad[i])
    end
    return animations
end

function Animation:load(characterSprite, animationName)


    if characterSprite == nil then
       print ">>> Error! Animation:load(characterSprite) was null <<<"
       love.event.quit()
       os.exit()
    end

    if characterSprite == "dugong" then
        self:loadDugongSprite(animationName)
    elseif characterSprite == "octopus" then
        self:loadOctopusSprite(animationName)
    --elseif characterSprite == "green" then
        --self:loadGreenSprite(animationName)
    else
        print ("Couldn't load animation: " .. characterSprite)
    end
end

function Animation:loadDugongSprite(animationName)

    self.width = 384
    self.height = 384
    self.animationSpeed = 0.2
    self.numLayers = 5
    self.layers = {}

    -- Idle
    if animationName == "idle" then
        self.layers = createAnimationLayers("dugong", "idle", self.width, self.height, self.animationSpeed, self.numLayers, {"bounce", "bounce", "bounce", "bounce", "bounce"}, {1, 1, 1, 1, 1})
    -- Move
    elseif animationName == "move" then
        self.layers = createAnimationLayers("dugong", "move", self.width, self.height, self.animationSpeed, self.numLayers, {"bounce", "bounce", "bounce", "bounce", "bounce"}, {1, 1, 2, 1, 1})
    else
        print ("Couldn't load animation: " .. animationName)
    end
    
end


function Animation:loadOctopusSprite(animationName)

    self.width = 384
    self.height = 384
    self.animationSpeed = 0.2
    self.numLayers = 5
    self.layers = {}

    -- Idle
    if animationName == "idle" then
        self.layers = createAnimationLayers("octopus", "idle", self.width, self.height, self.animationSpeed, self.numLayers, {"bounce", "bounce", "bounce", "bounce", "bounce"}, {1, 1, 1, 1, 1})
    -- Move
    elseif animationName == "grab" then
        self.layers = createAnimationLayers("octopus", "grab", self.width, self.height, self.animationSpeed, self.numLayers, {"bounce", "bounce", "bounce", "bounce", "bounce"}, {1, 1, 1, 1, 1})
    else
        print ("Couldn't load animation: " .. animationName)
    end
    
end



function Animation:update(dt)
    for i=1,self.numLayers do
        self.layers[i]:update(dt)
    end
end

function Animation:draw(x,y,scale)
    love.graphics.setColor(255, 255, 255)

    for i=1,#self.layers do
        self.layers[i]:draw(x, y, 0, scale, scale, self.width / 2, self.height / 2)
    end

    --for i=1, #(self.currentAnimation) do
    --    self.currentAnimation[i]:draw(self.x, self.y, 0, self.scale, self.scale, self.width / 2, self.height / 2)
    --end

    -- Variable reference:
    -- position (x), position (y), ?, scale (x), scale (y), offset X, offsetY
    -- TODO: check this offset. It might need to be scaled too.
end

function createAnimationLayers(assetName, animationName, width, height, animationSpeed, numLayers, animationModes, spriteFrameNums)

    local sprites = {}
    for i=1, numLayers do
        sprites[i] = love.graphics.newImage("assets/sprites/" .. assetName .. "/" .. animationName .. "/" .. i .. ".png")    
    end

    local layers = {}
    for i=1, numLayers do
        layers[i] = newAnimation(sprites[i], width, height, animationSpeed, spriteFrameNums[i]) 
    end

    for i=1, numLayers do
        layers[i]:setMode(animationModes[i])
    end

    return layers
end
