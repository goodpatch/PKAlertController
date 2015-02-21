//
//  PKAlertControllerConfiguration.h
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import <Foundation/Foundation.h>

#import "PKAlertUtility.h"

@interface PKAlertControllerConfiguration : NSObject <NSCopying>

@property (copy) NSString *title;
@property (copy) NSString *message;
@property PKAlertControllerStyle preferredStyle;
@property (readonly) NSArray *actions;
@property BOOL allowsMotionEffect;

+ (instancetype)defaultConfiguration;
+ (instancetype)defaultConfigurationWithCancelHandler:(void(^)(PKAlertAction *action))handler;
+ (instancetype)simpleAlertConfigurationWithHandler:(void(^)(PKAlertAction *action))handler;

- (void)addAction:(PKAlertAction *)action;
- (void)addActions:(NSArray *)actions;

@end
