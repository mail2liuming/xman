//
//  LZAlertView.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/19.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AlertMessageStyle) {
    Alert_Error=0,
    Alert_Success,
    Alert_Info
};

@interface LZAlertView : UIView

+ (void)showMessage:(NSString *)message byStyle:(AlertMessageStyle)style;

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title byStyle:(AlertMessageStyle)style;


@end
