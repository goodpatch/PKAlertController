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

@interface PKAlertActionCollectionViewController () <UICollectionViewDelegateFlowLayout>

@end

@implementation PKAlertActionCollectionViewController

static NSString * const reuseIdentifier = @"PKAlertViewControllerCellReuseIdentifier";

- (CGSize)collectionViewContentSize {
    return self.collectionView.collectionViewLayout.collectionViewContentSize;
}

- (void)configureCell:(PKAlertActionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PKAlertAction *action = self.actions[indexPath.item];
    cell.title = action.title;
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
    cell.contentView.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
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
