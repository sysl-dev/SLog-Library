# SLog-Library
LOVE2D (V11+) Library that I pretty much created for my own use. Feel free to take and adapt as needed for your own projects. 

Thank you,<br>
System Logoff

## SLog Audio
SLog Audio is a wrapper around LOVE2D's audio functions, with automatic import functionality.

### Including in your project
```audio = require 'path.to.audio'``` -- Creates Audio.sfx, Audio.vfx, Audio.mus<br>
```audio:setUp()``` -- Imports music from folders, sets music to loop.

### Requirements
Directories under an *audio* folder, the name of which is defined in the configuration. 

### Note
Currently Love2D 11.2 has an issue with streaming music, this will be corrected in 11.3. While that is pending, music is set as static.

### Configuration / Control
-- Folder where your audio is kept.<br>
local path_to_audio_folder = "audio"<br>
<br>
-- List files on startup in the console<br>
local list_files = true<br>
<br>
-- What folders of audio need to loop<br>
local groups_to_loop = {"env", "music"}<br>
<br>
-- Default local audio volume<br>
local default_volume = 0.5<br>
<br>
-- Default global audio volume<br>
local default_global_volume = 1<br>
<br>
-- Volume for all sounds<br>
audio.global = {}  -- audio.global.[audio_folders]<br>
audio.global.all = default_global_volume<br>
<br>
-- This table stores the volume of audio so we can update the global settings.<br>
audio.volume = {}<br>
<br>
-- DJ, controls the music that is playing.<br>
audio.dj = {}<br>
-- Current audio tracks.<br>
audio.dj.tracks = {}<br>
audio.dj.forced = nil<br>

### Functions - Music
#### audio:setVolume(type, file_name, vol)
Sets the volume of a single audio file.

#### audio:setAllVolume(type, vol)
Sets the volume of a group of audio files, groups are defined by the folders.

#### audio:setTypeVolume(type, vol)
Sets the volume of a type of audio files.

#### audio:setGlobalVolume(vol, folder_path)
Sets the global volume.<br>

#####Note:
Final volume is defined as ```audio.volume[type][k] * audio.global[type] * audio.global.all```

#### audio:play(name, type)
Plays a sound.

#### audio:fplay(name, type)
Force plays a sound by stopping the current sound and playing it again.

#### audio:stop(type)
Stops all of a type of sound from playing.

### Audio DJ - Allows control of music tracks.

#### audio.dj:play(name, number)
Plays a track, if no number is defined, plays it in slot 1.

#### audio.dj:crossplay(name, number)
Plays a track starting from the same position in the song as the defined track number. Allows swaps sort of like Banjo Kazooie, where the audio swaps depending on what's nearby.

#### audio.dj:pause(number)
Pauses a track.

#### audio.dj:restart(number)
Restarts a track from the begining.

#### audio.dj:clear(number)
Stops all playing tracks, clears the track list.

#### audio.dj:force(track)
Forces only this track to play until audio.dj:force(nil) is sent.


