add_test(
    NAME third_party/luagl
    COMMAND lua luagl/test1.lua
    WORKING_DIRECTORY ${RUNTIME_DIRECTORY}
)

add_test(
    NAME game_of_life
    COMMAND lua ${CMAKE_SOURCE_DIR}/source/script/game_of_life.lua
    WORKING_DIRECTORY ${RUNTIME_DIRECTORY}
)
