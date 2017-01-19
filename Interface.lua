-- TODO:
-- in-game GUI
-- title screen
-- pause screen
-- game over screen


Interface = {
    
}

function Interface:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end





----------------------------------------------------- LOAD
function Interface:load()
    
---------------
end -- End load






----------------------------------------------------- UPDATE
function Interface:update(dt)
    
    
-----------------
end -- End update





----------------------------------------------------- DRAW

function Interface:draw()
    
    if testing == true then
        love.graphics.print(gameState)
        love.graphics.setColor(255, 255, 255)
    end
    
    
    if gameState == "playing" then
        
        
    elseif gameState == "paused" then
        
        
    elseif gameState == "title" then
        
    
    elseif gameState == "gameover" then
        
    
    end
    
---------------
end -- End draw
