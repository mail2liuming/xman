//
//  PublicFunction.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/19.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicFunction : NSObject

/*!
 *  @brief  时间戳转换成标准时间
 *
 *  @param unittime
 *
 *  @return 
 */
+ (NSDate *)tranferUnitTime:(NSString *)unittime;

+ (NSString *)caculateTimeDifByReleaseUnitTime:(NSString *)releaseTime withCurrentTime:(NSString *)currentTime;

/*!
 *  @brief  to set uiview layer bordercolor,corner,width
 *
 *  @param view 
 */
+ (void)setInputBackViewBorder:(UIView *)view;

+ (void)setButtonBorder:(UIButton *)btn;

/*!
 *  @brief  check string is null,nil,empty
 *
 *  @param string
 *
 *  @return bool
 */
+ (BOOL)checkStringIsValid:(NSString*)string;


/*!
 *  @brief  convert NSDictionary to json string
 *
 *  @param jsonObj
 *
 *  @return 
 */
+ (NSString *)convertJSONObjectToJSONString:(id)jsonObj;


+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
@end
