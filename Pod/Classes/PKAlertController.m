//
//  PKAlertController.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import "PKAlertController.h"

static UIStoryboard *pk_registeredStoryboard;
static NSString *pk_defaultStoryboardName = @"PKAlert";
static NSString *const ActionsViewEmbededSegueIdentifier = @"actionsViewEmbedSegue";

#pragma mark - Functions

NSString *PKAlert_UIKitLocalizedString(NSString *key, NSString *comment)
{
    NSBundle *uikitBundle = [NSBundle bundleWithIdentifier:@"com.apple.UIKit"];
    return [uikitBundle localizedStringForKey:key value:@"" table:nil];
}

NSBundle *PKAlertControllerBundle(void)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:NSStringFromClass([PKAlertController class]) ofType:@"bundle"];
    return [NSBundle bundleWithPath:path];
}

#pragma mark - PKAlertAction

@interface PKAlertAction ()

@property (nonatomic) NSString *title;

@end

@implementation PKAlertAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void(^)(PKAlertAction *))handler {
    PKAlertAction *object = [[self alloc] init];
    object.title = title;
    object.handler = handler;
    return object;
}

+ (instancetype)cancelAction {
    PKAlertAction *object = [self actionWithTitle:PKAlert_UIKitLocalizedString(@"Cancel", @"") handler:nil];
    return object;
}

+ (instancetype)cancelActionWithHandler:(void(^)(PKAlertAction *))handler {
    PKAlertAction *object = [self actionWithTitle:PKAlert_UIKitLocalizedString(@"Cancel", @"") handler:handler];
    return object;
}

+ (instancetype)okAction {
    PKAlertAction *object = [self actionWithTitle:PKAlert_UIKitLocalizedString(@"OK", @"") handler:nil];
    return object;
}

+ (instancetype)okActionWithHandler:(void(^)(PKAlertAction *))handler {
    PKAlertAction *object = [self actionWithTitle:PKAlert_UIKitLocalizedString(@"OK", @"") handler:handler];
    return object;
}

+ (instancetype)doneAction {
    PKAlertAction *object = [self actionWithTitle:PKAlert_UIKitLocalizedString(@"Done", @"") handler:nil];
    return object;
}

+ (instancetype)doneActionWithHandler:(void(^)(PKAlertAction *))handler {
    PKAlertAction *object = [self actionWithTitle:PKAlert_UIKitLocalizedString(@"Done", @"") handler:handler];
    return object;
}

#pragma mark - NSCoping

- (id)copyWithZone:(NSZone *)zone {
    PKAlertAction *copiedObject = [[[self class] allocWithZone:zone] init];
    if (copiedObject) {
        copiedObject->_title = [_title copyWithZone:zone];
        copiedObject->_enabled = _enabled;
        copiedObject->_handler = [_handler copy];
    }
    return copiedObject;
}

#pragma mark - Init & dealloc

- (id)init {
    self = [super init];
    if (self) {
        _enabled = YES;
    }
    return self;
}

@end

#pragma mark - PKAlertControllerConfiguration

@interface PKAlertControllerConfiguration ()

@end

@implementation PKAlertControllerConfiguration

+ (instancetype)defaultConfiguration {
    PKAlertControllerConfiguration *object = [[PKAlertControllerConfiguration alloc] init];
    [object addAction:[PKAlertAction cancelAction]];
    return object;
}

+ (instancetype)defaultConfigurationWithCancelHandler:(void(^)(PKAlertAction *action))handler {
    PKAlertControllerConfiguration *object = [[PKAlertControllerConfiguration alloc] init];
    [object addAction:[PKAlertAction cancelActionWithHandler:handler]];
    return object;
}

+ (instancetype)simpleAlertConfigurationWithHandler:(void(^)(PKAlertAction *action))handler {
    PKAlertControllerConfiguration *object = [[PKAlertControllerConfiguration alloc] init];
    [object addAction:[PKAlertAction okActionWithHandler:handler]];
    return object;
}

#pragma mark - NSCoping

- (id)copyWithZone:(NSZone *)zone {
    PKAlertControllerConfiguration *copiedObject = [[[self class] allocWithZone:zone] init];
    if (copiedObject) {
        copiedObject->_title = [_title copyWithZone:zone];
        copiedObject->_message = [_message copyWithZone:zone];
        copiedObject->_preferredStyle = _preferredStyle;
        copiedObject->_actions = [_actions copyWithZone:zone];
        copiedObject->_allowsMotionEffect = _allowsMotionEffect;
    }
    return copiedObject;
}

