#pragma once

#include <string>
#include <functional>

namespace iOSDynamicLib {

class FloatingWindow {
public:
    static FloatingWindow& Instance();
    
    void ShowFloatingButton();
    void HideFloatingButton();
    
    void ShowFloatingWindow();
    void HideFloatingWindow();
    
    void ToggleFloatingWindow();
    
    bool IsFloatingButtonVisible() const;
    bool IsFloatingWindowVisible() const;
    
    void SetWindowTitle(const std::string& title);
    void SetWindowContent(const std::string& content);
    
    void SetOnButtonClicked(std::function<void()> callback);
    void SetOnWindowOpened(std::function<void()> callback);
    void SetOnWindowClosed(std::function<void()> callback);

private:
    FloatingWindow();
    ~FloatingWindow();
    FloatingWindow(const FloatingWindow&) = delete;
    FloatingWindow& operator=(const FloatingWindow&) = delete;
    
    struct Impl;
    Impl* pImpl;
};

}

extern "C" {
    void ShowFloatingButton();
    void HideFloatingButton();
    void ToggleFloatingWindow();
    int IsFloatingButtonVisible();
    int IsFloatingWindowVisible();
}
