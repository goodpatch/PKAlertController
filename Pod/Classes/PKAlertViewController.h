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

#pragma mark - PKAlertViewController

@interface PKAlertViewController : UIViewController

@property (nonatomic, readonly) PKAlertControllerConfiguration *configuration;

+ (void)registerStoryboard:(UIStoryboard *)storyboard;
+ (instancetype)instantiateOwnerViewController;
+ (instancetype)alertControllerWithConfigurationBlock:(PKAlertControllerConfigurationBlock)configurationBlock;
+ (instancetype)simpleAlertControllerWithConfigurationBlock:(PKAlertControllerConfigurationBlock)configurationBlock;
+ (instancetype)alertControllerWithConfiguration:(PKAlertControllerConfiguration *)configuration;

@end
