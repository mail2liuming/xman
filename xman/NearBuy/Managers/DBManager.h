//
//  DBManager.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/19.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject
AS_SINGLETON(DBManager);

- (void)getAllCountry:(LoadServerDataFinishedBlock)block;

- (void)getCountryCodeByName:(NSString *)name completed:(LoadServerDataFinishedBlock)block;

@end
