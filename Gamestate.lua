----------------------------------------------------- LIBARIES
require "AnAL"
require "Background"
require "Character"
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
    npc1,
    npc2
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
    player:load(physics, player_spawnX, player_spawnY, "pink")
    self.player = player

    local npc1_spawnX = 350
    local npc1_spawnY = 250
    local npc1 = Character:new()
    npc1:load(physics, npc1_spawnX, npc1_spawnY, "blue")
    self.npc1 = npc1

    local npc2_spawnX = 400
    local npc2_spawnY = 400
    local npc2 = Character:new()
    npc2:load(physics, npc2_spawnX, npc2_spawnY, "pink")
    self.npc2 = npc2

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
        self.npc1:update(dt)
        self.npc2:update(dt)
        
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
    self.npc1:draw()  
    self.npc2:draw()
    
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
