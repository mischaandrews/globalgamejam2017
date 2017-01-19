Character = {
    characterSprite,
    currentAnimation,
    scale,
    width,
    height,
    animationSpeed,
    numLayers,
    animations
}

function Character:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Character:load(world, posX, posY, characterSprite)

    self.characterSprite = characterSprite

    if characterSprite == "pink" then
        
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

    elseif characterSprite == "blue" then
        
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
        
        
    elseif characterSprite == "green" then
        
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
        
        
        self.currentAnimation = self.animations["idle"]
                
    end
  	
    self.x = posX
    self.y = posY

    self.physics = {}
    --remember, the shape (the rectangle we create next) anchors to the body from its center
    self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic") 

end

function Character:updateNpc(dt)
    for i=1, #(self.currentAnimation) do
        self.currentAnimation[i]:update(dt)
    end
end

createAnimations = function(assetName, animationName, width, height, animationSpeed, numLayers, animationMode, spriteFrameNums)
    
    sprites = {}
    for i=1, numLayers do
        -- Resource path example: assets/pink/idle-0.png
        sprites[i] = love.graphics.newImage("assets/" .. assetName .. "/" .. animationName .. "-" .. i .. ".png")    
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

function Character:update(dt)
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
        self.currentAnimation = self.animations["walk"]

    ---- Keyboard LEFT
    elseif love.keyboard.isDown("left") then
        self.x = self.x - intPlayerSpeed
        self.currentAnimation = self.animations["walk"]

    ---- Keyboard UP
    elseif love.keyboard.isDown("up") then
        self.y = self.y - intPlayerSpeed
        self.currentAnimation = self.animations["walk"]

    ---- Keyboard DOWN
    elseif love.keyboard.isDown("down") then 
        self.y = self.y + intPlayerSpeed
        self.currentAnimation = self.animations["walk"]

    -- TODO: combined states (up/right, down/left, etc)

    -- NO KEYBOARD
    else
        movementKeyDown = false
        self.currentAnimation = self.animations["idle"]
    end
end

function Character:draw()
    love.graphics.setColor(255, 255, 255)
    --self.currentAnim:draw(self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)

    --for i=1, #(self.currentAnimation) do
    --    self.currentAnimation[i]:draw(self.x, self.y, 0, self.scale, self.scale, self.width / 2, self.height / 2)
    --end

    -- Variable reference:
    -- position (x), position (y), ?, scale (x), scale (y), offset X, offsetY
    -- TODO: check this offset. It might need to be scaled too.
end

function Character:getPosition()
    return self.x, self.y
end

function Character:getVelocity()
    return self.physics.body:getLinearVelocity()
end

function Character:getTotalVelocity()
    local vx, vy = self.physics.body:getLinearVelocity()
    return math.sqrt(vx*vx + vy*vy)
end

function Character:applyForce(fx,fy)
    self.physics.body:applyForce(fx, fy)
end

function Character:setMass(mass)
    self.physics.body:setMass(mass)
end

function Character:getPhysics()
    return self.physics
end

function Character:characterSprite()
    if self.characterSprite == nil then
        return "unknown"
    else
        return self.characterSprite
    end
end
