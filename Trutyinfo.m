#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static NSString *const kWebsite = @"https://sharefiletruty.vercel.app";
static NSString *const kYouTube = @"https://youtube.com/@trungdepzai_y29?si=NwiL5XBGnki7fI65";

static UIView *gOverlay = nil;
static UIView *gCard = nil;

@interface TrutyGradientView : UIView
@end

@implementation TrutyGradientView
+ (Class)layerClass { return CAGradientLayer.class; }
@end

@interface TrutyGradientButton : UIButton
@end

@implementation TrutyGradientButton
+ (Class)layerClass { return CAGradientLayer.class; }
@end

@interface TrutyActions : NSObject
+ (instancetype)shared;
- (void)openWebsite;
- (void)openYouTube;
- (void)dismiss;
@end

@implementation TrutyActions

+ (instancetype)shared {
    static TrutyActions *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ instance = [TrutyActions new]; });
    return instance;
}

- (void)openURL:(NSString *)string {
    NSURL *url = [NSURL URLWithString:string];
    if (url) [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
}

- (void)openWebsite { [self openURL:kWebsite]; }
- (void)openYouTube { [self openURL:kYouTube]; }

- (void)dismiss {
    UIView *overlay = gOverlay;
    UIView *card = gCard;
    gOverlay = nil;
    gCard = nil;
    [UIView animateWithDuration:0.22 animations:^{
        overlay.alpha = 0;
        card.transform = CGAffineTransformMakeScale(0.92, 0.92);
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
    }];
}

@end

static UIColor *TrutyRGB(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
}

static void TrutySetGradient(UIView *view, NSArray<UIColor *> *colors) {
    CAGradientLayer *layer = (CAGradientLayer *)view.layer;
    NSMutableArray *cg = [NSMutableArray array];
    for (UIColor *c in colors) [cg addObject:(id)c.CGColor];
    layer.colors = cg;
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
}

static UILabel *TrutyLabel(NSString *text, CGFloat size, UIFontWeight weight, UIColor *color, NSTextAlignment align) {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = color;
    label.textAlignment = align;
    label.numberOfLines = 0;
    return label;
}

static TrutyGradientButton *TrutyLinkButton(NSString *title, NSArray<UIColor *> *colors, SEL action) {
    TrutyGradientButton *button = [TrutyGradientButton buttonWithType:UIButtonTypeCustom];
    TrutySetGradient(button, colors);
    button.layer.cornerRadius = 16;
    button.layer.masksToBounds = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [button addTarget:TrutyActions.shared action:action forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:52].active = YES;
    return button;
}

static UIWindow *TrutyKeyWindow(void) {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        if (windowScene.activationState != UISceneActivationStateForegroundActive) continue;
        for (UIWindow *window in windowScene.windows) {
            if (window.isKeyWindow) return window;
        }
    }
    return nil;
}

