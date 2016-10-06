//
//  LZAlertView.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/19.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "LZAlertView.h"
#import "NZAlertViewColor.h"
#define kShowDuring 3
#define kSelfHeight 90
@interface LZAlertView()
@property (nonatomic,assign)AlertMessageStyle lStyle;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *message;
@property (nonatomic,strong)UIImageView *imgV;
@property (nonatomic,strong)UILabel *titleLb;
@property (nonatomic,strong)UILabel *messageLb;
@property (nonatomic,strong)UIImageView *blurImageView;
@end

@implementation LZAlertView

- (id)initWithMessage:(NSString*)msg withTitle:(NSString*)title withStyle:(AlertMessageStyle)style{
    self = [super initWithFrame:CGRectMake(0, 0, UIScreenWidth, kSelfHeight)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.5;
        
        self.blurImageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.blurImageView.backgroundColor = [UIColor clearColor];
        
        self.lStyle = style;
        self.imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, (kSelfHeight-54)/2., 54, 54)];
        [self addSubview:self.imgV];
        self.titleLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imgV.frame)+5, CGRectGetMidY(self.imgV.frame), UIScreenWidth - CGRectGetMaxX(self.imgV.frame)-10, 35)];
        self.titleLb.font = [UIFont systemFontOfSize:18];
        self.titleLb.text = title;
        [self addSubview:self.titleLb];
        
        self.messageLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imgV.frame)+5, (kSelfHeight-54)/2., UIScreenWidth - CGRectGetMaxX(self.imgV.frame)-10, 54)];
        self.messageLb.font = [UIFont systemFontOfSize:16];
        self.messageLb.text = msg;
        self.messageLb.numberOfLines = 0;
        [self addSubview:self.messageLb];
        
        [self setAlertViewStyle:style];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.numberOfTapsRequired =1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)setAlertViewStyle:(AlertMessageStyle)alertViewStyle
{
    _lStyle = alertViewStyle;
    UIColor *color = nil;
    
    NSString *path = @"NZAlertView-Icons.bundle/";
    
    switch (_lStyle) {
        case Alert_Error:
            path = [path stringByAppendingString:@"AlertViewErrorIcon"];
            color = [NZAlertViewColor errorColor];
            break;
            
        case Alert_Info:
            path = [path stringByAppendingString:@"AlertViewInfoIcon"];
            color = [NZAlertViewColor infoColor];
            break;
            
        case Alert_Success:
            path = [path stringByAppendingString:@"AlertViewSucessIcon"];
            color = [NZAlertViewColor successColor];
            break;
    }
    
    self.imgV.image = [UIImage imageNamed:path];
    self.titleLb.textColor = color;
    self.messageLb.textColor = color;
}

- (void)show{
    self.top = -kSelfHeight;
    [KEY_WINDOW addSubview:self];
    UIImage *screenshot = [UIImage screenshot];
    NSData *imageData = UIImageJPEGRepresentation(screenshot, .0001);
    UIImage *blurredSnapshot = [[UIImage imageWithData:imageData] blurredImage:0.4];
    self.blurImageView.image = blurredSnapshot;
    [KEY_WINDOW insertSubview:self.blurImageView belowSubview:self];
    self.blurImageView.alpha = 0;
    
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.top = 0;
        self.blurImageView.alpha = 1;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:kShowDuring];
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.top = -kSelfHeight;
        self.blurImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.blurImageView removeFromSuperview];
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    }];
}

+ (void)showMessage:(NSString *)message byStyle:(AlertMessageStyle)style{
    [LZAlertView showMessage:message withTitle:nil byStyle:style];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title byStyle:(AlertMessageStyle)style{
    LZAlertView *alert = [[LZAlertView alloc]initWithMessage:message withTitle:title withStyle:style];
    [alert show];
}

@end
