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
@property UIImage *headerImage;
@property PKAlertControllerStyle preferredStyle;
@property NSTextAlignment titleTextAlignment;
@property NSTextAlignment messageTextAlignment;
@property UIView *customView;

@property (readonly) NSArray *actions;

@property BOOL allowsMotionEffect;
@property CGFloat motionEffectMinimumRelativeValue;
@property CGFloat motionEffectMaximumRelativeValue;
@property BOOL scrollViewTransparentEdgeEnabled;

// TODO: title font(NSAttributedString), color, backgroundColor
// TODO: message font(NSAttributedString), color, backgroundColor
// TODO: action font(NSAttributedString>, color, backgroundColor

+ (instancetype)defaultConfiguration;
+ (instancetype)defaultConfigurationWithCancelHandler:(void(^)(PKAlertAction *action))handler;
+ (instancetype)simpleAlertConfigurationWithHandler:(void(^)(PKAlertAction *action))handler;

- (void)addAction:(PKAlertAction *)action;
- (void)addActions:(NSArray *)actions;

@end
