# SLog-Library
LOVE2D (V11+) Library that I pretty much created for my own use. Feel free to take and adapt as needed for your own projects. (MIT Lisence)
It's mostly bruteforce code, since I just do gamejams, so I'm sorry if it's not the best.

Thank you,<br>
System Logoff.

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
```Audio.currentmusic = nil``` -- What music is currently playing
```Audio.debug = true``` -- Print the list of audio files to the console.

### Functions
#### Audio:setMusic(musicName)
Sets the music to the file name of your song, without the extension. This will also set Audio.currentmusic to the name of that song.<br>
Example: ```Audio:setMusic("Cool_Music")```<br>
If you do not set a song or the song does not exist, an error will print to the console, and the function will return nothing. 

#### Audio:crossMusic(musicName)
Pause the current music and switch to another song at the same time as the previous song.

#### Audio:pauseMusic(musicName)
Pause the music track.

#### Audio:resumeMusic(musicName)
Resume the music track.

#### Audio:restartMusic(musicName)
Restart the music track.

#### Audio:stopMusic(musicName)
Stop the music track.

#### Audio:stopAllMusic()
Stops all playing music tracks.

#### Audio:stopAllSFX()
Stops all playing sound effects.

#### Audio:sfxPlay(SFXName)
Play a sound effect.

#### Audio:sfxForcePlay(SFXName)
Force a sound effect to play by stopping the sound effect and replaying it.

#### Audio:stopAllVFX()
Stops all playing voice lines.

#### Audio:vfxPlay(SFXName)
Play a voice line.

#### Audio:vfxForcePlay(SFXName)
Force a voice line to play by stopping the sound effect and replaying it.

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
Send text with: ```Textbox:send("Text Here", "Clear")<br>
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








