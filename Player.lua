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
    currentAnimation,
    movementSpeed,
    boostPercent
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
    self.originalScale = 0.4
    self.scaleX = self.originalScale
    self.scaleY = self.originalScale
    self.movementSpeed = 6
    self.boostPercent = 50
    self.facingDirection = "left" -- left or right

    self.physics = {}
    --Player:loadPhysics(world, x, y)
    self.physics.body = love.physics.newBody(world, x, y, "dynamic") 
    self.physics.shape = love.physics.newCircleShape(playerRadius)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 1)
    self.physics.fixture:setUserData({"player",self})
    self.physics.fixture:setRestitution(0.8)

    self.animations = Animation.loadAnimations(characterSprite, {"idle", "move", "eat", "boost"})
    self.currentAnimation = self.animations["idle"]

end


function Player:switchFacingDirection()
   
    if self.facingDirection == "right" then
        self.facingDirection = "left"
        self.scaleX = self.originalScale * 1
    elseif self.facingDirection == "left" then
        self.facingDirection = "right"
        self.scaleX = self.originalScale * -1
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

    local outFartSpeed = 2

    if love.keyboard.isDown("return") then

        --Check amount of charge here
        if true and map.transitionState == "none" then
            self.z = math.min(self.z + outFartSpeed * dt, 1)
        else
        end
    end
end

function Player:updateAnimation(dt)
    --Update animation
    self.currentAnimation:update(dt)
    
    if self.currentAnimation == self.animations["eat"] then
        --self.animationTimer = self.animationTimer - dt
        --if self.animationTimer <= 0 then
           --self.currentAnimation = self.animations["idle"] 
        --end
    end
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
        self.currentAnimation = self.animations["boost"]
        --soundmachine.playEntityAction("dugong", "fart", "single")
    end
    
    if movementKeyDown == true then
        self.currentAnimation = self.animations["move"]
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

function Player:resetCurrentAnimation()
    self.currentAnimation:reset()
end

function Player:draw()
    love.graphics.setColor(255, 255, 255)
    self.currentAnimation:draw(self.x, self.y, self.scaleX + self.z * 0.2, self.scaleY + self.z * 0.2)
    
    -- Bounding circle
    --love.graphics.circle("line", self.x, self.y, playerRadius)
end
