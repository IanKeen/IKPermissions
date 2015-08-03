//
//  IKPermissionsHandler
//
//  Created by Ian Keen on 5/06/2015.
//  Copyright (c) 2015 IanKeen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IKResults/AsyncResult.h>

@protocol IKPermissionHandler <NSObject>
-(NSString *)name;
-(AsyncResult *)checkPermission;
@end