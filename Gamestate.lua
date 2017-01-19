----------------------------------------------------- LIBARIES
require "AnAL"
require "Background"
require "Character"
require "Camera"


Gamestate = {
    paused,
    camera,
    background,
    physics,
    player
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

    ---- Initial state
    gameState = "playing"
        
    self.background = Background:new()

    ---- Variables
    intWindowX = 1000
    intWindowY = 800
    
    ---- Load Physics
    self.physics = love.physics.newWorld(0, 0, true)

    ---- Create characters
    player_spawnX = 150
    player_spawnY = 200
    local player = character.new(physics, player_spawnX, player_spawnY, "pink", "playable")
    self.player = player

    npc1_spawnX = 350
    npc1_spawnY = 250
    npc1 = character.new(physics, npc1_spawnX, npc1_spawnY, "blue", "npc")
    
    npc2_spawnX = 400
    npc2_spawnY = 400
    npc2 = character.new(physics, npc2_spawnX, npc2_spawnY, "pink", "npc")

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
        if gameState == "playing" and key == "escape" then
            self.paused = not self.paused
        end
    end

    ------------ Animations ------------
    
    if gameState == "playing" and not self.paused then

        self.physics:update(dt) --this puts the world into motion

        self.background:update(dt)

        ---- Update camera
        playerX, playerY = self.player.x, self.player.y
        --camera.x = playerX - (intWindowX/2)
        --camera.y = playerY - (intWindowY/2)
        -- TODO: reintroduce camera

        -- Update characters
        self.player:update(dt)
        npc1.updateNPC(dt)
        npc2.updateNPC(dt)
        
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
    if gameState == "playing" then
        self.player:draw()  
        npc1.draw()  
        npc2.draw()
    end
    
    ---- Unset camera
    self.camera:unset()

---------------
end -- End draw
