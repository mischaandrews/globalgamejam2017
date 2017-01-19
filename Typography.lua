Typography = {
    
}

function Typography:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end



----------------------------------------------------- LOAD
function Typography:load()
    
    -- Load fonts
    
    fonts = {}
    
    fonts["large-dialogue"] = love.graphics.newFont("assets/fonts/nunito/Nunito-ExtraBold.ttf", 24)
    fonts["regular"] = love.graphics.newFont("assets/fonts/nunito/Nunito-Regular.ttf", 14)
    fonts["large-ui"] = love.graphics.newFont("assets/fonts/nunito/Nunito-Light.ttf", 28)
    fonts["small-ui"] = love.graphics.newFont("assets/fonts/nunito/Nunito-Light.ttf", 13)
    
    -- Set default font
    love.graphics.setFont(fonts["regular"])
    
---------------
end -- End load






----------------------------------------------------- UPDATE
--function Typeface:update(dt)
    
    
-----------------
--end -- End update





----------------------------------------------------- DRAW

--function Typeface:draw()

    
    
---------------
--end -- End draw
