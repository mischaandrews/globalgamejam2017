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
    


    local map = Map:new()
    map:load()
    self.map = map

    ---- Variables
    intWindowX = 1000
    intWindowY = 800

    ---- Load Physics
    local physics = love.physics.newWorld(0, 0, true)
    self.physics = physics

    ---- Create characters
    local player_spawnX = 150
    local player_spawnY = 200
    local player = Player:new()
    player:load(physics, player_spawnX, player_spawnY, "dugong")
    self.player = player

    self.npcs = {}
    
    local npc1_spawnX = 350
    local npc1_spawnY = 250
    local npc1 = Character:new()
    npc1:load(physics, npc1_spawnX, npc1_spawnY, "octopus")
    self.npcs[1] = npc1

    local npc2_spawnX = 400
    local npc2_spawnY = 400
    local npc2 = Character:new()
    npc2:load(physics, npc2_spawnX, npc2_spawnY, "octopus")
    self.npcs[2] = npc2
    
    ---- Create pickups
    -- TODO: do this better! lots of lettuce!
    self.pickups = {}
    
    local pickup1_spawnX = 400
    local pickup1_spawnY = 350
    local pickup1 = Pickup:new()
    pickup1:load(physics, pickup1_spawnX, pickup1_spawnY, "lettuce")
    self.pickups[1] = pickup1
    
    local pickup2_spawnX = 250
    local pickup2_spawnY = 100
    local pickup2 = Pickup:new()
    pickup2:load(physics, pickup2_spawnX, pickup2_spawnY, "lettuce")
    self.pickups[2] = pickup2
    
    local pickup3_spawnX = 410
    local pickup3_spawnY = 460
    local pickup3 = Pickup:new()
    pickup3:load(physics, pickup3_spawnX, pickup3_spawnY, "lettuce")
    self.pickups[3] = pickup3

    ---- Initial graphics setup
    --love.graphics.setMode(intWindowX, intWindowY)
    -- TODO: set window size

---------------
end -- End load



----------------------------------------------------- UPDATE
function Gamestate:update(dt)

    self.map:update(dt)

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

        ---- Update camera
        --playerX, playerY = self.player.x, self.player.y
        --camera.x = playerX - (intWindowX/2)
        --camera.y = playerY - (intWindowY/2)
        -- TODO: reintroduce camera

        -- Update characters
        self.player:update(dt)

        for i=1,#self.npcs do
            self.npcs[i]:update(dt)
        end
        
        for i=1,#self.pickups do
            self.pickups[i]:update(dt)
        end
        
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
           drawDialogueBox("Paused") 
        end
        
    elseif self.stage == "title" then
        
    elseif self.stage == "gameover" then
        drawDialogueBox("Game over")
    end

    ---- Unset camera
    self.camera:unset()

---------------
end -- End draw
