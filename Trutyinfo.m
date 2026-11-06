#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

static NSString *const kWebsite = @"https://sharefiletruty.vercel.app";
static NSString *const kYouTube = @"https://youtube.com/@trungdepzai_y29?si=NwiL5XBGnki7fI65";
static NSString *const kAvatarURL = @"https://files.catbox.moe/znu13m.png";

typedef NS_ENUM(NSInteger, TrutyIconKind) {
    TrutyIconGlobe,
    TrutyIconPlay,
    TrutyIconCode,
    TrutyIconUpload,
    TrutyIconChat,
    TrutyIconClose,
    TrutyIconArrow
};

static UIView *gOverlay = nil;
static UIView *gCard = nil;

static BOOL TrutyReduceMotion(void) {
    return UIAccessibilityIsReduceMotionEnabled();
}

static UIColor *TrutyRGB(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
}

static UIFont *TrutyFont(CGFloat size, UIFontWeight weight, BOOL rounded) {
    UIFont *font = [UIFont systemFontOfSize:size weight:weight];
    if (rounded) {
        UIFontDescriptor *descriptor = [font.fontDescriptor fontDescriptorWithDesign:UIFontDescriptorSystemDesignRounded];
        if (descriptor) font = [UIFont fontWithDescriptor:descriptor size:size];
    }
    return font;
}

static void TrutyPin(UIView *view, UIView *host, UIEdgeInsets insets) {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [view.topAnchor constraintEqualToAnchor:host.topAnchor constant:insets.top],
        [view.leadingAnchor constraintEqualToAnchor:host.leadingAnchor constant:insets.left],
        [view.trailingAnchor constraintEqualToAnchor:host.trailingAnchor constant:-insets.right],
        [view.bottomAnchor constraintEqualToAnchor:host.bottomAnchor constant:-insets.bottom]
    ]];
}

static void TrutySize(UIView *view, CGFloat width, CGFloat height) {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [view.widthAnchor constraintEqualToConstant:width],
        [view.heightAnchor constraintEqualToConstant:height]
    ]];
}

static void TrutyCenter(UIView *view, UIView *host) {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [view.centerXAnchor constraintEqualToAnchor:host.centerXAnchor],
        [view.centerYAnchor constraintEqualToAnchor:host.centerYAnchor]
    ]];
}

static UILabel *TrutyLabel(NSString *text, CGFloat size, UIFontWeight weight, UIColor *color, NSTextAlignment align, BOOL rounded) {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = TrutyFont(size, weight, rounded);
    label.textColor = color;
    label.textAlignment = align;
    label.numberOfLines = 0;
    return label;
}

@interface TrutyIconView : UIView
@property (nonatomic) TrutyIconKind kind;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) CGFloat stroke;
- (instancetype)initWithKind:(TrutyIconKind)kind color:(UIColor *)color;
@end

@implementation TrutyIconView

