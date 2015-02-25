//
//  PKAlertThemeManager.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/24.
//
//

#import "PKAlertThemeManager.h"

#import "PKAlertDefaultTheme.h"
#import "PKAlertWhiteBlueTheme.h"
#import "PKAlertUtility.h"

#import "PKAlertViewController.h"
#import "PKAlertActionCollectionViewController.h"

static BOOL pkAutoReloadAndNotification = YES;
static id<PKAlertTheme> pkDefaultTheme;

@implementation PKAlertThemeManager

+ (void)initialize {
    pkDefaultTheme = [[PKAlertDefaultTheme alloc] init];
}

+ (void)setAutoReloadThemeAndNotificationOnChanged:(BOOL)autoReload {
    if (autoReload != pkAutoReloadAndNotification) {
        pkAutoReloadAndNotification = autoReload;
    }
}

+ (void)setRegisterDefaultTheme:(id<PKAlertTheme>)theme {
    NSParameterAssert(theme);
    NSParameterAssert([theme conformsToProtocol:@protocol(PKAlertTheme)]);
    if (![theme isMemberOfClass:[pkDefaultTheme class]]) {
        pkDefaultTheme = theme;
        if (pkAutoReloadAndNotification) {
            [self customizeAlertAppearance];
            PKAlertReloadAppearance();
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:PKAlertDidReloadThemeNotification object:self];
            });
        }
    }
}

+ (id<PKAlertTheme>)defaultTheme {
    return pkDefaultTheme;
}

#pragma mark - Apply default theme to view components

+ (void)customizeAlertAppearance {
    id <PKAlertTheme> theme = [self defaultTheme];
    UIColor *barTintColor = [theme barTintColor];
    [[UICollectionViewCell appearanceWhenContainedIn:[PKAlertActionCollectionViewController class], nil] setBackgroundColor:barTintColor];
    UIColor *baseTintColor = [theme baseTintColor];
    [[UILabel appearanceWhenContainedIn:[PKAlertActionCollectionViewController class], nil] setTextColor:baseTintColor];
}

+ (void)customizeAlertDimView:(UIView *)view {
    id <PKAlertTheme> theme = [self defaultTheme];
    UIColor *dimColor = [theme dimColor];
    view.backgroundColor = dimColor;
}

+ (void)customizeAlertContentView:(UIView *)view {
    id <PKAlertTheme> theme = [self defaultTheme];
    UIColor *backgroundColor = [theme backgroundColor];
    view.backgroundColor = backgroundColor;
}

@end
