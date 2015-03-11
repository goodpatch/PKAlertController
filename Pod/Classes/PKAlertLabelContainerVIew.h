//
//  PKAlertLabelContainerVIew.h
//  Pods
//
//  Created by Satoshi Ohki on 2015/03/01.
//
//

#import <UIKit/UIKit.h>

@class PKAlertControllerConfiguration;

#import "PKAlertUtility.h"

#pragma mark - PKAlertDefaultLabel

@interface PKAlertDefaultLabel : UILabel

@end

@interface PKAlertTitleLabel : PKAlertDefaultLabel

@end

@interface PKAlertMessageLabel : PKAlertDefaultLabel

@end

#pragma mark - PKAlertLabelContainerView

@interface PKAlertLabelContainerView : UIView <PKAlertViewLayoutAdapter>

+ (instancetype)viewWithConfiguration:(PKAlertControllerConfiguration *)configuration;

@property (nonatomic, readonly) PKAlertTitleLabel *titleLabel;
@property (nonatomic, readonly) PKAlertMessageLabel *messageLabel;

@end