- (instancetype)initWithKind:(TrutyIconKind)kind color:(UIColor *)color {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _kind = kind;
        _color = color;
        _stroke = 1.8;
        self.backgroundColor = UIColor.clearColor;
        self.opaque = NO;
        self.contentMode = UIViewContentModeRedraw;
        self.userInteractionEnabled = NO;
        self.isAccessibilityElement = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat side = MIN(self.bounds.size.width, self.bounds.size.height);
    CGFloat scale = side / 24.0;
    CGContextTranslateCTM(ctx, (self.bounds.size.width - 24.0 * scale) / 2.0, (self.bounds.size.height - 24.0 * scale) / 2.0);
    CGContextScaleCTM(ctx, scale, scale);

    [self.color setStroke];
    [self.color setFill];

    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = self.stroke;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    UIBezierPath *fill = nil;

    switch (self.kind) {
        case TrutyIconGlobe: {
            [path appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(3, 3, 18, 18)]];
            [path appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(8, 3, 8, 18)]];
            [path moveToPoint:CGPointMake(3, 12)];
            [path addLineToPoint:CGPointMake(21, 12)];
            [path moveToPoint:CGPointMake(4.3, 7.5)];
            [path addLineToPoint:CGPointMake(19.7, 7.5)];
            [path moveToPoint:CGPointMake(4.3, 16.5)];
            [path addLineToPoint:CGPointMake(19.7, 16.5)];
            break;
        }
        case TrutyIconPlay: {
            [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(2.5, 5, 19, 14) cornerRadius:4.5]];
            fill = [UIBezierPath bezierPath];
            [fill moveToPoint:CGPointMake(10, 9)];
            [fill addLineToPoint:CGPointMake(15.2, 12)];
            [fill addLineToPoint:CGPointMake(10, 15)];
            [fill closePath];
            break;
        }
        case TrutyIconCode: {
            [path moveToPoint:CGPointMake(8, 7)];
            [path addLineToPoint:CGPointMake(3, 12)];
            [path addLineToPoint:CGPointMake(8, 17)];
            [path moveToPoint:CGPointMake(16, 7)];
            [path addLineToPoint:CGPointMake(21, 12)];
            [path addLineToPoint:CGPointMake(16, 17)];
            [path moveToPoint:CGPointMake(14, 5)];
            [path addLineToPoint:CGPointMake(10, 19)];
            break;
        }
        case TrutyIconUpload: {
            [path moveToPoint:CGPointMake(12, 16)];
            [path addLineToPoint:CGPointMake(12, 4)];
            [path moveToPoint:CGPointMake(7.5, 8.5)];
            [path addLineToPoint:CGPointMake(12, 4)];
            [path addLineToPoint:CGPointMake(16.5, 8.5)];
            [path moveToPoint:CGPointMake(4, 15)];
            [path addLineToPoint:CGPointMake(4, 20)];
            [path addLineToPoint:CGPointMake(20, 20)];
            [path addLineToPoint:CGPointMake(20, 15)];
            break;
        }
        case TrutyIconChat: {
            [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(3, 4, 18, 13) cornerRadius:4.5]];
            [path moveToPoint:CGPointMake(8, 17)];
            [path addLineToPoint:CGPointMake(8, 20.5)];
            [path addLineToPoint:CGPointMake(12, 17)];
            break;
        }
        case TrutyIconClose: {
            [path moveToPoint:CGPointMake(6, 6)];
            [path addLineToPoint:CGPointMake(18, 18)];
            [path moveToPoint:CGPointMake(18, 6)];
            [path addLineToPoint:CGPointMake(6, 18)];
            break;
        }
        case TrutyIconArrow: {
            [path moveToPoint:CGPointMake(5, 12)];
            [path addLineToPoint:CGPointMake(19, 12)];
            [path moveToPoint:CGPointMake(13, 6)];
            [path addLineToPoint:CGPointMake(19, 12)];
            [path addLineToPoint:CGPointMake(13, 18)];
            break;
        }
    }

    [path stroke];
    if (fill) [fill fill];
}

@end

@interface TrutyGradientView : UIView
@end

@implementation TrutyGradientView
+ (Class)layerClass { return CAGradientLayer.class; }
@end

@interface TrutyGradientButton : UIButton
@end

@implementation TrutyGradientButton

+ (Class)layerClass { return CAGradientLayer.class; }

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = highlighted ? 0.88 : 1.0;
        self.transform = highlighted ? CGAffineTransformMakeScale(0.98, 0.98) : CGAffineTransformIdentity;
    }];
}

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
    if (!overlay) return;
    gOverlay = nil;
    gCard = nil;
    BOOL reduce = TrutyReduceMotion();
    [UIView animateWithDuration:0.2 animations:^{
        overlay.alpha = 0;
        if (!reduce) card.transform = CGAffineTransformMakeScale(0.94, 0.94);
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
    }];
}

@end

static NSString *TrutyAvatarCachePath(void) {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [dir stringByAppendingPathComponent:@"trutyinfo_avatar.png"];
}

