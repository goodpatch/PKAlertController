//
//  PKAlertViewController.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import "PKAlertViewController.h"

#import <QuartzCore/CAGradientLayer.h>
#import "PKAlertAction.h"
#import "PKAlertControllerConfiguration.h"
#import "PKAlertActionCollectionViewController.h"
#import "PKAlertDefaultLabel.h"
#import "PKAlertThemeManager.h"

static UIStoryboard *pk_registeredStoryboard;
static NSString *pk_defaultStoryboardName = @"PKAlert";
static NSString *const ActionsViewEmbededSegueIdentifier = @"actionsViewEmbedSegue";

@interface PKAlertViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, PKAlertActionCollectionViewControllerDelegate>

@property (nonatomic, getter=isViewInitialized) BOOL viewInitialized;
@property (nonatomic) CGFloat mainScreenShortSideLength;
@property (nonatomic) PKAlertControllerConfiguration *configuration;
@property (nonatomic) PKAlertActionCollectionViewController *actionCollectionViewController;
@property (nonatomic) NSMutableArray *scrollViewComponents;
@property (nonatomic) NSLayoutConstraint *customViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *actionContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionContainerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

#pragma mark - User defined runtime attributes

@property (nonatomic) CGFloat alertOffset;
@property (nonatomic) CGFloat actionSheetOffset;
@property (nonatomic) CGFloat headerParallaxHeight;

@end

@implementation PKAlertViewController

+ (void)initialize {
    pk_registeredStoryboard = [UIStoryboard storyboardWithName:pk_defaultStoryboardName bundle:PKAlertControllerBundle()];
    [PKAlertThemeManager customizeAlertAppearance];
}

+ (void)registerStoryboard:(UIStoryboard *)storyboard {
    NSParameterAssert(storyboard);
    pk_registeredStoryboard = storyboard;
}

+ (instancetype)instantiateOwnerViewController {
    return [pk_registeredStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(PKAlertControllerStyle)preferredStyle {
    NSParameterAssert(preferredStyle >= PKAlertControllerStyleAlert);
    NSParameterAssert(preferredStyle < PKAlertControllerStyleFullScreen);

    PKAlertViewController *viewController = [self instantiateOwnerViewController];
    viewController.configuration.preferredStyle = preferredStyle;
    viewController.configuration.title = title;
    viewController.configuration.message = message;

    return viewController;
}

+ (instancetype)alertControllerWithConfigurationBlock:(PKAlertControllerConfigurationBlock)configurationBlock {
    NSParameterAssert(configurationBlock);
    PKAlertViewController *viewController = [self instantiateOwnerViewController];
    PKAlertControllerConfiguration *configuration = [[PKAlertControllerConfiguration alloc] init];
    configurationBlock(configuration);
    viewController.configuration = configuration;
    return viewController;
}

+ (instancetype)simpleAlertControllerWithConfigurationBlock:(PKAlertControllerConfigurationBlock)configurationBlock {
    NSParameterAssert(configurationBlock);
    PKAlertViewController *viewController = [self instantiateOwnerViewController];
    PKAlertControllerConfiguration *configuration = [PKAlertControllerConfiguration simpleAlertConfigurationWithHandler:nil];
    configurationBlock(configuration);
    viewController.configuration = configuration;
    return viewController;
}

+ (instancetype)alertControllerWithConfiguration:(PKAlertControllerConfiguration *)configuration {
    NSParameterAssert(configuration);
    PKAlertViewController *viewController = [self instantiateOwnerViewController];
    viewController.configuration = configuration;
    return viewController;
}

#pragma mark - Init & Dealloc

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Configure & Setup

- (void)configureInit {
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    CGSize size = [UIScreen mainScreen].bounds.size;
    _mainScreenShortSideLength = MIN(size.width, size.height);
    _configuration = [[PKAlertControllerConfiguration alloc] init];
    _scrollViewComponents = [NSMutableArray array];
}

- (void)setupAppearance {
    [PKAlertThemeManager customizeAlertDimView:self.view];
    [PKAlertThemeManager customizeAlertContentView:self.contentView];
}

- (void)setupMotionEffect {
    UIInterpolatingMotionEffect *xMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    UIInterpolatingMotionEffect *yMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    xMotionEffect.maximumRelativeValue = @(self.configuration.motionEffectMaximumRelativeValue);
    xMotionEffect.minimumRelativeValue = @(self.configuration.motionEffectMinimumRelativeValue);
    yMotionEffect.maximumRelativeValue = @(self.configuration.motionEffectMaximumRelativeValue);
    yMotionEffect.minimumRelativeValue = @(self.configuration.motionEffectMinimumRelativeValue);
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xMotionEffect, yMotionEffect];
    [self.contentView addMotionEffect:group];
}

- (void)setupAlertContents {
    CGFloat preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width / 2;

    if (self.configuration.customView) {
        UIView *customView = self.configuration.customView;
        customView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.scrollView addSubview:customView];
    } else {
        if (self.configuration.title) {
            PKAlertTitleLabel *titleLabel = [[PKAlertTitleLabel alloc] init];
            titleLabel.font = [UIFont boldSystemFontOfSize:17];
            titleLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
            titleLabel.text = self.configuration.title;
            titleLabel.textAlignment = self.configuration.titleTextAlignment;
            [self.scrollView addSubview:titleLabel];
            [self.scrollViewComponents addObject:titleLabel];
        }
        if (self.configuration.message) {
            PKAlertMessageLabel *label = [[PKAlertMessageLabel alloc] init];
            label.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
            label.font = [UIFont systemFontOfSize:13];
            label.text = self.configuration.message;
            label.textAlignment = self.configuration.messageTextAlignment;
            [self.scrollView addSubview:label];
            [self.scrollViewComponents addObject:label];
        }
    }
}

