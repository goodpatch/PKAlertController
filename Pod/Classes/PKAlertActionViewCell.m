//
//  PKAlertActionViewCell.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/22.
//
//

#import "PKAlertActionViewCell.h"

@interface PKAlertActionViewCell ()

@end

@implementation PKAlertActionViewCell

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    // FIXME: This is a bug with the iOS 8 SDK running on iOS 7 devices.
    // ISSUE: http://stackoverflow.com/a/25820173
    self.contentView.frame = bounds;
}

@end
