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
        [self configureLayoutConstraints];
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

- (void)configureLayoutConstraints {
    NSMutableArray *components = @[].mutableCopy;
    if (self.titleLabel) {
        [components addObject:self.titleLabel];
    }
    if (self.messageLabel) {
        [components addObject:self.messageLabel];
    }

    [components enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        NSMutableArray *constraints = @[
            [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:
             NSLayoutAttributeWidth multiplier:1 constant:PKAlertDefaultMargin * 2],
            [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:
             NSLayoutAttributeCenterX multiplier:1 constant:0],
        ].mutableCopy;
        [self addConstraints:constraints];

        constraints = [NSMutableArray array];
        if (idx == 0) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:PKAlertDefaultMargin * 3]];
        } else {
            UIView *previousView = [components objectAtIndex:idx - 1];
            if (previousView) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1 constant:PKAlertDefaultMargin]];
            }
        }
        if (idx == components.count - 1) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:PKAlertDefaultMargin * 3]];
        }
        [self addConstraints:constraints];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize viewSize = self.bounds.size;
    CGFloat labelWidth = viewSize.width - PKAlertDefaultMargin * 2;
    CGFloat subviewHeight = 0;

    if (self.titleLabel) {
        self.titleLabel.preferredMaxLayoutWidth = labelWidth;
        subviewHeight += [self.titleLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)].height;
    }
    if (self.messageLabel) {
        self.messageLabel.preferredMaxLayoutWidth = labelWidth;
        subviewHeight += [self.messageLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)].height;
    }

    CGFloat verticalMargin = 0;
    if (self.titleLabel) {
        verticalMargin += PKAlertDefaultMargin * 3;
    }
    if (self.messageLabel) {
        verticalMargin += verticalMargin ? PKAlertDefaultMargin : PKAlertDefaultMargin * 3;
    }
    verticalMargin += PKAlertDefaultMargin * 3;

    CGSize totalSize = CGSizeMake(viewSize.width, subviewHeight + verticalMargin);
    if (!CGSizeEqualToSize(self.layoutSize, totalSize)) {
        self.layoutSize = totalSize;
        [self invalidateIntrinsicContentSize];
    }
}

#pragma mark - (UIConstraintBasedLayoutLayering)

- (CGSize)intrinsicContentSize {
    return self.layoutSize;
}

@end
