----------------------------------------------------- LIBARIES
require "AnAL"
require "Background"
require "Character"
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

local cellWidth = 100
local cellHeight = 100

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

    local map = Map:new()
    map:load(physics, cellWidth, cellHeight)
    self.map = map

    intWindowX = 1200
    intWindowY = 700
    love.window.setMode( intWindowX, intWindowY )

    ---- Create characters
    local player_spawnX = 400
    local player_spawnY = 750
    local player = Player:new()
    player:load(physics, player_spawnX, player_spawnY, "dugong")
    self.player = player

    self.npcs = loadNpcs(physics)


    ---- Start music
    soundmachine.playEntityAction("level", "underwater", "loop")
    self.pickups = populateLettuces(physics, map.activeGrid, cellWidth, cellHeight)

---------------
end -- End load

function loadNpcs(physics)

    local npc1_spawnX = 350
    local npc1_spawnY = 250
    local npc1 = Character:new()
    npc1:load(physics, npc1_spawnX, npc1_spawnY, "octopus")

    local npc2_spawnX = 400
    local npc2_spawnY = 400
    local npc2 = Character:new()
    npc2:load(physics, npc2_spawnX, npc2_spawnY, "octopus")

    local npc3_spawnX = 700
    local npc3_spawnY = 400
    local npc3 = Character:new()
    npc3:load(physics, npc3_spawnX, npc3_spawnY, "octopus")

    ---- Create pickups
    -- TODO: do this better! lots of lettuce!
    --self.pickups = {}

    return {npc1, npc2, npc3}

end

----------------------------------------------------- UPDATE
function Gamestate:update(dt)

    self.map:update(dt)
    
    soundmachine.update()

    ---- Keyboard listeners for UI (not characters)

    function love.keypressed(key)
        ---- Check for pause
        if key == "escape" then
            self.paused = not self.paused
            soundmachine.toggle()
        end
    end

    ------------ Animations ------------
    
    if not self.paused then

        self.physics:update(dt) --this puts the world into motion

        self.background:update(dt)

        -- Update characters
        self.player:update(dt)

        for i=1,#self.npcs do
            self.npcs[i]:update(dt)
        end

        for i=1,#self.pickups do
            self.pickups[i]:update(dt)
        end

        ---- Update camera
        self.camera:setPosition(self.player.x-(intWindowX/2), self.player.y - (intWindowY/2))

        velocities = {}

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
    self.player:draw()  

    for i=1,#self.npcs do
        self.npcs[i]:draw(dt)
    end
    
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
        player:getUserData()[2].currentAnimation = player:getUserData()[2].animations["eat"]
        player:getUserData()[2]:resetCurrentAnimation()
        
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
