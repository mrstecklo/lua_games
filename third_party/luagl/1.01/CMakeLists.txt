add_library(luagl SHARED
    src/src/LuaGL.c
)
target_include_directories(luagl
    PUBLIC src/include
)
target_link_libraries(luagl
    PUBLIC
        lua
        opengl
)
set_target_properties(luagl
    PROPERTIES
        OUTPUT_NAME opengl
)

add_library(luaglut SHARED
    src/src/LuaGlut.c
)
target_include_directories(luaglut
    PUBLIC src/include
)
target_link_libraries(luaglut
    PUBLIC
        lua
    PRIVATE
        glut
)
set_target_properties(luaglut
    PROPERTIES
        OUTPUT_NAME glut
)

add_custom_command(
    TARGET luagl
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/src/tests ${RUNTIME_DIRECTORY}/luagl
)
