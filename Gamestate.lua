----------------------------------------------------- LIBARIES
require "AnAL"
require "Character"
require "Camera"


Gamestate = {
    camera,
    physics
}

function Gamestate:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

----------------------------------------------------- LOAD
function Gamestate:load()
    
    self.camera = Camera:new()

    ---- Initial state
    gameState = "ingame"
    paused = false
    
    ---- Variables
    intPlayerSpeed = 5
    bgColor_r = 45
    bgColor_g = 47
    bgColor_b = 56
    bgColor_a = 1
    intWindowX = 1000
    intWindowY = 800
    
    ---- Load level
    local physics = love.physics.newWorld(0, 0, true)
    physics:setCallbacks(beginContact)
    self.physics = physics
   
    ---- Create characters
    player1_spawnX = 150
    player1_spawnY = 200
    player1 = character.new(physics, player1_spawnX, player1_spawnY, "green", "playable")
    
    npc1_spawnX = 350
    npc1_spawnY = 250
    npc1 = character.new(physics, npc1_spawnX, npc1_spawnY, "blue", "npc")
    
    npc2_spawnX = 400
    npc2_spawnY = 400
    npc2 = character.new(physics, npc2_spawnX, npc2_spawnY, "pink", "npc")
    
    
    ---- Initial graphics setup
	--love.graphics.setMode(intWindowX, intWindowY)
    -- TODO: set window size
    love.graphics.setBackgroundColor(bgColor_r, bgColor_g, bgColor_b, bgColor_a)
    
    
---------------
end -- End load



----------------------------------------------------- UPDATE
function Gamestate:update(dt)

    
    ---- Keyboard listeners for UI (not characters)

    function love.keypressed(key)

        ---- Check for pause
        if gameState == "ingame" and key == "escape" then
            if paused == true then
                paused = false
            else
                paused = true
            end
        end
    end
    
    
    ------------ Animations ------------
    
    if gameState == "ingame" and paused == false then

        self.physics:update(dt) --this puts the world into motion

        ---- Update camera
        playerX, playerY = player1.getPosition()
        --camera.x = playerX - (intWindowX/2)
        --camera.y = playerY - (intWindowY/2)
        -- TODO: reintroduce camera

        -- Update characters
        player1.updatePlayer(dt)
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
    
    ---- Draw characters
    if gameState == "ingame" then
        player1.draw()  
        npc1.draw()  
        npc2.draw()
    end
    
    ---- Unset camera
    self.camera:unset()

---------------
end -- End draw
