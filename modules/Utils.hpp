#pragma once

#include <string>
#include <vector>
#include <algorithm>
#include <cctype>

namespace iOSDynamicLib {
namespace Utils {

class UtilsModule {
public:
    static std::string ToUpper(const std::string& str) {
        std::string result = str;
        std::transform(result.begin(), result.end(), result.begin(), 
            [](unsigned char c) { return static_cast<char>(std::toupper(c)); });
        return result;
    }
    
    static std::string ToLower(const std::string& str) {
        std::string result = str;
        std::transform(result.begin(), result.end(), result.begin(), 
            [](unsigned char c) { return static_cast<char>(std::tolower(c)); });
        return result;
    }
    
    static std::string Trim(const std::string& str) {
        auto start = str.find_first_not_of(" \t\n\r");
        if (start == std::string::npos) return "";
        auto end = str.find_last_not_of(" \t\n\r");
        return str.substr(start, end - start + 1);
    }
    
    static std::vector<std::string> Split(const std::string& str, char delimiter) {
        std::vector<std::string> result;
        std::string token;
        for (char c : str) {
            if (c == delimiter) {
                if (!token.empty()) {
                    result.push_back(token);
                    token.clear();
                }
            } else {
                token += c;
            }
        }
        if (!token.empty()) result.push_back(token);
        return result;
    }
    
    static std::string Join(const std::vector<std::string>& parts, const std::string& delimiter) {
        std::string result;
        for (size_t i = 0; i < parts.size(); ++i) {
            if (i > 0) result += delimiter;
            result += parts[i];
        }
        return result;
    }
    
    static std::string Replace(const std::string& str, const std::string& from, const std::string& to) {
        std::string result = str;
        size_t pos = 0;
        while ((pos = result.find(from, pos)) != std::string::npos) {
            result.replace(pos, from.length(), to);
            pos += to.length();
        }
        return result;
    }
    
    static bool StartsWith(const std::string& str, const std::string& prefix) {
        return str.size() >= prefix.size() && str.compare(0, prefix.size(), prefix) == 0;
    }
    
    static bool EndsWith(const std::string& str, const std::string& suffix) {
        return str.size() >= suffix.size() && str.compare(str.size() - suffix.size(), suffix.size(), suffix) == 0;
    }
    
    static bool Contains(const std::string& str, const std::string& substr) {
        return str.find(substr) != std::string::npos;
    }
};

}
}
