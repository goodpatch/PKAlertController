//
//  PKAlertLabelContainerVIew.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/03/01.
//
//

#import "PKAlertLabelContainerView.h"

#import "PKAlertControllerConfiguration.h"

#pragma mark - PKAlertDefaultLabel

@implementation PKAlertDefaultLabel

- (id)init {
    self = [super init];
    if (self) {
        [self configureInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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

- (void)configureInit {
    self.numberOfLines = 0;
    self.textAlignment = NSTextAlignmentCenter;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation PKAlertTitleLabel

@end

@implementation PKAlertMessageLabel

@end
#pragma mark - PKAlertLabelContainerVIew

@interface PKAlertLabelContainerView ()

@property (nonatomic) PKAlertTitleLabel *titleLabel;
@property (nonatomic) PKAlertMessageLabel *messageLabel;
@property (nonatomic) CGSize layoutSize;

@end

@implementation PKAlertLabelContainerView

+ (instancetype)viewWithConfiguration:(PKAlertControllerConfiguration *)configuration {
    NSParameterAssert(configuration);
    PKAlertLabelContainerView *view = [[PKAlertLabelContainerView alloc] initWIthConfiguration:configuration];
    return view;
}

- (instancetype)initWIthConfiguration:(PKAlertControllerConfiguration *)configuration {
    self = [super init];
    if (self) {
        [self setupLabelWithConfiguration:configuration];
    }
    return self;
}

- (void)setupLabelWithConfiguration:(PKAlertControllerConfiguration *)configuration {
    if (configuration.title) {
        PKAlertTitleLabel *titleLabel = [[PKAlertTitleLabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.text = configuration.title;
        titleLabel.textAlignment = configuration.titleTextAlignment;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    if (configuration.message) {
        PKAlertMessageLabel *messageLabel = [[PKAlertMessageLabel alloc] init];
        messageLabel.font = [UIFont systemFontOfSize:13];
        messageLabel.text = configuration.message;
        messageLabel.textAlignment = configuration.messageTextAlignment;
        [self addSubview:messageLabel];
        self.messageLabel = messageLabel;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize viewSize = self.bounds.size;
    CGFloat labelWidth = viewSize.width - PKAlertDefaultMargin * 2;
    self.titleLabel.preferredMaxLayoutWidth = labelWidth;
    self.messageLabel.preferredMaxLayoutWidth = labelWidth;

    CGFloat subviewHeight = [self.titleLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)].height;
    subviewHeight += [self.messageLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)].height;
    subviewHeight += PKAlertDefaultMargin * 3;
    CGSize totalSize = CGSizeMake(viewSize.width, subviewHeight);
    if (!CGSizeEqualToSize(self.layoutSize, totalSize)) {
        self.layoutSize = totalSize;
        [self invalidateIntrinsicContentSize];
    }
}

#pragma mark - (UIConstraintBasedLayoutLayering)

- (CGSize)intrinsicContentSize {
    return self.layoutSize;
}

#pragma mark - <PKAlertViewLayoutAdapter>

- (void)applyLayoutWithAlertComponentViews:(NSDictionary *)views {
    UIView *contentView = PKAlertGetViewInViews(PKAlertContentViewKey, views);
    UIScrollView *scrollView = (UIScrollView *)PKAlertGetViewInViews(PKAlertScrollViewKey, views);

    NSMutableArray *components = @[].mutableCopy;
    if (self.titleLabel) {
        [components addObject:self.titleLabel];
    }
    if (self.messageLabel) {
        [components addObject:self.messageLabel];
    }

    [components enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        NSMutableArray *constraints = @[
            [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:
             NSLayoutAttributeWidth multiplier:1 constant:PKAlertDefaultMargin * 2],
            [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:
             NSLayoutAttributeCenterX multiplier:1 constant:0],
        ].mutableCopy;
        [contentView addConstraints:constraints];

        constraints = [NSMutableArray array];
        if (idx == 0) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:PKAlertDefaultMargin]];
        } else {
            UIView *previousView = [components objectAtIndex:idx - 1];
            if (previousView) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1 constant:PKAlertDefaultMargin]];
            }
        }
        if (idx == components.count - 1) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:PKAlertDefaultMargin]];
        }
        [scrollView addConstraints:constraints];
    }];
}

- (void)prepareTextAnimation {
    self.alpha = 0;
}

- (void)performTextAnimation {
    self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -50);
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
