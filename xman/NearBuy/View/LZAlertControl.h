//
//  LZAlertControl.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/20.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertButtonClick) (BOOL confirm);

@interface LZAlertControl : UIView

- (id)initViewWithTitle:(NSString*)title withRemark:(NSString *)remark;

@property (nonatomic,strong)AlertButtonClick alertBlock;

+ (void)showAlertWithTitle:(NSString *)title withRemark:(NSString*)remark withBlock:(AlertButtonClick)block;

@end
