local audio = {
  _NAME        = 'SLog Audio',
  _VERSION     = '0.5',
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
}
--[[ Configuration ]]-----------------------------------------------------------

-- Folder where your audio is kept.
local path_to_audio_folder = "audio"

-- List files on startup in the console
local list_files = true

-- What folders of audio need to loop
local groups_to_loop = {"env", "music"}

-- Default local audio volume
local default_volume = 0.5

-- Default global audio volume
local default_global_volume = 1

-- Volume for all sounds
audio.global = {}  -- audio.global.[audio_folders]
audio.global.all = default_global_volume

-- This table stores the volume of audio so we can update the global settings.
audio.volume = {}

-- DJ, controls the music that is playing.
audio.dj = {}
-- Current audio tracks.
audio.dj.tracks = {}
audio.dj.forced = nil

--[[ End Configuration ]]-------------------------------------------------------

--[[ Notes ]]-------------------------------------------------------------------
-- Does all required audio functions to start using the media right away.
function audio:setUp()
audio:importAll()
audio:loopAll(groups_to_loop)

if list_files then audio:listAllFiles() end -- Enable for testing.
end

--[[ Importing and File Lists ]]------------------------------------------------
--[[ Notes ]]-------------------------------------------------------------------
-- Imports all media in audio folders.
function audio:importAll(folder_path)
  folder_path = folder_path or path_to_audio_folder
  if folder_path == nil then print("No Folder Loaded, Exiting.") return end
  local folder_items = love.filesystem.getDirectoryItems(folder_path)
  for i = 1, #folder_items do
    local name = folder_items[i]
    local path = folder_path .. "/" .. name
    if not audio[name] then audio[name] = {} end -- Create audio tables if nil
    if not audio.volume[name] then audio.volume[name] = {} end -- sound tables
    if not audio.global[name] then audio.global[name] = default_global_volume end -- Global Volumes
    audio:importFolder(name, path)
  end

