#!/bin/bash
set -e

LIBRARY_NAME="iOSDynamicLib"
CONFIGURATION="${1:-Release}"
OUTPUT_DIR="build"

echo "=== Building $LIBRARY_NAME Dynamic Library with Xcode/Clang ==="
echo "Configuration: $CONFIGURATION"
echo ""

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR/ios"
mkdir -p "$OUTPUT_DIR/simulator"

COMMON_FLAGS="-std=c++20 -O2 -fvisibility=hidden -fobjc-arc"

echo "=== Building for iOS (arm64) ==="
clang++ $COMMON_FLAGS \
    -target arm64-apple-ios14.0 \
    -isysroot $(xcrun --sdk iphoneos --show-sdk-path) \
    -framework UIKit \
    -framework Foundation \
    -dynamiclib \
    -install_name @rpath/${LIBRARY_NAME}.framework/${LIBRARY_NAME} \
    -o "$OUTPUT_DIR/ios/${LIBRARY_NAME}.dylib" \
    modules/FloatingWindow.mm

echo "Created: $OUTPUT_DIR/ios/${LIBRARY_NAME}.dylib"
file "$OUTPUT_DIR/ios/${LIBRARY_NAME}.dylib"

echo ""
echo "=== Building for iOS Simulator (arm64) ==="
clang++ $COMMON_FLAGS \
    -target arm64-apple-ios14.0-simulator \
    -isysroot $(xcrun --sdk iphonesimulator --show-sdk-path) \
    -framework UIKit \
    -framework Foundation \
    -dynamiclib \
    -install_name @rpath/${LIBRARY_NAME}.framework/${LIBRARY_NAME} \
    -o "$OUTPUT_DIR/simulator/${LIBRARY_NAME}_arm64.dylib" \
    modules/FloatingWindow.mm

echo "Created: $OUTPUT_DIR/simulator/${LIBRARY_NAME}_arm64.dylib"
file "$OUTPUT_DIR/simulator/${LIBRARY_NAME}_arm64.dylib"

echo ""
echo "=== Building for iOS Simulator (x86_64) ==="
clang++ $COMMON_FLAGS \
    -target x86_64-apple-ios14.0-simulator \
    -isysroot $(xcrun --sdk iphonesimulator --show-sdk-path) \
    -framework UIKit \
    -framework Foundation \
    -dynamiclib \
    -install_name @rpath/${LIBRARY_NAME}.framework/${LIBRARY_NAME} \
    -o "$OUTPUT_DIR/simulator/${LIBRARY_NAME}_x64.dylib" \
    modules/FloatingWindow.mm

echo "Created: $OUTPUT_DIR/simulator/${LIBRARY_NAME}_x64.dylib"
file "$OUTPUT_DIR/simulator/${LIBRARY_NAME}_x64.dylib"

echo ""
echo "=== Creating Fat Binary for Simulator ==="
lipo -create \
    "$OUTPUT_DIR/simulator/${LIBRARY_NAME}_arm64.dylib" \
    "$OUTPUT_DIR/simulator/${LIBRARY_NAME}_x64.dylib" \
    -output "$OUTPUT_DIR/simulator/${LIBRARY_NAME}.dylib"

echo "Created: $OUTPUT_DIR/simulator/${LIBRARY_NAME}.dylib"
file "$OUTPUT_DIR/simulator/${LIBRARY_NAME}.dylib"

echo ""
echo "=== Creating XCFramework ==="
xcodebuild -create-xcframework \
    -library "$OUTPUT_DIR/ios/${LIBRARY_NAME}.dylib" \
    -headers modules \
    -library "$OUTPUT_DIR/simulator/${LIBRARY_NAME}.dylib" \
    -headers modules \
    -output "$OUTPUT_DIR/${LIBRARY_NAME}.xcframework"

echo ""
echo "=== Build Complete ==="
echo "XCFramework: $OUTPUT_DIR/${LIBRARY_NAME}.xcframework"
echo ""
ls -la "$OUTPUT_DIR/${LIBRARY_NAME}.xcframework"
echo ""
echo "=== Binary Info ==="
find "$OUTPUT_DIR/${LIBRARY_NAME}.xcframework" -name "*.dylib" -exec file {} \;