- (void)configureInitialConstraints {
    UIView *superview = self.contentView.superview;
    CGFloat width = self.mainScreenShortSideLength - self.alertOffset * 2;
    CGFloat actionViewHeight = self.actionCollectionViewController.estimatedContentHeight;
    self.actionContainerViewHeightConstraint.constant = actionViewHeight;

    switch (self.configuration.preferredStyle) {
        case PKAlertControllerStyleAlert:
        {
            NSArray *constraints = @[
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superview
                 attribute:NSLayoutAttributeCenterX multiplier:1. constant:0],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superview
                 attribute:NSLayoutAttributeCenterY multiplier:1. constant:0],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil
                 attribute:NSLayoutAttributeWidth multiplier:1. constant:width],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil
                 attribute:NSLayoutAttributeTop multiplier:1. constant:self.alertOffset],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil
                 attribute:NSLayoutAttributeBottom multiplier:1. constant:self.alertOffset],
            ];
            [superview addConstraints:constraints];
            break;
        }
        case PKAlertControllerStyleFlexibleAlert:
        {
            NSArray *constraints = @[
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superview
                 attribute:NSLayoutAttributeCenterY multiplier:1. constant:0],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1. constant:self.alertOffset],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1. constant:-self.alertOffset],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil
                 attribute:NSLayoutAttributeTop multiplier:1. constant:self.alertOffset],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil
                 attribute:NSLayoutAttributeBottom multiplier:1. constant:self.alertOffset],
            ];
            [superview addConstraints:constraints];
            break;
        }
        case PKAlertControllerStyleFullScreen:
            break;
        case PKAlertControllerStyleActionSheet:
            break;
        case PKAlertControllerStyleFlexibleActionSheet:
            break;
    }
    if (self.scrollViewComponents.count > 0) {
        [self.scrollViewComponents enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1 constant:PKAlertDefaultMargin * 2]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1. constant:0]];

            NSMutableArray *contentConstraints = [NSMutableArray array];
            if (idx == 0) {
                [contentConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:PKAlertDefaultMargin]];
            } else {
                UIView *previousView = [self.scrollViewComponents objectAtIndex:idx - 1];
                if (previousView) {
                    [contentConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1 constant:PKAlertDefaultMargin]];
                }
            }
            if (idx == self.scrollViewComponents.count - 1) {
                [contentConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:-1 * PKAlertDefaultMargin]];
            }
            [self.scrollView addConstraints:contentConstraints];
        }];
    } else if (self.configuration.customView) {
        UIView *customView = self.configuration.customView;
        NSMutableArray *contentConstraints = @[
            [NSLayoutConstraint constraintWithItem:customView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.
             scrollView attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:customView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.
             scrollView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:customView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.
             scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:customView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0],
        ].mutableCopy;
        [self.scrollView addConstraints:contentConstraints];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:customView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];

        if ([customView respondsToSelector:@selector(applyLayoutWithAlertComponentViews:)]) {
            NSMutableDictionary *viewDictionary = PKAlertRemoveSelfFromDictionaryOfVariableBindings( NSDictionaryOfVariableBindings(self.contentView, self.scrollView)).mutableCopy;
            viewDictionary[PKAlertTopLayoutGuideKey] = self.topLayoutGuide;
            viewDictionary[PKAlertRootViewKey] = self.view;
            [(id<PKAlertViewLayoutAdapter>)customView applyLayoutWithAlertComponentViews:viewDictionary];
        }
    }
}

