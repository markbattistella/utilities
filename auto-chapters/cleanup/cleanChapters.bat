Forfiles -p {location} -s -m *.xml -d -0 -c "cmd /c del /Q /S @path >> .\mbChapterCleanup.log"
