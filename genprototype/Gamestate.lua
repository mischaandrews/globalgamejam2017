require "Map"

GameState = {
    map,
}

function GameState:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function GameState:load()
    local map = Map:new()
    map:load()
    self.map = map
end

function GameState:update(dt)
    self.map:update(dt)
end

function GameState:draw()
    self.map:draw()
end
