//
//  EtyAd.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/17.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "EtyAd.h"
#import "EtyComment.h"
@implementation EtyAdRequest



@end

@implementation EtyAd
- (instancetype)initWithAttribute:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            NSString *ad_id = [dic valueForKey:@"ad_id"];
            NSString *category = [dic valueForKey:@"category"];
            NSString *currt_time = [dic valueForKey:@"currt_time"];
            NSString *describe = [dic valueForKey:@"describe"];
            NSString *end_time = [dic valueForKey:@"end_time"];
            NSString *lat = [dic valueForKey:@"lat"];
            NSString *lng = [dic valueForKey:@"lng"];
            NSString *name = [dic valueForKey:@"name"];
            NSString *phone = [dic valueForKey:@"phone"];
            NSString *pic1 = [dic valueForKey:@"pic1"];
            NSString *pic2 = [dic valueForKey:@"pic2"];
            NSString *pic3 = [dic valueForKey:@"pic3"];
            NSString *pic4 = [dic valueForKey:@"pic4"];
            NSString *pic5 = [dic valueForKey:@"pic5"];
            NSString *price = [dic valueForKey:@"price"];
            NSString *pricetype = [dic valueForKey:@"pricetype"];
            NSString *realease_time = [dic valueForKey:@"realease_time"];
            NSString *state = [dic valueForKey:@"state"];
            NSString *title = [dic valueForKey:@"title"];
            NSString *user_id = [dic valueForKey:@"user_id"];
            NSString *view_count = [dic valueForKey:@"view_count"];
            NSString *watchlistcount = [dic valueForKey:@"watchlistcount"];
            NSString *withdrawn_time = [dic valueForKey:@"withdrawn_time"];
            NSString *in_watchlist = [dic valueForKey:@"in_watchlist"];
            NSString *commentcount = [dic valueForKey:@"commentcount"];
            self.ad_id = SAFE_STRING(ad_id);
            self.category = category;
            self.currt_time = currt_time;
            self.describe = describe;
            self.end_time = end_time;
            self.lat = lat;
            self.lng = lng;
            self.name = name;
            self.commentcount = commentcount;
            self.phone = phone;
            self.pic1 = pic1;
            self.pic2 = pic2;
            self.pic3 = pic3;
            self.pic4 = pic4;
            self.pic5 = pic5;
            self.price = price;
            self.pricetype = pricetype;
            self.realease_time = realease_time;
            self.state = state;
            self.title = title;
            self.user_id = user_id;
            self.view_count = view_count;
            self.in_watchlist = [in_watchlist isKindOfClass:[NSNull class] ]?0:[in_watchlist integerValue];
            self.watchlistcount = watchlistcount;
            self.withdrawn_time = withdrawn_time;
        }
    }
    return self;
}

+ (void)getAd_NearAdByParam:(EtyAdRequest *)request withFinish:(LoadServerDataFinishedBlock)block{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:request.session_id forKey:@"session_id"];
    [param setValue:request.orderby forKey:@"orderby"];
    [param setValue:request.category forKey:@"category"];
    [param setValue:request.lng forKey:@"lng"];
    [param setValue:request.lat forKey:@"lat"];
    [param setValue:request.pageindex forKey:@"pageindex"];
    [[NetworkManager shareNetwork]POST:@"ad/near_ad" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        NSLog(@"resp =%@",json);
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            NSArray *ads = [json valueForKey:@"ads"];
            NSMutableArray *returnads = [NSMutableArray array];
            [ads enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = obj;
                EtyAd *ety = [[EtyAd alloc]initWithAttribute:dic];
                [returnads addObject:ety];
            }];
            block(returnads,YES);
        }else{
            NSString *error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error %@",error);
        block(LOADDATAERRORCOMMON,NO);
    }];
}
+ (void)getAdDetailById:(NSString *)adid withFinish:(LoadServerDataFinishedBlock)block{
    NSDictionary *dic = @{@"id":adid};
    [[NetworkManager shareNetwork]POST:@"ad/getAd" parameters:dic success:^(NSURLSessionDataTask *task, id json) {
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            NSArray *ads = [json valueForKey:@"ads"];
            NSMutableArray *returnads = [NSMutableArray array];
            [ads enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = obj;
                EtyAd *ety = [[EtyAd alloc]initWithAttribute:dic];
                [returnads addObject:ety];
            }];
            block(returnads,YES);
        }else{
            NSString *error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
    }];
}
+ (void)getMyAdByType:(NSString *)type withIndex:(NSInteger)index withFinish:(LoadServerDataFinishedBlock)block{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:type forKey:@"state"];
    EtyUser *user = [AccountManager sharedInstance].currentUser;
    [param setObject:user?user.session_id:@"" forKey:@"session_id"];
    [param setObject:[NSNumber numberWithInteger:index] forKey:@"pageindex"];
    
    [[NetworkManager shareNetwork]POST:@"ad/my_ads" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        NSLog(@"resp =%@",json);
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            NSArray *ads = [json valueForKey:@"ads"];
            NSMutableArray *returnads = [NSMutableArray array];
            [ads enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = obj;
                EtyAd *ety = [[EtyAd alloc]initWithAttribute:dic];
                [returnads addObject:ety];
            }];
            block(returnads,YES);
        }else{
            NSString *error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);

    }];
}

