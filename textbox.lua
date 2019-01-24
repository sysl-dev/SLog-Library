local textbox = {
  _NAME        = 'SLog Textbox',
  _VERSION     = '0.1',
  _DESCRIPTION = 'Fancy Textbox System',
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
  ]]
}

-- Create image to show if image sent to {icon} is not valid.
local _noImageFound = love.image.newImageData(10,10)
for i = 0, 9 do
_noImageFound:setPixel(i, 0, 1, .2, .2, 1) _noImageFound:setPixel(0, i, .2, .2, 1, 1)
_noImageFound:setPixel(9, i, .2, 1, .2, 1) _noImageFound:setPixel(i, 9, 1, 1, .2, 1)
_noImageFound:setPixel(i, i, 1, .2, 1, 1)
end
local noImageFound = love.graphics.newImage(_noImageFound)

-- Create sound to play if sfx/music/voiceacting is not valid.
local noSoundFoundPath = 'library/slog/default.ogg' -- Update path if required
local noSoundFound = love.audio.newSource( noSoundFoundPath, "static" )

-- Font Tags, Palette Tags and Image tags assume you're storing them. Update if required.
textbox.fontTable = "font" -- What do you store your list of fonts in?
textbox.paletteTable = "Palette" -- What do you store your list of palettes in?
textbox.imgTable = "img" -- What do you store your list of images in?

-- Music/SFX/Voice Acting Control assumes you're using SLog Audio
textbox.SLog_Audio = true
-- Audio Tags will be disabled if you are not using it.
local Audio = "Audio" -- Name of loaded SLog Audio library
if _G[Audio] == nil then print("Audio Tags Disabled\n") textbox.SLog_Audio = false else
if _G[Audio]["_NAME"] ~= "SLog Audio" then print("Audio Tags Disabled\n") textbox.SLog_Audio = false end end
local Audio = _G[Audio]

-- Brute force control over tags and characters.
local textflags = {} -- Flags for one off text commands
local skipflags = {} -- Flags to skip the pause when drawing a command.
local soundflags = {} -- Flags to play a sound if it's a normal character.

-- Settings and Defaults
textbox.controlCharacter = "{" -- character that controls what starts a command.
textbox.controlCharacterEnd = "}" -- character that controls what ends a command.
textbox.counter = 0 -- Timer for letter printing
textbox.timer = 0 -- General Timer
textbox.pauseTimer = 0 -- Timer for text pauses.
textbox.currentCharacter = 0 -- Table Key of Currect character we're printing.
textbox.string = {} -- Table holding split string
textbox.defaultPrintSpeed = 20 -- Reset to default.
textbox.printSpeed = textbox.defaultPrintSpeed -- How fast are we printing this?
textbox.shakeText = false -- Special text effect
textbox.dropText = false -- Special text effect
textbox.dropShadow = false -- Special text effect
textbox.defaultFont = love.graphics.getFont() -- Get the default font. / Set a default font.
textbox.defaultColor = {1,1,1,1} -- Default color for text.
textbox.defaultTextSounds = true
textbox.textSoundsOn = textbox.defaultTextSounds

local function setDefaults()
  textbox.printSpeed = textbox.defaultPrintSpeed
  textbox.shakeText = false
  textbox.dropText = false
  textbox.dropShadow = false
  love.graphics.setFont(textbox.defaultFont)
  love.graphics.setColor(textbox.defaultColor)
  textbox.textSoundsOn = textbox.defaultTextSounds
end

-- What happens when a sound is played.
local function playTextSound()
  if textbox.textSoundsOn then -- Change as required.
    noSoundFound:stop()
    noSoundFound:play()
  end
end

