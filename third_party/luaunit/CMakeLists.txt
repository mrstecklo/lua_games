include(ExternalProject)

set(PREFIX ${CMAKE_CURRENT_BINARY_DIR}/luaunit.internal)
set(INSTALL_DIR ${PREFIX}/install)

ExternalProject_Add(luaunit.internal
    URL https://github.com/bluebird75/luaunit/releases/download/LUAUNIT_V3_4/luaunit-3.4.tar.gz
    PREFIX ${PREFIX}
    INSTALL_DIR ${INSTALL_DIR}
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/patch <SOURCE_DIR>
    CMAKE_ARGS
        -D CMAKE_INSTALL_PREFIX=<INSTALL_DIR>
)

add_custom_target(luaunit
    COMMAND ${CMAKE_COMMAND} -E copy ${INSTALL_DIR}/luaunit.lua ${RUNTIME_DIRECTORY}
)
add_dependencies(luaunit luaunit.internal)
