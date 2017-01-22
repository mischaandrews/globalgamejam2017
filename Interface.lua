


require "Typography"






Interface = {
    stage,
    paused,
    titleSprite,
    titleSpriteWidth
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
function Interface:drawText ( fontStyle, textBoxSize, message, posX, posY, colourR, colourG, colourB ) 
    love.graphics.setColor(colourR, colourG, colourB)
    love.graphics.setFont(fonts[fontStyle])
    love.graphics.printf(message, posX, posY, textBoxSize, 'center') 
end

-- Specific functions for drawing styled boxes/text
function Interface:drawPauseBox ( message )
    -- TODO: draw box
    local textBoxSize = 300
    self:drawText("large-ui", textBoxSize, message, (intWindowX/2) - (textBoxSize), (intWindowY/2) - textBoxSize, 255, 255, 255)
end


--drawLittleMessage = function ( message, posX, posY )
  --  drawText("small-ui", 50, message, posX, posY, 255, 255, 255)
--end



-- Screens
function Interface:drawScreen ( screen ) 
   
    if screen == "paused" then
       self:drawPauseBox("Paused") 
    end
    
    if screen == "gameover" then
       self:drawPauseBox("Game over") -- todo: change style
    end
    
    if screen == "title" then
        love.graphics.setColor(11, 33, 37)
        love.graphics.rectangle("fill", 0, 0, intWindowX, intWindowY)
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(self.titleSprite, 100, 100)
    end
    
end



function Interface:drawBoostUI ()
   
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
    
    self.stage = ""
    self.paused = ""
    
    self.titleSprite = love.graphics.newImage("assets/ui/title-screen.png")
    self.titleSpriteWidth = 1024
    
---------------
end -- End load






----------------------------------------------------- UPDATE
function Interface:update(dt)
    
    
    
-----------------
end -- End update





----------------------------------------------------- DRAW

function Interface:draw(stage, paused)
    
    if stage == "title" then
        self:drawScreen("title")
    end
    if stage == "playing" then
        self:drawBoostUI()
    end
    if paused == true and stage == "playing" then
        self:drawScreen("paused")
    end
            
---------------
end -- End draw
