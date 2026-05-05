module Utils;

import <algorithm>;
import <sstream>;
import <chrono>;

#ifdef __APPLE__
import <mach/mach_time.h>;
#endif

module :private;

namespace iOSDynamicLib {
namespace Utils {

auto UtilsModule::ToUpper(const std::string& str) -> std::string {
    std::string result = str;
    std::transform(result.begin(), result.end(), result.begin(), ::toupper);
    return result;
}

auto UtilsModule::ToLower(const std::string& str) -> std::string {
    std::string result = str;
    std::transform(result.begin(), result.end(), result.begin(), ::tolower);
    return result;
}

auto UtilsModule::Trim(const std::string& str) -> std::string {
    auto start = std::find_if_not(str.begin(), str.end(), ::isspace);
    auto end = std::find_if_not(str.rbegin(), str.rend(), ::isspace).base();
    
    if (start >= end) {
        return "";
    }
    return std::string(start, end);
}

auto UtilsModule::Split(const std::string& str, char delimiter) -> std::vector<std::string> {
    std::vector<std::string> tokens;
    std::stringstream ss(str);
    std::string token;
    
    while (std::getline(ss, token, delimiter)) {
        tokens.push_back(token);
    }
    
    return tokens;
}

auto UtilsModule::Join(const std::vector<std::string>& parts, const std::string& delimiter) -> std::string {
    std::string result;
    for (size_t i = 0; i < parts.size(); ++i) {
        if (i > 0) {
            result += delimiter;
        }
        result += parts[i];
    }
    return result;
}

auto UtilsModule::Replace(const std::string& str, const std::string& from, const std::string& to) -> std::string {
    if (from.empty()) {
        return str;
    }
    
    std::string result = str;
    size_t pos = 0;
    
    while ((pos = result.find(from, pos)) != std::string::npos) {
        result.replace(pos, from.length(), to);
        pos += to.length();
    }
    
    return result;
}

auto UtilsModule::StartsWith(const std::string& str, const std::string& prefix) -> bool {
    if (prefix.size() > str.size()) {
        return false;
    }
    return str.compare(0, prefix.size(), prefix) == 0;
}

auto UtilsModule::EndsWith(const std::string& str, const std::string& suffix) -> bool {
    if (suffix.size() > str.size()) {
        return false;
    }
    return str.compare(str.size() - suffix.size(), suffix.size(), suffix) == 0;
}

auto UtilsModule::Contains(const std::string& str, const std::string& substr) -> bool {
    return str.find(substr) != std::string::npos;
}

Timer::Timer() : m_startTime(0), m_endTime(0), m_running(false) {
}

auto Timer::Start() -> void {
#ifdef __APPLE__
    m_startTime = static_cast<double>(mach_absolute_time()) / 1e9;
#else
    m_startTime = static_cast<double>(std::chrono::high_resolution_clock::now().time_since_epoch().count()) / 1e9;
#endif
    m_running = true;
}

auto Timer::Stop() -> void {
#ifdef __APPLE__
    m_endTime = static_cast<double>(mach_absolute_time()) / 1e9;
#else
    m_endTime = static_cast<double>(std::chrono::high_resolution_clock::now().time_since_epoch().count()) / 1e9;
#endif
    m_running = false;
}

auto Timer::GetElapsedMilliseconds() const -> double {
    return GetElapsedSeconds() * 1000.0;
}

auto Timer::GetElapsedSeconds() const -> double {
    double endTime = m_running ? 
#ifdef __APPLE__
        static_cast<double>(mach_absolute_time()) / 1e9 :
#else
        static_cast<double>(std::chrono::high_resolution_clock::now().time_since_epoch().count()) / 1e9 :
#endif
        m_endTime;
    return endTime - m_startTime;
}

}
}
