tile = {}

tile.new = function(tileType, tileX, tileY, tileRotation, tileName)
  local self = {}

  self.tileImage = tileImages[tileType]
  
  if self.tileImage == nil then
     error ("Loading tileType: " .. tileType)
  end

----------------------------------------------------- LOAD TILE
  --properties and initialisation here
  addTile(tileType, tileX, tileY, tileRotation, self)

----------------------------------------------------- DRAW TILE
  self.draw = function()
	love.graphics.setColor(255, 255, 255)

        love.graphics.draw(self.tileImage, tileX, tileY, tileRotation, 1, 1, intTileSizeX/2, intTileSizeY/2)

	if testing == true then
		-- test printing
		love.graphics.print("tile: " .. tileName, tileX, tileY+15*1)
		love.graphics.print("rotation: " .. tileRotation, tileX, tileY+15*2)
		love.graphics.print("type: " .. tileType, tileX, tileY+15*3)
	end
  end

  return self
end



----------------------------------------------------- ADD TILE
function addTile(tileType, tileX, tileY, tileRotation, self)

	tiles.add(self)
	intNumTilesAdded = intNumTilesAdded + 1
	
    -- Physics
	--if (tileType == "bend" or tileType == "grass" or tileType == "sideRoad" or tileType == "crash1" or tileType == "speedBump" or tileType == "crash2") then
		--self.body = love.physics.newBody(world, tileX, tileY, "static")
  		--self.shape = love.physics.newRectangleShape(0, 0, intTileSizeX, intTileSizeY)
  		--self.fixture = love.physics.newFixture(self.body, self.shape, 5) -- A higher density gives it more mass.
  		--self.fixture:setUserData({tileType, self})
  	--end
end
