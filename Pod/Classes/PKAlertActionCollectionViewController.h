//
//  PKAlertActionCollectionViewController.h
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import <UIKit/UIKit.h>

@class PKAlertAction;
@class PKAlertActionCollectionViewController;

@protocol PKAlertActionCollectionViewControllerDelegate <NSObject>

- (void)actionCollectionViewController:(PKAlertActionCollectionViewController *)viewController didSelectForAction:(PKAlertAction *)action;

@end

@interface PKAlertActionCollectionViewController : UICollectionViewController

@property (weak, nonatomic) IBOutlet id<PKAlertActionCollectionViewControllerDelegate> delegate;
@property (nonatomic) NSArray *actions;
@property (nonatomic) CGFloat actionHeight;
@property (nonatomic, readonly) CGSize collectionViewContentSize;
@property (nonatomic, readonly) CGFloat estimatedContentHeight;

@end
