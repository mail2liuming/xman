//
//  UIAlertView+AlertBlock.h
//  AutoLayoutDemo
//
//  Created by 罗 建镇 on 14-7-23.
//  Copyright (c) 2014年 Luo Jianzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertCompletedBlock)(UIAlertView *alertView,NSInteger buttonIndex);

@interface UIAlertView (AlertBlock)<UIAlertViewDelegate>

@property (nonatomic,copy)AlertCompletedBlock completedBlock;


@end
