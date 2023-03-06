add_library(timer SHARED
    source/timer.cpp
)
target_include_directories(timer
    PUBLIC include
)
target_link_libraries(timer
    PUBLIC
        lua
)
