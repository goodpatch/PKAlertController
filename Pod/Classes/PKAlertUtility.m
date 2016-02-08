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

NSString *const PKAlertRootViewKey = @"rootView";
NSString *const PKAlertContentViewKey = @"contentView";
NSString *const PKAlertScrollViewKey = @"scrollView";
NSString *const PKAlertTopLayoutGuideKey = @"topLayoutGuide";

NSString *const PKAlertWillRefreshAppearanceNotification = @"com.goodpatch.PKAlertWillRefreshAppearanceNotification";
NSString *const PKAlertDidRefreshAppearanceNotification = @"com.goodpatch.PKAlertDidRefreshAppearanceNotification";
NSString *const PKAlertWillReloadThemeNotification = @"com.goodpatch.PKAlertWillReloadThemeNotificaiton";
NSString *const PKAlertDidReloadThemeNotification = @"com.goodpatch.PKAlertDidReloadThemeNotification";

static NSString *const UIViewControllerBasedStatusBarAppearance = @"UIViewControllerBasedStatusBarAppearance";

#pragma mark - Functions

NSString *PKAlert_UIKitLocalizedString(NSString *key, NSString *comment)
{
    NSBundle *uikitBundle = [NSBundle bundleWithIdentifier:@"com.apple.UIKit"];
    return [uikitBundle localizedStringForKey:key value:@"" table:nil];
}

NSBundle *PKAlertControllerBundle(void)
{
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[PKAlertUtility class]];
    NSString *bundlePath = [[frameworkBundle resourcePath] stringByAppendingPathComponent:@"PKAlertController.bundle"];
    return [NSBundle bundleWithPath:bundlePath];
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

UIView *PKAlertGetViewInViews(NSString *key, NSDictionary *views)
{
    assert(key && key.length > 0);
    assert(views && [views isKindOfClass:[NSDictionary class]]);

    NSArray *viewKeys = views.allKeys;
    NSString *alterKey = [NSString stringWithFormat:@"self.%@", key];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF IN %@)", @[key, alterKey]];
    NSString *foundKey = [[viewKeys filteredArrayUsingPredicate:predicate] firstObject];
    if (!foundKey) {
        return nil;
    }

    return views[foundKey];
}

NSDictionary *PKAlertRemoveSelfFromDictionaryOfVariableBindings(NSDictionary *bindings)
{
    assert(bindings && [bindings isKindOfClass:[NSDictionary class]]);
    static NSString *const InstanceVariableSign = @"_";
    static NSString *const SelfVariableKey = @"self.";

    NSMutableDictionary *newBindings = [NSMutableDictionary dictionary];
    for (NSString *key in bindings) {
        NSString *newKey = [[key stringByReplacingOccurrencesOfString:InstanceVariableSign withString:@""] stringByReplacingOccurrencesOfString:SelfVariableKey withString:@""];
        newBindings[newKey] = bindings[key];
    }

    return newBindings;
}

BOOL PKAlertViewControllerBasedStatusBarAppearance()
{
    NSDictionary *infoPlist = [NSBundle mainBundle].infoDictionary;
    return [infoPlist[UIViewControllerBasedStatusBarAppearance] boolValue];
}

@implementation PKAlertUtility

@end
