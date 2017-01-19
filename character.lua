createAnimations = function(assetName, animationName, width, height, animationSpeed, numLayers, spriteFrameNums)
    
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
        animations[i]:setMode("loop")
    end
    
    return animations
end


character = {}

character.new = function(world, posX, posY, characterSprite)

local self = {}

    self.characterSprite = characterSprite

    if characterSprite == "pink" then
        
        self.scale = 0.6
        self.width = 256
        self.height = 256
        self.animationSpeed = 0.2
        self.numLayers = 3
        self.animations = {}
        
        -- Idle
        idleFrameNums = {1, 1, 3} -- Legs, body, face
        self.animations["idle"] = createAnimations("pink", "idle", self.width, self.height, self.animationSpeed, self.numLayers, idleFrameNums)
        
        -- Wiggle
        wiggleFrameNums = {4, 1, 3}
        self.animations["wiggle"] = createAnimations("pink", "idle", self.width, self.height, self.animationSpeed, self.numLayers, wiggleFrameNums)
        
        self.currentAnimation = self.animations["idle"]
    
        
    elseif characterSprite == "blue" then
        
        self.scale = 0.6
        self.width = 256
        self.height = 256
        self.animationSpeed = 0.2
        self.numLayers = 3
        self.animations = {}
        
        -- Idle
        idleFrameNums = {1, 1, 3} -- Legs, body, face
        self.animations["idle"] = createAnimations("blue", "idle", self.width, self.height, self.animationSpeed, self.numLayers, idleFrameNums)
        
        -- Wiggle
        wiggleFrameNums = {4, 1, 3}
        self.animations["wiggle"] = createAnimations("blue", "idle", self.width, self.height, self.animationSpeed, self.numLayers, wiggleFrameNums)
        
        self.currentAnimation = self.animations["idle"]
                
    end
  	
    ----------------------------------------------------- LOAD CHARACTER
    self.x = posX
    self.y = posY

    self.physics = {}
    self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic") --remember, the shape (the rectangle we create next) anchors to the body from its center
    
    ----------------------------------------------------- UPDATE CHARACTER
    self.update = function(dt)

        
        
    end -- End update


    ----------------------------------------------------- UPDATE NPC

    self.updateNPC = function(dt)
    
        ---- Update animation
        
        for i=1, #(self.currentAnimation) do
            self.currentAnimation[i]:update(dt)
	    end
    
    end
    
    ----------------------------------------------------- UPDATE PLAYER
    
    self.updatePlayer = function(dt)   --returns bool of a movement key being down

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
            self.currentAnimation = self.animations["wiggle"]

        ---- Keyboard LEFT
        elseif love.keyboard.isDown("left") then
            self.x = self.x - intPlayerSpeed
            self.currentAnimation = self.animations["wiggle"]

        ---- Keyboard UP
        elseif love.keyboard.isDown("up") then
            self.y = self.y - intPlayerSpeed
            self.currentAnimation = self.animations["wiggle"]

        ---- Keyboard DOWN
        elseif love.keyboard.isDown("down") then 
            self.y = self.y + intPlayerSpeed
            self.currentAnimation = self.animations["wiggle"]

        -- TODO: combined states (up/right, down/left, etc)

        -- NO KEYBOARD
        else
           movementKeyDown = false
           self.currentAnimation = self.animations["idle"]
        end

    --return movementKeyDown
    

    end -- End update player

    ----------------------------------------------------- DRAW CHARACTER
    self.draw = function()

        love.graphics.setColor(255, 255, 255)
        --self.currentAnim:draw(self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
        
        for i=1, #(self.currentAnimation) do
            self.currentAnimation[i]:draw(self.x, self.y, 0, self.scale, self.scale, self.width / 2, self.height / 2)
	    end
        
        -- Variable reference:
        -- position (x), position (y), ?, scale (x), scale (y), offset X, offsetY
        -- TODO: check this offset. It might need to be scaled too.
        
    end -- End draw

    
    ----------------------------------------------------- HELPERS
    
    self.getPosition = function()
        return self.x, self.y
    end

    self.getVelocity = function()
        return self.physics.body:getLinearVelocity()
    end

    self.getTotalVelocity = function ()
        local vx, vy = self.physics.body:getLinearVelocity()
        return math.sqrt(vx*vx + vy*vy)
    end

    self.applyForce = function( fx, fy )
        self.physics.body:applyForce(fx, fy)
    end

    self.setMass = function(mass)
        self.physics.body:setMass(mass)
    end

    self.getPhysics = function ()
        return self.physics
    end

    self.characterSprite = function ()
        if self.characterSprite == nil then
            return "unknown"
        else
            return self.characterSprite
        end
    end

    
-----------------------------------------------------
    
    return self
    
end


