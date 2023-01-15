# Lua games
## Building
``` shell
mkdir temp
cd temp
cmake ..
cmake --build .
cd runtime/<config>
```
## Game of Life
``` shell
lua game_of_life/game_of_life.lua [--wrap] [--size=<width>x<height> | <map_module>]
```
