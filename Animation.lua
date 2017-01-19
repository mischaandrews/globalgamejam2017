Animation = {
    characterSprite,
    currentAnimation,
    scale,
    width,
    height,
    animationSpeed,
    numLayers,
    animations
}

function Animation:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Animation:load(characterSprite)

    if characterSprite == "pink" then

        -- Sprite order:
        -- legs (behind), body, face, legs (in front)

        self.scale = 0.6
        self.width = 256
        self.height = 256
        self.animationSpeed = 0.2
        self.numLayers = 3
        self.animations = {}

        -- Idle
        local idleFrameNums = {1, 1, 3} -- Legs, body, face
        self.animations["idle"] = createAnimations("pink", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", idleFrameNums)

        -- Walk
        local walkFrameNums = {4, 1, 3}
        self.animations["walk"] = createAnimations("pink", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", walkFrameNums)
        
        self.currentAnimation = self.animations["idle"]

    elseif characterSprite == "blue" then

        self.scale = 0.6
        self.width = 256
        self.height = 256
        self.animationSpeed = 0.2
        self.numLayers = 3
        self.animations = {}

        -- Idle
        local idleFrameNums = {1, 1, 3} -- Legs, body, face
        self.animations["idle"] = createAnimations("blue", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", idleFrameNums)

        -- Walk
        local walkFrameNums = {4, 1, 3}
        self.animations["walk"] = createAnimations("blue", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", walkFrameNums)

        self.currentAnimation = self.animations["idle"]

    elseif characterSprite == "green" then
        
        self.scale = 0.6
        self.width = 256
        self.height = 256
        self.animationSpeed = 0.1
        self.numLayers = 4
        self.animations = {}

        -- Idle
        local idleFrameNums = {1, 1, 5, 5} -- Legs, ears, body, face
        self.animations["idle"] = createAnimations("green", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "bounce", idleFrameNums)

        -- Walk
        local walkFrameNums = {9, 1, 5, 5} -- Legs, ears, body, face
        self.animations["walk"] = createAnimations("green", "walk", self.width, self.height, self.animationSpeed, self.numLayers, "loop", walkFrameNums)

        self.currentAnimation = self.animations["idle"]

    end
end

function Animation:update(dt)
    ---- Update animation
    for i=1, #(self.currentAnimation) do
        self.currentAnimation[i]:update(dt)
    end

    --else
        self.currentAnimation = self.animations["idle"]
    --end
end
