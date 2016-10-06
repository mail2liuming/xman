//
//  LocationManager.h
//  LNGaosutong
//
//  Created by 罗 建镇 on 15/3/9.
//  Copyright (c) 2015年 Parking. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DidUpdateLocationBlock) (BOOL success);

typedef void(^DidSearchObjBlock) (id obj ,id pois ,BOOL success);

@interface LocationManager : NSObject

@property (nonatomic,strong)CLLocation *currentLocation;
@property (nonatomic,strong)CLPlacemark *currentPlacemark;
@property (nonatomic,strong)DidUpdateLocationBlock updatedBlock;
@property (nonatomic,strong)DidSearchObjBlock searchBlock;
AS_SINGLETON(LocationManager)

- (void)startUpdateLocationWithCompleted:(DidUpdateLocationBlock)block;

- (void)stopUpdateLocation;


@end
