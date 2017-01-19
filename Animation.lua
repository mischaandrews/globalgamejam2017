Animation = {
    characterSprite,
    animationName,
    scale,
    width,
    height,
    animationSpeed,
    numLayers,
    layers
}

function Animation:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Animation:load(characterSprite, animationName)

    if characterSprite == "pink" then

        -- Sprite order:
        -- legs (behind), body, face, legs (in front)

        self.scale = 0.6
        self.width = 256
        self.height = 256
        self.animationSpeed = 0.2
        self.numLayers = 3
        self.layers = {}

        -- Idle
        if animationName == "idle" then
            self.layers = createAnimationLayers("pink", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", {1, 1, 3})
        end
        
        -- Walk
        if animationName == "walk" then
            self.layers = createAnimationLayers("pink", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", {4, 1, 3})
        end
        
    elseif characterSprite == "blue" then

        self.scale = 0.6
        self.width = 256
        self.height = 256
        self.animationSpeed = 0.2
        self.numLayers = 3
        self.layers = {}

        -- Idle
        if animationName == "idle" then
            self.layers = createAnimationLayers("blue", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", {1, 1, 3})
        end
            
        -- Walk
        if animationName == "walk" then
            self.layers = createAnimationLayers("blue", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "loop", {4, 1, 3})
        end
            
    elseif characterSprite == "green" then
        
        self.scale = 0.6
        self.width = 256
        self.height = 256
        self.animationSpeed = 0.1
        self.numLayers = 4
        self.layers = {}

        -- Idle
        if animationName == "idle" then
            self.layers = createAnimationLayers("green", "idle", self.width, self.height, self.animationSpeed, self.numLayers, "bounce", {1, 1, 5, 5})
        end
            
        -- Walk
        if animationName == "walk" then
            self.layers = createAnimationLayers("green", "walk", self.width, self.height, self.animationSpeed, self.numLayers, "loop", {9, 1, 5, 5})
        end

    end
end

function Animation:update(dt)
    ---- Update animation
    --for i=1, #(self.currentAnimation) do
        --self.currentAnimation[i]:update(dt)
    --end

end
