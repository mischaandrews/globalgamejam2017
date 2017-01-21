Camera = {
    x = 0,
    y = 0,
    scaleX = 1,
    scaleY = 1,
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
  love.graphics.scale(scale / self.scaleX, scale / self.scaleY)
  love.graphics.translate(-self.x, -self.y)
end

function Camera:unset()
  love.graphics.pop()
end

function Camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function Camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function Camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function Camera:setPosition(x, y)
  self.x = x
  self.y = y
end

function Camera:getPosition()
   return self.x, self.y
end

function Camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

