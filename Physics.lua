function getOceanForce(object)
    local forceX = 0
    local forceY = 0

    --Calculate gravity (or whatever)
    local objectGravX, objectGravY = getOceanGravity()
    forceX = forceX + objectGravX
    forceY = forceY + objectGravY

    --Limit max force - calculate drag perhaps?
    local dragX, dragY = getOceanDrag(object.physics.body:getLinearVelocity())
    forceX = forceX + dragX
    forceY = forceY + dragY

    return forceX, forceY
end

function getOceanGravity()
    --Here we can apply sinking or floating in water, etc.
    return 0, 100
end

function getOceanDrag(velX, velY)
    local dragCoeff = -8
    return dragCoeff * velX, dragCoeff * velY
end
