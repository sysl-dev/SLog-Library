local audio = {
  _NAME        = 'SLog Audio',
  _VERSION     = '0.1',
  _DESCRIPTION = 'Lazy Audio Controller',
  _URL         = 'https://github.com/SystemLogoff/SLog-Library',
  _LICENSE     = [[
    MIT LICENSE

    Copyright (c) 2019 Chris / Systemlogoff

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]],
  _Note = "Assumes: That you use music, sfx, vfx as folders."}

  --[[----------------------------------------------------------------------------
        Configuration
  --]]----------------------------------------------------------------------------

audio.currentmusic = {}
audio.currentmusic[1] = nil

audio.debug = false
audio.sfx = {} -- Container for sfx
audio.mus = {} -- Container for music
audio.vfx = {} -- Contaciner for Voice Acting

-- Volume of the tracks.
local globalVolume = 1
local globalVolumeSFX = 1
local globalVolumeMUS = 1
local globalVolumeVFX = 1

-- Table holding the volume of each sound.
local sfxVolume = {}
local musVolume = {}
local vfxVolume = {}

--[[----------------------------------------------------------------------------
      Importing and setup
--]]----------------------------------------------------------------------------

function audio:setUp()
  audio:importMusic(audio.debug)
  audio:loopAllMusic()
  audio:importSFX(audio.debug)
  audio:importVFX(audio.debug)
end

