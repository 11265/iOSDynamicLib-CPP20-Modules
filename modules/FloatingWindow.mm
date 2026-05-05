#import "FloatingWindow.hpp"
#import <UIKit/UIKit.h>

@interface FloatingButton : UIButton
@property (nonatomic, assign) CGPoint lastTouchPoint;
@property (nonatomic, assign) BOOL isDragging;
@end

@implementation FloatingButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.9];
        self.layer.cornerRadius = 30;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 5;
        
        [self setTitle:@"+" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.isDragging = NO;
    }
    
    CGPoint newCenter = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    
    CGRect bounds = self.superview.bounds;
    newCenter.x = MAX(self.frame.size.width/2, MIN(newCenter.x, bounds.size.width - self.frame.size.width/2));
    newCenter.y = MAX(self.frame.size.height/2 + 50, MIN(newCenter.y, bounds.size.height - self.frame.size.height/2 - 50));
    
    self.center = newCenter;
    [gesture setTranslation:CGPointZero inView:self.superview];
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat distance = sqrt(translation.x * translation.x + translation.y * translation.y);
        if (distance > 5) {
            self.isDragging = YES;
        }
    }
}

@end

@interface FloatingWindowView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation FloatingWindowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        self.layer.cornerRadius = 16;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 10;
        self.clipsToBounds = NO;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, frame.size.width - 80, 30)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.text = @"Floating Window";
        [self addSubview:_titleLabel];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _closeButton.frame = CGRectMake(frame.size.width - 44, 12, 32, 32);
        [_closeButton setTitle:@"✕" forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _closeButton.tintColor = [UIColor systemGrayColor];
        [self addSubview:_closeButton];
        
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(16, 56, frame.size.width - 32, frame.size.height - 80)];
        _contentTextView.font = [UIFont systemFontOfSize:14];
        _contentTextView.text = @"Welcome to Floating Window!\n\nThis is a dynamic library demo.\n\nYou can drag the floating button anywhere on the screen.";
        _contentTextView.editable = NO;
        _contentTextView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentTextView];
    }
    return self;
}

@end

@interface FloatingWindowController : NSObject
@property (nonatomic, strong) FloatingButton *floatingButton;
@property (nonatomic, strong) UIWindow *floatingWindow;
@property (nonatomic, strong) FloatingWindowView *windowView;
@property (nonatomic, assign) BOOL isWindowVisible;
@property (nonatomic, copy) void (^onButtonClicked)(void);
@property (nonatomic, copy) void (^onWindowOpened)(void);
@property (nonatomic, copy) void (^onWindowClosed)(void);
@end

@implementation FloatingWindowController

+ (instancetype)sharedInstance {
    static FloatingWindowController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FloatingWindowController alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupFloatingButton];
    }
    return self;
}

