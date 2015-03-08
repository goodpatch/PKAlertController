//
//  PKCustomView.h
//  PKAlertController
//
//  Created by Satoshi Ohki on 2015/02/25.
//  Copyright (c) 2015年 Satoshi Ohki. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <PKAlertUtility.h>

typedef NS_ENUM(NSInteger, PKCustomViewType) {
    PKCustomViewTypeTitleLabel = 1,
    PKCustomViewTypeSubTitleLabel,
    PKCustomViewTypeDescriptionTextView,
};

@interface PKCustomView : UIView <PKAlertViewLayoutAdapter>

@end
