//
//  UserRegisterSecondController.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/20.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "BaseController.h"

@interface UserRegisterSecondController : BaseController

- (id)initWithPhone:(NSString *)phone;

- (id)initWithChangePhone:(NSString *)phone;

- (id)initWithResetPwdWithPhone:(NSString *)phone;

@end
