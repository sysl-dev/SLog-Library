local pixels = {
  _NAME        = 'SLog Pixels',
  _VERSION     = '1.4',
  _DESCRIPTION = 'A Pixel Perfect Screen Scaler for Love2D',
  _URL         = 'https://github.com/SystemLogoff/lovePixel',
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

-- note to self: camera:attach(x,y,w,h, noclip)
-- note camera:attach(x,y,love.graphics.getWidth() / pixels.scale,love.graphics.getHeight() / lovePixels.scale, noclip)

local baseWidth = love.graphics.getWidth() -- Capture the conf.lua settings for Window Size
local baseHeight = love.graphics.getHeight()
-- Config
local allowUserResize = false -- Alow users to resize the window with window controls.
-- Table holding the string to each cursor. Note: Make it blank if you don't plan on using a cursor.
local cursorTable = {{"library/slog/cursor1.png",0,0},} -- Format {Path, -X, -Y offsets}
pixels.cursors = {} -- Table to hold image pointer for all cursors.
for k,v in pairs(cursorTable) do
  pixels.cursors[k] = love.graphics.newImage(v[1])
end
pixels.currentCursor = 0 -- Cursor to start with. 0 = No cursor.
pixels.showSystemCursor = true -- Show the system cursor.
pixels.drawBG = true -- Draw a blackBG behind everything.

function pixels:load(defaultScale)
    love.graphics.setDefaultFilter( "nearest", "nearest", 1 )
    pixels.mainCanvas = love.graphics.newCanvas(baseWidth,baseHeight)
    pixels:monitorSize()
    pixels:calcMaxScale()
    pixels:calcOffset()
    defaultScale = defaultScale or pixels.maxWindowScale
    pixels:forceCursor(pixels.showSystemCursor)
    pixels:resizeScreen(defaultScale)
end

-- Only supports main screen. Game -> TV is usually screen mirroring.
function pixels:monitorSize()
    local width, height = love.window.getDesktopDimensions(1)
    pixels.monitorWidth = width
    pixels.monitorHeight = height
end

function pixels:calcMaxScale() -- This is a much better way to do this.
    pixels.maxWindowScale = 3
    pixels.maxScale = 4
    local floatHeight = (pixels.monitorHeight) / baseHeight
    local floatWidth = (pixels.monitorWidth) / baseWidth

        if floatHeight < floatWidth then
            pixels.maxScale = (pixels.monitorHeight) / baseHeight
            -- We do -100 here to keep max window size in check from bleeding off the top and bottom of the screen in Windows.
            pixels.maxWindowScale = math.floor((pixels.monitorHeight - 100) / baseHeight)
        else
             pixels.maxScale = (pixels.monitorWidth) / baseWidth
             -- We do -100 here to keep max window size in check from bleeding off the sides of the screen in Windows.
             pixels.maxWindowScale = math.floor((pixels.monitorWidth - 100) / baseWidth)
        end
        print("Game Max Scale: " .. pixels.maxScale .. "\nGame Max Windowed Scale: " .. pixels.maxWindowScale .. "\n")
end

-- This should work on all monitors now? I think??
function pixels:calcOffset()
    local xgamearea = baseWidth * pixels.maxScale
    local width = pixels.monitorWidth
    local xblankspace = width - xgamearea

    local ygamearea = baseHeight * pixels.maxScale
    local height = pixels.monitorHeight
    local yblankspace = height - ygamearea

    pixels.xoffset = math.floor(xblankspace/2)
    pixels.yoffset = math.floor(yblankspace/2)

    if love.window.getFullscreen() == false then -- Don't care about offset if not fullscreen.
        pixels.xoffset = 0
        pixels.yoffset = 0
    end
end

-- This creates the Canvas we draw all assets on then scale up later.
function pixels:drawGameArea()
    love.graphics.setCanvas(pixels.mainCanvas)
    if pixels.drawBG then
      love.graphics.setColor(0,0,0,1)
      love.graphics.rectangle("fill", 0, 0, baseWidth, baseHeight)
    end
    love.graphics.setColor(1,1,1,1)
end

-- Stop drawing the canvas so we can take it and scale it.
function pixels:endDrawGameArea()
  if pixels.currentCursor > 0 and pixels.currentCursor <= #pixels.cursors then -- If cursor is not 0 or not out of bounds, draw it.
    love.graphics.draw(pixels.cursors[pixels.currentCursor],pixels.mousex - cursorTable[pixels.currentCursor][2],pixels.mousey- cursorTable[pixels.currentCursor][3])
  end
    love.graphics.setCanvas()
    love.graphics.draw(pixels.mainCanvas, 0 + pixels.xoffset , 0 + pixels.yoffset, 0, pixels.scale, pixels.scale)
end

-- Call this function to resize the screen with a new scale.
function pixels:resizeScreen(newScale)
    pixels.scale = newScale
    love.window.setMode(baseWidth * pixels.scale, baseHeight * pixels.scale, {fullscreen = false, resizable = allowUserResize, highdpi = false})
end

-- pixelMouse watches where we click to match it with the scaled game area.
-- include in love.update if you use mouse in your game.
function pixels:pixelMouse()
    pixels.mousey = math.floor((love.mouse.getY() - pixels.yoffset)/pixels.scale)
    pixels.mousex = math.floor((love.mouse.getX() - pixels.xoffset)/pixels.scale)
end

function pixels:toggleCursor()
  love.mouse.setVisible(love.mouse.isVisible())
end

function pixels:forceCursor(onoff)
  love.mouse.setVisible(onoff)
end

function pixels:setCursor(cursorNumber)
  if cursorNumber <= #pixels.cursors and cursorNumber >=0 then
    pixels.currentCursor = cursorNumber
  else
    print("Not a valid cursor number.")
  end
end


function pixels:fullscreenToggle()
    if love.window.getFullscreen() == false then
        pixels:resizeScreen(pixels.maxScale)
        love.window.setFullscreen(true, "desktop")
    else
        pixels:resizeScreen(math.floor(pixels.maxWindowScale))
        love.window.setFullscreen(false)
    end
end

if allowUserResize then
  --Override the love.resize.
  function love.resize(w,h)
    print(w,h)
    if h ~= pixels.monitorHeight or w ~= pixels.monitorWidth then -- Cheap hack to allow full screen and resize
      if pixels.scale < math.floor(pixels.maxWindowScale)  then
        pixels:resizeScreen(pixels.scale + 1)
      else
        pixels:resizeScreen(1)
      end
    else
    end
  end
end

return pixels
