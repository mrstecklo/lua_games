# Lua games
## Building
``` shell
mkdir temp
cd temp
cmake -DMS_SDK_MAKEFILE_PATH=path/to/dir/with/Win32.mak ..
cmake --build .
cd runtime/<config>
```
## Game of Life
``` shell
lua game_of_life/main.lua [--wrap] [--size=<width>x<height> | <map_module>]
```

## Snake
``` shell
lua snake/main.lua
```

## Path Finder
``` shell
lua path_finder/main.lua
```
