export module Core;

import Math;
import Utils;
import <string>;

export namespace iOSDynamicLib {

class Library {
public:
    static Library& Instance() {
        static Library instance;
        return instance;
    }
    
    auto GetVersion() const -> const char* { return "1.0.0"; }
    
    auto Add(int a, int b) const -> int { 
        return Math::MathModule::Add(a, b); 
    }
    
    auto Multiply(double a, double b) const -> double { 
        return Math::MathModule::Multiply(a, b); 
    }
    
    auto ProcessString(const std::string& input) const -> std::string { 
        return Utils::UtilsModule::ToUpper(input); 
    }
    
private:
    Library() = default;
    ~Library() = default;
    Library(const Library&) = delete;
    Library& operator=(const Library&) = delete;
};

}

export extern "C" {
    inline const char* GetVersion() { return "1.0.0"; }
    inline int Add(int a, int b) { return iOSDynamicLib::Math::MathModule::Add(a, b); }
    inline double Multiply(double a, double b) { return iOSDynamicLib::Math::MathModule::Multiply(a, b); }
    inline const char* ProcessString(const char* input) {
        static thread_local std::string result;
        result = iOSDynamicLib::Utils::UtilsModule::ToUpper(std::string(input ? input : ""));
        return result.c_str();
    }
}
