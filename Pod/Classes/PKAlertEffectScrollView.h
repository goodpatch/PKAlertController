//
//  PKAlertEffectScrollView.h
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/23.
//
//

#import <UIKit/UIKit.h>

@interface UIScrollView (PKAlertAddtions)

@property (nonatomic, readwrite) NSString *contentInsetFromString;

@end

#pragma mark - PKAlertEffectScrollView

// Like a UIPickerView transparent edge effect.

@interface PKAlertEffectScrollView : UIScrollView

@property (nonatomic, getter=isTransparentEdgeEnabled) BOOL transparentEdgeEnabled;
@property (nonatomic) CGFloat gradientFactor;

@end
