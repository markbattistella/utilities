# What it is
This application was designed for [ContentAgent](https://www.root6technology.com/contentagent-2/) where we needed specified chapter lengths for different media types:

1. 1 minute chapters for audio
1. 5 minute chapters for video

# How to use
1. In ContentAgent create a CMD node in the workflow

1. Link the `mbAutoChapters.exe` to the node

1. Enter the parameters:
```CMD
.\mbAutoChapters.exe {numberOfFrames} {video/audio} {filename}
```

example: `.\mbAutoChapters.exe 7856 video myvideo.mov`

| Parameters | Options
| :--------- | :------
| `{frames}` | Number of frames the file is
| `{video/audio}` | `video` for 5 minute chapters, `audio` for 1 minute chapters
| `{filename}` | The output filename to save as `{filename}.xml`

# Cleanup
Due to the way ContentAgent handles the media in `CA_Media` there isn't any cleanup of the `xml` files - unless you run the Orphan Files scan.

If you run the `cleanChapters.bat` on a task schedule - once a day - then it will look through the directory you specify, and delete only `xml` files. Since we use the XML Injection inside the Workflow we no longer need the file.

```batch
Forfiles -p {location} -s -m *.xml -d -0 -c "cmd /c del /Q /S @path >> .\mbChapterCleanup.log"
```

Change the `{location}` to where you have your `CA_Media` or where you've chosen to save the `xml` files.

It also outputs a `log` of the files deleted in the same directory as the batch file, and will override it every write.

# Static XML files
In earlier versions of ContentAgent it didn't care if there were more chapters than the total length (i.e. you could have 99x5min chapters on a 1 minute video).

If you don't want to run the application on every clip, you can just inject the video with the static XML.

**Note:** it might not work though, and will fail on burn or playback!
