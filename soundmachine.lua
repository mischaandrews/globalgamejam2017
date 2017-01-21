-- Adapted from Organ Donor code. Thanks Paul!

soundmachine = {}

soundErrors = {}
soundErrors.add = function(errorMsg)
  table.insert(soundErrors, errorMsg)
end


soundbank = {
  Placeholder = { -- Object
    Dial = { -- Action
      file = {"sound/placeholder/placeholderDial.ogg"},
      tags = {"placeholder", "dial"},
      volume =  1
    },
    Doctor = { -- Action
      file = {"sound/placeholder/placeholderDoctor.ogg"},
      tags = {"placeholder"},
      volume =  0.2
    },
    Random = { -- Action
      file =  {"sound/placeholder/placeholderEight.ogg", "sound/placeholder/placeholderForest.ogg", "sound/placeholder/placeholderPlease.ogg"},
      tags =  {"placeholder", "random"},
      volume =  1
    }
  },
  Dugong = {
    Movement = {
      file = {
        loop1 = "sound/movement-squish-loop1.ogg",
        loop2 = "sound/movement-squish-loop2.ogg",
        loop3 = "sound/movement-squish-loop3.ogg",
        loop4 = "sound/movement-squish-loop4.ogg"
        },
      tags = {},
      volume = 2.5
    },
    Collision = {
      file = {"sound/impact-squish-med1.ogg",
        "sound/impact-squish-med2.ogg",
        "sound/impact-squish-med3.ogg",
        "sound/impact-squish-sml1.ogg",
        "sound/impact-squish-sml2.ogg",
        "sound/impact-squish-sml3.ogg"
      },
      tags = {"gameplay", "impact", "collision"},
      volume = 1    
    },
    Slam = {
      file = {"sound/impact-squish-big1.ogg", "sound/impact-squish-big2.ogg", "sound/impact-squish-big3.ogg"},
      tags = {"gameplay", "impact", "slam"},
      volume = 0.8
    },
    Connect = {
      file = {"sound/organ-connect1.ogg", "sound/organ-connect2.ogg", "sound/organ-connect3.ogg", "sound/organ-connect4.ogg", "sound/organ-connect5.ogg"},
      tags = {"gameplay", "connect"},
      volume = 2
    },
    Saved = {
      file = {"sound/gui-collect.ogg"},
      tags = {"gameplay", "saved"},
      volume = 1}
  },
  Level = {
    Start = {
      file = {"sound/amb-city-loop1.ogg"},
      tags = {"loop", "amb"},
      volume =  0.5
      },
    Music = {
      file = {
        layer1 = {"sound/music-layer1-1.ogg", "sound/music-layer1-2.ogg"},
        layer2 = {"sound/music-layer2-1.ogg", "sound/music-layer2-2.ogg", "sound/music-layer2-3.ogg", "sound/music-layer2-4.ogg"},
        layer3 = {"sound/music-layer3-1.ogg", "sound/music-layer3-2.ogg"},
        layer4 = {"sound/music-layer4-1.ogg", "sound/music-layer4-2.ogg", "sound/music-layer4-3.ogg"},
        layer6 = {"sound/music-layer6.ogg"},
        layer7 = {"sound/music-layer7-1.ogg", "sound/music-layer7-2.ogg"},
        layer8 = {"sound/music-layer8-1.ogg", "sound/music-layer8-2.ogg"}        
        },
      tags = {},
      volume = 1
    },
    Win = {
      file = {"sound/music-win.ogg"},
      tags = {"end", "win"},
      volume =  1
    },
    Lose = {
      file = {"sound/music-lose.ogg"},
      tags = {"end", "lose"},
      volume =  1
    }
  },
  GUI = {
    Alert = {
      file = {"sound/gui-alert.ogg"},
      tags = {"gameplay", "gui", "alert"},
      volume =  0.8
    },
    Click = {
      file = {"sound/gui-click.ogg"},
      tags = {"gameplay", "gui", "connect"},
      volume =  0.6
    }
  }
}

-- WEIRDNESS STARTS
    --muslayer1 = {love.sound.newSoundData(soundbank["Level"]["Music"].file.layer1[1]),
      --love.sound.newSoundData(soundbank["Level"]["Music"].file.layer1[2])}
    --muslayer2 = {love.sound.newSoundData(soundbank["Level"]["Music"].file.layer2[1]),
      --love.sound.newSoundData(soundbank["Level"]["Music"].file.layer2[2]),
      --love.sound.newSoundData(soundbank["Level"]["Music"].file.layer2[3]),
      --love.sound.newSoundData(soundbank["Level"]["Music"].file.layer2[4])}
    --muslayer3 = {love.sound.newSoundData(soundbank["Level"]["Music"].file.layer3[1]),
      --love.sound.newSoundData(soundbank["Level"]["Music"].file.layer3[2])}
    --muslayer4 = {love.sound.newSoundData(soundbank["Level"]["Music"].file.layer4[1]),
        --love.sound.newSoundData(soundbank["Level"]["Music"].file.layer4[2]),
        --love.sound.newSoundData(soundbank["Level"]["Music"].file.layer4[3])}
    --muslayer6 = {love.sound.newSoundData(soundbank["Level"]["Music"].file.layer6[1])}
    --muslayer7 = {love.sound.newSoundData(soundbank["Level"]["Music"].file.layer7[1]),
      --love.sound.newSoundData(soundbank["Level"]["Music"].file.layer7[2])}
    --muslayer8 = {love.sound.newSoundData(soundbank["Level"]["Music"].file.layer8[1]),
      --love.sound.newSoundData(soundbank["Level"]["Music"].file.layer7[2])}
-- WEIRDNESS ENDS

soundmachine.playEntityAction = function(entityName, action)

  variationSml = math.random(95, 105)*0.01
  variationMed = math.random(90, 110)*0.01
  volumeAdj = 1
  pitch = 1

    
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