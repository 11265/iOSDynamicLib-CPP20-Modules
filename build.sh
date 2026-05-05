#!/bin/bash
set -e

LIBRARY_NAME="iOSDynamicLib"
CONFIGURATION="${1:-Release}"
OUTPUT_DIR="build"

echo "=== Building $LIBRARY_NAME with Xcode/Clang ==="
echo "Configuration: $CONFIGURATION"
echo ""

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR/ios"
mkdir -p "$OUTPUT_DIR/simulator"

COMMON_FLAGS="-std=c++20 -O2 -fvisibility=hidden"

echo "=== Building for iOS (arm64) ==="
clang++ $COMMON_FLAGS \
    -target arm64-apple-ios14.0 \
    -isysroot $(xcrun --sdk iphoneos --show-sdk-path) \
    -c modules/Library.cpp -o "$OUTPUT_DIR/ios/Library.o"

ar rcs "$OUTPUT_DIR/ios/lib${LIBRARY_NAME}.a" "$OUTPUT_DIR/ios/"*.o
echo "Created: $OUTPUT_DIR/ios/lib${LIBRARY_NAME}.a"

echo ""
echo "=== Building for iOS Simulator (arm64) ==="
clang++ $COMMON_FLAGS \
    -target arm64-apple-ios14.0-simulator \
    -isysroot $(xcrun --sdk iphonesimulator --show-sdk-path) \
    -c modules/Library.cpp -o "$OUTPUT_DIR/simulator/Library_arm64.o"

ar rcs "$OUTPUT_DIR/simulator/lib${LIBRARY_NAME}_arm64.a" "$OUTPUT_DIR/simulator/"*_arm64.o
echo "Created: $OUTPUT_DIR/simulator/lib${LIBRARY_NAME}_arm64.a"

echo ""
echo "=== Building for iOS Simulator (x86_64) ==="
clang++ $COMMON_FLAGS \
    -target x86_64-apple-ios14.0-simulator \
    -isysroot $(xcrun --sdk iphonesimulator --show-sdk-path) \
    -c modules/Library.cpp -o "$OUTPUT_DIR/simulator/Library_x64.o"

ar rcs "$OUTPUT_DIR/simulator/lib${LIBRARY_NAME}_x64.a" "$OUTPUT_DIR/simulator/"*_x64.o
echo "Created: $OUTPUT_DIR/simulator/lib${LIBRARY_NAME}_x64.a"

echo ""
echo "=== Creating Fat Binary for Simulator ==="
lipo -create \
    "$OUTPUT_DIR/simulator/lib${LIBRARY_NAME}_arm64.a" \
    "$OUTPUT_DIR/simulator/lib${LIBRARY_NAME}_x64.a" \
    -output "$OUTPUT_DIR/simulator/lib${LIBRARY_NAME}.a"
echo "Created: $OUTPUT_DIR/simulator/lib${LIBRARY_NAME}.a"

echo ""
echo "=== Creating XCFramework ==="
xcodebuild -create-xcframework \
    -library "$OUTPUT_DIR/ios/lib${LIBRARY_NAME}.a" \
    -headers modules \
    -library "$OUTPUT_DIR/simulator/lib${LIBRARY_NAME}.a" \
    -headers modules \
    -output "$OUTPUT_DIR/${LIBRARY_NAME}.xcframework"

echo ""
echo "=== Build Complete ==="
echo "XCFramework: $OUTPUT_DIR/${LIBRARY_NAME}.xcframework"
echo ""
ls -la "$OUTPUT_DIR/${LIBRARY_NAME}.xcframework"