- (void)setupFloatingButton {
    UIWindowScene *windowScene = nil;
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            windowScene = (UIWindowScene *)scene;
            break;
        }
    }
    
    if (!windowScene) return;
    
    UIWindow *keyWindow = nil;
    for (UIWindow *window in windowScene.windows) {
        if (window.isKeyWindow) {
            keyWindow = window;
            break;
        }
    }
    
    if (!keyWindow) return;
    
    self.floatingButton = [[FloatingButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.floatingButton.center = CGPointMake(keyWindow.bounds.size.width - 50, 150);
    
    [self.floatingButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [keyWindow addSubview:self.floatingButton];
}

- (void)buttonTapped:(UIButton *)sender {
    if (self.floatingButton.isDragging) {
        return;
    }
    
    if (self.onButtonClicked) {
        self.onButtonClicked();
    }
    
    [self toggleFloatingWindow];
}

- (void)toggleFloatingWindow {
    if (self.isWindowVisible) {
        [self hideFloatingWindow];
    } else {
        [self showFloatingWindow];
    }
}

- (void)showFloatingWindow {
    if (self.isWindowVisible) return;
    
    UIWindowScene *windowScene = nil;
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            windowScene = (UIWindowScene *)scene;
            break;
        }
    }
    
    if (!windowScene) return;
    
    UIWindow *keyWindow = nil;
    for (UIWindow *window in windowScene.windows) {
        if (window.isKeyWindow) {
            keyWindow = window;
            break;
        }
    }
    
    if (!keyWindow) return;
    
    CGFloat windowWidth = keyWindow.bounds.size.width - 40;
    CGFloat windowHeight = 300;
    CGFloat windowX = 20;
    CGFloat windowY = (keyWindow.bounds.size.height - windowHeight) / 2;
    
    self.windowView = [[FloatingWindowView alloc] initWithFrame:CGRectMake(windowX, windowY, windowWidth, windowHeight)];
    
    self.floatingWindow = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.floatingWindow.frame = keyWindow.bounds;
    self.floatingWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.floatingWindow.windowLevel = UIWindowLevelAlert + 1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [self.floatingWindow addGestureRecognizer:tap];
    
    [self.floatingWindow addSubview:self.windowView];
    
    [self.windowView.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.floatingWindow.hidden = NO;
    [self.floatingWindow makeKeyAndVisible];
    
    self.isWindowVisible = YES;
    
    if (self.onWindowOpened) {
        self.onWindowOpened();
    }
}

- (void)hideFloatingWindow {
    if (!self.isWindowVisible) return;
    
    self.floatingWindow.hidden = YES;
    self.floatingWindow = nil;
    self.windowView = nil;
    self.isWindowVisible = NO;
    
    if (self.onWindowClosed) {
        self.onWindowClosed();
    }
}

- (void)backgroundTapped:(UITapGestureRecognizer *)tap {
    CGPoint location = [tap locationInView:tap.view];
    if (!CGRectContainsPoint(self.windowView.frame, location)) {
        [self hideFloatingWindow];
    }
}

- (void)closeButtonTapped {
    [self hideFloatingWindow];
}

- (void)showButton {
    self.floatingButton.hidden = NO;
}

- (void)hideButton {
    self.floatingButton.hidden = YES;
}

- (void)setWindowTitle:(NSString *)title {
    self.windowView.titleLabel.text = title;
}

- (void)setWindowContent:(NSString *)content {
    self.windowView.contentTextView.text = content;
}

@end

struct iOSDynamicLib::FloatingWindow::Impl {
    FloatingWindowController *controller;
    
    Impl() {
        controller = [FloatingWindowController sharedInstance];
    }
};

iOSDynamicLib::FloatingWindow& iOSDynamicLib::FloatingWindow::Instance() {
    static FloatingWindow instance;
    return instance;
}

iOSDynamicLib::FloatingWindow::FloatingWindow() : pImpl(new Impl()) {}

iOSDynamicLib::FloatingWindow::~FloatingWindow() {
    delete pImpl;
}

void iOSDynamicLib::FloatingWindow::ShowFloatingButton() {
    [pImpl->controller showButton];
}

void iOSDynamicLib::FloatingWindow::HideFloatingButton() {
    [pImpl->controller hideButton];
}

void iOSDynamicLib::FloatingWindow::ShowFloatingWindow() {
    [pImpl->controller showFloatingWindow];
}

void iOSDynamicLib::FloatingWindow::HideFloatingWindow() {
    [pImpl->controller hideFloatingWindow];
}

void iOSDynamicLib::FloatingWindow::ToggleFloatingWindow() {
    [pImpl->controller toggleFloatingWindow];
}

bool iOSDynamicLib::FloatingWindow::IsFloatingButtonVisible() const {
    return !pImpl->controller.floatingButton.hidden;
}

bool iOSDynamicLib::FloatingWindow::IsFloatingWindowVisible() const {
    return pImpl->controller.isWindowVisible;
}

void iOSDynamicLib::FloatingWindow::SetWindowTitle(const std::string& title) {
    [pImpl->controller setWindowTitle:[NSString stringWithUTF8String:title.c_str()]];
}

void iOSDynamicLib::FloatingWindow::SetWindowContent(const std::string& content) {
    [pImpl->controller setWindowContent:[NSString stringWithUTF8String:content.c_str()]];
}

void iOSDynamicLib::FloatingWindow::SetOnButtonClicked(std::function<void()> callback) {
    pImpl->controller.onButtonClicked = callback;
}

void iOSDynamicLib::FloatingWindow::SetOnWindowOpened(std::function<void()> callback) {
    pImpl->controller.onWindowOpened = callback;
}

void iOSDynamicLib::FloatingWindow::SetOnWindowClosed(std::function<void()> callback) {
    pImpl->controller.onWindowClosed = callback;
}

extern "C" {

void ShowFloatingButton() {
    iOSDynamicLib::FloatingWindow::Instance().ShowFloatingButton();
}

void HideFloatingButton() {
    iOSDynamicLib::FloatingWindow::Instance().HideFloatingButton();
}

void ToggleFloatingWindow() {
    iOSDynamicLib::FloatingWindow::Instance().ToggleFloatingWindow();
}

int IsFloatingButtonVisible() {
    return iOSDynamicLib::FloatingWindow::Instance().IsFloatingButtonVisible() ? 1 : 0;
}

int IsFloatingWindowVisible() {
    return iOSDynamicLib::FloatingWindow::Instance().IsFloatingWindowVisible() ? 1 : 0;
}

}
