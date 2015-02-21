//
//  PKAlertControllerConfiguration.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import "PKAlertControllerConfiguration.h"

#import "PKAlertAction.h"

@interface PKAlertControllerConfiguration ()

@end

@implementation PKAlertControllerConfiguration

+ (instancetype)defaultConfiguration {
    PKAlertControllerConfiguration *object = [[PKAlertControllerConfiguration alloc] init];
    [object addAction:[PKAlertAction cancelAction]];
    return object;
}

+ (instancetype)defaultConfigurationWithCancelHandler:(void(^)(PKAlertAction *action))handler {
    PKAlertControllerConfiguration *object = [[PKAlertControllerConfiguration alloc] init];
    [object addAction:[PKAlertAction cancelActionWithHandler:handler]];
    return object;
}

+ (instancetype)simpleAlertConfigurationWithHandler:(void(^)(PKAlertAction *action))handler {
    PKAlertControllerConfiguration *object = [[PKAlertControllerConfiguration alloc] init];
    [object addAction:[PKAlertAction okActionWithHandler:handler]];
    return object;
}

#pragma mark - NSCoping

- (id)copyWithZone:(NSZone *)zone {
    PKAlertControllerConfiguration *copiedObject = [[[self class] allocWithZone:zone] init];
    if (copiedObject) {
        copiedObject->_title = [_title copyWithZone:zone];
        copiedObject->_message = [_message copyWithZone:zone];
        copiedObject->_preferredStyle = _preferredStyle;
        copiedObject->_actions = [_actions copyWithZone:zone];
        copiedObject->_allowsMotionEffect = _allowsMotionEffect;
    }
    return copiedObject;
}

#pragma mark - Init & dealloc

- (id)init {
    self = [super init];
    if (self) {
        _actions = @[];
        _allowsMotionEffect = YES;
    }
    return self;
}

#pragma mark -

- (void)addAction:(PKAlertAction *)action {
    NSMutableArray *mAction = _actions.mutableCopy;
    [mAction addObject:action];
    _actions = mAction.copy;
}

- (void)addActions:(NSArray *)actions {
    NSMutableArray *mAction = _actions.mutableCopy;
    for (id action in actions) {
        NSAssert([action isKindOfClass:[PKAlertAction class]], @"");
        [mAction addObject:action];
    }
    _actions = mAction.copy;
}

@end
