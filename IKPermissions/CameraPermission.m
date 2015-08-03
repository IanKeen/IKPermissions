//
//  CameraPermissions
//
//  Created by Ian Keen on 5/06/2015.
//  Copyright (c) 2015 IanKeen. All rights reserved.
//

#import "CameraPermission.h"
#import <IKResults/AsyncResult.h>

@import AVFoundation;

@interface CameraPermission ()
@property (nonatomic, strong) AsyncResult *result;
@end

@implementation CameraPermission
-(NSString *)name { return @"Camera"; }

-(AsyncResult *)checkPermission {
    self.result = [AsyncResult asyncResult];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                Result *result = (granted ?
                                  [Result success:@YES] :
                                  [Result failure:[self error:[self name] desc:@"User Denied"]]);
                [self.result fulfill:result];
            }];
            break;
        }
            
        case AVAuthorizationStatusRestricted:
            [self.result fulfill:[Result failure:[self error:[self name] desc:@"Restricted"]]];
            break;
        
        case AVAuthorizationStatusDenied:
            [self.result fulfill:[Result failure:[self error:[self name] desc:@"Denied"]]];
            break;
        
        case AVAuthorizationStatusAuthorized:
            [self.result fulfill:[Result success:@YES]];
            break;
    }
    
    return self.result;
}

-(NSError *)error:(NSString *)name desc:(NSString *)desc {
    NSError *instance = [NSError errorWithDomain:name code:0 userInfo:@{NSLocalizedDescriptionKey: desc}];
    return instance;
}
@end
