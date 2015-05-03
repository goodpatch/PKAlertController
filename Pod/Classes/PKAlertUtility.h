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

extern NSString *const PKAlertRootViewKey;
extern NSString *const PKAlertContentViewKey;
extern NSString *const PKAlertScrollViewKey;
extern NSString *const PKAlertTopLayoutGuideKey;

extern NSString *const PKAlertWillRefreshAppearanceNotification;
extern NSString *const PKAlertDidRefreshAppearanceNotification;
extern NSString *const PKAlertWillReloadThemeNotification;
extern NSString *const PKAlertDidReloadThemeNotification;

extern NSString *PKAlert_UIKitLocalizedString(NSString *key, NSString *comment) __attribute__((const));
extern NSBundle *PKAlertControllerBundle(void)  __attribute__((const));
extern void PKAlertReloadAppearance() __attribute__((const));
extern UIView *PKAlertGetViewInViews(NSString *key, NSDictionary *views) __attribute__((pure));
extern NSDictionary *PKAlertRemoveSelfFromDictionaryOfVariableBindings(NSDictionary *bindings);
extern BOOL PKAlertViewControllerBasedStatusBarAppearance();

typedef NS_ENUM (NSInteger, PKAlertControllerStyle) {
    PKAlertControllerStyleAlert = 0,
    PKAlertControllerStyleFlexibleAlert,
    PKAlertControllerStyleFullScreen,
    //    PKAlertControllerStyleActionSheet,
    //    PKAlertControllerStyleFlexibleActionSheet,
};

typedef NS_ENUM (NSInteger, PKAlertControllerPresentationTransitionStyle) {
    PKAlertControllerPresentationTransitionStyleNone = 0,
    PKAlertControllerPresentationTransitionStyleFadeIn,
    PKAlertControllerPresentationTransitionStyleFocusIn,
    PKAlertControllerPresentationTransitionStyleSlideUp,
    PKAlertControllerPresentationTransitionStyleSlideDown,
    PKAlertControllerPresentationTransitionStyleSlideLeft,
    PKAlertControllerPresentationTransitionStyleSlideRight,
    PKAlertControllerPresentationTransitionStylePushDown  NS_ENUM_AVAILABLE_IOS(8_0),
    PKAlertControllerPresentationTransitionStyleScale,
    PKAlertControllerPresentationTransitionStyleSemiModal NS_ENUM_AVAILABLE_IOS(8_0),
};

typedef NS_ENUM (NSInteger, PKAlertControllerDismissTransitionStyle) {
    PKAlertControllerDismissTransitionStyleNone = 0,
    PKAlertControllerDismissTransitionStyleFadeOut,
    PKAlertControllerDismissTransitionStyleZoomOut,
    PKAlertControllerDismissTransitionStyleSlideUp,
    PKAlertControllerDismissTransitionStyleSlideDown,
    PKAlertControllerDismissTransitionStyleSlideLeft,
    PKAlertControllerDismissTransitionStyleSlideRight,
    PKAlertControllerDismissTransitionStylePushDown,
    PKAlertControllerDismissTransitionStyleSemiModal NS_ENUM_AVAILABLE_IOS(8_0),
    PKAlertControllerDismissTransitionStyleBounceOut,
};

typedef NS_ENUM (NSInteger, PKAlertControllerViewAppearInAnimationType) {
    PKAlertControllerViewAppearInAnimationTypeNone = 0,
    PKAlertControllerViewAppearInAnimationTypeDropIn,
};

/*!
    @abstract A callback handler blocks when an action button cell selected and a PKAlertViewController object dismissed.
    @discussion
        This handler called twice when an action button cell selected and a PKAlertViewController object dismissed for each.
    @param action an tapped alert action button
    @param closed Whether PKAlertViewController dismissed
 */
typedef void (^PKActionHandler)(PKAlertAction *action, BOOL closed);

/*!
    @abstract A builder blocks with <i>PKAlertControllerConfiguration</i> initializing.
    @discussion
        The builder pattern Software design pattern.
 */
typedef void (^PKAlertControllerConfigurationBlock)(PKAlertControllerConfiguration *configuration);

#pragma mark - <PKAlertViewLayoutAdapter>

/*!
    @abstract Method definitions that called by <i>PKAlertViewController</i>
 */
@protocol PKAlertViewLayoutAdapter <NSObject>

@optional
/*!
    @abstract Implemented by a custom view to apply layout constraints and addtional actions when setup of layout constraints by <i>PKAlertViewController</i>
    @param views A dictionary of views that appear in the visual format string. The keys must be the string values used in the visual format string, and the values must be the view objects.
 */
- (void)applyLayoutWithAlertComponentViews:(NSDictionary *)views;

/*!
    @abstract Defines an alert content visible size to display scroll view transparent edges or do anything.
 */
- (CGSize)visibleSizeInAlertView;

@end

#pragma mark -

@interface PKAlertUtility : NSObject

@end
