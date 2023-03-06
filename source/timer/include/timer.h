#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include <lua.h>

LUA_API int luaopen_timer (lua_State *L);

#ifdef __cplusplus
} // extern "C"
#endif
