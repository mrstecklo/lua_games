#define LUA_LIB

#include <timer.h>
#include <lua.hpp>
#include <chrono>
#include <iostream>

int l_GetTime(lua_State* L)
{
    auto time = std::chrono::high_resolution_clock::now().time_since_epoch();
    const auto seconds = std::chrono::duration_cast<std::chrono::seconds>(time);
    time -= seconds;
    const auto milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(time);
    time -= milliseconds;
    const auto microseconds = std::chrono::duration_cast<std::chrono::microseconds>(time);

    lua_pushinteger(L, seconds.count());
    lua_pushinteger(L, milliseconds.count());
    lua_pushinteger(L, microseconds.count());
    return 3;
}

static const luaL_Reg funcs[] = {
  {"GetTime", l_GetTime},
  {NULL, NULL}
};

LUA_API int luaopen_timer(lua_State *L)
{
  luaL_newlib(L, funcs);
  return 1;
}
