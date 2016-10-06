//
//  Base.h
//  LNGaosutong
//
//  Created by 罗 建镇 on 15/3/9.
//  Copyright (c) 2015年 URoad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainController.h"

@interface Base : NSObject

AS_SINGLETON(Base);

@property (nonatomic,strong)BaseNavigationController *currentNavi;

+ (MainController *)shareMain;

@end