+ (void)getMyWatchByPageIndex:(NSInteger)page withFinish:(LoadServerDataFinishedBlock)block{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    EtyUser *user = [AccountManager sharedInstance].currentUser;
    [param setObject:user?user.session_id:@"" forKey:@"session_id"];
    [param setObject:[NSNumber numberWithInteger:page] forKey:@"pageindex"];
    [[NetworkManager shareNetwork]POST:@"watchlist/get_my_watchlist" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        NSLog(@"resp =%@",json);
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            NSArray *ads = [json valueForKey:@"ads"];
            NSMutableArray *returnads = [NSMutableArray array];
            [ads enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = obj;
                EtyAd *ety = [[EtyAd alloc]initWithAttribute:dic];
                [returnads addObject:ety];
            }];
            block(returnads,YES);
        }else{
            NSString *error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error %@",error);
        block(LOADDATAERRORCOMMON,NO);

    }];
}
+ (void)addToMyWatchByAdId:(NSString *)adid withFinish:(LoadServerDataFinishedBlock)block{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    EtyUser *user = [AccountManager sharedInstance].currentUser;
    [param setObject:user?user.session_id:@"" forKey:@"session_id"];
    [param setObject:adid forKey:@"ad_id"];
    [[NetworkManager shareNetwork]POST:@"watchlist/add_to_watchlist" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        
        NSLog(@"resp =%@",json);
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            block(nil,YES);
        }else{
            NSString*error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
        
    }];

    
}
+ (void)deleteMyWatchByAdId:(NSString *)adid withFinish:(LoadServerDataFinishedBlock)block{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    EtyUser *user = [AccountManager sharedInstance].currentUser;
    [param setObject:user?user.session_id:@"" forKey:@"session_id"];
    [param setObject:adid forKey:@"ad_id"];
    [[NetworkManager shareNetwork]POST:@"watchlist/del_watchlist" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        
        NSLog(@"resp =%@",json);
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            block(nil,YES);
        }else{
            NSString*error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);

    }];
}

+ (void)addNewAdByRequest:(EtyAd *)request withFinish:(LoadServerDataFinishedBlock)block{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[AccountManager sharedInstance].currentUser.session_id forKey:@"session_id"];
    [param setObject:request.category forKey:@"category"];
    [param setObject:request.lng forKey:@"lng"];
    [param setObject:request.lat forKey:@"lat"];
    [param setObject:@"0" forKey:@"pricetype"];
    [param setObject:request.price forKey:@"price"];
    [param setObject:request.title forKey:@"title"];
    [param setObject:request.describe forKey:@"describe"];
    [param setObject:@"1" forKey:@"follow_me"];
    [param setObject:request.phone forKey:@"phone"];
    [param setObject:request.pic1 forKey:@"pic1base64"];
    [param setObject:request.pic2 forKey:@"pic2base64"];
    [param setObject:request.pic3 forKey:@"pic3base64"];
    [param setObject:request.pic4 forKey:@"pic4base64"];
    [param setObject:request.pic5 forKey:@"pic5base64"];
    
    
    [[NetworkManager shareNetwork]POST:@"ad/selling_ad" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        
        NSLog(@"resp =%@",json);
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            block(nil,YES);
        }else{
            NSString*error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
        
    }];

}

+ (void)editAdByRequest:(EtyAd *)request withFinish:(LoadServerDataFinishedBlock)block{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[AccountManager sharedInstance].currentUser.session_id forKey:@"session_id"];
    [param setObject:request.category forKey:@"category"];
    [param setObject:request.ad_id forKey:@"ad_id"];
    [param setObject:request.lng forKey:@"lng"];
    [param setObject:request.lat forKey:@"lat"];
    [param setObject:@"0" forKey:@"pricetype"];
    [param setObject:request.price forKey:@"price"];
    [param setObject:request.title forKey:@"title"];
    [param setObject:request.describe forKey:@"describe"];
    [param setObject:@"1" forKey:@"follow_me"];
    [param setObject:request.phone forKey:@"phone"];
    [param setObject:request.pic1 forKey:@"pic1base64"];
    [param setObject:request.pic2 forKey:@"pic2base64"];
    [param setObject:request.pic3 forKey:@"pic3base64"];
    [param setObject:request.pic4 forKey:@"pic4base64"];
    [param setObject:request.pic5 forKey:@"pic5base64"];
    [[NetworkManager shareNetwork]POST:@"ad/selling_ad" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        
        NSLog(@"resp =%@",json);
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            block([json valueForKey:@"pic"],YES);
        }else{
            NSString*error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
        
    }];

}

