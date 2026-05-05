module Core;

import Math;
import Utils;
import <string>;

module :private;

namespace iOSDynamicLib {

Library& Library::Instance() {
    static Library instance;
    return instance;
}

auto Library::GetVersion() const -> const char* {
    return "1.0.0";
}

auto Library::Add(int a, int b) const -> int {
    return Math::MathModule::Add(a, b);
}

auto Library::Multiply(double a, double b) const -> double {
    return Math::MathModule::Multiply(a, b);
}

auto Library::ProcessString(const std::string& input) const -> std::string {
    return Utils::UtilsModule::ToUpper(input);
}

}

extern "C" {

const char* GetVersion() {
    return "1.0.0";
}

int Add(int a, int b) {
    return iOSDynamicLib::Math::MathModule::Add(a, b);
}

double Multiply(double a, double b) {
    return iOSDynamicLib::Math::MathModule::Multiply(a, b);
}

const char* ProcessString(const char* input) {
    static thread_local std::string result;
    result = iOSDynamicLib::Utils::UtilsModule::ToUpper(std::string(input));
    return result.c_str();
}

}
