cmake_minimum_required(VERSION 3.28)
project(iOSDynamicLib VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_SCAN_FOR_MODULES ON)

set(CMAKE_OSX_DEPLOYMENT_TARGET "14.0")

add_library(iOSDynamicLib SHARED)

target_sources(iOSDynamicLib PUBLIC
    FILE_SET CXX_MODULES FILES
        modules/Math.ixx
        modules/Utils.ixx
        modules/Core.ixx
)

target_compile_options(iOSDynamicLib PRIVATE
    -Wno-error
)

target_compile_features(iOSDynamicLib PUBLIC cxx_std_20)

set_target_properties(iOSDynamicLib PROPERTIES
    OUTPUT_NAME "iOSDynamicLib"
)

if(IOS)
    set_target_properties(iOSDynamicLib PROPERTIES
        XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED "NO"
    )
endif()

install(TARGETS iOSDynamicLib
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)
