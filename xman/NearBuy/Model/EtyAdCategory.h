//
//  EtyAdCategory.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/17.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EtyOrderBy : NSObject
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *orderDesc;
@end

@interface EtyAdCategory : NSObject
@property (nonatomic,strong)NSArray *categorys;
AS_SINGLETON(EtyAdCategory)

@property (nonatomic,strong)NSString *categoryId;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *desc;

+ (NSArray*)getAdCategorys;

+ (NSArray *)getAdCategoryNames;
@end
