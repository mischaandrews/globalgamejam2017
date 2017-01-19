-- TODO:
-- in-game GUI
-- title screen
-- pause screen
-- game over screen





require "Typography"






Interface = {
    
}

function Interface:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end




----------------------------------------------------- HELPERS

-- Generic function for drawing boxes for text to sit on
drawBox = function ()
   -- TODO: this 
end

-- Generic function for drawing text
drawText = function ( fontStyle, textBoxSize, message, posX, posY, colourR, colourG, colourB ) 
    love.graphics.setColor(colourR, colourG, colourB)
    love.graphics.setFont(fonts[fontStyle])
    love.graphics.printf(message, posX, posY, textBoxSize, 'center') 
end

-- Specific functions for drawing styled boxes/text
drawDialogueBox = function ( message )
    -- TODO: draw box
    local textBoxSize = 300
    drawText("large-ui", textBoxSize, message, (intWindowX/2) - (textBoxSize), (intWindowY/2) - textBoxSize, 255, 255, 255)
end

drawLittleMessage = function ( message, posX, posY )
    drawText("small-ui", 50, message, posX, posY, 255, 255, 255)
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
    

    
            
---------------
end -- End draw
