include("test")

add_custom_target(test_scripts.copy_to_runtime
    ALL
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/game_of_life ${RUNTIME_DIRECTORY}/game_of_life/test
)

add_dependencies(test_scripts.copy_to_runtime scripts.copy_to_runtime)

add_lua_test(third_party/luagl
    ARGS luagl/test1.lua
)

add_lua_test(game_of_life
    ARGS game_of_life/game_of_life.lua
)

add_lua_test(game_of_life/with_map
    ARGS game_of_life/game_of_life.lua gospers_gun
)

add_lua_test(game_of_life/wrap
    ARGS game_of_life/game_of_life.lua --wrap
)

add_lua_test(game_of_life/wrap_with_map
    ARGS game_of_life/game_of_life.lua --wrap gospers_gun
)

add_lua_test(game_of_life/with_map_wrap
    ARGS game_of_life/game_of_life.lua gospers_gun --wrap
)

add_lua_test(game_of_life/square
    ARGS game_of_life/game_of_life.lua square
)

add_lua_test(game_of_life/rectangle
    ARGS game_of_life/game_of_life.lua rectangle
)

add_lua_test(game_of_life/size
    ARGS game_of_life/game_of_life.lua --size=200x300
)

add_lua_test(game_of_life/size_with_map
    ARGS game_of_life/game_of_life.lua --size=200x200 gospers_gun
)

add_lua_test(game_of_life/size_wrap
    ARGS game_of_life/game_of_life.lua --size=200x200 --wrap
)

add_lua_test(game_of_life/invalid_size
    ARGS game_of_life/game_of_life.lua --size=200
)

add_lua_test(game_of_life/map
    ARGS game_of_life/test/test_map.lua
)
