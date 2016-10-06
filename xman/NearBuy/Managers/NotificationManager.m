//
//  NotificationManager.m
//  Parking
//
//  Created by 罗 建镇 on 15/4/4.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import "NotificationManager.h"

//登录成功或注销后会推送一个通知
NSString *const LoginOrLogoutSuccessNotification = @"com.nearbuy.Success";


@implementation NotificationManager

+ (void)postAccountChangeNotification
{
    [[NSNotificationCenter defaultCenter]postNotificationName:LoginOrLogoutSuccessNotification object:nil];
}

+ (void)addAccountChangeNotificationByObserver:(id)server selector:(SEL)selector
{
    [NotificationManager addNotificationByObserver:server selector:selector name:LoginOrLogoutSuccessNotification];
}

/**
 *  添加一个通知
 *
 *  @param server   接受通知的通知类
 *  @param selector 通知响应的方法
 */

+(void)addNotificationByObserver:(id)server selector:(SEL)selector name:(NSString *)notiName
{
    [[NSNotificationCenter defaultCenter]addObserver:server selector:selector name:notiName object:nil];
}
/**
 *  移除某个通知
 *
 *  @param server
 */

+ (void)removeNotificationByObserver:(id)server
{
    [[NSNotificationCenter defaultCenter]removeObserver:server];
}
@end
