//
//  PKAlertController.h
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import <UIKit/UIKit.h>

extern NSBundle *PKAlertControllerBundle(void)  __attribute__((const));

typedef NS_ENUM(NSInteger, PKAlertControllerStyle) {
    PKAlertControllerStyleAlert = 0,
    PKAlertControllerStyleAlertLong,
    PKAlertControllerStyleFullScreen,
    PKAlertControllerStyleActionSheet,
    PKAlertControllerStyleActionSheetLong,
};

#pragma mark - PKAlertController

@interface PKAlertController : UIViewController

@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *alertMessage;
@property (nonatomic, copy) NSAttributedString *alertAttributedTitle;
@property (nonatomic, copy) NSAttributedString *alertAttributedMessage;
@property (nonatomic, readonly) PKAlertControllerStyle preferredStyle;
@property (nonatomic, readonly) NSArray *actionButtons;

+ (void)registerStoryboard:(UIStoryboard *)storyboard;
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(PKAlertControllerStyle)preferredStyle;

@end
