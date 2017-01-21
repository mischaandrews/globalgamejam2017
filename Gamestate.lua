----------------------------------------------------- LIBARIES
require "AnAL"
require "Background"
require "Character"
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
    pickups
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

    ---- Load Physics
    local physics = love.physics.newWorld(0, 0, true)
    self.physics = physics

    local map = Map:new()
    map:load(physics)
    self.map = map

    intWindowX = 1000
    intWindowY = 550
    love.window.setMode( intWindowX, intWindowY )

    ---- Create characters
    local player_spawnX = 400
    local player_spawnY = 750
    local player = Player:new()
    player:load(physics, player_spawnX, player_spawnY, "dugong")
    self.player = player

    self.npcs = loadNpcs(physics)

    self.pickups = loadPickups(physics)

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
    npc3:load(physics, npc3_spawnX, npc3_spawnY, "eel")
    
    ---- Create pickups
    -- TODO: do this better! lots of lettuce!
    --self.pickups = {}


    return {npc1, npc2, npc3}

end

function loadPickups(physics)

    local pickup1_spawnX = 400
    local pickup1_spawnY = 350
    local pickup1 = Pickup:new()
    pickup1:load(physics, pickup1_spawnX, pickup1_spawnY, "lettuce")

    local pickup2_spawnX = 250
    local pickup2_spawnY = 100
    local pickup2 = Pickup:new()
    pickup2:load(physics, pickup2_spawnX, pickup2_spawnY, "lettuce")

    local pickup3_spawnX = 410
    local pickup3_spawnY = 460
    local pickup3 = Pickup:new()
    pickup3:load(physics, pickup3_spawnX, pickup3_spawnY, "lettuce")

    return {pickup1, pickup2, pickup3}

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

    ---- Set camera
    self.camera:set()

    self.background:draw()

    self.map:draw()

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