static void TrutyShowInfo(void) {
    if (gOverlay) return;

    UIWindow *window = TrutyKeyWindow();
    if (!window) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{ TrutyShowInfo(); });
        return;
    }

    UIVisualEffectView *overlay =
        [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    overlay.frame = window.bounds;
    overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlay.alpha = 0;
    [window addSubview:overlay];
    gOverlay = overlay;

    UIView *dim = [[UIView alloc] initWithFrame:overlay.bounds];
    dim.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dim.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    [overlay.contentView addSubview:dim];

    UIView *card = [UIView new];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = TrutyRGB(18, 20, 30, 0.96);
    card.layer.cornerRadius = 30;
    card.layer.borderWidth = 1;
    card.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.09].CGColor;
    card.layer.shadowColor = UIColor.blackColor.CGColor;
    card.layer.shadowOpacity = 0.5;
    card.layer.shadowRadius = 36;
    card.layer.shadowOffset = CGSizeMake(0, 18);
    [overlay.contentView addSubview:card];
    gCard = card;

    NSLayoutConstraint *preferredWidth = [card.widthAnchor constraintEqualToConstant:340];
    preferredWidth.priority = UILayoutPriorityDefaultHigh;
    [NSLayoutConstraint activateConstraints:@[
        [card.centerXAnchor constraintEqualToAnchor:overlay.contentView.centerXAnchor],
        [card.centerYAnchor constraintEqualToAnchor:overlay.contentView.centerYAnchor],
        [card.widthAnchor constraintLessThanOrEqualToAnchor:overlay.contentView.widthAnchor constant:-48],
        preferredWidth
    ]];

    TrutyGradientView *avatar = [TrutyGradientView new];
    TrutySetGradient(avatar, @[TrutyRGB(99, 102, 241, 1), TrutyRGB(236, 72, 153, 1)]);
    avatar.layer.cornerRadius = 38;
    avatar.layer.masksToBounds = YES;
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [avatar.widthAnchor constraintEqualToConstant:76],
        [avatar.heightAnchor constraintEqualToConstant:76]
    ]];
    UILabel *initial = TrutyLabel(@"T", 34, UIFontWeightHeavy, UIColor.whiteColor, NSTextAlignmentCenter);
    initial.translatesAutoresizingMaskIntoConstraints = NO;
    [avatar addSubview:initial];
    [NSLayoutConstraint activateConstraints:@[
        [initial.centerXAnchor constraintEqualToAnchor:avatar.centerXAnchor],
        [initial.centerYAnchor constraintEqualToAnchor:avatar.centerYAnchor]
    ]];

    UIView *avatarHolder = [UIView new];
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    [avatarHolder addSubview:avatar];
    [NSLayoutConstraint activateConstraints:@[
        [avatar.topAnchor constraintEqualToAnchor:avatarHolder.topAnchor],
        [avatar.bottomAnchor constraintEqualToAnchor:avatarHolder.bottomAnchor],
        [avatar.centerXAnchor constraintEqualToAnchor:avatarHolder.centerXAnchor]
    ]];

    UILabel *title = TrutyLabel(@"Trung", 26, UIFontWeightBold, UIColor.whiteColor, NSTextAlignmentCenter);
    UILabel *tagline = TrutyLabel(@"Lập trình viên • Chủ website ShareFile", 13, UIFontWeightMedium,
                                  TrutyRGB(165, 180, 252, 1), NSTextAlignmentCenter);
    UILabel *about = TrutyLabel(@"Xin chào! Mình tự xây dựng và quản trị ứng dụng chia sẻ file kèm chat với đầy đủ trang quản trị. Cảm ơn bạn đã ủng hộ ❤️",
                                14, UIFontWeightRegular, [UIColor colorWithWhite:1 alpha:0.68], NSTextAlignmentCenter);

    TrutyGradientButton *webButton =
        TrutyLinkButton(@"🌐  Truy cập Website",
                        @[TrutyRGB(99, 102, 241, 1), TrutyRGB(139, 92, 246, 1)], @selector(openWebsite));
    TrutyGradientButton *ytButton =
        TrutyLinkButton(@"▶️  Kênh YouTube",
                        @[TrutyRGB(239, 68, 68, 1), TrutyRGB(249, 115, 22, 1)], @selector(openYouTube));

    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setTitle:@"Đóng" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor colorWithWhite:1 alpha:0.55] forState:UIControlStateNormal];
    close.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [close addTarget:TrutyActions.shared action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [close.heightAnchor constraintEqualToConstant:40].active = YES;

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[
        avatarHolder, title, tagline, about, webButton, ytButton, close
    ]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 12;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [stack setCustomSpacing:18 afterView:avatarHolder];
    [stack setCustomSpacing:4 afterView:title];
    [stack setCustomSpacing:16 afterView:tagline];
    [stack setCustomSpacing:22 afterView:about];
    [stack setCustomSpacing:4 afterView:ytButton];
    [card addSubview:stack];
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:card.topAnchor constant:28],
        [stack.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-14],
        [stack.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:24],
        [stack.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-24]
    ]];

    [overlay layoutIfNeeded];
    card.transform = CGAffineTransformMakeScale(0.88, 0.88);
    card.alpha = 0;
    [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
        overlay.alpha = 1;
        card.alpha = 1;
        card.transform = CGAffineTransformIdentity;
    } completion:nil];
}

__attribute__((constructor))
static void TrutyinfoInit(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{ TrutyShowInfo(); });
}
