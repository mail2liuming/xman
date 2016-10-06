//
//  NetworkManager.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/16.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "NetworkManager.h"

//#define RequestUrl @"http://nearbuy.today/airshop/index.php/"
#define RequestUrl @"http://52.64.153.14/airshop"
#define kHostIp @"swoop.appworks.co.nz"
#define kHostAddress @"/airshop/"

//#define kHostIp @"52.64.153.14"
//#define kHostAddress @"/airshoptest/"
@implementation NetworkManager

+ (NetworkManager *)shareNetwork{
    static NetworkManager *obj =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //        configuration.HTTPAdditionalHeaders = @{@"Content-Type": @"text/html"};
        
        NSURL *url  =[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",kHostIp,kHostAddress]];
        obj =[[NetworkManager alloc]initWithBaseURL:url sessionConfiguration:configuration];
        obj.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //        obj.requestSerializer = [AFHTTPRequestSerializer serializer];
        //        obj.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        obj.responseSerializer.acceptableContentTypes = [obj.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        
        obj.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return obj;
}

@end