function textbox:draw(ix, iy)
  setDefaults()
  if #textbox.string == 0 then return end
  ix = ix or 0 iy = iy or 0 -- Set position to 0 if nothing set
  local pos = {x = ix, y = iy} -- Position to start printing text
  local cursor = {x = 0, y = 0} -- Cursor for printing characters
  local tempcursor = {x = 0, y = 0} -- Temp cursor to jump back if needed.
  local extra_padding = 0
  for i=1, textbox.currentCharacter do -- TODO: Change to [current character]
    if textbox.string[i]:sub(1,1) ~= textbox.controlCharacter then -- Check to see if it starts with a control character

      if textbox.shakeText then
        love.graphics.print(textbox.string[i], pos.x + cursor.x, pos.y + cursor.y + math.sin(textbox.timer + i)) -- If not print the character
      elseif textbox.dropText then
        love.graphics.print(textbox.string[i], pos.x + cursor.x, pos.y + cursor.y + math.tan(textbox.timer/4 + i)) -- If not print the character
      else
        if textbox.dropShadow then
          love.graphics.setColor(0,0,0,0.5)
          love.graphics.print(textbox.string[i], pos.x + cursor.x + 1, pos.y + cursor.y + 1) -- If not print the character
          love.graphics.setColor(1,1,1,1)
        end
        love.graphics.print(textbox.string[i], pos.x + cursor.x, pos.y + cursor.y) -- If not print the character
      end
      if soundflags[i] == nil and textbox.string[i]:sub(1,1) ~= " " then playTextSound() soundflags[i] = true end
      cursor.x = cursor.x + textbox:getCharacterWidth(textbox.string[i]) + extra_padding -- move the cursor to the length of the character

    else
      -- Add commands here.
      if textbox.string[i]:lower() == "{newline}" then cursor.x = 0 cursor.y = cursor.y + 16 end
      if textbox.string[i]:lower() == "{reset}" then setDefaults() end
      if textbox.string[i]:lower() == "{0xcolor}" then love.graphics.setColor(textbox.command2Hex(textbox.string[i+1])) end
      if textbox.string[i]:lower() == "{colorpal}" then love.graphics.setColor(_G[textbox.paletteTable][textbox.command2Num(textbox.string[i+1])]) end
      if textbox.string[i]:lower() == "{/color}" then love.graphics.setColor(textbox.defaultColor) end
      if textbox.string[i]:lower() == "{font}" then love.graphics.setFont(textbox.command2Font(textbox.string[i+1])) end
      if textbox.string[i]:lower() == "{/font}" then love.graphics.setFont(textbox.defaultFont) end
      if textbox.string[i]:lower() == "{shake}" then textbox.shakeText = true end
      if textbox.string[i]:lower() == "{/shake}" then textbox.shakeText = false end
      if textbox.string[i]:lower() == "{drop}" then textbox.dropText = true end
      if textbox.string[i]:lower() == "{/drop}" then textbox.dropText = false end
      if textbox.string[i]:lower() == "{shadow}" then textbox.dropShadow = true end
      if textbox.string[i]:lower() == "{/shadow}" then textbox.dropShadow = false end
      if textbox.string[i]:lower() == "{fastest}" then textbox.printSpeed = textbox.defaultPrintSpeed * 8 end
      if textbox.string[i]:lower() == "{fast}" then textbox.printSpeed = textbox.defaultPrintSpeed * 4 end
      if textbox.string[i]:lower() == "{slow}" then textbox.printSpeed = textbox.defaultPrintSpeed / 4 end
      if textbox.string[i]:lower() == "{slowest}" then textbox.printSpeed = 2 end
      if textbox.string[i]:lower() == "{instant}" then textbox.currentCharacter = #textbox.string end
      if textbox.string[i]:lower() == "{/speed}" then textbox.printSpeed = textbox.defaultPrintSpeed end
      if textbox.string[i]:lower() == "{savecursor}" then tempcursor = {x = cursor.x, y = cursor.y} end
      if textbox.string[i]:lower() == "{loadcursor}" then cursor = {x = tempcursor.x, y = tempcursor.y} end
      if textbox.string[i]:lower() == "{cursorx}" then cursor.x = textbox.command2Num(textbox.string[i+1]) end
      if textbox.string[i]:lower() == "{cursory}" then cursor.y = textbox.command2Num(textbox.string[i+1]) end
      if textbox.string[i]:lower() == "{text_pad}" then extra_padding = textbox.command2Num(textbox.string[i+1]) end
      if textbox.string[i]:lower() == "{text_bounce}" then extra_padding = math.sin(textbox.timer + i) end
      if textbox.string[i]:lower() == "{/text}" then extra_padding = 0 end
      if textbox.string[i]:lower() == "{sound_text}" then textbox.textSoundsOn = true end
      if textbox.string[i]:lower() == "{/sound_text}" then textbox.textSoundsOn = false end
      if textbox.string[i]:lower() == "{pause}" then if textflags[i] == nil then textbox.pauseTimer = textbox.command2Num(textbox.string[i+1]) textflags[i] = true end end
      if textbox.string[i]:lower() == "{icon}" then
         local aimage = textbox.command2String(textbox.string[i+1])
         if _G[textbox.imgTable][aimage] == nil then
           love.graphics.draw(noImageFound, pos.x + cursor.x, pos.y + cursor.y)
           cursor.x = cursor.x + noImageFound:getWidth()
         else
           love.graphics.draw(_G[textbox.imgTable][aimage], pos.x + cursor.x, pos.y + cursor.y)
           cursor.x = cursor.x + _G[textbox.imgTable][aimage]:getWidth()
         end
      end
      if textbox.SLog_Audio then -- These tags only work if Audio is loaded. They require it's functions.
        if textbox.string[i]:lower() == "{sfx}" then if textflags[i] == nil then Audio:sfxPlay(textbox.command2String(textbox.string[i+1])) textflags[i] = true end  end
        if textbox.string[i]:lower() == "{sfx_stop}" then if textflags[i] == nil then Audio:stopAllSFX() textflags[i] = true end  end
        if textbox.string[i]:lower() == "{vfx}" then if textflags[i] == nil then Audio:vfxPlay(textbox.command2String(textbox.string[i+1])) textflags[i] = true end end
        if textbox.string[i]:lower() == "{vfx_stop}" then if textflags[i] == nil then Audio:stopAllVFX() textflags[i] = true end  end
        if textbox.string[i]:lower() == "{mus}" then if textflags[i] == nil then Audio:setMusic(textbox.command2String(textbox.string[i+1])) textflags[i] = true end end
        if textbox.string[i]:lower() == "{mus_pause}" then if textflags[i] == nil then Audio:pauseMusic(textbox.command2String(textbox.string[i+1])) textflags[i] = true end end
        if textbox.string[i]:lower() == "{mus_resume}" then if textflags[i] == nil then Audio:resumeMusic(textbox.command2String(textbox.string[i+1])) textflags[i] = true end end
        if textbox.string[i]:lower() == "{mus_cross}" then if textflags[i] == nil then Audio:crossMusic(textbox.command2String(textbox.string[i+1])) textflags[i] = true end end
      end

      if skipflags[i] == nil then textbox:nextCharacter() skipflags[i] = true end
    end
  end
    love.graphics.setColor(1,1,1,1) -- Always reset the color after.
    love.graphics.setFont(textbox.defaultFont)
