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
    playerBoost,
    interface
}

function Gamestate:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

----------------------------------------------------- LOAD
function Gamestate:load()
    
    local quickstart = false -- switch between testing and demo to show/notshow title screen
    if quickstart then
        self.stage = "playing" 
        self.paused = false
    else
        self.stage = "title" 
        self.paused = true
    end

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
    love.window.setTitle( "Lettuce Friends" )

    ---- Create characters
    local player_spawnX = 1100
    local player_spawnY = 1300
    local player = Player:new()
    player:load(physics, player_spawnX, player_spawnY, "dugong")
    self.player = player

    local map = Map:new()
    map:load(physics, player)
    self.pickups = map:populateLettuces(physics)
    self.map = map

    local octopus = Octopus:new()
    octopus:load("octopus")
    octopus:spawn(physics, player, map)
    self.octopus = octopus

    ---- Interface
    self.interface = Interface:new()
    self.interface:load()

---------------
end -- End load

function Gamestate:clearDestroyed()
    ::tryagain::
    for i=1,#self.pickups do
        if self.pickups[i].destroyed then
            table.remove(self.pickups, i)
            goto tryagain
        end
    end
end

function Gamestate:checkAndTriggerTransition()
    if self.octopus.transitionState == "done" then
        self.map:regenActiveGrid(self.physics)
        self.octopus:spawn(self.physics, self.player, self.map)
    end
end

----------------------------------------------------- UPDATE
function Gamestate:update(dt)

    self:clearDestroyed()

    self:checkAndTriggerTransition()

    ---- Keyboard listeners for UI (not characters)

    function love.keypressed(key)
        ---- Check for pause
        if self.stage == "title" and key == "space" then
            ---- START THE GAME (from title screen)
            self.stage = "playing"
            self.paused = false
            ---- Start music
            soundmachine.playEntityAction("level", "underwater", "loop")
        elseif key == "escape" then
            self.paused = not self.paused
            soundmachine.toggle()
        end
    end


    self.map:update(dt)

    soundmachine.update()

    ------------ Animations ------------
    
    if not self.paused and self.stage == "playing" then

        self.physics:update(dt)

        --Update player
        self.player:update(dt, self.map)

        -- Update characters
        self.octopus:update(dt, self.player, self.map)

        for i=1,#self.pickups do
            self.pickups[i]:update(dt)
        end

        ---- Update camera
        self.camera:setPosition(self.player.x-(intWindowX/2), self.player.y - (intWindowY/2))

    end
    
    self.interface:update(dt)

-----------------
end -- End update


----------------------------------------------------- DRAW

function Gamestate:draw()

    --Map handles its own camera setting (because of parallax)
    self.map:drawRest(self.camera, intWindowX, intWindowY)

    ---- Set camera
    self.camera:set(1)

    self.octopus:draw(dt)
    
    for i=1,#self.pickups do
        self.pickups[i]:draw(dt)
    end
    
    self.camera:unset()

    --Map handles its own camera setting (because of parallax)
    self.map:drawTop(self.camera, intWindowX, intWindowY)

    self.camera:set(1)

    ---- Draw characters
    self.player:draw(self.map)

    ---- Draw interface
    
    if self.stage == "playing" then
        
        if self.paused == true then
           
        end
        
    elseif self.stage == "title" then
        
    elseif self.stage == "gameover" then
        drawScreen("gameover")
    end


    self.camera:unset()

    self.interface:draw(self.stage, self.paused)
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
        playerBoost = playerBoost + 10
        if playerBoost > 100 then
            playerBoost = 100
        end
        
        -- Delete the lettuce
        other:getUserData()[2]:destroy()
        
    elseif other:getUserData()[1] == "edge" then
        print "Player collided with edge" 

    elseif other:getUserData()[1] == "octopus" then
        print "Player collided with octopus"

        other:getUserData()[2]:transitionToNextGrid(self.map)

    end


end
