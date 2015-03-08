//
//  PKAlertControllerConfiguration.h
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import <Foundation/Foundation.h>

#import "PKAlertUtility.h"

@protocol PKAlertViewControllerDelegate;

@interface PKAlertControllerConfiguration : NSObject <NSCopying>

@property (copy) NSString *title;
@property (copy) NSString *message;
@property PKAlertControllerStyle preferredStyle;
@property NSTextAlignment titleTextAlignment;
@property NSTextAlignment messageTextAlignment;

/*!
    @abstract Set the view controller transition type to dismiss an alert view controller.
 */
@property PKAlertControllerPresentationTransitionStyle presentationTransitionStyle;

/*!
    @abstract Set the view controller transition type to present an alert view controller.
 */
@property PKAlertControllerDismissTransitionStyle dismissTransitionStyle;

/*!
    @abstract Set the animation type to animate an alert content after the view controller transition.
 */
@property PKAlertControllerViewAppearInAnimationType viewAppearInAnimationType;

/*!
    @abstract UIView to display on the alert view content.
 */
@property UIView<PKAlertViewLayoutAdapter> *customView;

@property (readonly) NSArray *actions;

@property BOOL allowsMotionEffect;
@property CGFloat motionEffectMinimumRelativeValue;
@property CGFloat motionEffectMaximumRelativeValue;
@property BOOL scrollViewTransparentEdgeEnabled;

/*!
    @abstract If status bar style update that an alert view presented. default value is `YES`
    @discussion
        Disable when View controller-based status bar appearance.
 */
@property BOOL statusBarAppearanceUpdate;

+ (instancetype)defaultConfiguration;
+ (instancetype)defaultConfigurationWithCancelHandler:(void(^)(PKAlertAction *action))handler;
+ (instancetype)simpleAlertConfigurationWithHandler:(void(^)(PKAlertAction *action))handler;

- (void)addAction:(PKAlertAction *)action;
- (void)addActions:(NSArray *)actions;

@end
