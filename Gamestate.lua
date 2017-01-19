----------------------------------------------------- LIBARIES
require "AnAL"
require "Background"
require "Character"
require "Camera"


testing = true

Gamestate = {
    paused,
    camera,
    background,
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

    self.paused = false

    self.camera = Camera:new()

    self.background = Background:new()

    ---- Variables
    intWindowX = 1000
    intWindowY = 800
    
    ---- Load Physics
    local physics = love.physics.newWorld(0, 0, true)
    self.physics = physics

    ---- Create characters
    local player_spawnX = 150
    local player_spawnY = 200
    local player = Character:new()
    player:load(physics, player_spawnX, player_spawnY, "pink", "playable")
    self.player = player

    local npc1_spawnX = 350
    local npc1_spawnY = 250
    local npc1 = Character:new()
    npc1:load(physics, npc1_spawnX, npc1_spawnY, "blue", "npc")
    self.npc1 = npc1
    
    local npc2_spawnX = 400
    local npc2_spawnY = 400
    local npc2 = Character:new()
    npc2:load(physics, npc2_spawnX, npc2_spawnY, "pink", "npc")
    self.npc2 = npc2

    ---- Initial graphics setup
    --love.graphics.setMode(intWindowX, intWindowY)
    -- TODO: set window size

---------------
end -- End load



----------------------------------------------------- UPDATE
function Gamestate:update(dt)

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

    ---- Draw characters
    self.player:draw()  
    self.npc1:draw()  
    self.npc2:draw()

    ---- Unset camera
    self.camera:unset()

---------------
end -- End draw
