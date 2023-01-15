include(ExternalProject)

set(PREFIX ${CMAKE_CURRENT_BINARY_DIR}/glut.internal)
set(INSTALL_DIR ${PREFIX}/install)
cmake_path(CONVERT ${INSTALL_DIR}/lib TO_NATIVE_PATH_LIST LIBINSTALL)
cmake_path(CONVERT ${INSTALL_DIR}/include/GL TO_NATIVE_PATH_LIST INCLUDEINSTALL)
cmake_path(CONVERT ${RUNTIME_DIRECTORY} TO_NATIVE_PATH_LIST DLLINSTALL)

ExternalProject_Add(glut.internal
    URL https://www.opengl.org/resources/libraries/glut/glut-3.6.tar.gz
    PREFIX ${PREFIX}
    INSTALL_DIR ${INSTALL_DIR}
    BUILD_IN_SOURCE TRUE
    CONFIGURE_COMMAND
        ${CMAKE_COMMAND} -E make_directory ${LIBINSTALL} ${INCLUDEINSTALL} ${DLLINSTALL}
    BUILD_COMMAND
        ${CMAKE_COMMAND} -E chdir <SOURCE_DIR>/lib/glut
        ${CMAKE_COMMAND} -E env "INCLUDE=C:\\Program Files (x86)\\Microsoft SDKs\\Windows\\v7.0A\\Include"
        nmake
            nodebug=1
            LIBINSTALL=${LIBINSTALL}
            INCLUDEINSTALL=${INCLUDEINSTALL}
            DLLINSTALL=${DLLINSTALL}
            -f Makefile.win
    INSTALL_COMMAND ""
)

add_library(glut INTERFACE)
target_include_directories(glut
    INTERFACE ${INCLUDEINSTALL}
)
target_link_libraries(glut
    INTERFACE ${LIBINSTALL}/glut32.lib
)
add_dependencies(glut glut.internal)
