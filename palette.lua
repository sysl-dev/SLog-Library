local palette = {
  _NAME        = 'SLog Palette',
  _VERSION     = '0.1',
  _DESCRIPTION = 'Lazy Palette From Image / Assume 32px Blocks.',
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
  ]]
}
local pathtoimage = "library/slog/palette.png"

local info = love.filesystem.getInfo( pathtoimage, "file" )
if info == nil then print("File not found. SLog Palette not loaded.") return end

palette.fileLocation = pathtoimage -- Point to your palette file.
palette.squareSize = 32

local image = love.image.newImageData(palette.fileLocation) -- Temp load the image
local r, g, b, a = 0,0,0,0
local i = 1

-- Loop through all the squares.
for y = 0, image:getHeight()-1, palette.squareSize do
  for x = 0, image:getWidth()-1, palette.squareSize do

    r, g, b, a = image:getPixel( x, y )
    palette[i] = {r, g, b, a}
    i = i + 1
  end
end

local image, r, g, b, a, i = nil, nil, nil, nil, nil, nil

return palette
