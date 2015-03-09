//
//  PKAlertControllerAnimatedTransitioning.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/03/08.
//
//

#import "PKAlertControllerAnimatedTransitioning.h"

#import <objc/runtime.h>
#import "PKAlertViewController.h"

#pragma mark - PKAlertViewController(PKAlertAnimatedTransitioning)

@interface PKAlertViewController (PKAlertAnimatedTransitioning)

@property (nonatomic) UIDynamicAnimator *animator;

@end

@implementation PKAlertViewController (PKAlertAnimatedTransitioning)

- (UIDynamicAnimator *)animator {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAnimator:(UIDynamicAnimator *)animator {
    objc_setAssociatedObject(self, @selector(animator), animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


#pragma mark - PKAlertControllerAnimatedTransitioning

@implementation PKAlertControllerAnimatedTransitioning

#pragma mark - <UIViewControllerAnimatedTransitioning>

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration || .5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
}

@end

#pragma mark - PKAlertControllerPresentingAnimatedTransitioning

@implementation PKAlertControllerPresentingAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.duration) {
        return self.duration;
    }
    switch (self.style) {
        case PKAlertControllerPresentationTransitionStyleNone:
            return 0;
        case PKAlertControllerPresentationTransitionStyleFadeIn:
            return .3;
        case PKAlertControllerPresentationTransitionStyleFocusIn:
            return .3;
        case PKAlertControllerPresentationTransitionStyleSlideDown:
            return .3;
        case PKAlertControllerPresentationTransitionStylePushDown:
            return .3;
    }
    return [super transitionDuration:transitionContext];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    UIView *contentView = toView.subviews.firstObject;
    PKAlertViewController *alertViewController = (PKAlertViewController *)toViewController;
    if (!alertViewController.animator) {
        alertViewController.animator = [[UIDynamicAnimator alloc] initWithReferenceView:toView];
    }

    toView.frame = containerView.frame;
    [containerView addSubview:toView];
    [toView setNeedsLayout];
    [toView layoutIfNeeded];
    UIColor *origianlContentViewBackgroundColor = contentView.backgroundColor;
    NSTimeInterval totalDuration = [self transitionDuration:transitionContext];

    contentView.backgroundColor = [origianlContentViewBackgroundColor colorWithAlphaComponent:1.];
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    switch (self.style) {
        case PKAlertControllerPresentationTransitionStyleNone:
            [transitionContext completeTransition:YES];
            return;
        case PKAlertControllerPresentationTransitionStyleFadeIn:
        {
            toView.alpha = 0;
            [UIView animateKeyframesWithDuration:totalDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                [UIView addKeyframeWithRelativeStartTime:0. relativeDuration:.6 animations:^{
                    toView.alpha = 0.5;
                }];
                [UIView addKeyframeWithRelativeStartTime:.6 relativeDuration:1. animations:^{
                    toView.alpha = 1.;
                }];
            } completion:^(BOOL finished) {
                if (finished) {
                    contentView.backgroundColor = origianlContentViewBackgroundColor;
                    [transitionContext completeTransition:YES];
                }
            }];
            return;
        }
        case PKAlertControllerPresentationTransitionStyleFocusIn:
        {
            toView.alpha = 0;
            contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            [UIView animateWithDuration:totalDuration animations:^{
                contentView.transform = CGAffineTransformIdentity;
                toView.alpha = 1.;
            } completion:^(BOOL finished) {
                if (finished) {
                    contentView.backgroundColor = origianlContentViewBackgroundColor;
                    [transitionContext completeTransition:YES];
                }
            }];
            return;
        }
        case PKAlertControllerPresentationTransitionStyleSlideDown:
        {
            NSAssert(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1, @"Requires iOS version 8.0 or latar");
            CGAffineTransform t1 = CGAffineTransformMakeTranslation(0, -1 * CGRectGetHeight(contentView.bounds) - contentView.frame.origin.y);
            contentView.transform = t1;
            [toView setNeedsLayout];
            [UIView animateWithDuration:totalDuration animations:^{
                contentView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (finished) {
                    contentView.backgroundColor = origianlContentViewBackgroundColor;
                    [transitionContext completeTransition:YES];
                }
            }];
            return;
        }
        case PKAlertControllerPresentationTransitionStylePushDown:
        {
            NSAssert(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1, @"Requires iOS version 8.0 or latar");
            CGPoint center = contentView.center;
            contentView.center = CGPointMake(center.x, -1 * CGRectGetHeight(contentView.bounds));
            CGFloat distance = center.y + fabsf(contentView.center.y);
            CGFloat contentSize = contentView.bounds.size.width * contentView.bounds.size.height;
            // UIKit newton 1 unit: size = 100point * 100point, dencity = 1.0, 100point/s2?
            CGFloat fundamentalSize = 100 * 100;
            CGFloat fundamentalVelocityLength = 100;
            CGFloat sizeForNewton = contentSize / fundamentalSize;
            CGFloat d1 = distance / fundamentalVelocityLength;
            CGFloat magnitude = sizeForNewton * d1 / (totalDuration * 0.8);    // timeOffset=0.8
            magnitude /= 2;

            UIDynamicAnimator *animator = alertViewController.animator;
            UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[contentView] mode:UIPushBehaviorModeInstantaneous];
            push.pushDirection = CGVectorMake(0, 1.0);
            [push setTargetOffsetFromCenter:UIOffsetMake(-1.0, 0) forItem:contentView];
            push.magnitude = magnitude;
            push.action = ^{
                if (contentView.center.y >= center.y - 30.0) {
                    NSTimeInterval elapsedTime = animator.elapsedTime;
                    NSTimeInterval remainTime = totalDuration - elapsedTime;
                    if (remainTime < 0) {
                        remainTime = 0;
                    }
//                    remainTime += sizeForNewton * remainTime;
//                    remainTime = sizeForNewton * (totalDuration * 0.2);
                    remainTime = 0.2;
                    [animator removeAllBehaviors];

                    [UIView animateKeyframesWithDuration:remainTime delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
                        [UIView addKeyframeWithRelativeStartTime:0. relativeDuration:.4 animations:^{
                            contentView.center = CGPointMake(center.x, center.y - 15);
                            contentView.transform = CGAffineTransformMakeRotation(M_PI / 90.0);
                        }];
                        [UIView addKeyframeWithRelativeStartTime:0. relativeDuration:.6 animations:^{
                            contentView.center = center;
                            contentView.transform = CGAffineTransformIdentity;
                        }];
                    } completion:^(BOOL finished) {
                        if (finished) {
                            contentView.backgroundColor = origianlContentViewBackgroundColor;
                            [transitionContext completeTransition:YES];
                        }
                    }];
                }
            };
            [animator addBehavior:push];
            return;
        }
        default:
            break;
    }
}

