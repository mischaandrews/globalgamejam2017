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
    
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(gameState)

    
---------------
end -- End draw