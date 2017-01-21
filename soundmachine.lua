-- Adapted from Organ Donor code. Thanks Paul!

soundmachine = {
    soundpaused = false
}



soundErrors = {}
soundErrors.add = function(errorMsg)
  table.insert(soundErrors, errorMsg)
end


soundbank = {
  dugong = {
    eat = {
      files = {
        "assets/sounds/dugong/lettuce2.ogg",
        "assets/sounds/dugong/lettuce1.ogg"
        },
      tag = {"squeak"},
      volume = 0.3
    },
    fart = {
      files = {
        "assets/sounds/dugong/longfart1.ogg",
        "assets/sounds/dugong/longfart2.ogg"
        },
      tag = {"fart"},
      volume = 0.3
    }
  },
  level = {
    underwater = {
      files = {"assets/sounds/level/underwater1.ogg"},
      tag = {"ambience"},
      volume =  2
      }
  },
  GUI = {

  }
}

soundmachine.playEntityAction = function(entityName, action, behaviour)

  volumeMultiplier = 1
  pitch = 1

    if behaviour == "loop" then
        TEsound.playLooping(soundbank[entityName][action].files[1],
            soundbank[entityName][action].tag,
            1000,
            soundbank[entityName][action].volume*volumeMultiplier,
            pitch)
    elseif behaviour == "single" then
        TEsound.play(soundbank[entityName][action].files[1],
            soundbank[entityName][action].tag,
            soundbank[entityName][action].volume*volumeMultiplier,
            pitch)    
    elseif behaviour == "basic" then
        TEsound.play(soundbank[entityName][action].files[1],
            soundbank[entityName][action].tag,
            soundbank[entityName][action].volume*volumeMultiplier,
            pitch)   
    end
    
--if entityName == "dugong" and action == "eat" then
    --TEsound.play(soundbank[entityName][action].files[1],
        --soundbank[entityName][action].tags,
        --soundbank[entityName][action].volume*volumeAdj,
        --pitch)        
--end
    
    --[[
    
  if action == "Collision" then
    volumeAdj = variationMed - 0.1
    pitch = variationMed
  end

  if entityName == "Level" and action == "Start" then
    TEsound.playLooping(soundbank[entityName][action].file,
      soundbank[entityName][action].tags,
      1000,
      soundbank[entityName][action].volume*volumeAdj,
      pitch)   
  -- initiate organ movement loops
  elseif entityName == "Organ" and action == "Movement" then
    TEsound.playLooping(soundbank[entityName][action].file.loop1,
      {"gameplay", "loop", "organMovement", "layer1"},
      1000,
      soundbank[entityName][action].volume*1.5,
      pitch)
    TEsound.playLooping(soundbank[entityName][action].file.loop2,
      {"gameplay", "loop", "organMovement", "layer2"},
      1000,
      soundbank[entityName][action].volume*volumeAdj,
      pitch)
    TEsound.playLooping(soundbank[entityName][action].file.loop3,
      {"gameplay", "loop", "organMovement", "layer3"},
      1000,
      soundbank[entityName][action].volume*volumeAdj,
      pitch)
    TEsound.playLooping(soundbank[entityName][action].file.loop4,
      {"gameplay", "loop", "organMovement", "layer4"},
      1000,
      soundbank[entityName][action].volume*volumeAdj,
      pitch)
  elseif entityName == "Level" and action == "Music" then
    -- muslayer1:play()
    -- muslayer2:play()
    -- muslayer3:play()
    -- muslayer4:play()
    -- muslayer6:play()
    -- muslayer7:play()
    -- muslayer8:play()
    TEsound.playLooping(muslayer1,
      {"gameplay", "loop", "music", "muslayer1"},
      1000,
      volumeAdj*1.2,
      pitch)
    TEsound.playLooping(muslayer2,
      {"gameplay", "loop", "music", "muslayer2"},
      1000,
      0,
      pitch)
    TEsound.playLooping(muslayer3,
      {"gameplay", "loop", "music", "muslayer3"},
      1000,
      0,
      pitch)
    TEsound.playLooping(muslayer4,
      {"gameplay", "loop", "music", "muslayer4"},
      1000,
      volumeAdj,
      pitch)
    TEsound.playLooping(muslayer6,
      {"gameplay", "loop", "music", "muslayer6"},
      1000,
      0,
      pitch)
    TEsound.playLooping(muslayer7,
      {"gameplay", "loop", "music", "muslayer7"},
      1000,
      0,
      pitch)
    TEsound.playLooping(muslayer8,
      {"gameplay", "loop", "music", "muslayer8"},
      1000,
      0,
      pitch)  
  -- play one-shot sound events
  elseif soundbank[entityName] ~= nil and soundbank[entityName][action] ~= nil then
    TEsound.play(soundbank[entityName][action].file,
      soundbank[entityName][action].tags,
      soundbank[entityName][action].volume*volumeAdj,
      pitch)
  else
    soundErrors.add("Sound missing for entity '" .. entityName .. "'' or child action '" .. action .."'!")
  end
    
    --]]

