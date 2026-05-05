export module Utils;

import <string>;
import <vector>;
import <chrono>;

export namespace iOSDynamicLib {
namespace Utils {

class UtilsModule {
public:
    static auto ToUpper(const std::string& str) -> std::string;
    static auto ToLower(const std::string& str) -> std::string;
    static auto Trim(const std::string& str) -> std::string;
    static auto Split(const std::string& str, char delimiter) -> std::vector<std::string>;
    static auto Join(const std::vector<std::string>& parts, const std::string& delimiter) -> std::string;
    static auto Replace(const std::string& str, const std::string& from, const std::string& to) -> std::string;
    static auto StartsWith(const std::string& str, const std::string& prefix) -> bool;
    static auto EndsWith(const std::string& str, const std::string& suffix) -> bool;
    static auto Contains(const std::string& str, const std::string& substr) -> bool;
};

class Timer {
public:
    Timer();
    auto Start() -> void;
    auto Stop() -> void;
    auto GetElapsedMilliseconds() const -> double;
    auto GetElapsedSeconds() const -> double;
    
private:
    double m_startTime;
    double m_endTime;
    bool m_running;
};

}
}
