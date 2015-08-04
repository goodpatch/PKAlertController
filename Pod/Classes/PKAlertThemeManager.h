//
//  PKAlertThemeManager.h
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/24.
//
//

#import <Foundation/Foundation.h>

@protocol PKAlertTheme <NSObject>

- (UIColor *)mainColor;
- (UIColor *)baseTintColor;
- (UIColor *)barTintColor;
- (UIColor *)shadowColor;
- (UIColor *)highlightColor;
- (UIColor *)backgroundColor;
- (UIColor *)dimColor;
- (UIColor *)separatorColor;

@end

@interface PKAlertThemeManager : NSObject

// TODO: switch theme: Notification before/after
+ (void)setAutoReloadThemeAndNotificationOnChanged:(BOOL)autoReload;
+ (void)setRegisterDefaultTheme:(id<PKAlertTheme>)theme;
+ (id<PKAlertTheme>)defaultTheme;

#pragma mark - Apply default theme to view components

+ (void)customizeAlertAppearance;
+ (void)customizeAlertDimView:(UIView *)view;
+ (void)customizeAlertContentView:(UIView *)view;

@end
