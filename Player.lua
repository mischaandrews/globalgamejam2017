require "Animation"
require "Physics"

Player = {
    x,
    y,
    z,
    physics,
    scaleX,
    scaleY,
    animations,
    currentAnimations,
    numLayers,
    movementSpeed,
    spriteLayerNames,
    animationNames,
    currentLayerAnimationNames
}

function Player:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local playerRadius = 40



function Player:load(world, x, y, characterSprite)

    if characterSprite == nil then
       print ">>> Error! Player:load(characterSprite) was null <<<"
       love.event.quit()
       os.exit()
    end

    self.x = x
    self.y = y
    self.z = 0
    self.scaleX = 0.4
    self.scaleY = 0.4
    self.movementSpeed = 6
    self.facingDirection = "left" -- left or right
    self.spriteLayerNames = {"backfin", "body", "rearfin", "frontfin", "face"}
    self.animationNames = {"idle", "move", "eat", "boost"}
    
    local initialAnimation = "idle"
    self.currentLayerAnimationNames = {initialAnimation, initialAnimation, initialAnimation, initialAnimation, initialAnimation}

    self.physics = {}
    --Player:loadPhysics(world, x, y)
    self.physics.body = love.physics.newBody(world, x, y, "dynamic") 
    self.physics.shape = love.physics.newCircleShape(playerRadius)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 1)
    self.physics.fixture:setUserData({"player",self})
    self.physics.fixture:setRestitution(0.8)

    self.animations = Animation.loadAnimations(characterSprite, self.animationNames, self.spriteLayerNames)

    self.currentAnimations = {}
    
    self.currentAnimations["backfin"] = self.animations[initialAnimation]["backfin"]
    self.currentAnimations["body"] = self.animations[initialAnimation]["body"]
    self.currentAnimations["rearfin"] = self.animations[initialAnimation]["rearfin"]
    self.currentAnimations["frontfin"] = self.animations[initialAnimation]["frontfin"]
    self.currentAnimations["face"] = self.animations[initialAnimation]["face"]
    
    self.numLayers = #self.currentAnimations
    
end


function Player:switchFacingDirection()
    if self.facingDirection == "right" then
        self.facingDirection = "left"
        self.scaleX = self.scaleX * -1
    elseif self.facingDirection == "left" then
        self.facingDirection = "right"
        self.scaleX = self.scaleX * -1
    end
end

function Player:getCurrentCell(cellWidth, cellHeight)
    return math.ceil ((self.x - (cellWidth / 2)) / (cellWidth)),
           math.ceil ((self.y - (cellHeight / 2)) / (cellHeight))
end

function Player:update(dt, map)

    self:updateMovement()
    self:updateAnimation(dt)

    self:updateTransitions(dt, map)

end

function Player:updateTransitions(dt, map)

    local prepFartSpeed = 2
    local execFartSpeed = 10

    if love.keyboard.isDown("return")
            and true --Check amount of charge here
            and (map.transitionState == "none" or map.transitionState == "fartPrep") then

        map.transitionState = "fartPrep"
        self.z = math.min(self.z + prepFartSpeed * dt, 1)
    else
        self.z = math.max(self.z - execFartSpeed * dt, 0)
    end
end

function Player:updateAnimation(dt)
    --Update animation
    self.currentAnimations:update(dt)
    
end

function Player:updateMovement()

    local forceX, forceY = getOceanForce(self)

    --Add player keyboard force
    local keyBoardForce = 1700
    local leftRight, upDown = self:getKeyboardVector()
    forceX = forceX + leftRight * keyBoardForce
    forceY = forceY + upDown * keyBoardForce 

    --Pass the force to the physics engine
    self.physics.body:applyForce(forceX, forceY)

    --Get the position back out of the physics engine
    --From last frame, but whatever
    self.x, self.y = self.physics.body:getPosition()
end



function Player:getKeyboardVector()
    local leftRight = 0
    local upDown = 0
    local movementKeyDown = false

    if keysDown({"left","a"}) then
        leftRight = leftRight - 1
        movementKeyDown = true
        if self.facingDirection == "right" then
            self:switchFacingDirection()
        end
        
    end
    if keysDown({"right","d"}) then
        leftRight = leftRight + 1
        movementKeyDown = true
        if self.facingDirection == "left" then
            self:switchFacingDirection()
        end
    end
    if keysDown({"up","w"}) then
        upDown = upDown - 1
        movementKeyDown = true
    end
    if keysDown({"down","s"}) then
        upDown = upDown + 1
        movementKeyDown = true
    end
    if keysDown({"space"}) then
        self:changeAnimationLayer("rearfin", "boost")
        soundmachine.playEntityAction("dugong", "fart", "single")
        playerBoost = playerBoost - 2
    end
    
    if movementKeyDown == true then
        self:changeAnimationLayer("rearfin", "move")
    end
    
    return leftRight, upDown
end


function keysDown(keys)
   for i=1,#keys do
       if love.keyboard.isDown(keys[i]) then
           return true
       end
   end
   return false
end

function Player:resetCurrentAnimations()
    
    
    --local bVal = self.spriteLayerNames["face"]
    local anim = self.animations["eat"]
    
    -- TODO: fix this Mish!
                
    if anim == nil then
        os.exit()
    end
    
    local scope = ""
    if scope == "all" then
        
        for i=1, #self.animationNames do
            for j=1, #self.spriteLayerNames do
                local iVal = self.animationNames[i]
                local jVal = self.spriteLayerNames[j]
                local anim = self.animations[iVal][jVal]
                anim:reset()
            end
        end
        
        --self.animations:reset()
    end
end


function Player:changeAnimationLayer(layerName, animationName)
    
    for i=1,#self.spriteLayerNames do
       if self.spriteLayerNames[i] == layerName then
           layerNumber = i 
        end
    end
    
    self.currentAnimations[layerName] = self.animations[animationName][layerName]
    self.currentLayerAnimationNames[layerNumber] = animationName
    self:resetCurrentAnimations("all")
    
end




function Player:updateAnimation(dt)
    --Update animation
    for i=1, #self.spriteLayerNames do
        self.animations[self.currentLayerAnimationNames[i]][self.spriteLayerNames[i]]:update(dt, self.spriteLayerNames)
    end
end

function Player:draw(map)
    love.graphics.setColor(255, 255, 255)

    local extraScaleX
    local extraScaleY = self.z * 0.1
    if self.facingDirection == "left" then
        extraScaleX = self.z * 0.1
    else
        extraScaleX = - self.z * 0.1
    end
    
    for i=1, #self.spriteLayerNames do
        self.animations[self.currentLayerAnimationNames[i]][self.spriteLayerNames[i]]:draw(
            self.x,
            self.y,
            self.scaleX + extraScaleX,
            self.scaleY + extraScaleY,
            self.spriteLayerNames)

    end

    -- Bounding circle
    love.graphics.circle("line", self.x, self.y, playerRadius)
end
