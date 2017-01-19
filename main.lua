-- Global Game Jam 2017 --

require "Gamestate"
require "Interface"

local gamestate = Gamestate:new()
local interface = Interface:new()

function love.load()
    gamestate:load()
    interface:load()
end

function love.update(dt)
    gamestate:update(dt)
    interface:update(dt)
end

function love.draw()
    gamestate:draw()
    interface:draw()
end