- (void)updateContentViewHeightConstraint {
    CGFloat actionViewHeight = self.actionContainerViewHeightConstraint.constant;
    CGFloat height = 0;
    for (UIView *view in self.scrollViewComponents) {
        if ([view respondsToSelector:@selector(preferredMaxLayoutWidth)]) {
            CGFloat width = MAX([(id)view preferredMaxLayoutWidth], view.bounds.size.width);
            CGSize size = [view sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
            height += size.height;
        }
    }
    if (self.configuration.customView) {
        UIView *customView = self.configuration.customView;
        [customView layoutIfNeeded];
        CGSize size = [customView intrinsicContentSize];
        CGFloat contentHeight = 0;
        contentHeight += size.height;
        if (!self.customViewHeightConstraint) {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:customView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:contentHeight];
            constraint.priority = UILayoutPriorityDefaultHigh;
            self.customViewHeightConstraint = constraint;
            [customView addConstraint:constraint];
        }
        self.customViewHeightConstraint.constant = contentHeight;
        height = contentHeight;
        if ([customView respondsToSelector:@selector(visibleSizeInAlertView)]) {
            height = [(id<PKAlertViewLayoutAdapter>)customView visibleSizeInAlertView].height;
        }
    }

    if (height > 0) {
        NSInteger count = self.scrollViewComponents.count;
        CGFloat totalHeight = actionViewHeight + height + PKAlertDefaultMargin * 2 * count;
        self.contentViewHeightConstraint.constant = totalHeight;
    } else {
        self.contentViewHeightConstraint.constant = actionViewHeight;
    }
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.configuration.preferredStyle == PKAlertControllerStyleFullScreen) {
        self.contentView.layer.cornerRadius = 0;
    }
    if (self.configuration.allowsMotionEffect) {
        [self setupMotionEffect];
    }
    [self setupAlertContents];
    [self configureInitialConstraints];
    [self setupAppearance];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupAppearance) name:PKAlertDidReloadThemeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scrollViewComponents enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.alpha = 0;
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    [self.scrollViewComponents enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([view respondsToSelector:@selector(preferredMaxLayoutWidth)]) {
            [(id)view setPreferredMaxLayoutWidth:self.contentView.bounds.size.width - PKAlertDefaultMargin * 2];
        }
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollViewComponents enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([view respondsToSelector:@selector(preferredMaxLayoutWidth)]) {
            [(id)view setPreferredMaxLayoutWidth:self.contentView.bounds.size.width - PKAlertDefaultMargin * 2];
        }
    }];
    [self updateContentViewHeightConstraint];

    if (self.configuration.customView) {
        [self.configuration.customView setNeedsDisplay];
    }

    // MARK: Avoid aborting in iOS 7
    // ISSUE: http://stackoverflow.com/questions/18429728/autolayout-and-subviews
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [self.view layoutIfNeeded];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.viewInitialized) {
        [self.scrollViewComponents enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -50);
            [UIView animateWithDuration:.3 delay:.0 usingSpringWithDamping:.6 initialSpringVelocity:.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                view.alpha = 1;
                view.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
    }
    self.viewInitialized = YES;
}

#pragma mark - Target actions

- (void)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return .3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;

    // AlertView
    if (toViewController == self) {
        toView.frame = containerView.frame;
        UIColor *origianlContentViewBackgroundColor = self.contentView.backgroundColor;
        [containerView addSubview:toView];
        self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.contentView.backgroundColor = [origianlContentViewBackgroundColor colorWithAlphaComponent:1.];
        toView.alpha = 0;
        fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toView.alpha = 1;
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished) {
                self.contentView.backgroundColor = origianlContentViewBackgroundColor;
                [transitionContext completeTransition:YES];
            }
        }];
    } else {
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            // HACK: Avoid abort.
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
                [self.contentView removeConstraints:self.contentView.constraints];
            }
            self.contentView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            fromView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                toView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                [transitionContext completeTransition:YES];
            }
        }];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:ActionsViewEmbededSegueIdentifier]) {
        PKAlertActionCollectionViewController *viewController = (PKAlertActionCollectionViewController *)segue.destinationViewController;
        viewController.actions = self.configuration.actions;
        viewController.delegate = self;
        self.actionCollectionViewController = viewController;
    }
}

#pragma mark - PKAlertActionCollectionViewControllerDelegate

- (void)actionCollectionViewController:(PKAlertActionCollectionViewController *)viewController didSelectForAction:(PKAlertAction *)action {
    [self dismiss:viewController];
}

@end
