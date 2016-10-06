//
//  EtyAppInfo.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/20.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EtyAppInfo : NSObject
AS_SINGLETON(EtyAppInfo)
@property (nonatomic,strong)NSString *about;
@property (nonatomic,strong)NSString *terms;
@property (nonatomic,strong)NSString *privacy;
@property (nonatomic,assign)BOOL hasLoaded;

+ (void)getAppInfoCompleted:(LoadServerDataFinishedBlock)block;

@end
