//
//  PKAlertActionCollectionViewFlowLayout.h
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/23.
//
//

#import <UIKit/UIKit.h>

#pragma mark - PKAlertActionCollectionSeparatorView

@interface PKAlertActionCollectionSeparatorView : UICollectionReusableView

@end

#pragma mark - PKAlertActionCollectionViewFlowLayoutDelegate

@protocol PKAlertActionCollectionViewFlowLayoutDelegate <NSObject>

@optional
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout hasHorizontalSeparatorForItemIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout hasCenterXSeparatorForItemIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - PKAlertActionCollectionViewFlowLayout

@interface PKAlertActionCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, getter=isSeparatorDisabled) BOOL separatorDisabled;
@property (nonatomic) UIEdgeInsets separatorInset;
@property (nonatomic) UIColor *separatorColor;

@property (weak, nonatomic) IBOutlet id <PKAlertActionCollectionViewFlowLayoutDelegate> delegate;

@end