end
--[[ Notes ]]-------------------------------------------------------------------
-- Imports the all files in a folder as an audio folder.
function audio:importFolder(name, path)
  local sfxnames = love.filesystem.getDirectoryItems( path )
  for i = 1, #sfxnames do
    	local path = path .. "/" .. sfxnames[i]
      local file_name = sfxnames[i]
      file_name = file_name:sub(1, #file_name-4) -- Strip File Type
      audio[name][file_name] = love.audio.newSource( path, "static" ) -- Update when 11.3 comes out with audio fixes.
      audio.volume[name][file_name] = default_volume
      audio[name][file_name]:setVolume(audio.volume[name][file_name] * audio.global[name] * audio.global.all)
  end
end
--[[ Notes ]]-------------------------------------------------------------------
-- Lists all the audio files that are imported.
function audio:listAllFiles(folder_path)
  folder_path = folder_path or path_to_audio_folder
  if folder_path == nil then print("No Folder Loaded, Exiting.") return end

  local folder_items = love.filesystem.getDirectoryItems(folder_path)

  for i = 1, #folder_items do
    print(folder_items[i]:upper() .. ":")
    local name = folder_items[i]
    for i,v in pairs(audio[name]) do
      print(i)
      print("Loop: " .. tostring(audio[name][i]:isLooping()))
      print("Volume:" .. audio.volume[name][i])
      print("Type Volume:" .. audio.global[name])
      print("Global Volume:" .. audio.global.all)
      print("Set Volume:" .. audio.global.all * audio.global[name] * audio.volume[name][i])
      print("Real Volume:" .. tostring(audio[name][i]:getVolume()))
      print("")
    end
  end
end


--[[ Loop Control ]]------------------------------------------------------------
--[[ Notes ]]-------------------------------------------------------------------
-- Sets music in folders as looping.
function audio:loopAll(table)
  for k, v in pairs(table) do
    audio:setLooping(v)
  end
end

--[[ Notes ]]-------------------------------------------------------------------
-- Sets music in folders as looping.
function audio:setLooping(name)
if not audio[name] then print("does not exist") return end
if type(audio[name]) ~= "table" then print("this is not a table") return end
  for k, v in pairs(audio[name]) do
    v:setLooping(true)
  end
end


--[[ Volume Control ]]----------------------------------------------------------
--[[ Notes ]]-------------------------------------------------------------------
-- Set the volume of a single sound.
function audio:setVolume(type, file_name, vol)
  audio.volume[type][file_name] = vol
  audio[type][file_name]:setVolume(audio.volume[type][file_name] * audio.global[type] * audio.global.all)
end

--[[ Notes ]]-------------------------------------------------------------------
-- Set the volume of a group/folder of sounds individually.
-- Not the global vol of that type.
function audio:setAllVolume(type, vol)
  for k, v in pairs(audio[type]) do
    audio.volume[type][k] = vol
    audio[type][k]:setVolume(audio.volume[type][k] * audio.global[type] * audio.global.all)
  end
end

--[[ Notes ]]-------------------------------------------------------------------
-- Set the volume of all of a type of sound.
function audio:setTypeVolume(type, vol)
  for k, v in pairs(audio[type]) do
    audio.global[type] = vol
    audio[type][k]:setVolume(audio.volume[type][k] * audio.global[type] * audio.global.all)
  end
end

--[[ Notes ]]-------------------------------------------------------------------
-- Set the volume of all sounds.
function audio:setGlobalVolume(vol, folder_path)
  folder_path = folder_path or path_to_audio_folder
  if folder_path == nil then print("No Folder Loaded, Exiting.") return end
  local folder_items = love.filesystem.getDirectoryItems(folder_path)
  for i = 1, #folder_items do
    type = folder_items[i]
    for k, v in pairs(audio[type]) do
      audio.global.all = vol
      audio[type][k]:setVolume(audio.volume[type][k] * audio.global[type] * audio.global.all)
    end
  end
end

--[[ Playing Audio ]]-----------------------------------------------------------
--[[ Notes ]]-------------------------------------------------------------------
-- Plays the audio file as a standard audio:play()
-- Has an option to search for the audio in all the types, slow
-- and not reccomended.
function audio:play(name, type)
  if type ~= nil then
    audio[type][name]:play()
    print("Playing", type, name)
  else
    folder_path = folder_path or path_to_audio_folder
    if folder_path == nil then print("No Folder Loaded, Exiting.") return end
    local folder_items = love.filesystem.getDirectoryItems(folder_path)
    for i = 1, #folder_items do
      type = folder_items[i]
      if audio[type][name] ~= nil then
        audio[type][name]:play()
        print("Playing", type, name)
        break
      end
    end
  end
end

--[[ Notes ]]-------------------------------------------------------------------
-- Forces a sound to play by stopping the previous version of the sound from
-- playing.
-- Has an option to search for the audio in all the types, slow
-- and not reccomended.
function audio:fplay(name, type)
  if type ~= nil then
    audio[type][name]:stop()
    audio[type][name]:play()
    print("Playing", type, name)
  else
    folder_path = folder_path or path_to_audio_folder
    if folder_path == nil then print("No Folder Loaded, Exiting.") return end
    local folder_items = love.filesystem.getDirectoryItems(folder_path)
    for i = 1, #folder_items do
      type = folder_items[i]
      if audio[type][name] ~= nil then
        audio[type][name]:stop()
        audio[type][name]:play()
        print("Playing", type, name)
        break
      end
    end
  end
end

--[[ Notes ]]-------------------------------------------------------------------
-- Stop all audio, or all of one type of audio from playing.
function audio:stop(type)
  if type ~= nil then
    for k, v in pairs(audio[type]) do
    audio[type][k]:stop()
    end
  else
    folder_path = folder_path or path_to_audio_folder
    if folder_path == nil then print("No Folder Loaded, Exiting.") return end
    local folder_items = love.filesystem.getDirectoryItems(folder_path)
    for i = 1, #folder_items do
      type = folder_items[i]
      for k, v in pairs(audio[type]) do
          audio[type][name]:stop()
      end
    end
  end
end

--[[ Playing Music ]]-----------------------------------------------------------
-- DJ searches the groups_to_loop table for the music.
-- really helps when you get a bunch of loud music you
-- want to reduce in volume as a batch.
--[[ Notes ]]-------------------------------------------------------------------
-- Play the music as a track, if no track number is given, assumes track 1
function audio.dj:play(name, number)
  number = number or 1
    if audio.dj.tracks[number] ~= nil then
      audio.dj.tracks[number]:stop()
    end
  for i=1, #groups_to_loop do
    if audio[groups_to_loop[i]][name] ~= nil then
      audio.dj.tracks[number] = audio[groups_to_loop[i]][name]
    end
  end
  if audio.dj.tracks[number] ~= nil then
    if audio.dj.forced ~= nil then
      audio.dj.forced:play()
    else
      audio.dj.tracks[number]:play()
    end
  else
    print(name .. "could not be found.")
  end
end

--[[ Notes ]]-------------------------------------------------------------------
function audio.dj:crossplay(name, number)
  number = number or 1
  audio.dj.tracks[number]:pause()
  local synctime = audio.dj.tracks[number]:tell()
  audio.dj.tracks[number]:stop()
    for i=1, #groups_to_loop do
      if audio[groups_to_loop[i]][name] ~= nil then
        audio.dj.tracks[number] = audio[groups_to_loop[i]][name]
      end
    end
    if audio.dj.tracks[number] ~= nil then
      audio.dj.tracks[number]:seek(synctime)
      audio.dj.tracks[number]:play()
    else
      print(name .. "could not be found.")
    end
end

--[[ Notes ]]-------------------------------------------------------------------
function audio.dj:pause(number)
  number = number or 1
  if not audio.dj:checkvalid(number) then return end
  audio.dj.tracks[number]:pause()
end

--[[ Notes ]]-------------------------------------------------------------------
function audio.dj:resume(number)
  number = number or 1
  if not audio.dj:checkvalid(number) then return end
  audio.dj.tracks[number]:play()
end

--[[ Notes ]]-------------------------------------------------------------------
function audio.dj:stop(number)
  number = number or 1
  if not audio.dj:checkvalid(number) then return end
  audio.dj.tracks[number]:stop()
end

--[[ Notes ]]-------------------------------------------------------------------
function audio.dj:restart(number)
  number = number or 1
  if not audio.dj:checkvalid(number) then return end
  audio.dj.tracks[number]:seek(0)
  audio.dj.tracks[number]:play()
end

--[[ Notes ]]-------------------------------------------------------------------
function audio.dj:clear()
  for i = 1, #audio.dj.tracks do
    audio.dj.tracks[i]:stop()
  end
  audio.dj.tracks = {}
end

--[[ Notes ]]-------------------------------------------------------------------
-- Note: You must define the track directly. audio[type][name]
function audio.dj:force(track)
  track = track or nil
  if track == nil then
     audio.dj.forced = nil
   else
     audio.dj.forced = track
   end
end

function audio.dj:checkvalid(number)
  if type(number) ~= "number" then print ("NAN") return false end
  if audio.dj.tracks[number] == nil then print ("NAT") return false end
  if type(audio.dj.tracks[number]) ~= "userdata" then print ("NUD") return false end
  return true
end

--[[ End of library ]]----------------------------------------------------------
return audio
