//
//  PKAlertEffectScrollView.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/23.
//
//

#import "PKAlertEffectScrollView.h"

@interface PKAlertEffectScrollView ()

@property (nonatomic) BOOL showTransparentBottomEdge;

@end


@implementation PKAlertEffectScrollView

#pragma mark - Init & dealloc

- (id)init {
    self = [super init];
    if (self) {
        [self configureInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureInit];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
}

#pragma mark - Configure & setup

- (void)configureInit {
    _gradientFactor = .1;
    // MARK: Responds to scroll transitions.
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:0 context:NULL];
}

#pragma mark - View life cycles

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // MARK: Responds to device orientation or view resizing.
    [self refreshTransparentEdge];
}

#pragma mark -

- (void)refreshTransparentEdge {
    CGFloat bottomEdge = self.contentOffset.y + self.frame.size.height;
    if (bottomEdge >= self.contentSize.height) {
        self.showTransparentBottomEdge = NO;
    } else {
        if (!self.showTransparentBottomEdge) {
            self.showTransparentBottomEdge = YES;
        }
    }
    [self updateGradient];
}

- (void)updateGradient {
    CAGradientLayer *maskLayer = [CAGradientLayer layer];

    maskLayer.anchorPoint = CGPointZero;
    UIColor *outerColor = [UIColor colorWithWhite:0 alpha:0];
    UIColor *innerColor = [UIColor colorWithWhite:1 alpha:1];

    if (!self.showTransparentBottomEdge) {
        maskLayer.colors = @[(__bridge id)innerColor.CGColor, (__bridge id)innerColor.CGColor, (__bridge id)innerColor.CGColor, (__bridge id)innerColor.CGColor];
    } else {
        maskLayer.colors = @[(__bridge id)innerColor.CGColor, (__bridge id)innerColor.CGColor, (__bridge id)innerColor.CGColor, (__bridge id)outerColor.CGColor];
    }

    if (!self.isTransparentEdgeEnabled) {
        maskLayer.locations = @[@0, @(self.gradientFactor)];
    } else {
        maskLayer.locations = @[@0, @(self.gradientFactor), @(1 - self.gradientFactor), @1];
    }
    maskLayer.frame = self.bounds;
    self.layer.masksToBounds = YES;

    self.layer.mask = maskLayer;
}

#pragma mark - Key value observiing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self refreshTransparentEdge];
}

@end
