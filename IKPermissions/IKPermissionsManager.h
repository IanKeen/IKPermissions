//
//  IKPermissionsManager
//
//  Created by Ian Keen on 5/06/2015.
//  Copyright (c) 2015 IanKeen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IKResults/AsyncResult.h>

@interface IKPermissionsManager : NSObject
-(instancetype)initWithPermissionHandlers:(NSArray *)handlers;
-(AsyncResult *)checkPermissions;

@property (nonatomic, readonly) BOOL isChecking;
@end
