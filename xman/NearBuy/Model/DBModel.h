//
//  DBModel.h
//  NearBuy
//
//  Created by URoad_MP on 15/9/24.
//  Copyright © 2015年 nearbuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EtyAd.h"
@interface DBModel : NSObject
AS_SINGLETON(DBModel)

//type 1 我发布的 2 我关注的
- (void)updateAd:(EtyAd *)ad toType:(NSString *)type;

- (NSString *)queryCommentCount:(EtyAd*)ad byType:(NSString *)type;

@end
