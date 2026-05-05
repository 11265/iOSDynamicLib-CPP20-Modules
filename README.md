# iOS Dynamic Library (C++20 Modules)

使用 **C++20 Modules** 构建的 iOS 动态库，支持 GitHub Actions 自动编译。

## C++20 Modules 特性

本项目使用 C++20 Modules 替代传统的 `#include` 头文件：

```cpp
// 传统方式 (不使用)
#include <string>
#include <vector>

// C++20 Modules 方式 (使用)
import <string>;
import <vector>;
import Math;
import Utils;
```

## 项目结构

```
iOSDynamicLib/
├── CMakeLists.txt              # CMake 配置 (支持 Modules)
├── modules/                    # C++20 模块文件
│   ├── Core.ixx               # 核心模块接口
│   ├── Core.cppm              # 核心模块实现
│   ├── Math.ixx               # 数学模块接口
│   ├── Math.cppm              # 数学模块实现
│   ├── Utils.ixx              # 工具模块接口
│   └── Utils.cppm             # 工具模块实现
└── .github/
    └── workflows/
        └── build.yml          # GitHub Actions 构建工作流
```

## 模块说明

### Core 模块 (`Core.ixx`)
```cpp
export module Core;

import <string>;

export namespace iOSDynamicLib {
    class Library {
    public:
        static Library& Instance();
        auto GetVersion() const -> const char*;
        auto Add(int a, int b) const -> int;
        auto Multiply(double a, double b) const -> double;
        auto ProcessString(const std::string& input) const -> std::string;
    };
}

export extern "C" {
    const char* GetVersion();
    int Add(int a, int b);
    double Multiply(double a, double b);
    const char* ProcessString(const char* input);
}
```

### Math 模块 (`Math.ixx`)
```cpp
export module Math;

import <vector>;

export namespace iOSDynamicLib {
namespace Math {
    class MathModule {
    public:
        static auto Add(int a, int b) -> int;
        static auto Multiply(double a, double b) -> double;
        static auto Power(double base, double exponent) -> double;
        static auto SquareRoot(double value) -> double;
        static auto Sum(const std::vector<double>& values) -> double;
        static auto Average(const std::vector<double>& values) -> double;
        // ... 更多函数
    };
}
}
```

### Utils 模块 (`Utils.ixx`)
```cpp
export module Utils;

import <string>;
import <vector>;

export namespace iOSDynamicLib {
namespace Utils {
    class UtilsModule {
    public:
        static auto ToUpper(const std::string& str) -> std::string;
        static auto ToLower(const std::string& str) -> std::string;
        static auto Trim(const std::string& str) -> std::string;
        static auto Split(const std::string& str, char delimiter) -> std::vector<std::string>;
        // ... 更多函数
    };
    
    class Timer { /* ... */ };
}
}
```

## 本地构建

### 前置要求
- **CMake 3.28+**
- **Xcode 15.0+** (需要 AppleClang 支持 C++20 Modules)
- **iOS SDK 14.0+**

### 构建 iOS Framework

```bash
# 创建构建目录
mkdir build && cd build

# 配置 (iOS 设备 - arm64)
cmake .. \
  -DCMAKE_SYSTEM_NAME=iOS \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=14.0 \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_CXX_SCAN_FOR_MODULES=ON \
  -GXcode

# 编译
cmake --build . --config Release
```

### 创建 XCFramework

```bash
# iOS (arm64)
cmake -B build/ios \
  -DCMAKE_SYSTEM_NAME=iOS \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_CXX_SCAN_FOR_MODULES=ON \
  -GXcode
cmake --build build/ios --config Release

# Simulator (x86_64)
cmake -B build/sim-x86 \
  -DCMAKE_SYSTEM_NAME=iOS \
  -DCMAKE_OSX_ARCHITECTURES=x86_64 \
  -DCMAKE_CXX_SCAN_FOR_MODULES=ON \
  -GXcode
cmake --build build/sim-x86 --config Release

# Simulator (arm64 - M1/M2 Mac)
cmake -B build/sim-arm64 \
  -DCMAKE_SYSTEM_NAME=iOS \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_CXX_SCAN_FOR_MODULES=ON \
  -GXcode
cmake --build build/sim-arm64 --config Release

# 创建 XCFramework
xcodebuild -create-xcframework \
  -framework build/ios/iOSDynamicLib.framework \
  -framework build/sim-x86/iOSDynamicLib.framework \
  -output build/iOSDynamicLib.xcframework
```

## GitHub Actions

### 自动构建
推送到 `main`/`master` 分支自动触发构建。

### 手动触发
1. GitHub 仓库 → **Actions**
2. 选择 **Build iOS Dynamic Library (C++20 Modules)**
3. 选择构建配置 (Release/Debug)
4. 点击 **Run workflow**

### 构建产物
- `iOSDynamicLib.xcframework` - 跨平台 Framework
- `iOSDynamicLib-1.0.0-cpp20-modules.xcframework.zip` - ZIP 压缩包

## 使用方法

### Swift 调用

```swift
import iOSDynamicLib

// C API
let version = String(cString: GetVersion())
let sum = Add(10, 20)
let product = Multiply(3.14, 2.0)
let processed = String(cString: ProcessString("hello"))
```

### Objective-C 调用

```objc
#import <iOSDynamicLib/iOSDynamicLib.h>

NSString *version = [NSString stringWithUTF8String:GetVersion()];
int sum = Add(10, 20);
double product = Multiply(3.14, 2.0);
```

### C++ 调用 (使用 Modules)

```cpp
import Core;
import Math;
import Utils;

int main() {
    // 使用命名空间 API
    auto result = iOSDynamicLib::Math::MathModule::Add(10, 20);
    auto text = iOSDynamicLib::Utils::UtilsModule::ToUpper("hello");
    
    // 使用单例模式
    auto& lib = iOSDynamicLib::Library::Instance();
    auto version = lib.GetVersion();
    
    return 0;
}
```

## C++20 Modules 优势

| 特性 | 传统 `#include` | C++20 Modules |
|------|----------------|---------------|
| 编译速度 | 慢 (重复解析) | 快 (预编译) |
| 隔离性 | 污染命名空间 | 完全隔离 |
| 依赖管理 | 容易循环依赖 | 明确依赖关系 |
| 二进制兼容 | 不稳定 | 更稳定 |

## 技术要求

- **编译器**: AppleClang 15.0+ (Xcode 15.0+)
- **CMake**: 3.28+
- **C++ 标准**: C++20
- **最低部署目标**: iOS 14.0

## 许可证

MIT License
