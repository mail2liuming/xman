//
//  NetworkManager.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/16.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "AFNetworking.h"

@interface NetworkManager : AFHTTPSessionManager

+ (NetworkManager *)shareNetwork;

@end