static void TrutyLoadAvatar(UIImageView *imageView, UIView *placeholder) {
    void (^apply)(UIImage *) = ^(UIImage *image) {
        imageView.image = image;
        [UIView animateWithDuration:0.35 animations:^{
            imageView.alpha = 1;
            placeholder.alpha = 0;
        }];
    };

    UIImage *cached = [UIImage imageWithContentsOfFile:TrutyAvatarCachePath()];
    if (cached) {
        apply(cached);
        return;
    }

    NSURL *url = [NSURL URLWithString:kAvatarURL];
    if (!url) return;
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithURL:url
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage *image = data ? [UIImage imageWithData:data] : nil;
        if (!image) return;
        [data writeToFile:TrutyAvatarCachePath() atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{ apply(image); });
    }];
    [task resume];
}

static UIView *TrutyInfoRow(TrutyIconKind kind, UIColor *tint, NSString *title, NSString *subtitle) {
    UIView *tile = [UIView new];
    tile.backgroundColor = [tint colorWithAlphaComponent:0.16];
    tile.layer.cornerRadius = 13;
    TrutySize(tile, 44, 44);

    TrutyIconView *icon = [[TrutyIconView alloc] initWithKind:kind color:tint];
    [tile addSubview:icon];
    TrutySize(icon, 22, 22);
    TrutyCenter(icon, tile);

    UILabel *titleLabel = TrutyLabel(title, 15, UIFontWeightSemibold, UIColor.whiteColor, NSTextAlignmentLeft, NO);
    UILabel *subtitleLabel = TrutyLabel(subtitle, 12.5, UIFontWeightRegular, [UIColor colorWithWhite:1 alpha:0.64], NSTextAlignmentLeft, NO);

    UIStackView *text = [[UIStackView alloc] initWithArrangedSubviews:@[titleLabel, subtitleLabel]];
    text.axis = UILayoutConstraintAxisVertical;
    text.spacing = 2;

    UIStackView *row = [[UIStackView alloc] initWithArrangedSubviews:@[tile, text]];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.alignment = UIStackViewAlignmentCenter;
    row.spacing = 14;
    return row;
}

