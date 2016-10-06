//
//  EtyUser.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/17.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EtyUser : NSObject
@property (nonatomic,strong)NSString *session_id;
@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *device_id;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *last_lat;
@property (nonatomic,strong)NSString *last_lng;
@property (nonatomic,strong)NSString *register_time;
@property (nonatomic,strong)NSString *last_login_time;
@property (nonatomic,strong)NSString *client_id;
@property (nonatomic,strong)NSString *status;

- (void)adreportToService:(NSString*)content withad_id:(NSString *)adid withitype:(NSString *)reportType completed:(LoadServerDataFinishedBlock)block;

@end
