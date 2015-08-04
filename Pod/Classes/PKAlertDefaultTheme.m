//
//  PKAlertDefaultTheme.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/24.
//
//

#import "PKAlertDefaultTheme.h"

@implementation PKAlertDefaultTheme

- (UIColor *)mainColor {
    return nil;
}

- (UIColor *)baseTintColor {
    return [UIColor colorWithRed:20./255. green:146./255. blue:250./255. alpha:1];
}

- (UIColor *)barTintColor {
    return [UIColor clearColor];
}

- (UIColor *)shadowColor {
    return nil;
}

- (UIColor *)highlightColor {
    return [UIColor colorWithWhite:.8 alpha:.8];
}

- (UIColor *)backgroundColor {
    return [UIColor colorWithWhite:1 alpha:.9];
}

- (UIColor *)dimColor {
    return [UIColor colorWithWhite:0 alpha:.5];
}

- (UIColor *)separatorColor {
    return [UIColor colorWithWhite:.75 alpha:1];
}

@end
