//
//  Base.m
//  LNGaosutong
//
//  Created by 罗 建镇 on 15/3/9.
//  Copyright (c) 2015年 URoad. All rights reserved.
//

#import "Base.h"

@implementation Base

DEF_SINGLETON(Base);

+ (MainController *)shareMain
{
    return [MainController sharedInstance];
}

@end
