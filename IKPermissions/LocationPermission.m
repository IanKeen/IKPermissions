//
//  LocationPermissions
//
//  Created by Ian Keen on 5/06/2015.
//  Copyright (c) 2015 IanKeen. All rights reserved.
//

#import "LocationPermission.h"
#import <IKResults/AsyncResult.h>

@import CoreLocation;

@interface LocationPermission () <CLLocationManagerDelegate>
@property (nonatomic, strong) AsyncResult *result;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation LocationPermission
-(NSString *)name { return @"Location"; }
-(AsyncResult *)checkPermission {
    self.result = [AsyncResult asyncResult];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    return self.result;
}

#pragma mark - Private
-(void)askForLocationAccess {
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [self.locationManager requestWhenInUseAuthorization];
            
        } else {
            [self.result fulfill:[Result failure:[self error:[self name] desc:@"Info.plist value NSLocationWhenInUseUsageDescription missing"]]];
        }
    } else {
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    Result *result = nil;
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:       [self askForLocationAccess]; break;
        case kCLAuthorizationStatusRestricted:          result = [Result failure:[self error:[self name] desc:@"Access Restricted"]]; break;
        case kCLAuthorizationStatusDenied:              result = [Result failure:[self error:[self name] desc:@"User has denied access"]]; break;
        case kCLAuthorizationStatusAuthorizedAlways:    result = [Result success:@YES]; break;
        case kCLAuthorizationStatusAuthorizedWhenInUse: result = [Result success:@YES]; break;
    }
    
    if (result) {
        [self.locationManager stopUpdatingLocation];
        [self.result fulfill:result];
    }
}

-(NSError *)error:(NSString *)name desc:(NSString *)desc {
    NSError *instance = [NSError errorWithDomain:name code:0 userInfo:@{NSLocalizedDescriptionKey: desc}];
    return instance;
}
@end