Animation = {
    spriteName,
    animationName,
    width,
    height,
    animationSpeed,
    numLayers,
    spriteLayers,
    spriteLayerNames
}

function Animation:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Animation.loadAnimations(spriteName, animsToLoad)
    
    local animations = {}
    for i=1,#animsToLoad do
        animations[animsToLoad[i]] = Animation:new()
        animations[animsToLoad[i]]:load(spriteName, animsToLoad[i])
    end
    
    
    return animations
end

function Animation:load(spriteName, animationName)


    if spriteName == nil then
       print ">>> Error! Animation:load(spriteName) was null <<<"
       love.event.quit()
       os.exit()
    end
    
    
    
    self.spriteLayers = {}
    
    if spriteName == "dugong" then
        self:loadDugongSprite(animationName)
    elseif spriteName == "octopus" then
        self:loadOctopusSprite(animationName)
    elseif spriteName == "lettuce" then
        self:loadLettuceSprite(animationName)
    else
        print ("Couldn't load animation: " .. spriteName)
    end
end

function Animation:loadDugongSprite(animationName)

    self.width = 384
    self.height = 384
    self.animationSpeed = 0.1
    self.numLayers = 5
    self.spriteLayers = {}
    self.spriteLayerNames = {"backfin", "body", "rearfin", "frontfin", "face"}
    self.numSpriteVariations = 1
    
    local animationModes = {}
    local frameNums = {}
    
    if animationName == "idle" then
        animationModes = {"bounce", "bounce", "bounce", "bounce", "bounce"}
        frameNums = {1, 1, 6, 1, 1}   
    elseif animationName == "move" then
        animationModes = {"bounce", "bounce", "bounce", "bounce", "bounce"}
        frameNums = {1, 1, 10, 1, 1}
    elseif animationName == "eat" then
        animationModes = {"once", "once", "once", "once", "once"}
        frameNums = {1, 1, 1, 1, 9}
    elseif animationName == "boost" then
        animationModes = {"bounce", "bounce", "bounce", "bounce", "bounce"}
        frameNums = {1, 1, 18, 1, 1}
    else
        print ("Couldn't load animation: " .. animationName)
    end
    
    for i=1, #self.spriteLayerNames do 
        self.spriteLayers[self.spriteLayerNames[i]] = createAnimationLayer("dugong", animationName, self.width, self.height, self.animationSpeed, i, animationModes[i], frameNums[i], math.random(self.numSpriteVariations))
    end
    
    return self.spriteLayers
    
end


function Animation:loadOctopusSprite(animationName)

    self.width = 384
    self.height = 384
    self.animationSpeed = 0.2
    self.numLayers = 5
    self.spriteLayers = {}
    self.spriteLayerNames = {"body", "bottomlegs", "rightarm", "leftarm", "face"}
    self.numSpriteVariations = 2
    
    if animationName == "idle" then
        animationModes = {"bounce", "bounce", "bounce", "bounce", "bounce"}
        frameNums = {1, 1, 1, 1, 1}   
    elseif animationName == "grab" then
        animationModes = {"bounce", "bounce", "bounce", "bounce", "bounce"}
        frameNums = {1, 1, 1, 1, 1}
    else
        print ("Couldn't load animation: " .. animationName)
    end
    
    for i=1, #self.spriteLayerNames do 
        self.spriteLayers[self.spriteLayerNames[i]] = createAnimationLayer("octopus", animationName, self.width, self.height, self.animationSpeed, i, animationModes[i], frameNums[i], math.random(self.numSpriteVariations))
    end
    
    return self.spriteLayers
    
end





function Animation:loadLettuceSprite(animationName)

    self.width = 64
    self.height = 64
    self.animationSpeed = 0.2
    self.numLayers = 1
    self.spriteLayers = {}
    self.spriteLayerNames = {"body"}
    self.numSpriteVariations = 2

    
    if animationName == "float" then
        animationModes = {"bounce"}
        frameNums = {1}   
    else
        print ("Couldn't load animation: " .. animationName)
    end
    
    for i=1, #self.spriteLayerNames do 
        self.spriteLayers[self.spriteLayerNames[i]] = createAnimationLayer("lettuce", animationName, self.width, self.height, self.animationSpeed, i, animationModes[i], frameNums[i], math.random(self.numSpriteVariations))
    end
    
end


function Animation:reset()
   
    for i=1, #self.numLayerNames do
        self.spriteLayers[self.spriteLayerNames[i]]:reset()
    end
    
end


function Animation:update(dt)
    for i=1,#self.spriteLayerNames do
        self.spriteLayers[self.spriteLayerNames[i]]:update(dt)
    end
end

function Animation:draw(x,y,scaleX,scaleY)
    love.graphics.setColor(255, 255, 255)

    for i=1,#self.spriteLayerNames do
        self.spriteLayers[self.spriteLayerNames[i]]:draw(x, y, 0, scaleX, scaleY, self.width / 2, self.height / 2)
    end

    -- Variable reference:
    -- position (x), position (y), ?, scale (x), scale (y), offset X, offsetY
    -- TODO: check this offset. It might need to be scaled too.
end


function createAnimationLayer(assetName, animationName, width, height, animationSpeed, layerNum, animationMode, frameNums, spriteVariation)

    local sprite = love.graphics.newImage("assets/sprites/" .. assetName .. "/" .. assetName .. spriteVariation .. "/" .. animationName .. "/" .. layerNum .. ".png")   
    local layer = newAnimation(sprite, width, height, animationSpeed, frameNums)
    layer.setMode(animationMode)

    return layer

end


--[[
function createAnimationLayers(assetName, animationName, width, height, animationSpeed, numLayers, animationModes, spriteFrameNums, spriteVariation)

    local sprites = {}
    for i=1, numLayers do
        sprites[i] = love.graphics.newImage("assets/sprites/" .. assetName .. "/" .. assetName .. spriteVariation .. "/" .. animationName .. "/" .. i .. ".png")    
    end
    local layers = {}
    for i=1, numLayers do
        layers[i] = newAnimation(sprites[i], width, height, animationSpeed, spriteFrameNums[i]) 
    end

    for i=1, numLayers do
        layers[i]:setMode(animationModes[i])
    end

    return layers

]]--


