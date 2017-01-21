require "Animation"

Player = {
    x,
    y,
    vx,
    vy,
    playerPhys,
    scale,
    animations,
    currentAnimation,
    movementSpeed,
    healthPercent,
    boostPercent
}

function Player:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local playerRadius = 20

function Player:load(world, x, y, characterSprite)

    if characterSprite == nil then
       print ">>> Error! Player:load(characterSprite) was null <<<"
       love.event.quit()
       os.exit()
    end

    self.x = x
    self.y = y
    self.scale = 0.35
    self.movementSpeed = 6
    self.healthPercent = 100
    self.boostPercent = 100

    self.playerPhys = loadPhysics(world)

    self.animations = Animation.loadAnimations(characterSprite, {"idle", "move"})
    self.currentAnimation = self.animations["move"]

end

function loadPhysics(world)
    local playerPhys = {}
    playerPhys.body = love.physics.newBody(world, x, y, "dynamic") 
    playerPhys.shape = love.physics.newCircleShape(playerRadius)
    playerPhys.fixture = love.physics.newFixture(playerPhys.body, playerPhys.shape, 1) 
    playerPhys.fixture:setRestitution(0.9)
    return playerPhys
end

function Player:update(dt)

    local forceX = 0
    local forceY = 0

    --Calculate gravity (or whatever)
    local playerGravX, playerGravY = self:getPlayerGravity()
    forceX = forceX + playerGravX
    forceY = forceY + playerGravY

    --Add player keyboard force
    local leftRight, upDown = self:getKeyboardVector()
    forceX = forceX + leftRight * 300
    forceY = forceY + upDown * 300 

    --Limit max force - calculate drag perhaps?


    --Pass the force to the physics engine
    self.playerPhys.body:applyForce(forceX, forceY)

    ---- Update animation
    self.currentAnimation:update(dt)

    self.x, self.y = self.playerPhys.body:getPosition()

end

function Player:getPlayerGravity()
    --Here we can apply sinking or floating in water, etc.
    return 0, 10
end

function Player:getKeyboardVector()
    local leftRight = 0
    local upDown = 0

    if keysDown({"left","a"}) then
        leftRight = leftRight - 1
    end
    if keysDown({"right","d"}) then
        leftRight = leftRight + 1
    end
    if keysDown({"up","w"}) then
        upDown = upDown - 1
    end
    if keysDown({"down","s"}) then
        upDown = upDown + 1
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

function Player:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", self.x-3, self.y-3, 106,106)
    self.currentAnimation:draw(self.x, self.y, self.scale)
end
