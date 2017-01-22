----------------------------------------------------- LIBARIES
require "AnAL"
require "Background"
require "Octopus"
require "Generation"
require "Pickup"
require "Camera"
require "Map"
require "Interface"
require "Player"
require "Tile"
require "TEsound"
require "soundmachine"


testing = true

Gamestate = {
    stage, -- Stages: title, playing, gameover
    paused,
    camera,
    background,
    map,
    physics,
    player,
    npcs,
    pickups,
    playerHealth,
    playerBoost
}

function Gamestate:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

----------------------------------------------------- LOAD
function Gamestate:load()
    
    self.stage = "playing"

    self.paused = false

    self.camera = Camera:new()

    self.background = Background:new()
    
    self.playerHealth = 100
    playerBoost = 20

    ---- Load Physics
    local physics = love.physics.newWorld(0, 0, true)

    function beginContact(a, b, coll)
        self:beginContact(a, b, coll)
    end

    function endContact(a, b, coll)
        self:endContact(a, b, coll)
    end

    function preSolve(a, b, coll)
        self:preSolve(a, b, coll)
    end

    function postSolve(a, b, coll, normalimpulse, tangentimpulse)
        self:postSolve(a, b, coll, normalimpulse, tangentimpulse)
    end

    physics:setCallbacks(beginContact, endContact, preSolve, postSolve)
    self.physics = physics

    intWindowX = 1200
    intWindowY = 700
    love.window.setMode( intWindowX, intWindowY )

    ---- Create characters
    local player_spawnX = 400
    local player_spawnY = 750
    local player = Player:new()
    player:load(physics, player_spawnX, player_spawnY, "dugong")
    self.player = player

    local map = Map:new()
    map:load(physics, player)
    self.pickups = map:populateLettuces(physics)
    self.map = map

    self.octopus = Octopus:spawn(physics, player, map)

    ---- Start music
    soundmachine.playEntityAction("level", "underwater", "loop")

---------------
end -- End load

----------------------------------------------------- UPDATE
function Gamestate:update(dt)

    ---- Keyboard listeners for UI (not characters)

    function love.keypressed(key)
        ---- Check for pause
        if key == "escape" then
            self.paused = not self.paused
            soundmachine.toggle()
        end
    end

    self.map:update(dt)

    soundmachine.update()

    ------------ Animations ------------
    
    if not self.paused then

        self.physics:update(dt)

        --Update player
        self.player:update(dt, self.map)

        -- Update characters
        self.octopus:update(dt)

        for i=1,#self.pickups do
            self.pickups[i]:update(dt)
        end

        ---- Update camera
        self.camera:setPosition(self.player.x-(intWindowX/2), self.player.y - (intWindowY/2))

    end

-----------------
end -- End update


----------------------------------------------------- DRAW

function Gamestate:draw()

    --Map handles its own camera setting (because of parallax)
    self.map:draw(self.camera, intWindowX, intWindowY)

    ---- Set camera
    self.camera:set(1)

    ---- Draw characters
    self.player:draw(self.map)  

    self.octopus:draw(dt)
    
    for i=1,#self.pickups do
        self.pickups[i]:draw(dt)
    end
    
    ---- Draw interface
    
    if self.stage == "playing" then
        
        if self.paused == true then
           drawScreen("pause") 
        end
        
    elseif self.stage == "title" then
        
    elseif self.stage == "gameover" then
        drawScreen("gameover")
    end

    ---- Unset camera
    self.camera:unset()

---------------
end -- End draw

----------------------------------------------------- COLLISIONS

-- a is the first fixture object in the collision.
-- b is the second fixture object in the collision.
-- coll is the contact object created. 

function Gamestate:beginContact(a, b, coll)
    
    if (a:getUserData()[1] == "player") then    
        self:playerCollide(a, b, coll)
    elseif (b:getUserData()[1] == "player") then
        self:playerCollide(b, a, coll)
    end
end

function Gamestate:endContact(a, b, coll)
end

function Gamestate:preSolve(a, b, coll)
end

function Gamestate:postSolve(a, b, coll, normalimpulse, tangentimpulse)
end

function Gamestate:playerCollide(player, other, coll)
    if other:getUserData()[1] == "pickup" then
        
        print "Player collided with pickup"
        
        -- Play eating sound
        soundmachine.playEntityAction("dugong", "eat", "single")
        
        -- Play eating animation
        local playerObject = player:getUserData()[2]
        playerObject:changeAnimationLayer("face", "eat")
        
        -- Increase available boost
        playerBoost = playerBoost + 5
        if playerBoost > 100 then
            playerBoost = 100
        end
        
        -- Delete the lettuce
        other:getUserData()[2]:destroy()
        
    elseif other:getUserData()[1] == "edge" then
        print "Player collided with edge" 
    end

end
