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
    currentLayerAnimationNames,
    movementKeyWasJustDown,
    boostKeyWasJustDown,
    
    -- Animation timers. hacky
    eatingTimerCurrent,
    eatingTimerTotal,
    boostTimerCurrent,
    boostTimerTotal,
    
    moveRotation,
    idleRotation,
    rotation
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
    self.movementKeyWasJustDown = false
    self.boostKeyWasJustDown = false
    self.eatingTimerTotal = 20 -- how long the dugong eats
    self.eatingTimerCurrent = 0
    self.boostTimerTotal = 20 -- length of boost
    self.boostTimerCurrent = 0
    self.moveRotation = 0.09
    self.idleRotation = 0
    self.rotation = 0
    
    local initialAnimation = "idle"
    self.currentLayerAnimationNames = {initialAnimation, initialAnimation, initialAnimation, initialAnimation, initialAnimation}

    self.physics = self:loadPhysics(world, x, y)


    self.animations = Animation.loadAnimations(characterSprite, self.animationNames, self.spriteLayerNames)

    self.currentAnimations = {}
    
    self.currentAnimations["backfin"] = self.animations[initialAnimation]["backfin"]
    self.currentAnimations["body"] = self.animations[initialAnimation]["body"]
    self.currentAnimations["rearfin"] = self.animations[initialAnimation]["rearfin"]
    self.currentAnimations["frontfin"] = self.animations[initialAnimation]["frontfin"]
    self.currentAnimations["face"] = self.animations[initialAnimation]["face"]
    
    self.numLayers = #self.currentAnimations
    
end

function Player:loadPhysics(world, x, y)
    local physics = {}
    physics.body = love.physics.newBody(world, x, y, "dynamic")
    physics.shape = love.physics.newCircleShape(playerRadius)
    physics.fixture = love.physics.newFixture(physics.body, physics.shape, 1)
    physics.fixture:setUserData({"player",self})
    physics.fixture:setRestitution(0.8)
    return physics
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

function Player:update(dt, map)

    self:updateMovement()
    self:updateAnimation(dt)

    self:updateTransitions(dt, map)
    
    
    
    
        
        -- Check whether to stop boosting
        if self.currentLayerAnimationNames[i] == "boost" then
           if self.boostTimerCurrent > 0 then
                 self.boostTimerCurrent = self.boostTimerCurrent - 1 -- todo: include dt
                 if self.boostTimerCurrent == 0 then
                    self:changeAnimationLayer("face", "idle")
                 end
           end
        end
    
    

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


function Player:updateMovement()

    local forceX, forceY = getOceanForce(self)

    --Add player keyboard force
    local keyBoardForce = 1700
    local leftRight, upDown, boosted = self:getKeyboardVector()
    local boostMultiplier = 1
    if boosted and self.boostTimerCurrent > 0 then
        boostMultiplier = 50
    end
    forceX = forceX + leftRight * keyBoardForce * boostMultiplier
    forceY = forceY + upDown * keyBoardForce * boostMultiplier
    

    --Pass the force to the physics engine
    self.physics.body:applyForce(forceX, forceY)

    --Get the position back out of the physics engine
    --From last frame, but whatever
    self.x, self.y = self.physics.body:getPosition()
end

function Player:setPos(x,y)
    self.physics.body:setPosition(x,y)
    self.x = x
    self.y = y
end

