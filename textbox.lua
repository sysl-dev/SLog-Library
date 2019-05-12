local textbox = {
  _NAME        = 'SLog Textbox',
  _VERSION     = '1.0',
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
-- TODO: Text-Pitch change command.
-- Create image to show if image sent to {icon} is not valid.
local _noImageFound = love.image.newImageData(10,10)
for i = 0, 9 do
_noImageFound:setPixel(i, 0, 1, .2, .2, 1) _noImageFound:setPixel(0, i, .2, .2, 1, 1)
_noImageFound:setPixel(9, i, .2, 1, .2, 1) _noImageFound:setPixel(i, 9, 1, 1, .2, 1)
_noImageFound:setPixel(i, i, 1, .2, 1, 1)
end
local noImageFound = love.graphics.newImage(_noImageFound)
-- Text Sounds
local text_sounds = {

}
-- Create sound to play if sfx/music/voiceacting is not valid.
if text_sounds[1] == nil then text_sounds[1] = love.audio.newSource( 'audio/sound/default.ogg', "static" ) end

-- Font Tags, Palette Tags and Image tags assume you're storing them. Update if required.
textbox.fontTable = "font" -- What do you store your list of fonts in?
textbox.paletteTable = "Palette" -- What do you store your list of palettes in?
textbox.imgTable = "img" -- What do you store your list of images in?

-- Music/SFX/Voice Acting Control assumes you're using SLog Audio
textbox.SLog_Audio = true
if package.loaded["library.slog.audio"] == nil then -- Change to your slog audio loaded path.
  textbox.SLog_Audio = false -- It will be disabled if you are not using it.
end

-- Brute force control over tags and characters.
local textflags = {} -- Flags for one off text commands
local skipflags = {} -- Flags to skip the pause when drawing a command.
local soundflags = {} -- Flags to play a sound if it's a normal character.

-- Settings and Defaults
-- Characters that are used to control what commands are, remember to update your command words if changed.
  textbox.controlCharacter = "{"
  textbox.controlCharacterEnd = "}"
-- Timers
  textbox.counter = 0 -- Timer for letter printing
  textbox.timer = 0 -- Animation Timer
  textbox.pauseTimer = 0 -- Timer for text pauses.
  textbox.blinkTimer = 0 -- Timer for blinking text.
  local blinkstate = false -- Controls blinkstate
  textbox.anitimer = 0
  local advance_animation = false
-- Controls the details of the passed string. Reset with textbox:resetString()
  textbox.currentCharacter = 0 -- Table Key of Currect character we're printing.
  textbox.string = {} -- Table holding split string
-- Defaults, Font, Color, Text Speed, Shadow and Outline Color, and if text sounds are on. Resets each new textbox.
  textbox.defaultFont = love.graphics.getFont() -- Get the default font. / Set a default font.
  textbox.defaultPrintSpeed = 0.08 -- Print Speed per character in seconds.
  textbox.defaultColor = {1,1,1,1} -- Default color for text.
  textbox.defaultDropShadowColor = {0,0,0,0.5} -- Default color for Drop Shadow.
  textbox.defaultOutlineColor = {0,0,0,1} -- Default color for Outline.
-- Sound Control
  textbox.defaultTextSounds = true -- Are text sounds on?
  textbox.defaultVoice = 1
  textbox.defaultSoundCharacter = 1
  local soundCounter = 0


local function setDefaults()
  textbox.printSpeed = textbox.defaultPrintSpeed
  textbox.textSoundsOn = textbox.defaultTextSounds
  textbox.skipWaiting = false
  textbox.shakeText = false
  textbox.shakeText2 = false
  textbox.shakeText3 = false
  textbox.dropText = false
  textbox.dropShadow = false
  textbox.outline = false
  textbox.thickOutline = false
  textbox.blink = false
  textbox.mirror = false
  textbox.italics = false
  textbox.swing = false
  textbox.spin = false
  textbox.rot90 = false
  textbox.rot180 = false
  textbox.scale = 1
  textbox.soundCharacter = textbox.defaultSoundCharacter
  textbox.currentColor = textbox.defaultColor
  textbox.currentVoice = textbox.defaultVoice
  textbox.dropShadowColor = textbox.defaultDropShadowColor
  textbox.outlineColor = textbox.defaultOutlineColor
  love.graphics.setFont(textbox.defaultFont)
  love.graphics.setColor(textbox.defaultColor)
  textbox.lineHeight = love.graphics.getFont():getHeight("W") + 4
end setDefaults()

-- What happens when a sound is played.
local function playTextSound()
  if textbox.textSoundsOn then -- Change as required.
    if soundCounter % textbox.soundCharacter == 0 then
    text_sounds[textbox.currentVoice]:stop()
    text_sounds[textbox.currentVoice]:play()
    end
    soundCounter = soundCounter + 1
  end
end

local function applyText(t, x, y, r, sx, sy, ox, oy, kx, ky)
  r = r or 0 sx = sx or textbox.scale sy = sy or textbox.scale
  ox = ox or 0 oy = oy or 0 kx = kx or 0 ky = ky or 0
  if textbox.italics then kx = -0.2 end
  if textbox.swing then
    r = math.sin(textbox.timer*2)/2
    ox = love.graphics.getFont():getWidth(t)/2 oy = love.graphics.getFont():getHeight(t)/2
    x = x + love.graphics.getFont():getWidth(t)/2 y = y + love.graphics.getFont():getHeight(t)/2
  end
  if textbox.rot90 then
    r = math.pi/2
    ox = love.graphics.getFont():getWidth(t)/2 oy = love.graphics.getFont():getHeight(t)/2
    x = x + love.graphics.getFont():getWidth(t)/2 y = y + love.graphics.getFont():getHeight(t)/2
  end
  if textbox.rot180 then
    r = math.pi
    ox = love.graphics.getFont():getWidth(t)/2 oy = love.graphics.getFont():getHeight(t)/2
    x = x + love.graphics.getFont():getWidth(t)/2 y = y + love.graphics.getFont():getHeight(t)/2
  end
  if textbox.spin then
    r = textbox.timer
    ox = love.graphics.getFont():getWidth(t)/2 oy = love.graphics.getFont():getHeight(t)/2
    x = x + love.graphics.getFont():getWidth(t)/2 y = y + love.graphics.getFont():getHeight(t)/2
  end
  if textbox.mirror then
    sx = textbox.scale * -1 x = x + love.graphics.getFont():getWidth(t)
  end
  if textbox.outline or textbox.thickOutline then
    love.graphics.setColor(textbox.outlineColor)
    love.graphics.print(t, x+1, y+0, r, sx, sy, ox, oy, kx, ky) -- If not print the character
    love.graphics.print(t, x+0, y+1, r, sx, sy, ox, oy, kx, ky) -- If not print the character
    love.graphics.print(t, x-1, y+0, r, sx, sy, ox, oy, kx, ky) -- If not print the character
    love.graphics.print(t, x+0, y-1, r, sx, sy, ox, oy, kx, ky) -- If not print the character
    love.graphics.setColor(1,1,1,1)
  end
  if textbox.thickOutline then
    love.graphics.setColor(textbox.outlineColor)
    love.graphics.print(t, x+1, y+1, r, sx, sy, ox, oy, kx, ky) -- If not print the character
    love.graphics.print(t, x+1, y-1, r, sx, sy, ox, oy, kx, ky) -- If not print the character
    love.graphics.print(t, x-1, y+1, r, sx, sy, ox, oy, kx, ky) -- If not print the character
    love.graphics.print(t, x-1, y-1, r, sx, sy, ox, oy, kx, ky) -- If not print the character
    love.graphics.setColor(1,1,1,1)
  end
  if textbox.dropShadow then
    love.graphics.setColor(textbox.dropShadowColor)
    love.graphics.print(t, x+1, y+1, r, sx, sy, ox, oy, kx, ky) -- If not print the character
    love.graphics.setColor(1,1,1,1)
  end
  love.graphics.setColor(textbox.currentColor)
  love.graphics.print(t,x,y, r, sx, sy, ox, oy, kx, ky)
  love.graphics.setColor(1,1,1,1)
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
      if soundflags[i] == nil and not textbox.string[i]:match("%W") then playTextSound() soundflags[i] = true end --only makes noise on alphanumic characters TODO: Improve
      if textbox.shakeText then applyText(textbox.string[i], pos.x + cursor.x, pos.y + cursor.y + math.sin(textbox.timer + i)) -- If not, we print it.
      elseif textbox.shakeText2 then applyText(textbox.string[i], pos.x + cursor.x + math.cos(textbox.timer + i/4)*2, pos.y + cursor.y + math.sin(textbox.timer + i/4)*2) -- If not, we print it.
      elseif textbox.shakeText3 then
      if i % 2 == 0 then
        applyText(textbox.string[i], pos.x + cursor.x - math.cos(textbox.timer + i)*4, pos.y + cursor.y - math.sin(textbox.timer + i)*4)
       else
        applyText(textbox.string[i], pos.x + cursor.x + math.cos(textbox.timer + i)*4, pos.y + cursor.y + math.sin(textbox.timer + i)*4)
       end
      elseif textbox.dropText then applyText(textbox.string[i], pos.x + cursor.x, pos.y + cursor.y + math.tan(textbox.timer/4 + i)) -- With any effects
      elseif blinkstate and textbox.blink then -- print nothing
      else applyText(textbox.string[i], pos.x + cursor.x, pos.y + cursor.y) end -- or by itself
      cursor.x = cursor.x + (textbox:getCharacterWidth(textbox.string[i]) * textbox.scale) + extra_padding -- move the cursor to the length of the character
    else
      -- COMMANDS
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
      if textbox.string[i]:lower() == "{icon_ani}" then
         local aimage = textbox.command2String(textbox.string[i+1])
         if textflags[i] == nil then textflags[i] = 1 end
         if _G[textbox.imgTable][aimage] == nil then  -- If not a valid image, draw nothing
           love.graphics.draw(noImageFound, pos.x + cursor.x, pos.y + cursor.y)
           cursor.x = cursor.x + noImageFound:getWidth()
         elseif type(_G[textbox.imgTable][aimage]) ~= "table" then -- If not an animation, draw only the image
           love.graphics.draw(_G[textbox.imgTable][aimage], pos.x + cursor.x, pos.y + cursor.y)
           cursor.x = cursor.x + _G[textbox.imgTable][aimage]:getWidth()
         else
           love.graphics.draw(_G[textbox.imgTable][aimage][textflags[i]], pos.x + cursor.x, pos.y + cursor.y) -- If it is an animation, use the textflag as a counter to animate
           cursor.x = cursor.x + _G[textbox.imgTable][aimage][textflags[i]]:getWidth()
          if advance_animation then
            if textflags[i] < #_G[textbox.imgTable][aimage] then
              textflags[i] = textflags[i] + 1
            else
              textflags[i] = 1
            end
          end
         end
      end
      if textbox.string[i]:lower() == "{newline}" then cursor.x = 0 cursor.y = cursor.y + (textbox.lineHeight * textbox.scale) end
      if textbox.string[i]:lower() == "{reset}" then setDefaults() end
      if textbox.string[i]:lower() == "{savecursor}" then tempcursor = {x = cursor.x, y = cursor.y} end
      if textbox.string[i]:lower() == "{loadcursor}" then cursor = {x = tempcursor.x, y = tempcursor.y} end
      if textbox.string[i]:lower() == "{cursorx}" then cursor.x = textbox.command2Num(textbox.string[i+1]) end
      if textbox.string[i]:lower() == "{cursory}" then cursor.y = textbox.command2Num(textbox.string[i+1]) end
      -- COLOR / STYLE
      if textbox.string[i]:lower() == "{hextcolor}" then textbox.currentColor = textbox.command2Hex(textbox.string[i+1]) end
      if textbox.string[i]:lower() == "{paltcolor}" then textbox.currentColor = _G[textbox.paletteTable][textbox.command2Num(textbox.string[i+1])] end
      if textbox.string[i]:lower() == "{/tcolor}" then textbox.currentColor = textbox.defaultColor end
      if textbox.string[i]:lower() == "{hexscolor}" then textbox.dropShadowColor = textbox.command2Hex(textbox.string[i+1]) end
      if textbox.string[i]:lower() == "{palscolor}" then textbox.dropShadowColor = _G[textbox.paletteTable][textbox.command2Num(textbox.string[i+1])] end
      if textbox.string[i]:lower() == "{/scolor}" then textbox.dropShadowColor = textbox.defaultDropShadowColor end
      if textbox.string[i]:lower() == "{hexocolor}" then textbox.outlineColor = textbox.command2Hex(textbox.string[i+1]) end
      if textbox.string[i]:lower() == "{palocolor}" then textbox.outlineColor = _G[textbox.paletteTable][textbox.command2Num(textbox.string[i+1])] end
      if textbox.string[i]:lower() == "{/ocolor}" then textbox.outlineColor = textbox.defaultDropShadowColor end
      if textbox.string[i]:lower() == "{font}" then love.graphics.setFont(textbox.command2Font(textbox.string[i+1])) textbox.lineHeight = love.graphics.getFont():getHeight("W") + 4 end
      if textbox.string[i]:lower() == "{/font}" then love.graphics.setFont(textbox.defaultFont) end
      if textbox.string[i]:lower() == "{shadow}" then textbox.dropShadow = true end
      if textbox.string[i]:lower() == "{/shadow}" then textbox.dropShadow = false end
      if textbox.string[i]:lower() == "{outline}" then textbox.outline = true end
      if textbox.string[i]:lower() == "{/outline}" then textbox.outline = false end
      if textbox.string[i]:lower() == "{toutline}" then textbox.thickOutline = true end
      if textbox.string[i]:lower() == "{/toutline}" then textbox.thickOutline = false end
      if textbox.string[i]:lower() == "{i}" then textbox.italics = true end
      if textbox.string[i]:lower() == "{/i}" then textbox.italics = false end
      if textbox.string[i]:lower() == "{scale}" then textbox.scale = textbox.command2Num(textbox.string[i+1]) end
      -- MOVEMENT / SPACING
      if textbox.string[i]:lower() == "{swing}" then textbox.swing = true end
      if textbox.string[i]:lower() == "{/swing}" then textbox.swing = false end
      if textbox.string[i]:lower() == "{spin}" then textbox.spin = true end
      if textbox.string[i]:lower() == "{/spin}" then textbox.spin = false end
      if textbox.string[i]:lower() == "{rot90}" then textbox.rot90 = true end
      if textbox.string[i]:lower() == "{/rot90}" then textbox.rot90 = false end
      if textbox.string[i]:lower() == "{rot180}" then textbox.rot180 = true end
      if textbox.string[i]:lower() == "{/rot180}" then textbox.rot180 = false end
      if textbox.string[i]:lower() == "{mirror}" then textbox.mirror = true end
      if textbox.string[i]:lower() == "{/mirror}" then textbox.mirror = false end
      if textbox.string[i]:lower() == "{blink}" then textbox.blink = true end
      if textbox.string[i]:lower() == "{/blink}" then textbox.blink = false end
      if textbox.string[i]:lower() == "{shake}" then textbox.shakeText = true end
      if textbox.string[i]:lower() == "{/shake}" then textbox.shakeText = false end
      if textbox.string[i]:lower() == "{shake2}" then textbox.shakeText2 = true end
      if textbox.string[i]:lower() == "{/shake2}" then textbox.shakeText2 = false end
      if textbox.string[i]:lower() == "{shake3}" then textbox.shakeText3 = true end
      if textbox.string[i]:lower() == "{/shake3}" then textbox.shakeText3 = false end
      if textbox.string[i]:lower() == "{drop}" then textbox.dropText = true end
      if textbox.string[i]:lower() == "{/drop}" then textbox.dropText = false end
      if textbox.string[i]:lower() == "{text_pad}" then extra_padding = textbox.command2Num(textbox.string[i+1]) end
      if textbox.string[i]:lower() == "{text_bounce}" then extra_padding = math.sin(textbox.timer + i) end
      if textbox.string[i]:lower() == "{/text}" then extra_padding = 0 end
      -- SPEED
      if textbox.string[i]:lower() == "{speed_instant}" then  textbox.skipWaiting = true textflags[i] = true  end
      if textbox.string[i]:lower() == "{speed_fastest}" then textbox.printSpeed = textbox.defaultPrintSpeed / 8 end
      if textbox.string[i]:lower() == "{speed_fast}" then textbox.printSpeed = textbox.defaultPrintSpeed / 2 end
      if textbox.string[i]:lower() == "{speed_slow}" then textbox.printSpeed = textbox.defaultPrintSpeed * 2 end
      if textbox.string[i]:lower() == "{speed_slowest}" then textbox.printSpeed = 0.5 end
      if textbox.string[i]:lower() == "{speed_set}" then textbox.printSpeed = textbox.command2Num(textbox.string[i+1]) end
      if textbox.string[i]:lower() == "{/speed}" then textbox.printSpeed = textbox.defaultPrintSpeed textbox.skipWaiting = false end
      if textbox.string[i]:lower() == "{instant}" then textbox.currentCharacter = #textbox.string end
      if textbox.string[i]:lower() == "{pause}" then if textflags[i] == nil then textbox.pauseTimer = textbox.command2Num(textbox.string[i+1]) textflags[i] = true end end
      -- SOUND
      if textbox.string[i]:lower() == "{sound_text}" then textbox.textSoundsOn = true end
      if textbox.string[i]:lower() == "{/sound_text}" then textbox.textSoundsOn = false end
      if textbox.string[i]:lower() == "{sound_character}" then textbox.soundCharacter = textbox.command2Num(textbox.string[i+1]) end
      if textbox.string[i]:lower() == "{/sound_character}" then textbox.soundCharacter = 1 end
      if textbox.string[i]:lower() == "{voice}" then
        textbox.currentVoice = textbox.command2Num(textbox.string[i+1])
        if textbox.currentVoice > #text_sounds then textbox.currentVoice = 1 end -- Reset Voice to 1 if the voice number is not real.
      end
      if textbox.SLog_Audio then -- These tags only work if SLog Audio is loaded. Currently only supports layer 1
        if textbox.string[i]:lower() == "{sfx}" then if textflags[i] == nil then Audio:sfxPlay(textbox.command2String(textbox.string[i+1])) textflags[i] = true end  end
        if textbox.string[i]:lower() == "{sfx_stop}" then if textflags[i] == nil then Audio:stopAllSFX() textflags[i] = true end  end
        if textbox.string[i]:lower() == "{vfx}" then if textflags[i] == nil then Audio:vfxPlay(textbox.command2String(textbox.string[i+1])) textflags[i] = true end end
        if textbox.string[i]:lower() == "{vfx_stop}" then if textflags[i] == nil then Audio:stopAllVFX() textflags[i] = true end  end
        if textbox.string[i]:lower() == "{mus}" then if textflags[i] == nil then Audio:setMusicPlay(textbox.command2String(textbox.string[i+1])) textflags[i] = true end end
        if textbox.string[i]:lower() == "{mus_pause}" then if textflags[i] == nil then Audio:pauseMusic(textbox.command2Num(textbox.string[i+1])) textflags[i] = true end end
        if textbox.string[i]:lower() == "{mus_resume}" then if textflags[i] == nil then Audio:resumeMusic(textbox.command2Num(textbox.string[i+1])) textflags[i] = true end end
      end
      if skipflags[i] == nil then textbox:nextCharacter() skipflags[i] = true end
    end
  end
    love.graphics.setColor(1,1,1,1) -- Always reset the color after.
    love.graphics.setFont(textbox.defaultFont)
    advance_animation = false
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
  textbox.counter = textbox.counter + dt
  if textbox.pauseTimer > 0 then
    textbox.pauseTimer = textbox.pauseTimer -  dt
  else
  if textbox.counter > textbox.printSpeed or textbox.skipWaiting then
    textbox.counter = 0
    textbox:nextCharacter()
  end
end

-- Counter for text effects
  if textbox.timer < 999999 then
    textbox.timer = textbox.timer + 10 * dt
  else textbox.timer = 0 end

-- Timer for blinking/glitching
  textbox.blinkTimer = textbox.blinkTimer + dt
  if textbox.blinkTimer > 0.5 then
    blinkstate = not blinkstate
    textbox.blinkTimer = 0
  end

-- Timer for animations
  textbox.anitimer = textbox.anitimer + dt
  if textbox.anitimer > 0.1 then
  advance_animation = true
  textbox.anitimer = 0
  end
end


function textbox:nextCharacter()
  if textbox.currentCharacter < #textbox.string then
    textbox.currentCharacter = textbox.currentCharacter + 1
  end
end

function textbox:send(string, keep, linebreakat)  -- Preprocess the string, split and seperate commands
  string = string or "NO STRING"
  keep = keep or nil
  linebreakat = linebreakat or nil
  local line_length = 0
  local last_space = 0
  local extra_spaces = 1
  textbox.counter = 0
  if not keep then
    textflags = {} -- Clear flags set for one off commands.
    skipflags = {} -- Clear flags to skip the pause for special commands
    soundflags = {} -- Clear flags that play audio.
    setDefaults()
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
  if tonumber(linebreakat) ~= nil then -- Note, text effects will break this. Set it up for your default font. (Or don't use it.)
    local i = 1 -- This was mostly made to make RPGs easier. If you're fine with {newline} as needed, then it does the job.
    while i < #textbox.string do
      if textbox.string[i]:sub(1,1) == textbox.controlCharacter then
        if textbox.string[i] == "{newline}" then line_length = 0 + textbox:getCharacterWidth(" ") end
      else
        if textbox.string[i]:sub(1,1) == " " then last_space = i end
        line_length = line_length + textbox:getCharacterWidth(textbox.string[i]) -- + extra space if using it.
        if line_length > linebreakat then
          table.insert(textbox.string, last_space, "{newline}")
          table.remove(textbox.string, last_space+1)
          i = last_space
          line_length = 0
        end
      end
      i = i + 1
    end
  end
end

function textbox:resetString()
  textbox.currentCharacter = 0
  textbox.string = {}
end

return textbox
