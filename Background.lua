
Background = {
    bgColor_r = 45,
    bgColor_g = 47,
    bgColor_b = 56,
    bgColor_a = 1
}

function Background:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Background:draw()
    love.graphics.setBackgroundColor(self.bgColor_r, self.bgColor_g, self.bgColor_b, self.bgColor_a)
end