+ (void)withdrawnAdByAdid:(NSString *)adid withFinish:(LoadServerDataFinishedBlock)block{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[AccountManager sharedInstance].currentUser.session_id forKey:@"session_id"];
    [param setObject:adid forKey:@"ad_id"];
    [[NetworkManager shareNetwork]POST:@"ad/ad_withdrawn" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        
        NSLog(@"resp =%@",json);
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            block(nil,YES);
        }else{
            NSString*error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
        
    }];

}
+ (void)relistAdByAd:(EtyAd *)ad withFinish:(LoadServerDataFinishedBlock)block{
    NSString*jsonstring = [EtyAd convertAdEntityToJson:ad];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[AccountManager sharedInstance].currentUser.session_id forKey:@"session_id"];
    [param setObject:jsonstring forKey:@"json_ad"];
    [[NetworkManager shareNetwork]POST:@"ad/relist_ad" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        
        NSLog(@"resp =%@",json);
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            block(nil,YES);
        }else{
            NSString*error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
        
    }];
    

}

+ (NSString*)convertAdEntityToJson:(EtyAd *)ad{
    NSMutableDictionary *addic = [NSMutableDictionary dictionary];
    [addic setObject:ad.ad_id forKey:@"ad_id"];
    [addic setObject:ad.title forKey:@"title"];
    [addic setObject:ad.describe forKey:@"describe"];
    [addic setObject:ad.price forKey:@"price"];
    [addic setObject:ad.state forKey:@"state"];
    [addic setObject:ad.user_id forKey:@"user_id"];
    [addic setObject:ad.pricetype forKey:@"pricetype"];
    [addic setObject:ad.category forKey:@"category"];
    [addic setObject:ad.phone forKey:@"phone"];
    [addic setObject:ad.name forKey:@"name"];
    [addic setObject:ad.realease_time forKey:@"realease_time"];
    [addic setObject:ad.end_time forKey:@"end_time"];
    [addic setObject:ad.view_count forKey:@"view_count"];
    [addic setObject:ad.lat forKey:@"lat"];
    [addic setObject:ad.lng forKey:@"lng"];
    [addic setObject:ad.pic1 forKey:@"pic1"];
    [addic setObject:ad.pic2 forKey:@"pic2"];
    [addic setObject:ad.pic3 forKey:@"pic3"];
    [addic setObject:ad.pic4 forKey:@"pic4"];
    [addic setObject:ad.pic5 forKey:@"pic5"];
    [addic setObject:ad.currt_time forKey:@"currt_time"];
    [addic setObject:ad.watchlistcount forKey:@"watchlistcount"];
    [addic setObject:ad.withdrawn_time forKey:@"withdrawn_time"];
    
    return [PublicFunction convertJSONObjectToJSONString:addic];
    
}

+ (void)searchAdByKeyword:(NSString *)keyword withIndex:(NSInteger)pageIndex withFinish:(LoadServerDataFinishedBlock)block
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:keyword forKey:@"search"];
//    [param setObject:[AccountManager sharedInstance].hasLogin?[AccountManager sharedInstance].currentUser.session_id:@"" forKey:@"session_id"];
//    [param setObject:@"1" forKey:@"orderby"];
//    [param setObject:@"" forKey:@"category"];
//    CLLocationCoordinate2D loc = [LocationManager sharedInstance].currentLocation.coordinate;
//    [param setObject:[NSNumber numberWithFloat:loc.latitude] forKey:@"lat"];
//    [param setObject:[NSNumber numberWithFloat:loc.longitude] forKey:@"lng"];
//    
    [param setObject:[NSNumber numberWithInteger:pageIndex] forKey:@"pageindex"];
    
    [[NetworkManager shareNetwork]POST:@"ad/search_near_ad" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        NSLog(@"resp =%@",json);
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            NSArray *ads = [json valueForKey:@"ads"];
            NSMutableArray *returnads = [NSMutableArray array];
            [ads enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = obj;
                EtyAd *ety = [[EtyAd alloc]initWithAttribute:dic];
                [returnads addObject:ety];
            }];
            block(returnads,YES);
        }else{
            NSString *error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error %@",error);
        block(LOADDATAERRORCOMMON,NO);
    }];

}

- (void)getAdCommentByIndex:(NSInteger)index withFinish:(LoadServerDataFinishedBlock)block{
    NSDictionary *param = @{@"ad_id":self.ad_id,@"pageindex":[NSNumber numberWithInteger:index]};
    [[NetworkManager shareNetwork]POST:@"ad_comment/getAdComments" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            NSArray *ads = [json valueForKey:@"ads"];
            NSMutableArray *returnads = [NSMutableArray array];
            [ads enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = obj;
                EtyComment *ety = [[EtyComment alloc]initWithDic:dic];
                [returnads addObject:ety];
            }];
            block(returnads,YES);
        }else{
            NSString *error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);

    }];
}

- (void)addNewCommentByContent:(NSString *)content withFinish:(LoadServerDataFinishedBlock)block{
    NSDictionary *parma = @{@"ad_id":self.ad_id,@"session_id":[AccountManager sharedInstance].currentUser.session_id,@"content":content};
    [[NetworkManager shareNetwork]POST:@"ad_comment/addAdComments" parameters:parma success:^(NSURLSessionDataTask *task, id json) {
        
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            block(@"comment success",YES);
        }else if(ret == 2){
            block(@"Session expired,please logon again",NO);
        }else if (ret == 3){
            block(@"The title or content is too long",NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
    }];
}

@end
