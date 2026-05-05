module Math;

import <algorithm>;
import <numeric>;
import <stdexcept>;

module :private;

namespace iOSDynamicLib {
namespace Math {

auto MathModule::Add(int a, int b) -> int {
    return a + b;
}

auto MathModule::Add(double a, double b) -> double {
    return a + b;
}

auto MathModule::Subtract(int a, int b) -> int {
    return a - b;
}

auto MathModule::Subtract(double a, double b) -> double {
    return a - b;
}

auto MathModule::Multiply(int a, int b) -> int {
    return a * b;
}

auto MathModule::Multiply(double a, double b) -> double {
    return a * b;
}

auto MathModule::Divide(int a, int b) -> int {
    if (b == 0) {
        throw std::runtime_error("Division by zero");
    }
    return a / b;
}

auto MathModule::Divide(double a, double b) -> double {
    if (b == 0.0) {
        throw std::runtime_error("Division by zero");
    }
    return a / b;
}

auto MathModule::Power(double base, double exponent) -> double {
    return std::pow(base, exponent);
}

auto MathModule::SquareRoot(double value) -> double {
    if (value < 0) {
        throw std::runtime_error("Cannot calculate square root of negative number");
    }
    return std::sqrt(value);
}

auto MathModule::Sin(double radians) -> double {
    return std::sin(radians);
}

auto MathModule::Cos(double radians) -> double {
    return std::cos(radians);
}

auto MathModule::Tan(double radians) -> double {
    return std::tan(radians);
}

auto MathModule::Sum(const std::vector<double>& values) -> double {
    return std::accumulate(values.begin(), values.end(), 0.0);
}

auto MathModule::Average(const std::vector<double>& values) -> double {
    if (values.empty()) {
        return 0.0;
    }
    return Sum(values) / static_cast<double>(values.size());
}

auto MathModule::Min(const std::vector<double>& values) -> double {
    if (values.empty()) {
        throw std::runtime_error("Cannot find minimum of empty vector");
    }
    return *std::min_element(values.begin(), values.end());
}

auto MathModule::Max(const std::vector<double>& values) -> double {
    if (values.empty()) {
        throw std::runtime_error("Cannot find maximum of empty vector");
    }
    return *std::max_element(values.begin(), values.end());
}

}
}
