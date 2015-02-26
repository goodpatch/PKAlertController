//
//  PKCustomView.m
//  PKAlertController
//
//  Created by Satoshi Ohki on 2015/02/25.
//  Copyright (c) 2015年 Satoshi Ohki. All rights reserved.
//

#import "PKCustomView.h"

@interface PKCustomView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleHeightConstraint;

@end


@implementation PKCustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGSize)intrinsicContentSize {
    CGFloat subviewWidth = self.bounds.size.width - self.titleLabelLeadingConstraint.constant * 2;
    CGFloat subviewHeight = [self.titleLabel sizeThatFits:CGSizeMake(subviewWidth, CGFLOAT_MAX)].height;
    subviewHeight += self.subTitleHeightConstraint.constant;
    subviewHeight += [self.descriptionLabel sizeThatFits:CGSizeMake(subviewWidth, CGFLOAT_MAX)].height;

    CGSize totalSize = CGSizeMake(self.bounds.size.width, subviewHeight);
    return totalSize;
}

@end
