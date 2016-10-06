//
//  BaseNavigationController.h
//  LNGaosutong
//
//  Created by 罗 建镇 on 15/3/5.
//  Copyright (c) 2015年 URoad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

+ (BaseNavigationController *)shareNaviController;

- (void)popBackControllerByBackIndex:(NSInteger)index;

@end
