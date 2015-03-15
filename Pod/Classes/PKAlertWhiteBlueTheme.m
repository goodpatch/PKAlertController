//
//  PKAlertWhiteBlueTheme.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/24.
//
//

#import "PKAlertWhiteBlueTheme.h"

@implementation PKAlertWhiteBlueTheme

- (UIColor *)baseTintColor {
    return [UIColor colorWithWhite:1 alpha:1];
}

- (UIColor *)barTintColor {
    return [UIColor colorWithRed:89./255. green:144./255. blue:252./255. alpha:1];
}

- (UIColor *)highlightColor {
    return [[self barTintColor] colorWithAlphaComponent:.8];
}

- (UIColor *)backgroundColor {
    return [UIColor whiteColor];
}

@end
