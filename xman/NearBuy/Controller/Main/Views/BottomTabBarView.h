//
//  BottomTabBarView.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/16.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomTabBarView : UIView

@property (nonatomic,strong)void(^tabBarSelectIndexBlock)(NSInteger index);
- (id)initWithTitles:(NSArray *)titles bySelectImages:(NSArray*)imgs byUnSelectImages:(NSArray *)unImgs;
- (void)setDefaultSelectIndex:(NSInteger)defaultIndex;

@end