static TrutyGradientButton *TrutyActionButton(NSString *title, TrutyIconKind kind, NSArray<UIColor *> *colors, SEL action) {
    TrutyGradientButton *button = [TrutyGradientButton buttonWithType:UIButtonTypeCustom];
    CAGradientLayer *layer = (CAGradientLayer *)button.layer;
    NSMutableArray *cg = [NSMutableArray array];
    for (UIColor *color in colors) [cg addObject:(id)color.CGColor];
    layer.colors = cg;
    layer.startPoint = CGPointMake(0, 0.5);
    layer.endPoint = CGPointMake(1, 0.5);
    button.layer.cornerRadius = 18;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    button.accessibilityLabel = title;
    button.accessibilityTraits = UIAccessibilityTraitLink;
    [button addTarget:TrutyActions.shared action:action forControlEvents:UIControlEventTouchUpInside];

    TrutyIconView *leading = [[TrutyIconView alloc] initWithKind:kind color:UIColor.whiteColor];
    UILabel *label = TrutyLabel(title, 16, UIFontWeightBold, UIColor.whiteColor, NSTextAlignmentLeft, YES);
    label.userInteractionEnabled = NO;
    TrutyIconView *trailing = [[TrutyIconView alloc] initWithKind:TrutyIconArrow color:[UIColor colorWithWhite:1 alpha:0.85]];
    label.translatesAutoresizingMaskIntoConstraints = NO;

    [button addSubview:leading];
    [button addSubview:label];
    [button addSubview:trailing];
    TrutySize(leading, 24, 24);
    TrutySize(trailing, 20, 20);

    [NSLayoutConstraint activateConstraints:@[
        [button.heightAnchor constraintEqualToConstant:56],
        [leading.leadingAnchor constraintEqualToAnchor:button.leadingAnchor constant:18],
        [leading.centerYAnchor constraintEqualToAnchor:button.centerYAnchor],
        [label.leadingAnchor constraintEqualToAnchor:leading.trailingAnchor constant:12],
        [label.centerYAnchor constraintEqualToAnchor:button.centerYAnchor],
        [trailing.trailingAnchor constraintEqualToAnchor:button.trailingAnchor constant:-18],
        [trailing.centerYAnchor constraintEqualToAnchor:button.centerYAnchor],
        [label.trailingAnchor constraintLessThanOrEqualToAnchor:trailing.leadingAnchor constant:-8]
    ]];
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

static UIView *TrutyBuildAvatar(void) {
    UIColor *violet = TrutyRGB(124, 92, 255, 1);
    UIColor *cyan = TrutyRGB(34, 211, 238, 1);
    UIColor *pink = TrutyRGB(244, 114, 182, 1);

    UIView *holder = [UIView new];
    UIView *box = [UIView new];
    [holder addSubview:box];
    TrutySize(box, 108, 108);
    [NSLayoutConstraint activateConstraints:@[
        [box.topAnchor constraintEqualToAnchor:holder.topAnchor],
        [box.bottomAnchor constraintEqualToAnchor:holder.bottomAnchor],
        [box.centerXAnchor constraintEqualToAnchor:holder.centerXAnchor]
    ]];

    UIView *glow = [UIView new];
    glow.backgroundColor = [violet colorWithAlphaComponent:0.9];
    glow.layer.cornerRadius = 44;
    glow.layer.shadowColor = violet.CGColor;
    glow.layer.shadowOpacity = 0.85;
    glow.layer.shadowRadius = 26;
    glow.layer.shadowOffset = CGSizeZero;
    [box addSubview:glow];
    TrutySize(glow, 88, 88);
    TrutyCenter(glow, box);

    UIView *ringHost = [UIView new];
    [box addSubview:ringHost];
    TrutySize(ringHost, 108, 108);
    TrutyCenter(ringHost, box);

    CAGradientLayer *ring = [CAGradientLayer layer];
    ring.frame = CGRectMake(0, 0, 108, 108);
    ring.type = kCAGradientLayerConic;
    ring.colors = @[(id)violet.CGColor, (id)cyan.CGColor, (id)pink.CGColor, (id)violet.CGColor];
    ring.startPoint = CGPointMake(0.5, 0.5);
    ring.endPoint = CGPointMake(0.5, 0);
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = CGRectMake(0, 0, 108, 108);
    mask.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(mask.bounds, 2, 2)].CGPath;
    mask.fillColor = nil;
    mask.strokeColor = UIColor.blackColor.CGColor;
    mask.lineWidth = 4;
    ring.mask = mask;
    [ringHost.layer addSublayer:ring];

    if (!TrutyReduceMotion()) {
        CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        spin.fromValue = @0;
        spin.toValue = @(2 * M_PI);
        spin.duration = 7;
        spin.repeatCount = HUGE_VALF;
        spin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [ring addAnimation:spin forKey:@"spin"];
    }

    UIView *backing = [UIView new];
    backing.backgroundColor = TrutyRGB(12, 15, 32, 1);
    backing.layer.cornerRadius = 46;
    [box addSubview:backing];
    TrutySize(backing, 92, 92);
    TrutyCenter(backing, box);

    TrutyIconView *placeholder = [[TrutyIconView alloc] initWithKind:TrutyIconCode color:TrutyRGB(167, 190, 255, 1)];
    placeholder.stroke = 1.6;
    [box addSubview:placeholder];
    TrutySize(placeholder, 42, 42);
    TrutyCenter(placeholder, box);

    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 46;
    imageView.alpha = 0;
    imageView.isAccessibilityElement = YES;
    imageView.accessibilityLabel = @"Ảnh đại diện của Trung";
    [box addSubview:imageView];
    TrutySize(imageView, 92, 92);
    TrutyCenter(imageView, box);

    TrutyLoadAvatar(imageView, placeholder);
    return holder;
}

