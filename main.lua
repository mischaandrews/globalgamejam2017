require "Gamestate"

local gamestate = Gamestate:new()

function love.load()
    gamestate:load()
end

function love.update(dt)
    gamestate:update(dt)
end

function love.draw()
    gamestate:draw()
end
