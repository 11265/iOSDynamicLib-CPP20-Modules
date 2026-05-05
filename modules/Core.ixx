export module Core;

import <string>;
import <memory>;

export namespace iOSDynamicLib {

class Library {
public:
    static Library& Instance();
    
    auto GetVersion() const -> const char*;
    auto Add(int a, int b) const -> int;
    auto Multiply(double a, double b) const -> double;
    auto ProcessString(const std::string& input) const -> std::string;
    
private:
    Library() = default;
    ~Library() = default;
    Library(const Library&) = delete;
    Library& operator=(const Library&) = delete;
};

}

export extern "C" {
    const char* GetVersion();
    int Add(int a, int b);
    double Multiply(double a, double b);
    const char* ProcessString(const char* input);
}
