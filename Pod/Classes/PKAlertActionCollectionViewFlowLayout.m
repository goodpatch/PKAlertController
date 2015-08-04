//
//  PKAlertActionCollectionViewFlowLayout.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/23.
//
//

#import "PKAlertActionCollectionViewFlowLayout.h"
#import "PKAlertThemeManager.h"

static NSString *HorizontalSeparatorBorderDecoratorView = @"com.goodpatch.PKAlertHorizontalSeparator";
static NSString *CenterXSeparatorBorderDecoratorView = @"com.goodpatch.PKAlertCenterXSeparator";

#pragma mark - PKAlertActionCollectionSeparatorView

@interface PKAlertActionCollectionSeparatorView ()

@end

@implementation PKAlertActionCollectionSeparatorView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        id <PKAlertTheme> theme = [PKAlertThemeManager defaultTheme];
        self.backgroundColor = [theme separatorColor];
    }
    return self;
}

@end

#pragma mark - PKAlertActionCollectionViewFlowLayout

@interface PKAlertActionCollectionViewFlowLayout ()

@end

@implementation PKAlertActionCollectionViewFlowLayout

- (id)init {
    self = [super init];
    if (self) {
        [self configureInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureInit];
    }
    return self;
}

- (void)configureInit {
    id <PKAlertTheme> theme = [PKAlertThemeManager defaultTheme];
    self.separatorColor = [theme separatorColor];
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - 

- (NSArray *)createLayoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *newAttributes = [NSMutableArray array];

    if (![self.delegate respondsToSelector:@selector(collectionView:layout:hasHorizontalSeparatorForItemIndexPath:)] ||
        [self.delegate collectionView:self.collectionView layout:self hasHorizontalSeparatorForItemIndexPath:indexPath]) {
        [newAttributes addObject:[self layoutAttributesForDecorationViewOfKind:HorizontalSeparatorBorderDecoratorView atIndexPath:indexPath]];
    }
    if (![self.delegate respondsToSelector:@selector(collectionView:layout:hasCenterXSeparatorForItemIndexPath:)] ||
        [self.delegate collectionView:self.collectionView layout:self hasHorizontalSeparatorForItemIndexPath:indexPath]) {
        NSInteger count = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:indexPath.section];
        if (count == 2 && indexPath.item == 1) {
            [newAttributes addObject:[self layoutAttributesForDecorationViewOfKind:CenterXSeparatorBorderDecoratorView atIndexPath:indexPath]];
        }
    }
    return newAttributes;
}

#pragma mark - UISubclassingHooks

- (void)prepareLayout {
    [self registerClass:[PKAlertActionCollectionSeparatorView class] forDecorationViewOfKind:HorizontalSeparatorBorderDecoratorView];
    [self registerClass:[PKAlertActionCollectionSeparatorView class] forDecorationViewOfKind:CenterXSeparatorBorderDecoratorView];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *allAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newLayoutAttributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in allAttributes) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            NSArray *decorationAttributes = [self createLayoutAttributesForDecorationViewAtIndexPath:attributes.indexPath];
            if (decorationAttributes) {
                [newLayoutAttributes addObjectsFromArray:decorationAttributes];
            }
        }
        [newLayoutAttributes addObject:attributes];
    }
    return newLayoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    CGRect cellFrame = cellAttributes.frame;
    CGFloat scale = [UIScreen mainScreen].scale;

    if ([elementKind isEqualToString:HorizontalSeparatorBorderDecoratorView]) {
        layoutAttributes.frame = CGRectMake(cellFrame.origin.x + self.separatorInset.left, cellFrame.origin.y, cellFrame.size.width - self.separatorInset.left - self.separatorInset.right, 1.0 / scale);
    } else if ([elementKind isEqualToString:CenterXSeparatorBorderDecoratorView]) {
        layoutAttributes.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y + self.separatorInset.top, 1.0 / scale, cellFrame.size.height - self.separatorInset.top - self.separatorInset.bottom);
    }
    layoutAttributes.zIndex = 10;

    return layoutAttributes;
}

@end
