#pragma once

#include <vector>
#include <cmath>
#include <algorithm>
#include <numeric>

namespace iOSDynamicLib {
namespace Math {

class MathModule {
public:
    static int Add(int a, int b) { return a + b; }
    static double Add(double a, double b) { return a + b; }
    
    static int Subtract(int a, int b) { return a - b; }
    static double Subtract(double a, double b) { return a - b; }
    
    static int Multiply(int a, int b) { return a * b; }
    static double Multiply(double a, double b) { return a * b; }
    
    static int Divide(int a, int b) { 
        if (b == 0) return 0;
        return a / b; 
    }
    static double Divide(double a, double b) { 
        if (b == 0.0) return 0.0;
        return a / b; 
    }
    
    static double Power(double base, double exponent) { 
        return std::pow(base, exponent); 
    }
    static double SquareRoot(double value) { 
        return std::sqrt(value); 
    }
    
    static double Sin(double radians) { return std::sin(radians); }
    static double Cos(double radians) { return std::cos(radians); }
    static double Tan(double radians) { return std::tan(radians); }
    
    static double Sum(const std::vector<double>& values) {
        return std::accumulate(values.begin(), values.end(), 0.0);
    }
    static double Average(const std::vector<double>& values) {
        if (values.empty()) return 0.0;
        return Sum(values) / static_cast<double>(values.size());
    }
    static double Min(const std::vector<double>& values) {
        if (values.empty()) return 0.0;
        return *std::min_element(values.begin(), values.end());
    }
    static double Max(const std::vector<double>& values) {
        if (values.empty()) return 0.0;
        return *std::max_element(values.begin(), values.end());
    }
};

}
}
