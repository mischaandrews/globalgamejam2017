Animation = {
    spriteName,
    animationName,
    width,
    height,
    animationSpeed,
    numLayers,
    spriteLayers
}

function Animation:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Animation.loadAnimations(spriteName, animationNames, spriteLayerNames)
    
    local animations = {}
    for i=1,#animationNames do
        animations[animationNames[i]] = {}
        for j=1,#spriteLayerNames do
            animations[animationNames[i]][spriteLayerNames[j]] = Animation:new()
            animations[animationNames[i]][spriteLayerNames[j]]:load(spriteName,     animationNames[i], spriteLayerNames)
        end
    end
    
    return animations
end

function Animation:load(spriteName, animationName, spriteLayerNames)

    if spriteName == nil then
       print ">>> Error! Animation:load(spriteName) was null <<<"
       love.event.quit()
       os.exit()
    end
    
    
    self.spriteLayers = {}
    
    if spriteName == "dugong" then
        self:loadDugongSprite(animationName, spriteLayerNames)
    elseif spriteName == "octopus" then
        self:loadOctopusSprite(animationName, spriteLayerNames)
    elseif spriteName == "lettuce" then
        self:loadLettuceSprite(animationName, spriteLayerNames)
    else
        print ("Couldn't load animation: " .. spriteName)
    end
end

function Animation:loadDugongSprite(animationName, spriteLayerNames)

    self.width = 384
    self.height = 384
    self.animationSpeed = 0.1
    self.numLayers = 5
    self.spriteLayers = {}
    self.numSpriteVariations = 1
    
    local animationModes = {}
    local frameNums = {}
    
    if animationName == "idle" then
        animationModes = {"bounce", "bounce", "bounce", "bounce", "bounce"}
        animationSpeedMultipliers = {1, 1, 0.2, 0.2, 1}
        frameNums = {1, 1, 7, 5, 1} 
        
    elseif animationName == "move" then
        animationModes = {"bounce", "bounce", "bounce", "bounce", "bounce"}
        animationSpeedMultipliers = {1, 1, 1, 1.4, 1}
        frameNums = {1, 1, 10, 11, 1}
        
    elseif animationName == "eat" then
        animationModes = {"once", "once", "once", "once", "once"}
        animationSpeedMultipliers = {1, 1, 1, 1, 1}
        frameNums = {1, 1, 1, 1, 9}
        
    elseif animationName == "boost" then
        animationModes = {"bounce", "bounce", "bounce", "bounce", "bounce"}
        animationSpeedMultipliers = {1, 1, 3, 1, 1}
        frameNums = {1, 1, 10, 1, 1}
    else
        print ("Couldn't load animation: " .. animationName)
    end
    
    for i=1, #spriteLayerNames do 
         self.spriteLayers[spriteLayerNames[i]] = createAnimationLayer("dugong", animationName, self.width, self.height, self.animationSpeed * (1/animationSpeedMultipliers[i]), i, animationModes[i], frameNums[i], math.random(self.numSpriteVariations))
    end
    
    return self.spriteLayers
    
end


function Animation:loadOctopusSprite(animationName, spriteLayerNames)

    self.width = 384
    self.height = 384
    self.animationSpeed = 0.2
    self.numLayers = 5
    self.spriteLayers = {}
    self.numSpriteVariations = 1
    
    if animationName == "idle" then
        animationModes = {"bounce", "bounce", "bounce", "bounce", "bounce"}
        animationSpeedMultipliers = {1, 1, 1, 1, 1}
        frameNums = {1, 1, 1, 1, 1}   
    elseif animationName == "grab" then
        animationModes = {"bounce", "bounce", "bounce", "bounce", "bounce"}
        animationSpeedMultipliers = {1, 1, 1, 1, 1}
        frameNums = {1, 1, 1, 1, 1}
    else
        print ("Couldn't load animation: " .. animationName)
    end
    
    for i=1, #spriteLayerNames do 
        self.spriteLayers[spriteLayerNames[i]] = createAnimationLayer("octopus", animationName, self.width, self.height, self.animationSpeed, i, animationModes[i], frameNums[i], math.random(self.numSpriteVariations))
    end
        
    return self.spriteLayers
    
end





function Animation:loadLettuceSprite(animationName, spriteLayerNames)

    self.width = 64
    self.height = 64
    self.animationSpeed = 0.2
    self.numLayers = 1
    self.spriteLayers = {}
    self.numSpriteVariations = 2

    
    if animationName == "float" then
        animationModes = {"bounce"}
        animationSpeedMultipliers = {1}
        frameNums = {1}   
    else
        print ("Couldn't load animation: " .. animationName)
    end
    
    
    for i=1, #spriteLayerNames do 
        self.spriteLayers[spriteLayerNames[i]] = createAnimationLayer("lettuce", animationName, self.width, self.height, self.animationSpeed, i, animationModes[i], frameNums[i], math.random(self.numSpriteVariations))
    end
    

    
end


function Animation:reset(layerScope)
    for i=1,#layerScope do
        self.spriteLayers[layerScope[i]]:reset()
    end
end


function Animation:update(dt, layersToUpdate)
    for i=1,#layersToUpdate do
        self.spriteLayers[layersToUpdate[i]]:update(dt)
    end
end

function Animation:draw(x,y,scaleX,scaleY, layersToUpdate)
    love.graphics.setColor(255, 255, 255)

    for i=1,#layersToUpdate do
        self.spriteLayers[layersToUpdate[i]]:draw(x, y, 0, scaleX, scaleY, self.width / 2, self.height / 2)
    end

    -- Variable reference:
    -- position (x), position (y), ?, scale (x), scale (y), offset X, offsetY
    -- TODO: check this offset. It might need to be scaled too.
end


function createAnimationLayer(assetName, animationName, width, height, animationSpeed, layerNum, animationMode, frameNums, spriteVariation)

    local sprite = love.graphics.newImage("assets/sprites/" .. assetName .. "/" .. assetName .. spriteVariation .. "/" .. animationName .. "/" .. layerNum .. ".png")   
    local layer = newAnimation(sprite, width, height, animationSpeed, frameNums)
    layer:setMode(animationMode)

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


