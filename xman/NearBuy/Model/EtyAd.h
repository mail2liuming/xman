//
//  EtyAd.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/17.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EtyAdRequest : NSObject
//请求参数
@property (nonatomic,strong)NSString *session_id;
@property (nonatomic,strong)NSString *orderby;
@property (nonatomic,strong)NSString *category;
@property (nonatomic,strong)NSString *lng;
@property (nonatomic,strong)NSString *lat;
@property (nonatomic,strong)NSString *pageindex;

@end

@interface EtyAd : NSObject



//结果参数
@property (nonatomic,strong)NSString *ad_id;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *describe;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *state;
@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *pricetype;
@property (nonatomic,strong)NSString *category;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *realease_time;
@property (nonatomic,strong)NSString *end_time;
@property (nonatomic,strong)NSString *view_count;
@property (nonatomic,strong)NSString *lat;
@property (nonatomic,strong)NSString *lng;
@property (nonatomic,strong)NSString *pic1;
@property (nonatomic,strong)NSString *pic2;
@property (nonatomic,strong)NSString *pic3;
@property (nonatomic,strong)NSString *pic4;
@property (nonatomic,strong)NSString *pic5;
@property (nonatomic,strong)NSString *currt_time;
@property (nonatomic,strong)NSString *watchlistcount;
@property (nonatomic,strong)NSString *withdrawn_time;
@property (nonatomic,strong)NSString *commentcount;
@property (nonatomic,assign)NSInteger in_watchlist;//是否已收藏 0未搜藏，1已收藏
- (instancetype)initWithAttribute:(NSDictionary *)dic;

+ (void)getAd_NearAdByParam:(EtyAdRequest *)request withFinish:(LoadServerDataFinishedBlock)block;

+ (void)getMyWatchByPageIndex:(NSInteger)page withFinish:(LoadServerDataFinishedBlock)block;

+ (void)addToMyWatchByAdId:(NSString *)adid withFinish:(LoadServerDataFinishedBlock)block;

+ (void)deleteMyWatchByAdId:(NSString *)adid withFinish:(LoadServerDataFinishedBlock)block;

+ (void)getMyAdByType:(NSString *)type withIndex:(NSInteger)index withFinish:(LoadServerDataFinishedBlock)block;


+ (void)addNewAdByRequest:(EtyAd *)request withFinish:(LoadServerDataFinishedBlock)block;

+ (void)editAdByRequest:(EtyAd *)request withFinish:(LoadServerDataFinishedBlock)block;

+ (void)withdrawnAdByAdid:(NSString*)adid withFinish:(LoadServerDataFinishedBlock)block;

/*!
 *  @brief  重新上架公告
 *
 *  @param jsonad 当前广告的实体转成josn
 *  @param block  
 */
+ (void)relistAdByAd:(EtyAd*)ad withFinish:(LoadServerDataFinishedBlock)block;

+ (void)searchAdByKeyword:(NSString *)keyword withIndex:(NSInteger)pageIndex withFinish:(LoadServerDataFinishedBlock)block;

- (void)getAdCommentByIndex:(NSInteger)index withFinish:(LoadServerDataFinishedBlock)block;

- (void)addNewCommentByContent:(NSString* )content withFinish:(LoadServerDataFinishedBlock)block;

+ (void)getAdDetailById:(NSString *)adid withFinish:(LoadServerDataFinishedBlock)block;

@end
