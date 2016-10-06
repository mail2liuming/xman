//
//  EtyAdCategory.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/17.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "EtyAdCategory.h"

@implementation EtyOrderBy



@end

@implementation EtyAdCategory

DEF_SINGLETON(EtyAdCategory)

+ (NSArray *)getAdCategorys{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    NSArray *categoryNames = @[@"All",@"Electronics",@"Clothing",@"Flatmates",@"Home & Garden",@"Sports",@"Everything else"];
    NSArray *categoryDescs = @[@"",@"",@"",@"",@"",@"",@""];

    [categoryNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        EtyAdCategory *category  = [[EtyAdCategory alloc]init];
        category.categoryId = [NSString stringWithFormat:@"%ld",(long)idx];
        category.name = obj;
        category.desc = categoryDescs[idx];
        [array addObject:category];
    }];
    
    return array;
}

+ (NSArray *)getAdCategoryNames{
    NSArray *categoryNames = @[@"Electronics",@"Clothing",@"Flatmates",@"Home & Garden",@"Sports",@"Everything else"];
    return categoryNames;
}

- (NSArray *)categorys{
    if (!_categorys || _categorys.count==0) {
        
        _categorys = [EtyAdCategory getAdCategorys];
        return _categorys;
        
    }else{
        return _categorys;
    }
    return nil;
}

@end