static UIView *TrutyBuildChip(void) {
    UIView *holder = [UIView new];

    UIView *chip = [UIView new];
    chip.backgroundColor = [UIColor colorWithWhite:1 alpha:0.08];
    chip.layer.cornerRadius = 15;
    chip.layer.borderWidth = 1;
    chip.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.1].CGColor;
    [holder addSubview:chip];
    chip.translatesAutoresizingMaskIntoConstraints = NO;

    TrutyIconView *icon = [[TrutyIconView alloc] initWithKind:TrutyIconPlay color:TrutyRGB(255, 107, 107, 1)];
    TrutySize(icon, 16, 16);
    UILabel *handle = TrutyLabel(@"@trungdepzai_y29", 13, UIFontWeightMedium, [UIColor colorWithWhite:1 alpha:0.86], NSTextAlignmentLeft, NO);

    UIStackView *content = [[UIStackView alloc] initWithArrangedSubviews:@[icon, handle]];
    content.axis = UILayoutConstraintAxisHorizontal;
    content.alignment = UIStackViewAlignmentCenter;
    content.spacing = 6;
    content.userInteractionEnabled = NO;
    [chip addSubview:content];
    TrutyPin(content, chip, UIEdgeInsetsMake(7, 12, 7, 14));

    [NSLayoutConstraint activateConstraints:@[
        [chip.topAnchor constraintEqualToAnchor:holder.topAnchor],
        [chip.bottomAnchor constraintEqualToAnchor:holder.bottomAnchor],
        [chip.centerXAnchor constraintEqualToAnchor:holder.centerXAnchor]
    ]];
    return holder;
}

static UIView *TrutyBuildGroup(void) {
    UIView *group = [UIView new];
    group.backgroundColor = [UIColor colorWithWhite:1 alpha:0.05];
    group.layer.cornerRadius = 22;
    group.layer.borderWidth = 1;
    group.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.08].CGColor;

    UIStackView *rows = [[UIStackView alloc] initWithArrangedSubviews:@[
        TrutyInfoRow(TrutyIconCode, TrutyRGB(167, 139, 250, 1), @"Lập trình viên web", @"Tự thiết kế và vận hành ứng dụng"),
        TrutyInfoRow(TrutyIconUpload, TrutyRGB(34, 211, 238, 1), @"ShareFile", @"Chia sẻ file nhanh gọn"),
        TrutyInfoRow(TrutyIconChat, TrutyRGB(244, 114, 182, 1), @"Chat trực tiếp", @"Trò chuyện ngay trong ứng dụng")
    ]];
    rows.axis = UILayoutConstraintAxisVertical;
    rows.spacing = 14;
    [group addSubview:rows];
    TrutyPin(rows, group, UIEdgeInsetsMake(16, 16, 16, 16));
    return group;
}