end

soundmachine.update = function()
    --[[
  -- Real-time volume adjustments
  bloodVolume = math.min(1, bloodLoss + 0.3)
  hospitalVolume = 5000/hospitalDistance
  organMovementVolume = organVelocity/100 -- determine movement volume
  if movementInput == false then -- if there's no movement input, reduce volume
    organMovementVolume = math.max(0, organMovementVolume - 0.2)
  end
  organMovementPitch = organVelocity/1000 + 0.9 -- determine movement pitch
  TEsound.volume("organMovement", organMovementVolume)  -- set movement volume
    TEsound.volume("layer2", organMovementVolume * 0)
    TEsound.volume("layer3", organMovementVolume * 0)
    TEsound.volume("layer4", organMovementVolume * 0)
  TEsound.pitch("organMovement", organMovementPitch) -- set movement pitch
  TEsound.volume("music", 0.9) -- set global music volume
    TEsound.volume("muslayer2", bloodVolume)
    TEsound.volume("muslayer3", 0)
    TEsound.volume("muslayer6", 0)
    TEsound.volume("muslayer7", 0)
    TEsound.volume("muslayer8", 0)   
  if numOrgans > 1 then
    TEsound.volume("layer2", organMovementVolume * 1)
    TEsound.volume("muslayer6", 1)
  end
  if numOrgans > 2 then
    TEsound.volume("layer3", organMovementVolume * 1)
    TEsound.volume("muslayer3", 1)
  end
  if numOrgans > 3 then
    TEsound.volume("layer4", organMovementVolume * 1)
    TEsound.volume("muslayer8", 1)
  end
  if numOrgans > 4 then
    TEsound.volume("layer4", organMovementVolume * 1)
    TEsound.volume("muslayer7", 1)
  end
    --]]
end

soundmachine.stop = function (tag)
  TEsound.stop(tag);
end

soundmachine.pause = function(tag)
  TEsound.pause(tag);
end

soundmachine.resume = function(tag)
  TEsound.resume(tag);
end

soundmachine.toggle = function(tag)
    if soundmachine.soundpaused == true then
        soundmachine.soundpaused = false
        soundmachine.resume()
    else
        soundmachine.soundpaused = true
        soundmachine.pause()
    end
    -- TODO: fix pausing of sound
end

--[[
carSoundBank = {
  {"sound/car-engine-loop1.ogg"},
  {"sound/car-engine-loop2.ogg"}
}

carsound = {}
carCount = 0
carsound.new = function ()

  local self = {}

  self.tag = "car"..carCount
  carCount = carCount + 1

  self.carSound = carSoundBank[ math.random(1,2) ]

  self.start = function ()
    TEsound.playLooping(self.carSound, self.tag)
    TEsound.volume(self.tag, 0)
  end

  self.update = function ( dist )
    carVolume = (150 / (dist))*1.25

    carVolume = math.min( 1.0, carVolume )
    carVolume = math.max( 0.0, carVolume )

    TEsound.volume(self.tag, carVolume)
  end

  self.stop = function ()
    TEsound.stop(self.tag, false)
    -- self.carSource:stop()
  end

  return self

end

--]]