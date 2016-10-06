//
//  PublicFunction.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/19.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "PublicFunction.h"

@implementation PublicFunction

+ (NSDate *)tranferUnitTime:(NSString *)unittime{
    return [NSDate dateWithTimeIntervalSince1970:[unittime doubleValue]];
}

+ (NSString *)caculateTimeDifByReleaseUnitTime:(NSString *)releaseTime withCurrentTime:(NSString *)currentTime{
    
    long currentUnix = [currentTime longLongValue];
    long releaseUnix = [releaseTime longLongValue];
    long interval = currentUnix - releaseUnix;
    long minute = interval / 60;
    if (minute >= 60) {
        int hour = (int)(minute / 60);
        if (hour >= 24) {
            int day = hour / 24;
            if (day >= 30 ) {
                int month = day / 30;
                if (month >= 12) {
                    int year = month / 12;
                    if (year > 1)
                        return [NSString stringWithFormat:@"%d years ago",year];
                    else
                        return [NSString stringWithFormat:@"%d year",year];
                } else {
                    if (month > 1)
                        return [NSString stringWithFormat:@"%d months ago",month];
                    else
                        return [NSString stringWithFormat:@"%d month",month];
                }
            } else {
                if (day > 1)
                    return [NSString stringWithFormat:@"%d days ago",day];
                else
                    return [NSString stringWithFormat:@"%d day",day];
            }
            
        } else {
            if (hour > 1) 
                return [NSString stringWithFormat:@"%d hours ago",hour];
            else 
                return [NSString stringWithFormat:@"%d hour",hour];
        }
    } else {
        if (minute > 1) 
            return [NSString stringWithFormat:@"%ld minutes ago",(long)minute];
        else 
            return [NSString stringWithFormat:@"%ld minute",(long)minute];
    }
    return nil;
}

+ (void)setInputBackViewBorder:(UIView *)view{
    view.layer.cornerRadius = 3.0;
    view.layer.borderColor = UI_INPUT_LAYER_COLOR.CGColor;
    view.layer.borderWidth = 0.5;
}

+ (void)setButtonBorder:(UIButton *)btn{
    btn.layer.cornerRadius = 3.0;
    btn.clipsToBounds = YES;
}

+ (BOOL)checkStringIsValid:(NSString *)string{
    if ([string isKindOfClass:[NSNull class]]|| string == nil || [string isEqualToString:@""]) {
        return NO;
    }else{
        return YES;
    }
}

+ (NSString *)convertJSONObjectToJSONString:(id)jsonObj{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}


+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
@end
