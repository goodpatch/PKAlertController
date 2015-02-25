//
//  PKAlertUtility.h
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import <Foundation/Foundation.h>

@class PKAlertAction;
@class PKAlertControllerConfiguration;
@class PKAlertController;

extern const CGFloat PKAlertDefaultMargin;
extern const CGFloat PKAlertDefaultTappableHeight;
extern const CGFloat PKAlertMessageMargin;

extern NSString *const PKAlertWillRefreshAppearanceNotification;
extern NSString *const PKAlertDidRefreshAppearanceNotification;
extern NSString *const PKAlertWillReloadThemeNotification;
extern NSString *const PKAlertDidReloadThemeNotification;

extern NSString *PKAlert_UIKitLocalizedString(NSString *key, NSString *comment) __attribute__((const));
extern NSBundle *PKAlertControllerBundle(void)  __attribute__((const));
extern void PKAlertReloadAppearance() __attribute__((const));

typedef NS_ENUM(NSInteger, PKAlertControllerStyle) {
    PKAlertControllerStyleAlert = 0,
    PKAlertControllerStyleFlexibleAlert,
    PKAlertControllerStyleFullScreen,
    PKAlertControllerStyleActionSheet,
    PKAlertControllerStyleFlexibleActionSheet,
};

typedef void(^PKActionHandler)(PKAlertAction *action);
typedef void(^PKAlertControllerConfigurationBlock)(PKAlertControllerConfiguration *configuration);

@interface PKAlertUtility : NSObject

@end
