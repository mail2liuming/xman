//
//  BaseController.h
//  LNGaosutong
//
//  Created by 罗 建镇 on 15/3/4.
//  Copyright (c) 2015年 URoad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseController : UIViewController
- (id)initWithTitle:(NSString *)title;
@property (nonatomic,strong)NSString *titleString;
@property (nonatomic,strong)UIImage *naviRightBtnImg;
@property (nonatomic,strong)UIImage *naviLeftBtnImg;

@property (nonatomic,strong)UIView *titleView;
- (void)registerKeyboardNotification;
- (void)naviRightButtonClick;
- (void)naviLeftButtonClick;
- (void)naviBackAction;

- (void)startAnimation;
- (void)stopAnimation;
@end
