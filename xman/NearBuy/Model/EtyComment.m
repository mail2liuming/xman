//
//  EtyComment.m
//  NearBuy
//
//  Created by URoad_MP on 15/9/8.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "EtyComment.h"

@implementation EtyComment

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        NSString *comId = [dic valueForKey:@"id"];
        NSString *intime = [dic valueForKey:@"intime"];
        NSString *userid = [dic valueForKey:@"user_id"];
        NSString *username = [dic valueForKey:@"user_name"];
        NSString *content =[dic valueForKey:@"content"];
        NSString *curr_time = [dic valueForKey:@"currt_time"];
        self.commentId = SAFE_STRING(comId);
        self.intime = SAFE_STRING(intime);
        self.user_id = SAFE_STRING(userid);
        self.user_name = SAFE_STRING(username);
        self.content = SAFE_STRING(content);
        self.curr_time = SAFE_STRING(curr_time);
    }
    return self;
}

@end
