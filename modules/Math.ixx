export module Math;

import <vector>;
import <cmath>;
import <algorithm>;
import <numeric>;

export namespace iOSDynamicLib {
namespace Math {

class MathModule {
public:
    static auto Add(int a, int b) -> int { return a + b; }
    static auto Add(double a, double b) -> double { return a + b; }
    
    static auto Subtract(int a, int b) -> int { return a - b; }
    static auto Subtract(double a, double b) -> double { return a - b; }
    
    static auto Multiply(int a, int b) -> int { return a * b; }
    static auto Multiply(double a, double b) -> double { return a * b; }
    
    static auto Divide(int a, int b) -> int { 
        if (b == 0) return 0;
        return a / b; 
    }
    static auto Divide(double a, double b) -> double { 
        if (b == 0.0) return 0.0;
        return a / b; 
    }
    
    static auto Power(double base, double exponent) -> double { 
        return std::pow(base, exponent); 
    }
    static auto SquareRoot(double value) -> double { 
        return std::sqrt(value); 
    }
    
    static auto Sin(double radians) -> double { return std::sin(radians); }
    static auto Cos(double radians) -> double { return std::cos(radians); }
    static auto Tan(double radians) -> double { return std::tan(radians); }
    
    static auto Sum(const std::vector<double>& values) -> double {
        return std::accumulate(values.begin(), values.end(), 0.0);
    }
    static auto Average(const std::vector<double>& values) -> double {
        if (values.empty()) return 0.0;
        return Sum(values) / static_cast<double>(values.size());
    }
    static auto Min(const std::vector<double>& values) -> double {
        if (values.empty()) return 0.0;
        return *std::min_element(values.begin(), values.end());
    }
    static auto Max(const std::vector<double>& values) -> double {
        if (values.empty()) return 0.0;
        return *std::max_element(values.begin(), values.end());
    }
};

}
}