function audio:importMusic(printlist)
  printlist = printlist or false
  local musicnames = love.filesystem.getDirectoryItems( "music" )
  local musiclist = "Music List: \n"
  for i = 1, #musicnames do
    	local path = "music/" .. musicnames[i]
      local name = musicnames[i]
      name = name:sub(1, #name-4) -- Strip File Type
      audio.mus[name] = love.audio.newSource( path, "static" ) -- TODO: Change when 11.3 comes out.
      musVolume[name] = 1
      musiclist = musiclist .. i .. ". " .. "'" .. name .. "'\n"
  end
  if printlist then print(musiclist) end
    musicnames, musiclist = nil, nil
    print("MUSIC SET TO STATIC - CHANGE WHEN 11.3 IS RELEASED.\n")
end

function audio:importSFX(printlist)
  printlist = printlist or false
  local sfxnames = love.filesystem.getDirectoryItems( "sfx" )
  local sfxlist = "Sound List: \n"
  for i = 1, #sfxnames do
    	local path = "sfx/" .. sfxnames[i]
      local name = sfxnames[i]
      name = name:sub(1, #name-4) -- Strip File Type
      audio.sfx[name] = love.audio.newSource( path, "static" )
      sfxVolume[name] = 1
      sfxlist = sfxlist .. i .. ". " .. "'" .. name .. "'\n"
  end
  if printlist then print(sfxlist) end
  sfxnames, sfxlist = nil, nil
end

function audio:importVFX(printlist)
  printlist = printlist or false
  local sfxnames = love.filesystem.getDirectoryItems( "vfx" )
  local sfxlist = "Voice Acting List: \n"
  for i = 1, #sfxnames do
    	local path = "vfx/" .. sfxnames[i]
      local name = sfxnames[i]
      name = name:sub(1, #name-4) -- Strip File Type
      audio.vfx[name] = love.audio.newSource( path, "static" )-- TODO: Change when 11.3 comes out.
      vfxVolume[name] = 1
      sfxlist = sfxlist .. i .. ". " .. "'" .. name .. "'\n"
  end
  if printlist then print(sfxlist) end
  sfxnames, sfxlist = nil, nil
end

function audio:loopAllMusic()
  for k,v in pairs(audio.mus) do
    audio.mus[k]:setLooping(true)
  end
end

--[[----------------------------------------------------------------------------
      Global Volume Control
--]]----------------------------------------------------------------------------

function audio:setGlobalSFXVolume(value)
  if value == nil then return end
  if tonumber(value) == nil then return end
  if value > 1 then value = 1 end -- Sound can not be set to over 1.
  if value < 0.01 then value = 0 end -- Sound can not be set under 0.
  globalVolumeSFX = value
  for k,v in pairs(audio.sfx) do
    audio.sfx[k]:setVolume(sfxVolume[k] * globalVolume * globalVolumeSFX)
  end
end

function audio:setGlobalMusicVolume(value)
  if value == nil then return end
  if tonumber(value) == nil then return end
  if value > 1 then value = 1 end -- Sound can not be set to volume over 1.
  if value < 0.01 then value = 0 end -- Sound can not be set under 0.
  globalVolumeMUS = value
  for k,v in pairs(audio.mus) do
    audio.mus[k]:setVolume(musVolume[k] * globalVolume * globalVolumeMUS)
  end
end

function audio:setGlobalVFXVolume(value)
  if value == nil then return end
  if tonumber(value) == nil then return end
  if value > 1 then value = 1 end -- Sound can not be set to over 1.
  if value < 0.01 then value = 0 end -- Sound can not be set under 0.
  globalVolumeVFX = value
  for k,v in pairs(audio.sfx) do
    audio.vfx[k]:setVolume(vfxVolume[k] * globalVolume * globalVolumeVFX)
  end
end

function audio:setGlobalVolume(value)
  if value == nil then return end
  if tonumber(value) == nil then return end
  if value > 1 then value = 1 end -- Sound can not be set to over 1.
  if value < 0.01 then value = 0 end -- Sound can not be set under 0.
  globalVolume = value
  audio:setGlobalSFXVolume(globalVolumeSFX)
  audio:setGlobalMusicVolume(globalVolumeMUS)
  audio:setGlobalVFXVolume(globalVolumeVFX)
end

function audio:returnVolumeLevels()
  return globalVolume, globalVolumeSFX, globalVolumeMUS, globalVolumeVFX
end

--[[----------------------------------------------------------------------------
      Detailed Volume Control
--]]----------------------------------------------------------------------------

function audio:setSingleSFX(name, value)
  if value == nil then return end
  if tonumber(value) == nil then return end
  if value > 1 then value = 1 end -- Sound can not be set to over 1.
  if value < 0.01 then value = 0 end -- Sound can not be set under 0.
  if sfxVolume[name] == nil then print("That sound does not exist.") return end
  sfxVolume[name] = value
  audio.sfx[name]:setVolume(sfxVolume[name] * globalVolume * globalVolumeSFX)
  return sfxVolume[name]
end

function audio:setSingleMusic(name, value)
  if value == nil then return end
  if tonumber(value) == nil then return end
  if value > 1 then value = 1 end -- Sound can not be set to over 1.
  if value < 0.01 then value = 0 end -- Sound can not be set under 0.
  if musVolume[name] == nil then print("That song does not exist.") return end
  musVolume[name] = value
  audio.mus[name]:setVolume(musVolume[name] * globalVolume * globalVolumeMUS)
  return musVolume[name]
end

function audio:setSingleVFX(name, value)
  if value == nil then return end
  if tonumber(value) == nil then return end
  if value > 1 then value = 1 end -- Sound can not be set to over 1.
  if value < 0.01 then value = 0 end -- Sound can not be set under 0.
  if vfxVolume[name] == nil then print("That voice does not exist.") return end
  vfxVolume[name] = value
  audio.vfx[name]:setVolume(vfxVolume[name] * globalVolume * globalVolumeVFX)
  return vfxVolume[name]
end

--[[----------------------------------------------------------------------------
      Batch Volume Control
--]]----------------------------------------------------------------------------

function audio:setBatchSFX(names, values)
-- Note, this function has less protection than the single sets, use with care
  if #names ~= #values then print("Length of tables do not match.") return end
    for i=1, #names do
      if sfxVolume[names[i]] == nil then print("Sound not found.") return end
      if tonumber(values[i]) == nil then return end
      sfxVolume[names[i]] = values[i]
    end
    audio:setGlobalSFXVolume(globalVolumeSFX)
end

function audio:setBatchMusic(names, values)
-- Note, this function has less protection than the single sets, use with care
  if #names ~= #values then print("Length of tables do not match.") return end
    for i=1, #names do
      if musVolume[names[i]] == nil then print("Music not found.") return end
      if tonumber(values[i]) == nil then return end
      musVolume[names[i]] = values[i]
    end
    audio:setGlobalMusicVolume(globalVolumeMUS)
end

function audio:setBatchVFX(names, values)
-- Note, this function has less protection than the single sets, use with care
  if #names ~= #values then print("Length of tables do not match.") return end
    for i=1, #names do
      if vfxVolume[names[i]] == nil then print("Sound not found.") return end
      if tonumber(values[i]) == nil then return end
      vfxVolume[names[i]] = values[i]
    end
      audio:setGlobalVFXVolume(globalVolumeVFX)
end

--[[----------------------------------------------------------------------------
      Music Control
--]]----------------------------------------------------------------------------

function audio:setMusicPlay(musicName, musicLayer)
  musicLayer = musicLayer or 1
  if musicName == nil then print("No Music Set!") return end
  if audio.mus[musicName] == nil then print("Not a song!") return end
  if audio.currentmusic[musicLayer] == musicName then
    print("Music is the same, no change!") return
  else
    for key, value in pairs(audio.mus) do
      audio.mus[key]:stop()
    end
    audio.mus[musicName]:play()
    audio.currentmusic[musicLayer] = musicName
  end
end

function audio:setMusic(musicName, musicLayer)
  musicLayer = musicLayer or 1
  if musicName == nil then print("No Music Set!") return end
  if audio.mus[musicName] == nil then print("Not a song!") return end
  if audio.currentmusic[musicLayer] == musicName then
    print("Music is the same, no change!") return
  else
    audio.currentmusic[musicLayer] = musicName
  end
end

function audio:playMusic(musicLayer)
  musicLayer = musicLayer or 1
  if audio.currentmusic[musicLayer] == nil then print("Not a layer!") return end
  if audio.mus[audio.currentmusic[musicLayer]] == nil then print("Not a song!") return end
  audio.mus[audio.currentmusic[musicLayer]]:play()
end

function audio:pauseMusic(musicLayer)
  musicLayer = musicLayer or 1
  if audio.currentmusic[musicLayer] == nil then print("Not a layer!") return end
  if audio.mus[audio.currentmusic[musicLayer]] == nil then print("Not a song!") return end
  audio.mus[audio.currentmusic[musicLayer]]:pause()
end

function audio:resumeMusic(musicLayer)
  musicLayer = musicLayer or 1
  if audio.currentmusic[musicLayer] == nil then print("Not a layer!") return end
  if audio.mus[audio.currentmusic[musicLayer]] == nil then print("Not a song!") return end
  audio.mus[audio.currentmusic[musicLayer]]:play()
end

function audio:restartMusic(musicLayer)
  musicLayer = musicLayer or 1
  if audio.currentmusic[musicLayer] == nil then print("Not a layer!") return end
  if audio.mus[audio.currentmusic[musicLayer]] == nil then print("Not a song!") return end
  audio.mus[audio.currentmusic[musicLayer]]:seek(0)
  audio.mus[audio.currentmusic[musicLayer]]:play()
end

function audio:stopMusic(musicLayer)
  musicLayer = musicLayer or 1
  if audio.currentmusic[musicLayer] == nil then print("Not a layer!") return end
  if audio.mus[audio.currentmusic[musicLayer]] == nil then print("Not a song!") return end
  audio.mus[audio.currentmusic[musicLayer]]:stop()
end

function audio:stopAllMusic()
  for key, value in pairs(audio.mus) do
    audio.mus[key]:stop()
  end
end

function audio:crossMusic(layer1, layer2)
  if audio.currentmusic[layer1] == nil then print("Not a layer!") return end
  if audio.currentmusic[layer2] == nil then print("Not a layer!") return end
    audio:pauseMusic(layer1)
    audio:pauseMusic(layer2)
    audio.mus[audio.currentmusic[layer2]]:seek(audio.mus[audio.currentmusic[layer1]]:tell())
    audio:playMusic(layer2)
end

function audio:clearMusic()
  audio:stopAllMusic()
  audio.currentmusic = {}
  audio.currentmusic[1] = nil
end

--[[----------------------------------------------------------------------------
      SFX Control
--]]----------------------------------------------------------------------------

function audio:stopAllSFX()
  for key, value in pairs(audio.sfx) do
    audio.sfx[key]:stop()
  end
end

function audio:sfxPlay(SFXName)
  if SFXName == nil then print("No Sound Set!") return end
  if audio.sfx[SFXName] == nil then print("Not a Sound!") return end
  audio.sfx[SFXName]:play()
end

function audio:sfxForcePlay(SFXName)
  if SFXName == nil then print("No Sound Set!") return end
  if audio.sfx[SFXName] == nil then print("Not a Sound!") return end
  audio.sfx[SFXName]:stop()
  audio.sfx[SFXName]:play()
end

--[[----------------------------------------------------------------------------
      VFX Control
--]]----------------------------------------------------------------------------

function audio:stopAllVFX()
  for key, value in pairs(audio.vfx) do
    audio.vfx[key]:stop()
  end
end

function audio:vfxPlay(VFXName)
  if VFXName == nil then print("No Voice Set!") return end
  if audio.vfx[VFXName] == nil then print("Not a Voice Clip!") return end
  audio.vfx[VFXName]:play()
end

function audio:vfxForcePlay(VFXName)
  if VFXName == nil then print("No Voice Set!") return end
  if audio.vfx[VFXName] == nil then print("Not a Voice Clip!") return end
  audio.vfx[VFXName]:stop()
  audio.vfx[VFXName]:play()
end


return audio
