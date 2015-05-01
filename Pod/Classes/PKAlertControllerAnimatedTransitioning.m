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
    return self.duration ? self.duration : 1;
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
            return .5;
        case PKAlertControllerPresentationTransitionStyleSlideLeft:
        case PKAlertControllerPresentationTransitionStyleSlideRight:
            return .5;
        case PKAlertControllerPresentationTransitionStylePushDown:
            return .3;
        case PKAlertControllerPresentationTransitionStyleScale:
            return .5;
        default:
            return [super transitionDuration:transitionContext];
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

    CGFloat containerViewArea = containerView.bounds.size.width * containerView.bounds.size.height;
    CGFloat contentViewArea = contentView.bounds.size.width * contentView.bounds.size.height;

    contentView.backgroundColor = [origianlContentViewBackgroundColor colorWithAlphaComponent:1.];
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    switch (self.style) {
        case PKAlertControllerPresentationTransitionStyleNone:
            [transitionContext completeTransition:YES];
            return;
        case PKAlertControllerPresentationTransitionStyleFadeIn:
        {
            toView.alpha = 0;
            [UIView animateKeyframesWithDuration:totalDuration delay:self.delay options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
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
            [UIView animateWithDuration:totalDuration delay:self.delay usingSpringWithDamping:self.dampingRatio initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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
        case PKAlertControllerPresentationTransitionStyleSlideUp:
        {
            CGAffineTransform t1 = CGAffineTransformMakeTranslation(0, CGRectGetHeight(toView.bounds) + CGRectGetHeight(contentView.bounds) + contentView.frame.origin.y);
            contentView.transform = t1;
            [toView setNeedsLayout];
            CGFloat duration = totalDuration;
            if (!self.duration && containerViewArea / contentViewArea > 2.5) {
                duration /= 2;
            }
            [UIView animateWithDuration:duration delay:self.delay usingSpringWithDamping:self.dampingRatio initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                contentView.transform = CGAffineTransformIdentity;
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
            CGAffineTransform t1 = CGAffineTransformMakeTranslation(0, -1 * CGRectGetHeight(contentView.bounds) - contentView.frame.origin.y);
            contentView.transform = t1;
            [toView setNeedsLayout];
            CGFloat duration = totalDuration;
            if (!self.duration && containerViewArea / contentViewArea > 2.5) {
                duration /= 2;
            }
            [UIView animateWithDuration:duration delay:self.delay usingSpringWithDamping:self.dampingRatio initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                contentView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (finished) {
                    contentView.backgroundColor = origianlContentViewBackgroundColor;
                    [transitionContext completeTransition:YES];
                }
            }];
            return;
        }
        case PKAlertControllerPresentationTransitionStyleSlideLeft:
        {
            CGAffineTransform t1 = CGAffineTransformMakeTranslation(CGRectGetWidth(toView.bounds) + CGRectGetWidth(contentView.bounds) + contentView.frame.origin.x, 0);
            contentView.transform = t1;
            [toView setNeedsLayout];
            [UIView animateWithDuration:totalDuration delay:self.delay usingSpringWithDamping:self.dampingRatio initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                contentView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (finished) {
                    contentView.backgroundColor = origianlContentViewBackgroundColor;
                    [transitionContext completeTransition:YES];
                }
            }];
            return;
        }
        case PKAlertControllerPresentationTransitionStyleSlideRight:
        {
            CGAffineTransform t1 = CGAffineTransformMakeTranslation(-1 * CGRectGetWidth(contentView.bounds) - contentView.frame.origin.x, 0);
            contentView.transform = t1;
            [toView setNeedsLayout];
            [UIView animateWithDuration:totalDuration delay:self.delay usingSpringWithDamping:self.dampingRatio initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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
            CGFloat distance = center.y + fabs(contentView.center.y);
            // UIKit newton 1 unit: size = 100point * 100point, dencity = 1.0, 100point/s2?
            CGFloat fundamentalArea = 100 * 100;
            CGFloat fundamentalVelocityLength = 100;
            CGFloat sizeOfNewton = contentViewArea / fundamentalArea;
            CGFloat d1 = distance / fundamentalVelocityLength;
            CGFloat magnitude = sizeOfNewton * d1 / totalDuration;

            UIDynamicAnimator *animator = alertViewController.animator;
            UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[contentView] mode:UIPushBehaviorModeInstantaneous];
            push.pushDirection = CGVectorMake(0, 1.0);
            [push setTargetOffsetFromCenter:UIOffsetMake(-2.0, 0) forItem:contentView];
            push.magnitude = magnitude;
            push.action = ^{
                if (contentView.center.y >= center.y - 30.0 * d1) {
//                    NSTimeInterval elapsedTime = animator.elapsedTime;
                    NSTimeInterval remainTime;
//                    NSTimeInterval remainTime = totalDuration - elapsedTime;
//                    if (remainTime < 0) {
//                        remainTime = 0;
//                    }
//                    remainTime += sizeOfNewton * remainTime;
//                    remainTime = sizeOfNewton * (totalDuration * 0.2);
                    remainTime = 0.2;
                    [animator removeAllBehaviors];

                    [UIView animateKeyframesWithDuration:remainTime delay:self.delay options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
                        [UIView addKeyframeWithRelativeStartTime:0. relativeDuration:.4 animations:^{
                            contentView.center = CGPointMake(center.x, center.y - d1);
                            if (sizeOfNewton <= 10) {
                                contentView.transform = CGAffineTransformMakeRotation(M_PI / 90.0 * d1);
                            }
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
        case PKAlertControllerPresentationTransitionStyleScale:
        {
            toView.alpha = 0;
            contentView.transform = CGAffineTransformMakeScale(0.6, 0.6);
            [UIView animateWithDuration:totalDuration delay:self.delay usingSpringWithDamping:self.dampingRatio initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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
        case PKAlertControllerPresentationTransitionStyleSemiModal:
        {
            NSAssert(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1, @"Requires iOS version 8.0 or latar");
            CGAffineTransform t1 = CGAffineTransformMakeTranslation(0, CGRectGetHeight(toView.bounds) + CGRectGetHeight(contentView.bounds) + contentView.frame.origin.y);
            contentView.transform = t1;
            [toView setNeedsLayout];
            [UIView animateWithDuration:totalDuration delay:self.delay usingSpringWithDamping:self.dampingRatio initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                contentView.transform = CGAffineTransformIdentity;
                fromView.transform = CGAffineTransformMakeScale(.95, .95);
            } completion:^(BOOL finished) {
                if (finished) {
                    contentView.backgroundColor = origianlContentViewBackgroundColor;
                    [transitionContext completeTransition:YES];
                }
            }];
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
        case PKAlertControllerDismissTransitionStyleNone:
            return 0;
        case PKAlertControllerDismissTransitionStyleFadeOut:
            return .5;
        case PKAlertControllerDismissTransitionStyleZoomOut:
            return .3;
        case PKAlertControllerDismissTransitionStyleSlideLeft:
        case PKAlertControllerDismissTransitionStyleSlideRight:
            return .5;
        case PKAlertControllerDismissTransitionStylePushDown:
            return .5;
        case PKAlertControllerDismissTransitionStyleSemiModal:
            return .5;
        case PKAlertControllerDismissTransitionStyleBounceOut:
            return .5;
        default:
            return [super transitionDuration:transitionContext];
    }

    return [super transitionDuration:transitionContext];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    UIView *contentView = fromView.subviews.firstObject;
    UIView *containerView = [transitionContext containerView];
    PKAlertViewController *alertViewController = (PKAlertViewController *)fromViewController;
    if (!alertViewController.animator) {
        alertViewController.animator = [[UIDynamicAnimator alloc] initWithReferenceView:toView];
    }
    NSTimeInterval totalDuration = [self transitionDuration:transitionContext];

    NSArray *contentConstraints = contentView.constraints;
    NSArray *rootViewConstraints = fromView.constraints;

    CGFloat containerViewArea = containerView.bounds.size.width * containerView.bounds.size.height;
    CGFloat contentViewArea = contentView.bounds.size.width * contentView.bounds.size.height;

    // HACK: Avoid abort.
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [fromView removeConstraints:rootViewConstraints];
        [contentView removeConstraints:contentConstraints];
    }
    switch (self.style) {
        case PKAlertControllerDismissTransitionStyleNone:
            [transitionContext completeTransition:YES];
            return;
        case PKAlertControllerDismissTransitionStyleFadeOut:
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
        case PKAlertControllerDismissTransitionStyleZoomOut:
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
        case PKAlertControllerDismissTransitionStyleSlideUp:
        {
            CGPoint center = contentView.center;
            CGFloat duration = totalDuration;
            if (!self.duration && containerViewArea / contentViewArea > 2.5) {
                duration /= 2;
            }
            [UIView animateWithDuration:duration animations:^{
                toView.transform = CGAffineTransformIdentity;
                contentView.transform = CGAffineTransformMakeTranslation(0, -1 * center.y - CGRectGetHeight(contentView.bounds) / 2.0);
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
            CGFloat duration = totalDuration;
            if (!self.duration && containerViewArea / contentViewArea > 2.5) {
                duration /= 2;
            }
            [UIView animateWithDuration:duration animations:^{
                contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(fromView.bounds) - center.y + CGRectGetHeight(contentView.bounds) / 2.0);
            } completion:^(BOOL finished) {
                if (finished) {
                    toView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                    [transitionContext completeTransition:YES];
                }
            }];
            return;
        }
        case PKAlertControllerDismissTransitionStyleSlideLeft:
        {
            [UIView animateWithDuration:totalDuration animations:^{
                contentView.transform = CGAffineTransformMakeTranslation(-1 * CGRectGetWidth(contentView.bounds) - contentView.frame.origin.x, 0);
            } completion:^(BOOL finished) {
                if (finished) {
                    toView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                    [transitionContext completeTransition:YES];
                }
            }];
            return;
        }
        case PKAlertControllerDismissTransitionStyleSlideRight:
        {
            [UIView animateWithDuration:totalDuration animations:^{
                contentView.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(toView.bounds) + CGRectGetWidth(contentView.bounds) + contentView.frame.origin.x, 0);
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
            // UIKit newton 1 unit: size = 100point * 100point, dencity = 1.0, 100point/s2?
            CGFloat fundamentalArea = 100 * 100;
            CGFloat fundamentalVelocityLength = 100;
            CGFloat sizeForNewton = contentViewArea / fundamentalArea;
            CGFloat d1 = distance / fundamentalVelocityLength;
            CGFloat magnitude = sizeForNewton * d1 / totalDuration;

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
        case PKAlertControllerDismissTransitionStyleSemiModal:
        {
            NSAssert(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1, @"Requires iOS version 8.0 or latar");
            CGPoint center = contentView.center;
            [UIView animateWithDuration:totalDuration animations:^{
                toView.transform = CGAffineTransformIdentity;
                contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(fromView.bounds) - center.y + CGRectGetHeight(contentView.bounds) / 2.0);
            } completion:^(BOOL finished) {
                if (finished) {
                    toView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                    [transitionContext completeTransition:YES];
                }
            }];
            return;
        }
        case PKAlertControllerDismissTransitionStyleBounceOut:
            [UIView animateKeyframesWithDuration:totalDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                [UIView addKeyframeWithRelativeStartTime:0. relativeDuration:.2 animations:^{
                    contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .975, .975);
                }];
                [UIView addKeyframeWithRelativeStartTime:.2 relativeDuration:.4 animations:^{
                    contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
                }];
                [UIView addKeyframeWithRelativeStartTime:.6 relativeDuration:.7 animations:^{
                    contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.2, 0.2);
                }];
                [UIView addKeyframeWithRelativeStartTime:.8 relativeDuration:.9 animations:^{
                    contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
                    fromView.alpha = 0;
                }];
            } completion:^(BOOL finished) {
                if (finished) {
                    toView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                    [transitionContext completeTransition:YES];
                }
            }];
            return;
    }
}

@end
