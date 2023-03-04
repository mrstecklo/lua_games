cmake_minimum_required(VERSION 3.24)

project(LuaGames)

set(MS_SDK_MAKEFILE_PATH_DESCRIPTION "Path to directory with Win32.mak. Usually C:/Program Files (x86)/Microsoft SDKs/Windows/v7.0A/Include")
set(MS_SDK_MAKEFILE_PATH "" CACHE PATH ${MS_SDK_MAKEFILE_PATH_DESCRIPTION})
if(NOT EXISTS ${MS_SDK_MAKEFILE_PATH}/Win32.mak)
    message(FATAL_ERROR "Please provide -DMS_SDK_MAKEFILE_PATH. ${MS_SDK_MAKEFILE_PATH_DESCRIPTION}")
endif()

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/build/cmake)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/runtime)
set(RUNTIME_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/$<CONFIG>)

add_subdirectory(third_party)
add_subdirectory(source)

enable_testing()
add_subdirectory(test)
