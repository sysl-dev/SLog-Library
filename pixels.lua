local pixels = {
  _NAME        = 'SLog Pixels',
  _VERSION     = '2.0',
  _DESCRIPTION = 'A Pixel Perfect Screen Scaler for Love2D',
  _URL         = 'https://github.com/SystemLogoff/SLog-Library/',
  _Old_URL         = 'https://github.com/SystemLogoff/lovePixel',
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


--[[ Configuration ]]-----------------------------------------------------------
-- A requirement for pixel perfect scaling.
  love.graphics.setDefaultFilter( "nearest", "nearest", 1 )
  love.graphics.setLineStyle("rough")

-- Capture the conf.lua settings for Window Size
  local baseWidth = love.graphics.getWidth()
  local baseHeight = love.graphics.getHeight()

-- Allow user to resize the window with window controls.
  local windowResize = true

-- Draw a black BG behind the pixel canvas.
  pixels.drawBG = true

-- Table defining all graphical cursors used.
---- Format {Path to image, -X offset, -Y offset}
---- If unused, cursorTable = {{}} is reccomended
  local cursorTable = {{"texture/system/cursor1.png",0,0},}

-- Table, loads all cursors from cursorTable and assigned them as a new image.
  pixels.cursors = {}
  for k,v in pairs(cursorTable) do
    pixels.cursors[k] = love.graphics.newImage(v[1])
  end

-- The current graphical cursor to use, 0 is a blank cursor.
  pixels.currentCursor = 1

-- Show the system cursor at startup.
  pixels.showSystemCursor = true

-- Name of table to hold canvas screenshots
  local name_screenshots = "screenshots"
  pixels[name_screenshots] = {}

--[[ End Configuration ]]-------------------------------------------------------

--[[ Notes ]]-------------------------------------------------------------------
-- Loads Pixels
-- Will use the max possible scale if none is defined.
function pixels:load(defaultScale)
    pixels.canvas = love.graphics.newCanvas(baseWidth,baseHeight)
    pixels:monitorSize()
    pixels:calcMaxScale()
    pixels:calcOffset()
    defaultScale = defaultScale or pixels.maxWindowScale
    pixels:forceCursor(pixels.showSystemCursor)
    pixels:resizeScreen(defaultScale)
end

--[[ Notes ]]-------------------------------------------------------------------
-- Include in your main update loop.
-- Updates offset and the pixel mouse position.
function pixels:update(dt)
  pixels:pixelMouse()
  pixels:calcOffset()
end

--[[ Notes ]]-------------------------------------------------------------------
-- Calculates the monitor size and stores it for later use.
-- Only calculates on the main screen, because that's 99% of what people use.
function pixels:monitorSize()
    local width, height = love.window.getDesktopDimensions(1)
    pixels.monitor = {w = width, h = height}
end

--[[ Notes ]]-------------------------------------------------------------------
-- Calculates the max scale of the windowed game and fullscreen game
function pixels:calcMaxScale() -- This is a much better way to do this.
  local floatWidth = (pixels.monitor.w) / baseWidth
  local floatHeight = (pixels.monitor.h) / baseHeight

  if floatHeight < floatWidth then
      pixels.maxScale = (pixels.monitor.h) / baseHeight
      -- Subtract 100 to adjust for taskbar
      pixels.maxWindowScale = math.floor((pixels.monitor.h - 100) / baseHeight)
  else
       pixels.maxScale = (pixels.monitor.w) / baseWidth
       -- Subtract 100 to adjust for taskbar
       pixels.maxWindowScale = math.floor((pixels.monitor.w - 100) / baseWidth)
  end
end

--[[ Notes ]]-------------------------------------------------------------------
-- Calculates the offset to draw the canvas in if fullscreen.
-- If it's not fullscreen, don't bother with offset.
function pixels:calcOffset(width, height)
  width = width or pixels.monitor.w
  height = height or pixels.monitor.h

  local gameWidth = baseWidth * pixels.maxScale
  local blankWidth = width - gameWidth

  local gameHeight = baseHeight * pixels.maxScale
  local blankHeight = height - gameHeight

  pixels.offset = {
    x = math.floor(blankWidth/2),
    y = math.floor(blankHeight/2)
  }

  if love.window.getFullscreen() == false then
      pixels.offset = {x=0, y=0}
  end
end

--[[ Notes ]]-------------------------------------------------------------------
-- This function will put everything drawn after into Pixels scaling canvas.
function pixels:drawGameArea()
    love.graphics.setCanvas(pixels.canvas)
    if pixels.drawBG then
      love.graphics.setColor(0,0,0,1)
      love.graphics.rectangle("fill", 0, 0, baseWidth, baseHeight)
    end
    love.graphics.setColor(1,1,1,1)
end

--[[ Notes ]]-------------------------------------------------------------------
-- Put this after you are done drawing to return to the default canvas and
-- draw the image scaled to the window.
-- Also includes the graphical cursor, if enabled.
function pixels:endDrawGameArea()
  if pixels.currentCursor > 0 and pixels.currentCursor <= #pixels.cursors then -- If cursor is not 0 or not out of bounds, draw it.
    love.graphics.draw(pixels.cursors[pixels.currentCursor],pixels.mouse.x - cursorTable[pixels.currentCursor][2],pixels.mouse.y- cursorTable[pixels.currentCursor][3])
  end
    love.graphics.setCanvas()
    love.graphics.draw(pixels.canvas, 0 + pixels.offset.x , 0 + pixels.offset.y, 0, pixels.scale, pixels.scale)
end

--[[ Notes ]]-------------------------------------------------------------------
-- This function is called to resize the screen.
function pixels:resizeScreen(newScale)
    pixels.scale = newScale
    love.window.setMode(baseWidth * pixels.scale, baseHeight * pixels.scale, {fullscreen = false, resizable = windowResize, highdpi = false})
end

--[[ Notes ]]-------------------------------------------------------------------
-- This function is sets the game to fullscreen or returns to windowed mode.
function pixels:fullscreenToggle()
    if love.window.getFullscreen() == false then
        pixels:resizeScreen(pixels.maxScale)
        love.window.setFullscreen(true, "desktop")
    else
        pixels:resizeScreen(math.floor(pixels.maxWindowScale))
        love.window.setFullscreen(false)
    end
end

--[[ Notes ]]-------------------------------------------------------------------
-- This function will control resizing with the window.
if windowResize then
  function love.resize(w,h)
    -- Capture all scales
    local scales = {}
    for i=1, pixels.maxWindowScale do
      scales[i] = {baseWidth * i, baseHeight * i}
    end
    local setscale = 1
    for i=1, #scales do
      if w > scales[i][1] then
        setscale = setscale + 1
      end
    end

    if setscale == pixels.scale then
      if w < baseWidth * setscale then setscale = setscale - 1 end
    end

    if setscale == 0 then setscale = 1 end
    if setscale > pixels.maxWindowScale then setscale = pixels.maxWindowScale end

    pixels:resizeScreen(setscale)

  end
end

--[[ Pixel Cursor ]]------------------------------------------------------------
--[[ Notes ]]-------------------------------------------------------------------
-- This updates the pixel mouse, replaces the love.mouse for checking for mouse
-- position.
function pixels:pixelMouse()
    pixels.mouse = {
      x = math.floor((love.mouse.getX() - pixels.offset.x)/pixels.scale),
      y = math.floor((love.mouse.getY() - pixels.offset.y)/pixels.scale)
    }
end

--[[ Notes ]]-------------------------------------------------------------------
-- This function toggles the system cursor.
function pixels:toggleCursor()
  love.mouse.setVisible(love.mouse.isVisible())
end

--[[ Notes ]]-------------------------------------------------------------------
-- This function sets the system cursor. Uses true/false.
function pixels:forceCursor(onoff)
  love.mouse.setVisible(onoff)
end

--[[ Notes ]]-------------------------------------------------------------------
-- This function sets the graphical cursor, will not set an invalid cursor.
function pixels:setCursor(cursorNumber)
  if cursorNumber <= #pixels.cursors and cursorNumber >=0 then
    pixels.currentCursor = cursorNumber
  else
    print("Not a valid cursor number.")
  end
end

--[[ Notes ]]-------------------------------------------------------------------
-- Check to see if the pixel mouse in in a defined area.
-- Uses a 3x3 hit rectangle if nothing is defined for the mouse.
function pixels:mousearea(x1,y1,w1,h1,  mx,my,mw,mh)
  mw = mw or 3
  mh = mh or 3
  mx = mx or pixels.mouse.x
  my = my or pixels.mouse.y
  return x1 < mx+mw and
         mx < x1+w1 and
         y1 < my+mh and
         my < y1+h1
end

--[[ Pixel Screenshot ]]--------------------------------------------------------
--[[ Notes ]]-------------------------------------------------------------------
-- Capture a screenshot, with a name.
-- Can define a seperate screenshot bank.
-- Note, does not last past the game closing.
function pixels:screenshot(name, picture)
  name = name or "default"
  picture = picture or name_screenshots
  if pixels[picture] == nil then
    pixels[picture] = {}
  end
  local capture = Pixels.canvas:newImageData( 1, 1, 0, 0, baseWidth, baseHeight )
  pixels[picture][name] = love.graphics.newImage(capture)
end

--[[ Notes ]]-------------------------------------------------------------------
-- Erases all screenshots
function pixels:screenshotClearAll(picture)
  picture = picture or name_screenshots
  pixels[picture] = {}
end

--[[ Notes ]]-------------------------------------------------------------------
-- Erases a screenshot.
function pixels:screenshotClear(name, picture)
  name = name or "default"
  picture = picture or name_screenshots
  pixels[picture] = {}
end

--[[ Notes ]]-------------------------------------------------------------------
-- Check to see if the screenshot/bank exists, reccomended before trying to draw
function pixels:screenshotExist(name, picture)
  name = name or "default"
  picture = picture or name_screenshots
  if pixels[picture] == nil then
    pixels[picture] = {}
  end
  if pixels[picture][name] ~= nil then return true else return false end
end

--[[ End of library ]]----------------------------------------------------------
return pixels
