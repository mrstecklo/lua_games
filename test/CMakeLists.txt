include("test")

add_custom_target(test_scripts.copy_to_runtime
    ALL
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/common ${RUNTIME_DIRECTORY}/test/common
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/game_of_life ${RUNTIME_DIRECTORY}/test/game_of_life
)

add_dependencies(test_scripts.copy_to_runtime scripts.copy_to_runtime)

add_lua_test(third_party/luagl
    ARGS luagl/test1.lua
)

add_lua_test(game_of_life
    ARGS game_of_life/main.lua
)

add_lua_test(game_of_life/with_map
    ARGS game_of_life/main.lua gospers_gun
)

add_lua_test(game_of_life/wrap
    ARGS game_of_life/main.lua --wrap
)

add_lua_test(game_of_life/wrap_with_map
    ARGS game_of_life/main.lua --wrap gospers_gun
)

add_lua_test(game_of_life/with_map_wrap
    ARGS game_of_life/main.lua gospers_gun --wrap
)

add_lua_test(game_of_life/size
    ARGS game_of_life/main.lua --size=200x300
)

add_lua_test(game_of_life/size_with_map
    ARGS game_of_life/main.lua --size=200x200 gospers_gun
)

add_lua_test(game_of_life/size_wrap
    ARGS game_of_life/main.lua --size=200x200 --wrap
)

add_lua_test(game_of_life/invalid_size
    ARGS game_of_life/main.lua --size=200
)

add_lua_test(game_of_life/life_map
    ARGS test/game_of_life/test_life_map.lua
)

add_lua_test(common/path
    ARGS test/common/test_path.lua
)

add_lua_test(common/map
    ARGS test/common/test_map.lua
)
