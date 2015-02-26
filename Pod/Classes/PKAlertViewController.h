//
//  PKAlertViewController.h
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import <UIKit/UIKit.h>

#import "PKAlertUtility.h"

@class PKAlertControllerConfiguration;
@class PKAlertViewController;

@protocol PKAlertViewControllerDelegate <NSObject>

@optional
- (void)viewWillLayoutAlertSubviewsWithContentView:(UIView *)contentView scrollView:(UIScrollView *)scrollView;
- (void)viewDidLayoutAlertSubviewsWithContentView:(UIView *)contentView scrollView:(UIScrollView *)scrollView;

@end

#pragma mark - PKAlertViewController

@interface PKAlertViewController : UIViewController

@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *alertMessage;
@property (nonatomic) UIView *customView;
@property (nonatomic, readonly) PKAlertControllerConfiguration *configuration;

+ (void)registerStoryboard:(UIStoryboard *)storyboard;
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(PKAlertControllerStyle)preferredStyle;
+ (instancetype)alertControllerWithConfigurationBlock:(PKAlertControllerConfigurationBlock)configurationBlock;
+ (instancetype)simpleAlertControllerWithConfigurationBlock:(PKAlertControllerConfigurationBlock)configurationBlock;
+ (instancetype)alertControllerWithConfiguration:(PKAlertControllerConfiguration *)configuration;

@end