@end

#pragma mark - PKAlertControllerDismissingAnimatedTransitioning

@implementation PKAlertControllerDismissingAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.duration) {
        return self.duration;
    }

    switch (self.style) {
        case PKAlertControllerDismissStyleTransitionNone:
            return 0;
        case PKAlertControllerDismissStyleTransitionFadeOut:
            return .5;
        case PKAlertControllerDismissStyleTransitionZoomOut:
            return .3;
        case PKAlertControllerDismissTransitionStyleSlideDown:
            return .3;
        case PKAlertControllerDismissTransitionStylePushDown:
            return .5;
        default:
            break;
    }

    return [super transitionDuration:transitionContext];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    UIView *contentView = fromView.subviews.firstObject;
    PKAlertViewController *alertViewController = (PKAlertViewController *)fromViewController;
    if (!alertViewController.animator) {
        alertViewController.animator = [[UIDynamicAnimator alloc] initWithReferenceView:toView];
    }
    NSTimeInterval totalDuration = [self transitionDuration:transitionContext];

    NSArray *contentConstraints = contentView.constraints;
    NSArray *rootViewConstraints = fromView.constraints;
    // HACK: Avoid abort.
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [fromView removeConstraints:rootViewConstraints];
        [contentView removeConstraints:contentConstraints];
    }
    switch (self.style) {
        case PKAlertControllerDismissStyleTransitionNone:
            [transitionContext completeTransition:YES];
            return;
        case PKAlertControllerDismissStyleTransitionFadeOut:
        {
            [UIView animateWithDuration:totalDuration animations:^{
                fromView.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    toView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                    [transitionContext completeTransition:YES];
                }
            }];
            return;
        }
        case PKAlertControllerDismissStyleTransitionZoomOut:
        {
            [UIView animateWithDuration:totalDuration animations:^{
                contentView.transform = CGAffineTransformMakeScale(0.6, 0.6);
                fromView.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    toView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                    [transitionContext completeTransition:YES];
                }
            }];
            return;
        }
        case PKAlertControllerDismissTransitionStyleSlideDown:
        {
            CGPoint center = contentView.center;
            [UIView animateWithDuration:totalDuration animations:^{
                contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(fromView.bounds) - center.y + CGRectGetHeight(contentView.bounds) / 2.0);
            } completion:^(BOOL finished) {
                if (finished) {
                    toView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                    [transitionContext completeTransition:YES];
                }
            }];
            return;
        }
        case PKAlertControllerDismissTransitionStylePushDown:
        {
            CGPoint center = contentView.center;
            CGPoint targetCenter = CGPointMake(center.x, CGRectGetHeight(fromView.bounds) + center.y + CGRectGetHeight(contentView.bounds) / 2.0);
            CGFloat distance = targetCenter.y - center.y + CGRectGetHeight(contentView.bounds) / 2.0;
            CGFloat contentSize = contentView.bounds.size.width * contentView.bounds.size.height;
            // UIKit newton 1 unit: size = 100point * 100point, dencity = 1.0, 100point/s2?
            CGFloat fundamentalSize = 100 * 100;
            CGFloat fundamentalVelocityLength = 100;
            CGFloat sizeForNewton = contentSize / fundamentalSize;
            CGFloat d1 = distance / fundamentalVelocityLength;
            CGFloat magnitude = sizeForNewton * d1 / totalDuration;
            magnitude /= 1.5;

            UIDynamicAnimator *animator = alertViewController.animator;
            UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[contentView] mode:UIPushBehaviorModeInstantaneous];
            push.pushDirection = CGVectorMake(0, 1.0);
            push.magnitude = magnitude;
            [push setTargetOffsetFromCenter:UIOffsetMake(-5.0, 0) forItem:contentView];
            push.action = ^{
//                if (animator.elapsedTime >= totalDuration) {
                if (contentView.frame.origin.y > fromView.frame.size.height) {
                    [animator removeAllBehaviors];
                    toView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                    [transitionContext completeTransition:YES];
                }
            };
            [animator addBehavior:push];
            return;
        }
    }
}

@end
