//
//  AboutController.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/20.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "BaseController.h"

typedef NS_ENUM(NSInteger, AboutStyle) {
    AboutPage=0,
    TermPage,
    PrivacyPage
};

@interface AboutController : BaseController


- (id)initWithTitle:(NSString *)title withType:(AboutStyle)style;
@end
