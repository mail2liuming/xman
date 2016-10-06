//
//  EtyComment.h
//  NearBuy
//
//  Created by URoad_MP on 15/9/8.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EtyComment : NSObject

@property (nonatomic,strong)NSString *intime;
@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *user_name;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *commentId;
@property (nonatomic,strong)NSString *curr_time;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
