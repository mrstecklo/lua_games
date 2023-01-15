include(ExternalProject)

set(PREFIX ${CMAKE_CURRENT_BINARY_DIR}/lua.internal)
set(INSTALL_DIR ${PREFIX}/install)

ExternalProject_Add(lua.internal
    URL http://www.lua.org/ftp/lua-5.4.4.tar.gz
    PREFIX ${PREFIX}
    INSTALL_DIR ${INSTALL_DIR}
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/patch <SOURCE_DIR>
    CMAKE_ARGS
        -D CMAKE_INSTALL_PREFIX=<INSTALL_DIR>
)

add_custom_target(lua.copy_to_runtime
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${INSTALL_DIR}/bin ${RUNTIME_DIRECTORY}
)

add_library(lua INTERFACE)
target_include_directories(lua
    INTERFACE ${INSTALL_DIR}/include
)
target_link_libraries(lua
    INTERFACE ${INSTALL_DIR}/lib/lua.lib
)
target_compile_definitions(lua
    INTERFACE LUA_COMPAT_5_3
    INTERFACE LUA_BUILD_AS_DLL
)
add_dependencies(lua.copy_to_runtime lua.internal)
add_dependencies(lua lua.copy_to_runtime)
