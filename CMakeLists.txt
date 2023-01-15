cmake_minimum_required(VERSION 3.24)

project(LuaGames)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/build/cmake)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/runtime)
set(RUNTIME_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/$<CONFIG>)

add_subdirectory(third_party)
add_subdirectory(source)

enable_testing()
add_subdirectory(test)
