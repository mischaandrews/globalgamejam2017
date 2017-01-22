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
drawPauseBox = function ( message )
    -- TODO: draw box
    local textBoxSize = 300
    drawText("large-ui", textBoxSize, message, (intWindowX/2) - (textBoxSize), (intWindowY/2) - textBoxSize, 255, 255, 255)
end


--drawLittleMessage = function ( message, posX, posY )
  --  drawText("small-ui", 50, message, posX, posY, 255, 255, 255)
--end



-- Screens
drawScreen = function ( screen ) 
   
    if screen == "pause" then
       drawPauseBox("Paused") 
    end
    
    if screen == "gameover" then
       drawPauseBox("Game over") -- todo: change style
    end
    
end



drawBoostUI = function ()
   
    local width = 200
    local height = 20
    local offsetX = 20
    local offsetY = 20
    
    local posX = intWindowX - (width + offsetX)
    local posY = intWindowY - (height + offsetY)
    
    -- draw the background (black)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", posX, posY, width, height)
    
    -- draw the bar (green)
    love.graphics.setColor(81, 199, 77)
    love.graphics.rectangle("fill", posX, posY, playerBoost/100*width, height)
    
    love.graphics.setColor(255, 255, 255)
    -- draw the sprite
    --love.graphics.draw(imgHealthBar, posX, posY)
    
    
end


--[[
drawHealthUI = function ()
   
    local width = 200
    local height = 20
    local offsetX = 20
    local offsetY = 55
    
    local posX = intWindowX - (width + offsetX)
    local posY = intWindowY - (height + offsetY)
    
    playerHealth = 100 -- todo

    -- draw the background (black)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", posX, posY, width, height)
    
    -- draw the bar (pink)
    love.graphics.setColor(235, 55, 115)
    love.graphics.rectangle("fill", posX, posY, playerHealth/100*width, height)
    
    love.graphics.setColor(255, 255, 255)
    -- draw the sprite
    --love.graphics.draw(imgHealthBar, posX, posY)
    
end
]]--

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
    
    drawBoostUI()
            
---------------
end -- End draw
