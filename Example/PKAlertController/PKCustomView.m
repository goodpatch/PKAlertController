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

@property (nonatomic) CALayer *subTitleBottomBorderLayer;

@end


@implementation PKCustomView

- (CALayer *)createSubTitleBorderLayer {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = self.subTitleLabel.textColor.CGColor;
    bottomBorder.borderWidth = 1 / [UIScreen mainScreen].scale;
    bottomBorder.frame = CGRectMake(0, CGRectGetHeight(self.subTitleLabel.bounds), CGRectGetWidth(self.subTitleLabel.bounds), bottomBorder.borderWidth);
    return bottomBorder;
}

#pragma mark -

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.subTitleBottomBorderLayer) {
        [self.subTitleBottomBorderLayer removeFromSuperlayer];
        self.subTitleBottomBorderLayer = nil;
    }
    self.subTitleBottomBorderLayer = [self createSubTitleBorderLayer];
    [self.subTitleLabel.layer addSublayer:self.subTitleBottomBorderLayer];
}

- (CGSize)intrinsicContentSize {
    CGFloat subviewWidth = self.bounds.size.width - self.titleLabelLeadingConstraint.constant * 2;
    CGFloat subviewHeight = [self.titleLabel sizeThatFits:CGSizeMake(subviewWidth, CGFLOAT_MAX)].height;
    subviewHeight += self.subTitleHeightConstraint.constant;
    subviewHeight += [self.descriptionLabel sizeThatFits:CGSizeMake(subviewWidth, CGFLOAT_MAX)].height;

    CGSize totalSize = CGSizeMake(self.bounds.size.width, subviewHeight + 20);
    return totalSize;
}

@end
