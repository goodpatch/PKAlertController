//
//  PKAlertViewController.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import "PKAlertViewController.h"

#import "PKAlertAction.h"
#import "PKAlertControllerConfiguration.h"
#import "PKAlertActionCollectionViewController.h"

static UIStoryboard *pk_registeredStoryboard;
static NSString *pk_defaultStoryboardName = @"PKAlert";
static NSString *const ActionsViewEmbededSegueIdentifier = @"actionsViewEmbedSegue";

@interface PKAlertViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, PKAlertActionCollectionViewControllerDelegate>

@property (nonatomic, getter=isViewInitialized) BOOL viewInitialized;
@property (nonatomic) CGFloat mainScreenShortSideLength;
@property (nonatomic) PKAlertControllerConfiguration *configuration;
@property (nonatomic) PKAlertActionCollectionViewController *actionCollectionViewController;
@property (nonatomic) CGSize labelSize;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *actionContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionContainerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

#pragma mark - User defined runtime attributes

@property (nonatomic) CGFloat alertOffset;
@property (nonatomic) CGFloat actionSheetOffset;

@end

@implementation PKAlertViewController

+ (void)initialize {
    pk_registeredStoryboard = [UIStoryboard storyboardWithName:pk_defaultStoryboardName bundle:PKAlertControllerBundle()];
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
    NSParameterAssert(preferredStyle <= PKAlertControllerStyleFullScreen);

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

#pragma mark - Configure & Setup

- (void)configureInit {
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    CGSize size = [UIScreen mainScreen].bounds.size;
    _mainScreenShortSideLength = MIN(size.width, size.height);
    _configuration = [[PKAlertControllerConfiguration alloc] init];
    _labelSize = CGSizeZero;
}

- (void)setupMotionEffect {
    // TODO: MotionEffect settings
    UIInterpolatingMotionEffect *xMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    UIInterpolatingMotionEffect *yMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    xMotionEffect.maximumRelativeValue = @10.0;
    xMotionEffect.minimumRelativeValue = @-10.0;
    yMotionEffect.maximumRelativeValue = @10.0;
    yMotionEffect.minimumRelativeValue = @-10.0;
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xMotionEffect, yMotionEffect];
    [self.contentView addMotionEffect:group];
}

- (void)setupAlertContents {
    // TODO: title, message
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width / 2;
    label.text = self.configuration.message;
//    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollView addSubview:label];
    CGSize size = [label sizeThatFits:CGSizeMake(label.preferredMaxLayoutWidth, CGFLOAT_MAX)];
    self.labelSize = size;
}

- (void)configureConstraintsInLayoutSubviews {
    UIView *superview = self.contentView.superview;
    CGFloat width = self.mainScreenShortSideLength - self.alertOffset * 2;
    NSInteger actionCount = self.configuration.actions.count;
    CGFloat actionViewHeight = 0;
    if (actionCount > 0 && actionCount < 3) {
        actionViewHeight = 44.0;
    } else if (actionCount >= 3) {
        actionViewHeight = 44.0 * actionCount;
    }
    self.actionContainerViewHeightConstraint.constant = actionViewHeight;

    switch (self.configuration.preferredStyle) {
        case PKAlertControllerStyleAlert:
        {
            self.contentViewHeightConstraint.constant = actionViewHeight + self.labelSize.height;
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
            self.contentViewHeightConstraint.constant = actionViewHeight + self.labelSize.height;
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
        {
            NSArray *constraints = @[
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1. constant:0],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1. constant:0],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1. constant:0],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1. constant:0],
            ];
            [superview addConstraints:constraints];
            break;
        }
        case PKAlertControllerStyleActionSheet:
            break;
        case PKAlertControllerStyleFlexibleActionSheet:
            break;
    }
    UILabel *label = [[self.scrollView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *binding) {
        if ([evaluatedObject isKindOfClass:[UILabel class]]) {
            return YES;
        }
        return NO;
    }]] firstObject];
    if (label) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterX multiplier:1. constant:0]];
        NSArray *contentConstraints = @[
                                        [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:16],
                                        [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                                        ];
        [self.scrollView addConstraints:contentConstraints];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeWidth multiplier:1 constant:40]];
    //    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.labelSize.height + 84]];

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:.9];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (!self.isViewInitialized) {
        [self configureConstraintsInLayoutSubviews];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    UILabel *label = [[self.scrollView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *binding) {
        if ([evaluatedObject isKindOfClass:[UILabel class]]) {
            return YES;
        }
        return NO;
    }]] firstObject];
    if (label) {
        label.preferredMaxLayoutWidth = self.contentView.bounds.size.width - 40;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
