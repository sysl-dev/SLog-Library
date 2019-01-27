# SLog-Library
LOVE2D (V11+) Library that I pretty much created for my own use. Feel free to take and adapt as needed for your own projects. (MIT License) It's mostly brute-force code, since I just do game jams. Let me know if you find it useful!

Thank you,<br>
System Logoff

## SLog Audio
SLog Audio is a wrapper around LOVE2D's audio functions, with automatic import functionality.

### Including in your project
```Audio = require 'path.to.audio'``` -- Creates Audio.sfx, Audio.vfx, Audio.mus<br>
```Audio:setUp()``` -- Imports music from folders, sets music to loop.

### Requirements
```music```, ```sfx``` and ```vfx``` directories, containing music, sound effects, and voice-over effects respectively.

### Note
Currently Love2D 11.2 has an issue with streaming music, this will be corrected in 11.3

### Configuration / Control
```Audio.currentmusic[#]``` -- What music is currently playing
```Audio.debug = true``` -- Print the list of audio files to the console on game load.

### Functions - Music
#### Audio:setMusicPlay(musicName, musicLayer)
Sets the music to an imported song. The name is the music filename without the extension. If you do not define a layer, it will default to 1. It will then auto-play the track and stop other songs playing.

#### Audio:setMusic(musicName, musicLayer)
Set the music of a layer, does not auto-play the track.

#### Audio:playMusic(musicLayer)
Play the track on that music layer. If no value is passed it will default to 1.

#### Audio:pauseMusic(musicLayer)
Pause the track on that music layer. If no value is passed it will default to 1.

#### Audio:resumeMusic(musicLayer)
Resume the track on that music layer. If no value is passed it will default to 1.

#### Audio:restartMusic(musicLayer)
Restarts the track on that music layer. If no value is passed it will default to 1.

#### Audio:stopMusic(musicName)
Stop the track on that music layer. If no value is passed it will default to 1.

#### Audio:stopAllMusic()
Stops all playing music tracks.

#### Audio:crossMusic(layer1, layer2)
Pause layer1, resume layer2 at layer1's paused time.

### Functions - Sound
#### Audio:stopAllSFX()
Stops all playing sound effects.

#### Audio:sfxPlay(SFXName)
Play a sound effect.

#### Audio:sfxForcePlay(SFXName)
Force a sound effect to play by stopping the sound effect and replaying it.

### Functions - VFX
#### Audio:stopAllVFX()
Stops all playing voice lines.

#### Audio:vfxPlay(SFXName)
Play a voice line.

#### Audio:vfxForcePlay(SFXName)
Force a voice line to play by stopping the sound effect and replaying it.

### Functions - Volume
#### Audio:setGlobalSFXVolume(value)
Set the global volume of all sound effects.

#### Audio:setGlobalMusicVolume(value)
Set the global volume of all songs.

#### Audio:setGlobalVFXVolume(value)
Set the global volume of all voice effects.

#### Audio:setGlobalVolume(value)
Set the global volume of all sounds.

#### Audio:setSingleSFX(name, value)
Set the volume of a single sound.

#### Audio:setSingleMusic(name, value)
Set the volume of a single song.

#### Audio:setSingleVFX(name, value)
Set the volume of a single voice.

#### Audio:setBatchSFX({table_names}{table_values})
Batch set the sound volume of a list of sound effects.

#### Audio:setBatchMusic({table_names}{table_values})
Batch set the sound volume of a list of songs.

#### Audio:setBatchCFX({table_names}{table_values})
Batch set the sound volume of a list of voices.

## SLog Floppy
SLog Floppy is a wrapper around [Smallfolk](https://github.com/gvx/Smallfolk) for a fast way to manage save files.

### Including in your project
```Floppy = require 'path.to.floppy'``` <br>
Note: You will have to define Smallfolk's imported name in floppy.lua

### Configuration / Control
```floppy.filetype = ".txt"``` -- Defines what save files end with.

### Functions
#### Floppy:save(filename, memory)
Filename is what the file is named, memory is what Lua Table to dump to the file.

#### Floppy:delete(filename)
Delete a save file.

#### memory = Floppy:Load(filename)
Filename is what the file is named, memory is what Lua Table to dump the file into.

## SLog Palette
A quick image to palette table command.

### Including in your project
```Palette = require 'path.to.palette'``` <br>

### Configuration / Control
```palette.fileLocation = "library/slog/palette.png"``` -- Point to your palette file.
```palette.squareSize = 32``` -- Size of your palette squares.

### Using
```love.graphics.setColor(Palette[#])``` -- Where # is a number in your palette.

## SLog Palette
A Pixel Perfect Screen Scaler for Love2D.

### Including in your project
```Pixels = require 'path.to.pixels'```
```Pixels:load()``` -- Set the default screen scale, if not assigned it will do the max window size that fits within the current screen.<br><br>
At the start of love:draw() insert: ```  Pixels:drawGameArea()``` then at the end, after ahh your draw code, put ```Pixels:endDrawGameArea()```

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

#### pixels.mousey / pixels.mousex
Variables that give you the X/Y position of the mouse according to the pixel scale of the screen. Use this to check for mouse position.

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
