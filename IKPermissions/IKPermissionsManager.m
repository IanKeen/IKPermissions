//
//  IKPermissionsManager
//
//  Created by Ian Keen on 5/06/2015.
//  Copyright (c) 2015 IanKeen. All rights reserved.
//

#import "IKPermissionsManager.h"
#import "IKPermissionHandler.h"
#import <IKCore/NSArray+Reduce.h>

@interface IKPermissionsManager ()
@property (nonatomic, strong) NSArray *handlers;
@end

@implementation IKPermissionsManager
#pragma mark - Lifecycle
-(instancetype)initWithPermissionHandlers:(NSArray *)handlers {
    if (!(self = [super init])) { return nil; }
    self.handlers = handlers;
    return self;
}

#pragma mark - Public
-(AsyncResult *)checkPermissions {
    if (self.isChecking) {
        //NOTE: this is required because returning nil and then attempting .success/.failure results in BAD_EXEC
        [NSException raise:@"IKPermissionsManager" format:@"Already checking permissions, please use 'isChecking' to prevent this error"];
    }
    
    _isChecking = YES;
    
    AsyncResult *result = [self.handlers reduce:nil function:^id(AsyncResult *accumulator, id<IKPermissionHandler> handler) {
        if (accumulator == nil) { return [handler checkPermission]; }
        return accumulator.flatMapAsyncTo(handler, @selector(checkPermission));
    }];
    
    return result.finally(^() { _isChecking = NO; });
}
@end
