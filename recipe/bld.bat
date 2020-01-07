msbuild.exe /p:Configuration=Release FreeImage.2017.vcxproj
if errorlevel 1 exit 1
move Dist\%PLATFORM%\FreeImage.lib %LIBRARY_LIB%\FreeImage.lib
move Dist\%PLATFORM%\FreeImage.dll %LIBRARY_BIN%\FreeImage.dll
move Dist\%PLATFORM%\FreeImage.h %LIBRARY_INC%
if errorlevel 1 exit 1
