#pragma once

#include "Math.hpp"
#include "Utils.hpp"
#include <string>

namespace iOSDynamicLib {

class Library {
public:
    static Library& Instance() {
        static Library instance;
        return instance;
    }
    
    const char* GetVersion() const { return "1.0.0"; }
    
    int Add(int a, int b) const { 
        return Math::MathModule::Add(a, b); 
    }
    
    double Multiply(double a, double b) const { 
        return Math::MathModule::Multiply(a, b); 
    }
    
    std::string ProcessString(const std::string& input) const { 
        return Utils::UtilsModule::ToUpper(input); 
    }
    
private:
    Library() = default;
    ~Library() = default;
    Library(const Library&) = delete;
    Library& operator=(const Library&) = delete;
};

}

extern "C" {
    const char* GetVersion();
    int Add(int a, int b);
    double Multiply(double a, double b);
    const char* ProcessString(const char* input);
}