#pragma mark - Init & dealloc

- (id)init {
    self = [super init];
    if (self) {
        _actions = @[];
        _allowsMotionEffect = YES;
    }
    return self;
}

#pragma mark -

- (void)addAction:(PKAlertAction *)action {
    NSMutableArray *mAction = _actions.mutableCopy;
    [mAction addObject:action];
    _actions = mAction.copy;
}

- (void)addActions:(NSArray *)actions {
    NSMutableArray *mAction = _actions.mutableCopy;
    for (id action in actions) {
        NSAssert([action isKindOfClass:[PKAlertAction class]], @"");
        [mAction addObject:action];
    }
    _actions = mAction.copy;
}

@end

#pragma mark - PKAlertController

@interface PKAlertController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, getter=isViewInitialized) BOOL viewInitialized;
@property (nonatomic) CGFloat mainScreenShortSideLength;
@property (nonatomic) PKAlertControllerConfiguration *configuration;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *actionContainerView;

#pragma mark - User defined runtime attributes

@property (nonatomic) CGFloat alertOffset;
@property (nonatomic) CGFloat actionSheetOffset;

@end

@implementation PKAlertController

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

    PKAlertController *viewController = [self instantiateOwnerViewController];
    viewController.configuration.preferredStyle = preferredStyle;
    viewController.configuration.title = title;
    viewController.configuration.message = message;

    return viewController;
}

+ (instancetype)alertControllerWithConfigurationBlock:(PKAlertControllerConfigurationBlock)configurationBlock {
    NSParameterAssert(configurationBlock);
    PKAlertController *viewController = [self instantiateOwnerViewController];
    PKAlertControllerConfiguration *configuration = [[PKAlertControllerConfiguration alloc] init];
    configurationBlock(configuration);
    viewController.configuration = configuration;
    return viewController;
}

+ (instancetype)simpleAlertControllerWithConfigurationBlock:(PKAlertControllerConfigurationBlock)configurationBlock {
    NSParameterAssert(configurationBlock);
    PKAlertController *viewController = [self instantiateOwnerViewController];
    PKAlertControllerConfiguration *configuration = [PKAlertControllerConfiguration simpleAlertConfigurationWithHandler:nil];
    configurationBlock(configuration);
    viewController.configuration = configuration;
    return viewController;
}

+ (instancetype)alertControllerWithConfiguration:(PKAlertControllerConfiguration *)configuration {
    NSParameterAssert(configuration);
    PKAlertController *viewController = [self instantiateOwnerViewController];
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

- (void)configureConstraintsInLayoutSubviews {
    UIView *superview = self.contentView.superview;
    CGFloat width = self.mainScreenShortSideLength - self.alertOffset * 2;
    switch (self.configuration.preferredStyle) {
        case PKAlertControllerStyleAlert:
        {
            NSLayoutConstraint *contentHeightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1. constant:width];
            contentHeightConstraint.priority = UILayoutPriorityDefaultHigh;
            NSArray *constraints = @[
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superview
                 attribute:NSLayoutAttributeCenterX multiplier:1. constant:0],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superview
                 attribute:NSLayoutAttributeCenterY multiplier:1. constant:0],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil
                 attribute:NSLayoutAttributeWidth multiplier:1. constant:width],
                contentHeightConstraint,
            ];
            [superview addConstraints:constraints];
            break;
        }
        case PKAlertControllerStyleFlexibleAlert:
        {
            NSLayoutConstraint *contentHeightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1. constant:width];
            contentHeightConstraint.priority = UILayoutPriorityDefaultHigh;
            NSArray *constraints = @[
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superview
                 attribute:NSLayoutAttributeCenterY multiplier:1. constant:0],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1. constant:self.alertOffset],
                [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1. constant:-self.alertOffset],
                contentHeightConstraint,
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidAppear:animated];
    self.viewInitialized = YES;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss:nil];
    });
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
        UIColor *origianlContentViewBackgroundColor = self.contentView.backgroundColor;
        [containerView addSubview:toView];
        self.contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([segue.identifier isEqualToString:ActionsViewEmbededSegueIdentifier]) {
    }
}

@end

#pragma mark - PKAlertActionCollectionViewController

@interface PKAlertActionCollectionViewController ()

@property (nonatomic) NSArray *actions;

@end

@implementation PKAlertActionCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
