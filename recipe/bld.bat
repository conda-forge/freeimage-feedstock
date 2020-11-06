dos2unix Source/**/*.cpp

patch -p1 < %RECIPE_DIR%/patches/Use-system-libs.patch
patch -p1 < %RECIPE_DIR%/patches/Fix-compatibility-with-system-libpng.patch
patch -p1 < %RECIPE_DIR%/patches/CVE-2019-12211-13.patch

# remove all included libs to make sure these don't get used during compile
rm -r Source/Lib* Source/ZLib Source/OpenEXR

rem clear files which cannot be built due to dependencies on private headers
rem see also unbundle patch
echo "" > Source/FreeImage/PluginG3.cpp
echo "" > Source/FreeImageToolkit/JPEGTransform.cpp

mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_INSTALL_LIBDIR=lib ^
      -DBUILD_SHARED_LIBS=ON ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_MODULE_PATH="%RECIPE_DIR%/cmake;${CMAKE_MODULE_PATH}" ^
      -DCMAKE_FIND_ROOT_PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY ^
      -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY ^
      -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER ^
      -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY ^
      -DCMAKE_FIND_FRAMEWORK=NEVER ^
      -DCMAKE_FIND_APPBUNDLE=NEVER ^
      -G "Ninja" ^
      ..

ninja
ninja install

rem cmake -E create_symlink ${PREFIX}/lib/libfreeimage${SHLIB_EXT} ${PREFIX}/lib/libfreeimage-${PKG_VERSION}${SHLIB_EXT}


rem msbuild.exe /p:Configuration=Release FreeImage.2017.vcxproj
rem if errorlevel 1 exit 1
rem move Dist\%PLATFORM%\FreeImage.lib %LIBRARY_LIB%\FreeImage.lib
rem move Dist\%PLATFORM%\FreeImage.dll %LIBRARY_BIN%\FreeImage.dll
rem move Dist\%PLATFORM%\FreeImage.h %LIBRARY_INC%
rem if errorlevel 1 exit 1
