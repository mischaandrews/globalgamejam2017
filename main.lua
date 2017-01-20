-- Global Game Jam 2017 --

require "Gamestate"
require "Typography"

local gamestate = Gamestate:new()
local interface = Interface:new()
local typography = Typography:new()

function love.load()
    love.window.setMode(1024, 768)
    gamestate:load()
    interface:load()
    typography:load()
end

function love.update(dt)
    gamestate:update(dt)
    interface:update(dt)
end

function love.draw()
    gamestate:draw()
    interface:draw()
end
