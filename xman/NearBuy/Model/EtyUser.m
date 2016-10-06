//
//  EtyUser.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/17.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "EtyUser.h"

@implementation EtyUser

- (void)adreportToService:(NSString *)content withad_id:(NSString *)adid withitype:(NSString *)reportType completed:(LoadServerDataFinishedBlock)block{
    NSDictionary *parm = @{@"session_id":self.session_id,@"content":content,@"ad_id":adid,@"itype":reportType};
    [[NetworkManager shareNetwork]POST:@"ad_report/addAdReports" parameters:parm success:^(NSURLSessionDataTask *task, id json) {
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            block(nil,YES);
        }else if(ret == 2){
            block(@"Session expired,please logon again",NO);
        }else if (ret == 3){
            block(@"The title or content is to long",NO);

        }else{
            NSString *error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }
        

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
    }];
}

@end