## SLog Floppy
SLog Floppy is a wrapper around [Smallfolk](https://github.com/gvx/Smallfolk) for a fast way to manage save files.

### Including in your project
```Floppy = require 'path.to.floppy'``` <br>
Note: You will have to define Smallfolk's imported name in floppy.lua

### Configuration / Control
```floppy.filetype = ".txt"``` -- Defines what save files end with.<br>
<br>
```floppy.ram = "ram"``` -- Default table to save to file

### Functions
#### Floppy:save(filename, memory)
Filename is what the file is named, memory is what Lua Table to dump to the file.

#### Floppy:delete(filename)
Delete a save file.

#### memory = Floppy:loadas(filename)
Filename is what the file is named, memory is what Lua Table to dump the file into.

#### Floppy:load(filename)
Loads the save into the default table.

## SLog Palette
A quick image to palette table command.

### Including in your project
```Palette = require 'path.to.palette'``` <br>

### Configuration / Control
```palette.fileLocation = "library/slog/palette.png"``` -- Point to your palette file.
```palette.squareSize = 32``` -- Size of your palette squares.

### Using
```love.graphics.setColor(Palette[#])``` -- Where # is a number in your palette.

## SLog Pixels
A Pixel Perfect Screen Scaler for Love2D.

### Including in your project
```Pixels = require 'path.to.pixels'```
```Pixels:load()``` -- Set the default screen scale, if not assigned it will do the max window size that fits within the current screen.<br><br>
At the start of love:draw() insert: ```  Pixels:drawGameArea()``` then at the end, after all your draw code, put ```Pixels:endDrawGameArea()```

### Configuration / Control
Note: Make sure conf.lua has the proper 1x size width and height for your project.
```local allowUserResize = false``` -- Alow users to resize the window with window controls.<br>
```local cursorTable = {{"path/to/cursor1.png",0,0},}``` -- Format {Path, -X, -Y offsets} -- Table holding the string to each cursor. Note: Make it blank if you don't plan on using a cursor.<br>
```pixels.currentCursor = 0 ```-- Cursor to start with. 0 = No cursor.<br>
```pixels.showSystemCursor = true``` -- Show the system cursor.<br>
```pixels.drawBG = true``` -- Draw a blackBG behind everything.<br>

### Functions
#### Pixels:resizeScreen(newScale)
Resize the screen to a new scale.

#### Pixels:fullscreenToggle()
Change to fullscreen or normal view.

#### Pixels:toggleCursor()
Toggle system cursor on or off.

#### Pixels:setCursor(cursorNumber)
Force system cursor on or off.

#### Pixels:forceCursor(cursorNumber)
Force system cursor on or off.

#### pixels.mouse.y / pixels.mouse.x
Variables that give you the X/Y position of the mouse according to the pixel scale of the screen. Use this to check for mouse position.

#### pixels:screenshot(name, picture)
Take a screenshot of the current screen.

#### pixels:screenshotClearAll(picture)
Clear all pictures

#### pixels:screenshotClear(name, picture)
Clear a single picture 

#### pixels:screenshotExist(name, picture)
Check to see if the screenshot/bank exists, reccomended before trying to draw.



## SLog Textbox
A fancy system for printing text.<br>
<img src="https://i.imgur.com/iF6hBKw.gif" alt="Example of text">

### Including in your project
```Textbox = require 'path.to.textbox'``` <br>
Note: You will have to define the path to the default sound.<br>
Note: Image/Font/Palette tags require you to define what table they are held in. <br>
Note: Audio tags require SLog Audio.

### Using
In ```love:draw()``` include: ```Textbox:draw(x, y)```<br>
Send text with: ```Textbox:send("Text Here", "Clear")```<br>
Note: Clear clears the previous text from the box.

### Tags
#### {newline}
Prints a new line.

#### {reset}
Resets all formatting

#### {0xcolor}{Hex Code w/wo alpha ex: C0FFEE or COFFEEAA}
Sets color to the hex value.

#### {colorpal}{#}
Sets color from palette table. Requires a palette table.

#### {/color}
Revert back to default color.

#### {font}{fontname}
Change font to fontname.

#### {shake}
Have the text shake in a sinwave pattern.

#### {/shake}
End Shake.

#### {drop}
Have the text fall like raindrops down the screen.

#### {/drop}
End Drop.

#### {shadow}
Draw +1/+1 offset drop shadow behind text.

#### {/shadow}
End Shadow

#### {fastest} {fast} {slow} {slowest} {instant}
Change the text speed

#### {/speed}
Revert back to default speed.

#### {savecursor}
Save the current position of the text printing x/y position.

#### {loadcursor}
Load the current position of the text printing x/y position.

#### {cursorx} {cursory}
Set the X or Y position of the printing cursor.

#### {textpad}{#}
Set the padding between characters.

#### {text_bounce}
Make the rest of the text on the line bounce like a string.

#### {/text}
End text_bounce and textpad.

#### {sound_text}
Play an audio sound per text character.

#### {/sound_text}
Stop playing audio per text character

#### {pause}{#}
Pause for # - 60 * dt

#### {icon}{imagename}
Print an image to the text-box, move cursor to after image. Assumes images are in a table defined in settings.

### Functions (Requires Audio.lua)

#### {sfx}{sfxname}
Play a sound effect.

#### {vfx}{vfxname}
Play a voice over.

#### {mus}{musicname}
Play music.

#### {sfx_stop}{sfxname}
Stop a sound effect.

#### {vfx_stop}{vfxname}
Stop a voice over.

#### {mus_pause}{musicname}
Pause Music

#### {mus_resume}{musicname}
Resume Music

#### {mus_cross}{musicname}
Switch to another music track at the same point as the last song.
