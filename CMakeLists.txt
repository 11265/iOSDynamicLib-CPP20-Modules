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
        modules/Math.cppm
        modules/Utils.ixx
        modules/Utils.cppm
        modules/Core.ixx
        modules/Core.cppm
)

target_compile_features(iOSDynamicLib PUBLIC cxx_std_20)

set_target_properties(iOSDynamicLib PROPERTIES
    FRAMEWORK TRUE
    FRAMEWORK_VERSION A
    MACOSX_FRAMEWORK_IDENTIFIER "com.iosdynamiclib.iOSDynamicLib"
    MACOSX_FRAMEWORK_SHORT_VERSION_STRING ${PROJECT_VERSION}
    MACOSX_FRAMEWORK_BUNDLE_VERSION ${PROJECT_VERSION}
    OUTPUT_NAME "iOSDynamicLib"
)

if(IOS)
    set_target_properties(iOSDynamicLib PROPERTIES
        XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED "NO"
    )
endif()

install(TARGETS iOSDynamicLib
    FRAMEWORK DESTINATION .
)
