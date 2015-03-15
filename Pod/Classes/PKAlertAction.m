//
//  PKAlertAction.m
//  Pods
//
//  Created by Satoshi Ohki on 2015/02/21.
//
//

#import "PKAlertAction.h"

@interface PKAlertAction ()

@property (nonatomic) NSString *title;

@end

@implementation PKAlertAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void(^)(PKAlertAction *))handler {
    PKAlertAction *object = [[self alloc] init];
    object.title = title;
    object.handler = handler;
    return object;
}

+ (instancetype)cancelAction {
    PKAlertAction *object = [self actionWithTitle:PKAlert_UIKitLocalizedString(@"Cancel", @"") handler:nil];
    return object;
}

+ (instancetype)cancelActionWithHandler:(void(^)(PKAlertAction *))handler {
    PKAlertAction *object = [self actionWithTitle:PKAlert_UIKitLocalizedString(@"Cancel", @"") handler:handler];
    return object;
}

+ (instancetype)okAction {
    PKAlertAction *object = [self actionWithTitle:PKAlert_UIKitLocalizedString(@"OK", @"") handler:nil];
    return object;
}

+ (instancetype)okActionWithHandler:(void(^)(PKAlertAction *))handler {
    PKAlertAction *object = [self actionWithTitle:PKAlert_UIKitLocalizedString(@"OK", @"") handler:handler];
    return object;
}

+ (instancetype)doneAction {
    PKAlertAction *object = [self actionWithTitle:PKAlert_UIKitLocalizedString(@"Done", @"") handler:nil];
    return object;
}

+ (instancetype)doneActionWithHandler:(void(^)(PKAlertAction *))handler {
    PKAlertAction *object = [self actionWithTitle:PKAlert_UIKitLocalizedString(@"Done", @"") handler:handler];
    return object;
}

#pragma mark - NSCoping

- (id)copyWithZone:(NSZone *)zone {
    PKAlertAction *copiedObject = [[[self class] allocWithZone:zone] init];
    if (copiedObject) {
        copiedObject->_title = [_title copyWithZone:zone];
        copiedObject->_enabled = _enabled;
        copiedObject->_handler = [_handler copy];
    }
    return copiedObject;
}

#pragma mark - Init & dealloc

- (id)init {
    self = [super init];
    if (self) {
        _enabled = YES;
    }
    return self;
}

@end