function Player:getKeyboardVector()
    local leftRight = 0
    local upDown = 0
    local movementKeyDown = false
    local boostKeyDown = false
    local boosted = false

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
        boostKeyDown = true
    end    
    
    -- Just started holding a movement key
    if movementKeyDown == true and self.movementKeyWasJustDown == false then
        self.movementKeyWasJustDown = true
        self:changeAnimationLayer("rearfin", "move")
        self:changeAnimationLayer("backfin", "move")
        self:changeAnimationLayer("frontfin", "move")
        self.rotation = self.moveRotation
    
    -- Just finished holding a movement key
    elseif movementKeyDown == false and self.movementKeyWasJustDown == true then
        self.movementKeyWasJustDown = false 
        self:changeAnimationLayer("rearfin", "idle") -- does this work with spacebar?
        self:changeAnimationLayer("backfin", "idle")
        self:changeAnimationLayer("frontfin", "idle")
        self.rotation = self.idleRotation
    end
    
    -- Just started holding the boost key
    if boostKeyDown == true and self.boostKeyWasJustDown == false then
        self.boostTimerCurrent = self.boostTimerTotal  
        
        self.boostKeyWasJustDown = true
        playerBoost = playerBoost - 10
        if playerBoost < 0 then
           playerBoost = 0 
        else
            boosted = true 
            soundmachine.playEntityAction("dugong", "fart", "single")
            self:changeAnimationLayer("rearfin", "boost")
            self:changeAnimationLayer("backfin", "boost")
            self:changeAnimationLayer("frontfin", "boost")
            self:changeAnimationLayer("face", "boost")
        end
        
    
    -- Just finished holding the boost key, movement key is down
    elseif boostKeyDown == false and self.boostKeyWasJustDown == true and movementKeyDown == true then
        self.boostKeyWasJustDown = false 
        self:changeAnimationLayer("rearfin", "move")
        self:changeAnimationLayer("backfin", "move")
        self:changeAnimationLayer("frontfin", "move")
        self:changeAnimationLayer("face", "move")
        self.rotation = self.moveRotation
    
    -- Just finished holding the boost key, movement key is not down
    elseif boostKeyDown == false and self.boostKeyWasJustDown == true and movementKeyDown == false then
        self.boostKeyWasJustDown = false 
        self:changeAnimationLayer("rearfin", "idle")
        self:changeAnimationLayer("backfin", "idle")
        self:changeAnimationLayer("frontfin", "idle")
        self:changeAnimationLayer("face", "idle")
        self.rotation = self.idleRotation
    end
    
    return leftRight, upDown, boosted
end


function keysDown(keys)
   for i=1,#keys do
       if love.keyboard.isDown(keys[i]) then
           return true
       end
   end
   return false
end



function Player:resetCurrentAnimations(scope)
    
    for i=1, #self.currentLayerAnimationNames do
        for j=1, #self.spriteLayerNames do
            self.animations[self.currentLayerAnimationNames[i]][self.spriteLayerNames[j]]:reset({self.spriteLayerNames[j]})
        end
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
    self:resetCurrentAnimations(self.spriteLayerNames)
    
    if animationName == "eat" then
        self.eatingTimerCurrent = self.eatingTimerTotal
        -- the rest happens in update
    end
    
end




function Player:updateAnimation(dt)
    --Update animation
    -- self.currentAnimations["backfin"] = self.animations[initialAnimation]["backfin"]
    --self.animations["idle"]["backfin"]:update(dt, {"backfin"})
    
    for i=1, #self.currentLayerAnimationNames do
        for j=1, #self.spriteLayerNames do
            self.animations[self.currentLayerAnimationNames[i]][self.spriteLayerNames[j]]:update(dt, {self.spriteLayerNames[j]})
        end
        
        -- Check whether to stop eating
        if self.currentLayerAnimationNames[i] == "eat" then
           if self.eatingTimerCurrent > 0 then
                 self.eatingTimerCurrent = self.eatingTimerCurrent - 1 -- todo: include dt
                 if self.eatingTimerCurrent == 0 then
                    self:changeAnimationLayer("face", "idle")
                 end
           end
        end
        
        
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
    
    for i=1, #self.currentLayerAnimationNames do
        --self.currentAnimations["backfin"] = self.animations[initialAnimation]["backfin"]
    
        local rot = self.rotation
        if self.facingDirection == "left" then
           rot = -rot 
        end
        
        for i=1, #self.spriteLayerNames do
            self.currentAnimations[self.spriteLayerNames[i]]:draw(
                self.x,
                self.y,
                rot,
                self.scaleX + extraScaleX,
                self.scaleY + extraScaleY,
                {self.spriteLayerNames[i]})
        end
    end

    -- Bounding circle
    --love.graphics.circle("line", self.x, self.y, playerRadius)
end
