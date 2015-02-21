//
//  PKAlertController.h
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import <UIKit/UIKit.h>

@class PKAlertAction;
@class PKAlertControllerConfiguration;
@class PKAlertController;

extern NSString *PKAlert_UIKitLocalizedString(NSString *key, NSString *comment) __attribute__((const));
extern NSBundle *PKAlertControllerBundle(void)  __attribute__((const));

typedef NS_ENUM(NSInteger, PKAlertControllerStyle) {
    PKAlertControllerStyleAlert = 0,
    PKAlertControllerStyleFlexibleAlert,
    PKAlertControllerStyleFullScreen,
    PKAlertControllerStyleActionSheet,
    PKAlertControllerStyleFlexibleActionSheet,
};

typedef void(^PKActionHandler)(PKAlertAction *action);
typedef void(^PKAlertControllerConfigurationBlock)(PKAlertControllerConfiguration *configuration);

#pragma mark - PKAlertAction

@interface PKAlertAction : NSObject <NSCopying>

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, copy) PKActionHandler handler;

+ (instancetype)actionWithTitle:(NSString *)title handler:(PKActionHandler)handler;
+ (instancetype)cancelAction;
+ (instancetype)cancelActionWithHandler:(void(^)(PKAlertAction *))handler;
+ (instancetype)okAction;
+ (instancetype)okActionWithHandler:(void(^)(PKAlertAction *))handler;
+ (instancetype)doneAction;
+ (instancetype)doneActionWithHandler:(void(^)(PKAlertAction *))handler;

@end

#pragma mark - PKAlertControllerConfiguration

@interface PKAlertControllerConfiguration : NSObject <NSCopying>

@property (copy) NSString *title;
@property (copy) NSString *message;
@property PKAlertControllerStyle preferredStyle;
@property (readonly) NSArray *actions;
@property BOOL allowsMotionEffect;

+ (instancetype)defaultConfiguration;
+ (instancetype)defaultConfigurationWithCancelHandler:(void(^)(PKAlertAction *action))handler;
+ (instancetype)simpleAlertConfigurationWithHandler:(void(^)(PKAlertAction *action))handler;

- (void)addAction:(PKAlertAction *)action;
- (void)addActions:(NSArray *)actions;

@end

#pragma mark - PKAlertController

@interface PKAlertController : UIViewController

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

#pragma mark - PKAlertActionCollectionViewController

@interface PKAlertActionCollectionViewController : UICollectionViewController

@end
