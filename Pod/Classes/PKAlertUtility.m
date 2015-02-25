//
//  PKAlertUtility.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import "PKAlertUtility.h"

const CGFloat PKAlertDefaultMargin = 8.0;
const CGFloat PKAlertDefaultTappableHeight = 44.0;
const CGFloat PKAlertMessageMargin = 20.0;

NSString *const PKAlertWillRefreshAppearanceNotification = @"com.goodpatch.PKAlertWillRefreshAppearanceNotification";
NSString *const PKAlertDidRefreshAppearanceNotification = @"com.goodpatch.PKAlertDidRefreshAppearanceNotification";
NSString *const PKAlertWillReloadThemeNotification = @"com.goodpatch.PKAlertWillReloadThemeNotificaiton";
NSString *const PKAlertDidReloadThemeNotification = @"com.goodpatch.PKAlertDidReloadThemeNotification";

#pragma mark - Functions

NSString *PKAlert_UIKitLocalizedString(NSString *key, NSString *comment)
{
    NSBundle *uikitBundle = [NSBundle bundleWithIdentifier:@"com.apple.UIKit"];
    return [uikitBundle localizedStringForKey:key value:@"" table:nil];
}

NSBundle *PKAlertControllerBundle(void)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PKAlertController" ofType:@"bundle"];
    return [NSBundle bundleWithPath:path];
}

void PKAlertReloadAppearance()
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PKAlertWillRefreshAppearanceNotification object:nil];

    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:PKAlertDidRefreshAppearanceNotification object:nil];
}

@implementation PKAlertUtility

@end
