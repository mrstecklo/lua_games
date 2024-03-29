include("test")

add_custom_target(test_scripts.copy_to_runtime
    ALL
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/common ${RUNTIME_DIRECTORY}/test/common
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/game_of_life ${RUNTIME_DIRECTORY}/test/game_of_life
)

add_dependencies(test_scripts.copy_to_runtime
    scripts.copy_to_runtime
    luaunit
)

add_lua_test(third_party/luagl
    ARGS luagl/test1.lua
)

add_lua_test(game_of_life/life_map
    ARGS test/game_of_life/test_life_map.lua
)

add_lua_test(game_of_life/program_options
    ARGS test/game_of_life/test_program_options.lua
)

add_lua_test(common/path
    ARGS test/common/test_path.lua
)

add_lua_test(common/map
    ARGS test/common/test_map.lua
)
