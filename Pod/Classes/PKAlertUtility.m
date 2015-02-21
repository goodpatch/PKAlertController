//
//  PKAlertUtility.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import "PKAlertUtility.h"

#pragma mark - Functions

NSString *PKAlert_UIKitLocalizedString(NSString *key, NSString *comment)
{
    NSBundle *uikitBundle = [NSBundle bundleWithIdentifier:@"com.apple.UIKit"];
    return [uikitBundle localizedStringForKey:key value:@"" table:nil];
}

NSBundle *PKAlertControllerBundle(void)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PKAlertController" ofType:@"bundle"];
    return [NSBundle bundleWithPath:path];
}

@implementation PKAlertUtility

@end
