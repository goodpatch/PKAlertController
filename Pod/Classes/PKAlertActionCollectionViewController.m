//
//  PKAlertActionCollectionViewController.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import "PKAlertActionCollectionViewController.h"

#import "PKAlertAction.h"
#import "PKAlertActionViewCell.h"
#import "PKAlertThemeManager.h"

@interface PKAlertActionCollectionViewController () <UICollectionViewDelegateFlowLayout>

@end

@implementation PKAlertActionCollectionViewController

static NSString * const reuseIdentifier = @"PKAlertViewControllerCellReuseIdentifier";

- (CGSize)collectionViewContentSize {
    return self.collectionView.collectionViewLayout.collectionViewContentSize;
}

- (CGFloat)estimatedContentHeight {
    NSUInteger count = self.actions.count;
    if (count == 0) {
        return 0;
    } else if (count <= 2) {
        return PKAlertDefaultTappableHeight;
    }
    return PKAlertDefaultTappableHeight * count;
}

- (void)configureCell:(PKAlertActionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PKAlertAction *action = self.actions[indexPath.item];
    cell.titleLabel.text = action.title;
    if (indexPath.item == [self.collectionView numberOfItemsInSection:indexPath.section] - 1) {
        UIFontDescriptor *fontDescriptor = cell.titleLabel.font.fontDescriptor;
        UIFontDescriptor *boldFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        cell.titleLabel.font = [UIFont fontWithDescriptor:boldFontDescriptor size:fontDescriptor.pointSize];
    }
}

#pragma mark - View life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        [self.collectionView.collectionViewLayout invalidateLayout];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    // FIXME: iOS7 not working invalidateLayout in willRoateToInterfaceOrientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.collectionView.collectionViewLayout invalidateLayout];
        } completion:nil];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.actions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [self configureCell:(PKAlertActionViewCell *)cell atIndexPath:indexPath];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIColor *highlightColor = [[PKAlertThemeManager defaultTheme] highlightColor];
    if (highlightColor) {
        cell.contentView.backgroundColor = highlightColor;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PKAlertAction *action = self.actions[indexPath.item];
    [self.delegate actionCollectionViewController:self didSelectForAction:action];
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = [(UICollectionViewFlowLayout *)collectionViewLayout itemSize];
    itemSize.width = collectionView.bounds.size.width;
    if (self.actions.count == 2) {
        itemSize.width /= 2.0;
    }
    return itemSize;
}

@end
