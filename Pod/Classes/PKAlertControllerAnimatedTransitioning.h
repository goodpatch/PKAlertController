//
//  PKAlertControllerAnimatedTransitioning.h
//  Pods
//
//  Created by Satoshi Ohki on 2015/03/08.
//
//

#import <Foundation/Foundation.h>

#import "PKAlertUtility.h"

#pragma mark - PKAlertControllerAnimatedTransitioning

@interface PKAlertControllerAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) CGFloat duration;

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext;
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;

@end

#pragma mark - PKAlertControllerPresentingAnimatedTransitioning

@interface PKAlertControllerPresentingAnimatedTransitioning : PKAlertControllerAnimatedTransitioning

@property (nonatomic) PKAlertControllerPresentationTransitionStyle style;
@property (nonatomic) CGFloat dampingRatio;
@property (nonatomic) NSTimeInterval delay;
@property (nonatomic) UIViewTintAdjustmentMode tintAdjustmentMode;

@end

#pragma mark - PKAlertControllerDismissingAnimatedTransitioning

@interface PKAlertControllerDismissingAnimatedTransitioning : PKAlertControllerAnimatedTransitioning

@property (nonatomic) PKAlertControllerDismissTransitionStyle style;

@end