static void TrutyShowInfo(void) {
    if (gOverlay) return;

    UIWindow *window = TrutyKeyWindow();
    if (!window) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{ TrutyShowInfo(); });
        return;
    }

    BOOL reduce = TrutyReduceMotion();

    UIVisualEffectView *overlay =
        [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    overlay.frame = window.bounds;
    overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlay.alpha = 0;
    [window addSubview:overlay];
    gOverlay = overlay;

    UIView *dim = [[UIView alloc] initWithFrame:overlay.bounds];
    dim.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dim.backgroundColor = [UIColor colorWithWhite:0 alpha:0.42];
    [dim addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:TrutyActions.shared action:@selector(dismiss)]];
    [overlay.contentView addSubview:dim];

    UIView *card = [UIView new];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.layer.shadowColor = TrutyRGB(124, 92, 255, 1).CGColor;
    card.layer.shadowOpacity = 0.38;
    card.layer.shadowRadius = 42;
    card.layer.shadowOffset = CGSizeMake(0, 22);
    card.accessibilityViewIsModal = YES;
    [overlay.contentView addSubview:card];
    gCard = card;

    NSLayoutConstraint *preferredWidth = [card.widthAnchor constraintEqualToConstant:344];
    preferredWidth.priority = UILayoutPriorityDefaultHigh;
    [NSLayoutConstraint activateConstraints:@[
        [card.centerXAnchor constraintEqualToAnchor:overlay.contentView.centerXAnchor],
        [card.centerYAnchor constraintEqualToAnchor:overlay.contentView.centerYAnchor],
        [card.widthAnchor constraintLessThanOrEqualToAnchor:overlay.contentView.widthAnchor constant:-40],
        preferredWidth
    ]];

    UIVisualEffectView *glass =
        [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterialDark]];
    glass.layer.cornerRadius = 34;
    glass.layer.masksToBounds = YES;
    glass.layer.borderWidth = 1;
    glass.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.14].CGColor;
    [card addSubview:glass];
    TrutyPin(glass, card, UIEdgeInsetsZero);

    UIView *tint = [UIView new];
    tint.backgroundColor = TrutyRGB(14, 18, 38, 0.74);
    [glass.contentView addSubview:tint];
    TrutyPin(tint, glass.contentView, UIEdgeInsetsZero);

    TrutyGradientView *aurora = [TrutyGradientView new];
    aurora.userInteractionEnabled = NO;
    CAGradientLayer *auroraLayer = (CAGradientLayer *)aurora.layer;
    auroraLayer.type = kCAGradientLayerRadial;
    auroraLayer.colors = @[
        (id)TrutyRGB(124, 92, 255, 0.46).CGColor,
        (id)TrutyRGB(34, 211, 238, 0.12).CGColor,
        (id)TrutyRGB(14, 18, 38, 0).CGColor
    ];
    auroraLayer.locations = @[@0, @0.55, @1];
    auroraLayer.startPoint = CGPointMake(0.5, 0);
    auroraLayer.endPoint = CGPointMake(1, 1);
    [glass.contentView addSubview:aurora];
    aurora.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [aurora.topAnchor constraintEqualToAnchor:glass.contentView.topAnchor],
        [aurora.leadingAnchor constraintEqualToAnchor:glass.contentView.leadingAnchor],
        [aurora.trailingAnchor constraintEqualToAnchor:glass.contentView.trailingAnchor],
        [aurora.heightAnchor constraintEqualToConstant:260]
    ]];

    UILabel *name = TrutyLabel(@"Trung", 30, UIFontWeightHeavy, UIColor.whiteColor, NSTextAlignmentCenter, YES);

    TrutyGradientButton *website =
        TrutyActionButton(@"Mở website", TrutyIconGlobe,
                          @[TrutyRGB(110, 86, 255, 1), TrutyRGB(34, 190, 230, 1)], @selector(openWebsite));
    TrutyGradientButton *youtube =
        TrutyActionButton(@"Xem kênh YouTube", TrutyIconPlay,
                          @[TrutyRGB(240, 60, 70, 1), TrutyRGB(255, 130, 60, 1)], @selector(openYouTube));

    UIView *avatar = TrutyBuildAvatar();
    UIView *chip = TrutyBuildChip();
    UIView *group = TrutyBuildGroup();

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[avatar, name, chip, group, website, youtube]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 10;
    [stack setCustomSpacing:14 afterView:avatar];
    [stack setCustomSpacing:22 afterView:chip];
    [stack setCustomSpacing:18 afterView:group];
    [glass.contentView addSubview:stack];
    TrutyPin(stack, glass.contentView, UIEdgeInsetsMake(34, 22, 24, 22));

    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.accessibilityLabel = @"Đóng";
    [close addTarget:TrutyActions.shared action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [glass.contentView addSubview:close];
    TrutySize(close, 44, 44);
    [NSLayoutConstraint activateConstraints:@[
        [close.topAnchor constraintEqualToAnchor:glass.contentView.topAnchor constant:10],
        [close.trailingAnchor constraintEqualToAnchor:glass.contentView.trailingAnchor constant:-10]
    ]];

    UIView *closeDisc = [UIView new];
    closeDisc.userInteractionEnabled = NO;
    closeDisc.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    closeDisc.layer.cornerRadius = 16;
    [close addSubview:closeDisc];
    TrutySize(closeDisc, 32, 32);
    TrutyCenter(closeDisc, close);

    TrutyIconView *closeIcon = [[TrutyIconView alloc] initWithKind:TrutyIconClose color:[UIColor colorWithWhite:1 alpha:0.85]];
    closeIcon.stroke = 2.0;
    [closeDisc addSubview:closeIcon];
    TrutySize(closeIcon, 16, 16);
    TrutyCenter(closeIcon, closeDisc);

    [overlay layoutIfNeeded];

    card.alpha = 0;
    if (!reduce) card.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:(reduce ? 0.2 : 0.55) delay:0 usingSpringWithDamping:0.82 initialSpringVelocity:0.4
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