end

-- Get the width of the character passed to it.
function textbox:getCharacterWidth(character)
  return love.graphics.getFont():getWidth(character)
end

function textbox.command2Hex(istring)
  if istring == nil then return textbox.defaultColor end
  if istring:sub(1,1) ~= textbox.controlCharacter then return textbox.defaultColor end
  local c1, c2, c3, c4
  local c1 = istring:sub(2,3)
  c1 = tonumber("0x" .. c1)
  local c2 = istring:sub(4,5)
  c2 = tonumber("0x" .. c2)
  local c3 = istring:sub(6,7)
  c3 = tonumber("0x" .. c3)
  local c4 = istring:sub(8,9)
  c4 = tonumber("0x" .. c4)
  -- check to see if we have the right number of characters.
  -- check to see if those characters convert to numbers properly
  if c1 ~= nil and c2 ~= nil and c3 ~= nil then
    c1 = c1/255 c2 = c2/255 c3 = c3/255
    if c4 ~= nil then c4 = c4/255 end
    return {c1,c2,c3,c4 or 1}
  else
    return {1,1,1,1}
  end
end

function textbox.command2Font(istring)
  if istring == nil then return textbox.defaultFont end
  if istring:sub(1,1) ~= textbox.controlCharacter then return textbox.defaultFont end
  istring = istring:sub(2, #istring-1)
  return _G[textbox.fontTable][istring]
end

function textbox.command2Num(istring)
  if istring == nil then return 0 end
  if istring:sub(1,1) ~= textbox.controlCharacter then return 0 end
  istring = istring:sub(2, #istring-1)
  if tonumber(istring) == nil then return 0 end
  return  tonumber(istring)
end

function textbox.command2String(istring)
  if istring == nil then return "Bad String" end
  if istring:sub(1,1) ~= textbox.controlCharacter then return "Bad String" end
  istring = istring:sub(2, #istring-1)
  return istring
end


-- Update the current character displayed
function textbox:update(dt)
-- Control how fast characters print.
  textbox.counter = textbox.counter + textbox.printSpeed * dt
  if textbox.counter > 1 then
    textbox.counter = 0
    if textbox.pauseTimer > 0 then
      textbox.pauseTimer = textbox.pauseTimer - 60 * dt
    else
      textbox:nextCharacter()
    end
  end
-- Counter for text effects
  if textbox.timer < 999999 then
    textbox.timer = textbox.timer + 10 * dt
  else textbox.timer = 0 end
end


function textbox:nextCharacter()
  if textbox.currentCharacter < #textbox.string then
    textbox.currentCharacter = textbox.currentCharacter + 1
  end
end

function textbox:send(string, clear)  -- Preprocess the string, split and seperate commands
  string = string or "NO STRING"
  clear = clear or nil
  textbox.counter = 0
  textflags = {} -- Clear flags set for one off commands.
  skipflags = {} -- Clear flags to skip the pause for special commands
  soundflags = {} -- Clear flags that play audio.
  setDefaults()
  if clear then
    textbox:resetString()
  end
  local mixletters = false
  local mixword = ""
  for i = 1, #string do -- For each character in the string
    local c = string:sub(i,i) -- Seperate the character
    if mixletters then
      mixword = mixword .. c
      if c == textbox.controlCharacterEnd then
        mixletters = false
        textbox.string[#textbox.string+1] = mixword
        mixword = ""
      end
    else
      if c == textbox.controlCharacter then
        mixletters = true
        mixword = mixword .. textbox.controlCharacter
      elseif c == "\n" then
        textbox.string[#textbox.string+1] = textbox.controlCharacter .. "newline" .. textbox.controlCharacterEnd
      else
        textbox.string[#textbox.string+1] = c -- push it to the string table.
      end
    end
  end
end

function textbox:resetString()
  textbox.currentCharacter = 0
  textbox.string = {}
end

return textbox
