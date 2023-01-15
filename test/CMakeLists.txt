add_test(
    NAME third_party/luagl
    COMMAND lua luagl/test1.lua
    WORKING_DIRECTORY ${RUNTIME_DIRECTORY}
)
