Camera = {
    x = 0,
    y = 0,
    rotation = 0
}

function Camera:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Camera:set(scale)
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(scale, scale)
  love.graphics.translate(-self.x, -self.y)
end

function Camera:unset()
  love.graphics.pop()
end

function Camera:setPosition(x, y)
  self.x = x
  self.y = y
end

