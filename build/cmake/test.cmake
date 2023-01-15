function(add_lua_test NAME)
    cmake_parse_arguments(TEST "" "" "ARGS" ${ARGN})
    add_test(
        NAME ${NAME}
        COMMAND ${RUNTIME_DIRECTORY}/lua ${TEST_ARGS}
        WORKING_DIRECTORY ${RUNTIME_DIRECTORY}
    )
endfunction()
