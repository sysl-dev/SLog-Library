local audio = {
  _NAME        = 'SLog Audio',
  _VERSION     = '0.1',
  _DESCRIPTION = 'Lazy Audio Controller',
  _URL         = 'https://github.com/SystemLogoff',
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
  _Note = "Assumes: audio = {mus = {}, and sfx = {}, and vsfx = {}} change if required."}

audio.currentmusic = nil
audio.debug = true
audio.sfx = {} -- Container for sfx
audio.mus = {} -- Container for music
audio.vfx = {} -- Contaciner for Voice Acting

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
      musiclist = musiclist .. i .. ". " .. "'" .. name .. "'\n"
  end
  if printlist then print(musiclist) end
    musicnames, musiclist = nil, nil
    print("HEY, CHANGE THIS TO STREAM WHEN 11.3 is out")
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

function audio:setMusic(musicName)
  if musicName == nil then print("No Music Set!") return end
  if audio.mus[musicName] == nil then print("Not a song!") return end
  if audio.currentmusic == musicName then
    print("Music is the same, no change!") return
  else
    for key, value in pairs(audio.mus) do
      audio.mus[key]:stop()
    end
    audio.mus[musicName]:play()
    audio.currentmusic = musicName
  end
end

function audio:crossMusic(musicName)
  if musicName == nil then print("No Music Set!") return end
  if audio.mus[musicName] == nil then print("Not a song!") return end
  if audio.currentmusic == musicName then
    print("Music is the same, no change!") return
  else
    for key, value in pairs(audio.mus) do
      audio.mus[key]:pause()
    end
    audio.mus[musicName]:seek(audio.mus[audio.currentmusic]:tell())
    audio.mus[musicName]:play()
    audio.currentmusic = musicName
  end
end

function audio:pauseMusic(musicName)
  if audio.currentmusic == nil then print("No Music Set!") return end
  if audio.mus[musicName] == nil then print("Not a song!") return end
  audio.mus[musicName]:pause()
end

function audio:resumeMusic(musicName)
  if audio.currentmusic == nil then print("No Music Set!") return end
  if audio.mus[musicName] == nil then print("Not a song!") return end
  audio.mus[musicName]:play()
end

function audio:restartMusic(musicName)
  if audio.currentmusic == nil then print("No Music Set!") return end
  if audio.mus[musicName] == nil then print("Not a song!") return end
  audio.mus[musicName]:seek(0)
  audio.mus[musicName]:play()
end

function audio:stopMusic(musicName)
  if audio.currentmusic == nil then print("No Music Set!") return end
  if audio.mus[musicName] == nil then print("Not a song!") return end
  audio.mus[musicName]:stop()
end

function audio:stopAllMusic()
  for key, value in pairs(audio.mus) do
    audio.mus[key]:stop()
  end
end

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
