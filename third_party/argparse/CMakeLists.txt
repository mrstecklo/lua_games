include(ExternalProject)

set(PREFIX ${CMAKE_CURRENT_BINARY_DIR}/argparse.internal)
set(INSTALL_DIR ${PREFIX}/install)

ExternalProject_Add(argparse.internal
    URL https://github.com/mpeterv/argparse/archive/refs/tags/0.6.0.tar.gz
    PREFIX ${PREFIX}
    INSTALL_DIR ${INSTALL_DIR}
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/patch <SOURCE_DIR>
    CMAKE_ARGS
        -D CMAKE_INSTALL_PREFIX=<INSTALL_DIR>
)

add_custom_target(argparse
    COMMAND ${CMAKE_COMMAND} -E copy ${INSTALL_DIR}/argparse.lua ${RUNTIME_DIRECTORY}
)
add_dependencies(argparse argparse.internal)
