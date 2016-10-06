//
//  ResetPasswordController.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/22.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "BaseController.h"

@interface ResetPasswordController : BaseController

- (id)initWithPhone:(NSString *)phone byCode:(NSString *)code;

@end
