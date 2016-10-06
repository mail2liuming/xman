//
//  EtyAppInfo.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/20.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "EtyAppInfo.h"

@implementation EtyAppInfo
DEF_SINGLETON(EtyAppInfo);
+ (void)getAppInfoCompleted:(LoadServerDataFinishedBlock)block{
    [[NetworkManager shareNetwork]GET:@"app_info" parameters:nil success:^(NSURLSessionDataTask *task, id json) {
        
        NSString *about = [json valueForKey:@"about"];
        NSString *terms = [json valueForKey:@"terms"];
        NSString *privacy = [json valueForKey:@"privacy"];
        [EtyAppInfo sharedInstance].about = about;
        [EtyAppInfo sharedInstance].terms = terms;
        [EtyAppInfo sharedInstance].privacy = privacy;
        
        block([EtyAppInfo sharedInstance],YES);
        [EtyAppInfo sharedInstance].hasLoaded = YES;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(LOADDATAERRORCOMMON,NO);
        [EtyAppInfo sharedInstance].hasLoaded = NO;
    }];
}

@end
