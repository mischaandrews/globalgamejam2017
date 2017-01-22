-- Global Game Jam 2017 --

require "Gamestate"
require "Typography"

local gamestate = Gamestate:new()
local typography = Typography:new()

function love.load()
    gamestate:load()
    typography:load()
end

function love.update(dt)
    gamestate:update(dt)
end

function love.draw()
    gamestate:draw()
end
