local floppy = {
  _NAME        = 'SLog Floppy',
  _VERSION     = '0.1',
  _DESCRIPTION = 'A Save/Load Library for Love2D, requires smallfolk.',
  _URL         = 'https://github.com/SystemLogoff/SLog-Library',
  _REQUIRES    = 'https://github.com/gvx/Smallfolk',
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

if package.loaded["library.smallfolk.smallfolk"] == nil then -- Floppy requires smallfolk, change to library path
  print("Floppy requires Smallfolk to work. / Floppy disabled") return nil
end

floppy.filetype = ".txt" -- Saves end with this, change to "" to end with nothing.

function floppy:save(filename, memory)
  local didwork, savemessage
  if type(filename) ~= type("STRING") then
    print("Floppy only supports strings for save files.") return
  end
  if not (filename:match("%w")) then
    print("Floppy only supports A-Z, a-z and 0-9.") return
  end
  if memory == nil then print("NOTHING TO SAVE") return end
  didwork, savemessage = love.filesystem.write(filename .. floppy.filetype, Smallfolk.dumps(memory))
  print("Save?", didwork, "Notes:", savemessage)
end

function floppy:delete(filename)
  local didwork, savemessage
  if type(filename) ~= type("STRING") then
    print("Floppy only supports strings for save files.") return
  end
  if not (filename:match("%w")) then
    print("Floppy only supports A-Z, a-z and 0-9.") return
  end
  didwork = love.filesystem.remove(filename .. floppy.filetype)
  print("Deleted?", didwork)
end

function floppy:load(filename) -- memory = floppy:load(filename)
  local contents, size
  if type(filename) ~= type("STRING") then
    print("Floppy only supports strings for save files.") return
  end
  if not (filename:match("%w")) then
    print("Floppy only supports A-Z, a-z and 0-9.") return
  end
  contents, size = love.filesystem.read(filename .. floppy.filetype)
  if contents then return Smallfolk.loads(contents) else print("Nothing in save file") return nil end
  print("Size/Notes", size)
end


return floppy
