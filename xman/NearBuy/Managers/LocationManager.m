//
//  LocationManager.m
//  LNGaosutong
//
//  Created by 罗 建镇 on 15/3/9.
//  Copyright (c) 2015年 Parking. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()<CLLocationManagerDelegate>

@property (nonatomic,strong)CLLocationManager *locManager;
@end

@implementation LocationManager

DEF_SINGLETON(LocationManager)

- (id)init
{
    self = [super init];
    if (self) {
        self.locManager = [[CLLocationManager alloc]init];
        [self.locManager setDelegate:self];
        
    }
    return self;
}

- (void)startUpdateLocationWithCompleted:(DidUpdateLocationBlock)block
{
    if (block) {
        self.updatedBlock = block;
    }
    if (SYSTEM_VERSION_LATER_THAN_7_0) {
        [self.locManager requestWhenInUseAuthorization];
    }
    [self.locManager startUpdatingLocation];
}

- (void)stopUpdateLocation
{
    [self.locManager stopUpdatingLocation];
    self.updatedBlock = nil;
}


- (void)convertLocationToCountry{
    
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    
    [reverseGeocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
//        NSString *countryCode = myPlacemark.ISOcountryCode;
        NSString *countryName = myPlacemark.country;
        NSLog(@"countryName =%@",countryName);
        self.currentPlacemark = myPlacemark;
    }];
    
}

/**
 *  更新得到当前位置，后停止更新
 *
 *  @param manager
 *  @param locations
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations.count>0) {
        
        self.currentLocation = locations[0];
        if (!self.currentPlacemark) {
            [self convertLocationToCountry];
        }

        if (self.updatedBlock) {
            self.updatedBlock(YES);
//            [self stopUpdateLocation];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:GPSUPDATENOTIFICATION object:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.updatedBlock) {
        self.updatedBlock(NO);
    }
}



@end
