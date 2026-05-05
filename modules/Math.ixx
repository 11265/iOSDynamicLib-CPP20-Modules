export module Math;

import <vector>;
import <cmath>;
import <stdexcept>;

export namespace iOSDynamicLib {
namespace Math {

class MathModule {
public:
    static auto Add(int a, int b) -> int;
    static auto Add(double a, double b) -> double;
    
    static auto Subtract(int a, int b) -> int;
    static auto Subtract(double a, double b) -> double;
    
    static auto Multiply(int a, int b) -> int;
    static auto Multiply(double a, double b) -> double;
    
    static auto Divide(int a, int b) -> int;
    static auto Divide(double a, double b) -> double;
    
    static auto Power(double base, double exponent) -> double;
    static auto SquareRoot(double value) -> double;
    
    static auto Sin(double radians) -> double;
    static auto Cos(double radians) -> double;
    static auto Tan(double radians) -> double;
    
    static auto Sum(const std::vector<double>& values) -> double;
    static auto Average(const std::vector<double>& values) -> double;
    static auto Min(const std::vector<double>& values) -> double;
    static auto Max(const std::vector<double>& values) -> double;
};

}
}
