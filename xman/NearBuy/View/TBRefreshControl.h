//
//  TBRefreshControl.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/17.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBRefreshControl : UIView

- (id)initView;

- (void)addControlScrollView:(UIScrollView *)scView;

- (void)beginRefresh;
- (void)endRefresh;

@property (nonatomic,strong)void(^refreshBlock)(void);

@end
