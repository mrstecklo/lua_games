include("test")

add_lua_test(third_party/luagl
    ARGS luagl/test1.lua
)

add_lua_test(game_of_life
    ARGS game_of_life/game_of_life.lua
)
