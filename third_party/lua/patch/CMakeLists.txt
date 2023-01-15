cmake_minimum_required(VERSION 3.24)
project(lua)

add_library(lua SHARED
    src/lapi.c
    src/lcode.c
    src/lctype.c
    src/ldebug.c
    src/ldo.c
    src/ldump.c
    src/lfunc.c
    src/lgc.c
    src/llex.c
    src/lmem.c
    src/lobject.c
    src/lopcodes.c
    src/lparser.c
    src/lstate.c
    src/lstring.c
    src/ltable.c
    src/ltm.c
    src/lundump.c
    src/lvm.c
    src/lzio.c
    src/lauxlib.c
    src/lbaselib.c
    src/lcorolib.c
    src/ldblib.c
    src/liolib.c
    src/lmathlib.c
    src/loadlib.c
    src/loslib.c
    src/lstrlib.c
    src/ltablib.c
    src/lutf8lib.c
    src/linit.c
)
target_include_directories(lua
    PUBLIC src
)
target_compile_definitions(lua
    PUBLIC LUA_COMPAT_5_3
    PUBLIC LUA_BUILD_AS_DLL
)

add_executable(lua.executable
    src/lua.c
)
target_link_libraries(lua.executable
    PRIVATE lua
)
set_target_properties(lua.executable
    PROPERTIES
        OUTPUT_NAME lua
)

install(
    TARGETS
        lua
        lua.executable
)
install(
    FILES
        src/luaconf.h
        src/lua.h
        src/lualib.h
        src/lauxlib.h
        src/lua.hpp
    DESTINATION include
)
