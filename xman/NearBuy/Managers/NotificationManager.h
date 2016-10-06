//
//  NotificationManager.h
//  Parking
//
//  Created by 罗 建镇 on 15/4/4.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

/**
 *  用户登录了或者注销了，推送一个通知
 */
+ (void)postAccountChangeNotification;

/**
 *  为用户增加通知
 *
 *  @param server
 *  @param selector 
 */
+ (void)addAccountChangeNotificationByObserver:(id)server selector:(SEL)selector;

@end
