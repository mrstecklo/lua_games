add_subdirectory(timer)

add_custom_target(scripts.copy_to_runtime
    ALL
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/script ${RUNTIME_DIRECTORY}
)
add_dependencies(scripts.copy_to_runtime
    argparse
)
