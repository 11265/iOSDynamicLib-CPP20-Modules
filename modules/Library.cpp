#include "Library.hpp"

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
    result = iOSDynamicLib::Utils::UtilsModule::ToUpper(std::string(input ? input : ""));
    return result.c_str();
}

}
